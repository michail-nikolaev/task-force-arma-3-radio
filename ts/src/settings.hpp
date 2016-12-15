#pragma once
#include <string>
#include <array>
#include "helpers.hpp"
#include "enum.hpp"
#include "Locks.hpp"
#include "SignalSlot.hpp"

//Was originally using enum.hpp. But it had to be edited to allow more than 8 settings.. at that was too tedious
#define Settings(XX) \
   XX(full_duplex,true), \
   XX(addon_version,"unknown"), \
   XX(serious_channelName,""), \
   XX(serious_channelPassword,""), \
   XX(intercomVolume,0.3f), \
   XX(intercomEnabled,true), \
   XX(pluginTimeout,4.f), \
   XX(headsetLowered,false), \
   XX(spectatorNotHearEnemies,false)

#define EnumEntry(x,y) x
#define EnumString(x,y) #x
#define EnumDefault(x,y) y

class Setting {
public:
    enum _enum : unsigned char {
        Settings(EnumEntry),
        Setting_MAX
    };
    static constexpr std::array<char*, static_cast<size_t>(Setting_MAX)> SettingStrings{
        Settings(EnumString)
    };

    static _enum _from_string(const char* str) {
        for (int i = 0; i < Setting_MAX; ++i) {
            if (_strnicmp(str, SettingStrings[i], strlen(SettingStrings[i])) == 0) {
                return static_cast<_enum>(i);
            }
        }
        return Setting_MAX;
    }

    Setting() = delete;
    constexpr Setting(_enum value) : _value((value < _enum::Setting_MAX) ? value : (throw std::logic_error("invalid Enum value"))) {}
    Setting(const char* str) : _value(_from_string(str)) {}
    Setting(const std::string&s) : _value(_from_string(s.c_str())) {}
    constexpr operator _enum() const { return _value; }
    _enum     _value;
};

//static_assert(stringToSetting("full_duplex") == 0x0, "Can't execute Setting::_to_string at compile time!");

class settingValue {//This is heavily optimized towards booleans get<bool> can be optimized down to a single instruction. Allowing very fast branching
public:
    explicit settingValue() : type(settingType::t_invalid), boolValue(false) {}
    constexpr settingValue(bool value) : type(settingType::t_bool), boolValue(value) {}
    settingValue(const float& value) : type(settingType::t_float), floatValue(value) {}
    settingValue(const std::string& value) : type(settingType::t_string), stringValue(new std::string(value)) {}
    settingValue(const char* value) : type(settingType::t_string), stringValue(new std::string(value)) {}
    void operator=(const bool& value) {
        switch (type) {
            case settingType::t_bool: boolValue = value;        break;
            case settingType::t_float: floatValue = value ? 1.f : 0.f;  break;
            case settingType::t_string: stringValue->assign(value ? "true" : "false");  break;
        }
    }
    void operator=(const float& value) {
        switch (type) {
            case settingType::t_bool: boolValue = value > 0.f; break;
            case settingType::t_float: floatValue = value; break;
            case settingType::t_string: stringValue->assign(std::to_string(value)); break;
        }
    }
    void setString(const std::string& value) const {
        stringValue->assign(value);
    }
    void setString(const char* value) const {
        stringValue->assign(value);
    }
    ~settingValue() {
        if (type == settingType::t_string)
            delete stringValue;
    }
    settingValue(const settingValue& other) = delete;//Disable copying
    operator std::string() const {
        switch (type) {
            case settingType::t_bool: return boolValue ? "true" : "false";
            case settingType::t_float: return std::to_string(floatValue);
            case settingType::t_string: return std::string(*stringValue);
        }
        return "";
    }
    operator const float() const {
#ifdef _DEBUG
        if (type != settingType::t_float)
            __debugbreak();
#endif
        return floatValue;
    }
    operator const bool() const {
#ifdef _DEBUG
        if (type != settingType::t_bool)
            __debugbreak();
#endif
        return boolValue;
    }

private:
    enum class settingType {
        t_invalid,
        t_bool,
        t_float,
        t_string
    };
    const settingType type;
    union {
        bool boolValue;
        float floatValue;
        std::string* stringValue;
    };
};

class settings {
public:
    settings() {}
    ~settings() {}

    static bool isValidKey(Setting key) {
        return key < Setting::Setting_MAX;
    }
    template<typename TYPE>
    void set(Setting key, const TYPE& value) {
        values[key] = value;
        needRefresh = false;
        configValueSet(key);
    }

    template<>
    void set(Setting key, const std::string& value) {
        LockGuard_exclusive<CriticalSectionLock> lock(&m_lock);
        values[key].setString(value);
        needRefresh = false;
        configValueSet(key);
    }

    template<typename TYPE>
    TYPE get(Setting key) {
        //Using an invalid key on get will crash. But get is only used with compile-time known keys for now anyway.
        if (std::is_same<TYPE, std::string>::value) {	//Only lock for types that are big enough to need mutex
            LockGuard_exclusive<CriticalSectionLock> lock(&m_lock);
            return values[key];
        }
        return values[key];
    }

    const settingValue& get(Setting key) {
        return values[key];
    }
    void setRefresh() { needRefresh = true; }
    bool needsRefresh() const { return needRefresh; }
    Signal<void(const Setting&)> configValueSet;
private:
    CriticalSectionLock m_lock;
    bool needRefresh = true;
    std::array<settingValue, Setting::Setting_MAX + 1> values{
        Settings(EnumDefault)
    };
};

