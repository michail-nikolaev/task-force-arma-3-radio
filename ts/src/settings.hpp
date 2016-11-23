#pragma once
#include <string>
#include <array>
#include "helpers.hpp"
#include "enum.hpp"
#include "Locks.hpp"
#include "SignalSlot.hpp"

#pragma push_macro("max") //macro is interfering with ENUM _from_string function. Could also define NOMINMAX globally
#undef max
ENUM(Setting, unsigned char,
    full_duplex = 0,
    addon_version,
    serious_channelName,
    serious_channelPassword,
    intercomVolume,
    intercomEnabled,
    Setting_MAX	//has to be last value
)
#pragma pop_macro("max")

static_assert(Setting("full_duplex") == 0x0, "Can't execute Setting::_to_string at compile time!");


class settingValue {//This is heavily optimized towards booleans get<bool> can be optimized down to a single instruction. Allowing very fast branching
public:
    explicit settingValue() : type(settingType::t_invalid), boolValue(false) {}
    constexpr settingValue(bool value) : type(settingType::t_bool), boolValue(value) {}
    settingValue(const float& value) : type(settingType::t_float), floatValue(value) {}
    settingValue(const std::string& value) : type(settingType::t_string), stringValue(new std::string(value)) {}
    settingValue(const char* value) : type(settingType::t_string), stringValue(new std::string(value)) {}
    void operator=(const bool& value) {
        switch (type) {
            case settingType::t_bool: boolValue = value;
            case settingType::t_float: floatValue = value ? 1.f : 0.f;
            case settingType::t_string: stringValue->assign(value ? "true" : "false");
        }
    }
    void operator=(const float& value) {
        switch (type) {
            case settingType::t_bool: boolValue = value > 0.f;
            case settingType::t_float: floatValue = value;
            case settingType::t_string: stringValue->assign(std::to_string(value));
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
        switch (type) {
            case settingType::t_bool: return boolValue ? 1.f : 0.f;
            case settingType::t_float: return floatValue;
            case settingType::t_string: return helpers::parseArmaNumber(*stringValue);
        }
        return 0.f;
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
        true,  //full_duplex
        "unknown", 
        "",  //serious_channelName
        "",   //serious_channelPassword
        0.3f, //intercomVolume
        true //intercomEnabled
    };
};

