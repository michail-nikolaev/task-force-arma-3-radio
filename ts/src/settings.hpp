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
    Setting_MAX	//has to be last value
)
#pragma pop_macro("max")

static_assert(Setting("full_duplex") == 0x0, "Can't execute Setting::_to_string at compile time!");


class settingValue {
public:
    explicit settingValue() : type(settingType::t_invalid), boolValue(false) {}
    explicit settingValue(const bool& value) : type(settingType::t_bool), boolValue(value) {}
    explicit settingValue(const float& value) : type(settingType::t_float), floatValue(value) {}
    explicit settingValue(const std::string& value) : type(settingType::t_string), stringValue(new std::string(value)) {}
    explicit settingValue(const char* value) : type(settingType::t_string), stringValue(new std::string(value)) {}
    void operator=(const bool& value) {
        type = settingType::t_bool;
        boolValue = value;
    }
    void operator=(const float& value) {
        type = settingType::t_float;
        floatValue = value;
    }
    void operator=(const std::string& value) {
        if (type == settingType::t_string)
            delete stringValue;
        type = settingType::t_string;
        stringValue = new std::string(value);
    }
    void operator=(const char* value) {
        operator=(std::string(value));
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
        switch (type) {
            case settingType::t_bool: return boolValue;
            case settingType::t_float: return floatValue > 0.f;
            case settingType::t_string: return !stringValue->compare("true") || !stringValue->compare("TRUE");
        }
        return false;
    }

private:
    enum class settingType {
        t_invalid,
        t_bool,
        t_float,
        t_string
    } type;
    union {
        bool boolValue;
        float floatValue;
        const std::string* stringValue;
    };
};

class settings {
public:
    settings() {
        //default variables
        values[Setting::full_duplex] = true;
        values[Setting::addon_version] = "unknown";
        values[Setting::serious_channelName] = "";
        values[Setting::serious_channelPassword] = "";
    }
    ~settings() {}
    template<typename TYPE>
    void set(const Setting& key, const TYPE& value) {
        if (std::is_same<TYPE, std::string>::value) {  //Only lock for types that are big enough to need mutex
            LockGuard_exclusive<CriticalSectionLock> lock(&m_lock);
            values[key] = value;
            needRefresh = false;
        } else {
            values[key] = value;
            needRefresh = false;
        }
        configValueSet(key);
    }
    template<typename TYPE>
    TYPE get(const Setting& key) {
        if (std::is_same<TYPE, std::string>::value) {	//Only lock for types that are big enough to need mutex
            LockGuard_exclusive<CriticalSectionLock> lock(&m_lock);
            if (Setting::Setting_MAX < key)//Using that instead of values.size because that can be evaluated at compile-time
                return values.at(Setting::Setting_MAX);
            return values.at(key);
        } else {
            if (Setting::Setting_MAX < key)//Using that instead of values.size because that can be evaluated at compile-time
                return values.at(Setting::Setting_MAX);
            return values.at(key);
        }
    }

    const settingValue& get(const Setting& key) {
        if (Setting::Setting_MAX < key)//Using that instead of values.size because that can be evaluated at compile-time
            return values.at(Setting::Setting_MAX);
        return values.at(key);
    }
    void setRefresh() { needRefresh = true; }
    bool needsRefresh() const { return needRefresh; }
    Signal<void(const Setting&)> configValueSet;
private:
    CriticalSectionLock m_lock;
    bool needRefresh = true;
    std::array<settingValue, Setting::Setting_MAX + 1> values;
};

