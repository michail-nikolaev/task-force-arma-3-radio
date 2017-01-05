
#include "common.hpp"
#include "profilers.hpp"
#include "CommandProcessor.hpp"
#include "helpers.hpp"
#include "Logger.hpp"
#include "task_force_radio.hpp"











void assertfunc(bool as, std::string cause) {
    if (as)
        DebugBreak();
}
#define ASSERT(a) assertfunc(!(a),#a)

auto speedTestStringToGameCommand() {
    std::string test1("TS_INFO");
    std::string test2("IS_SPEAKING");
    std::string test3("FREQ");
    std::string test4("KILLED");
    std::string test5("TRACK");
    std::string test6("DFRAME");
    std::string test7("SPEAKERS");
    std::string test8("TANGENT");
    std::string test9("TANGENT_LR");
    std::string test10("TANGENT_DD");
    std::string test11("RELEASE_ALL_TANGENTS");
    std::string test12("SETCFG");
    std::string test13("MISSIONEND");
    std::string test14("unknown");
    std::string test15("POS");
    static gameCommand results[32];
    std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    for (auto i = 0; i < 1000000; ++i) {
        results[0] = CommandProcessor::toGameCommand(test1, 2);
        results[1] = CommandProcessor::toGameCommand(test2, 2);
        results[2] = CommandProcessor::toGameCommand(test3, 14);
        results[3] = CommandProcessor::toGameCommand(test4, 3);
        results[4] = CommandProcessor::toGameCommand(test5, 4);
        results[5] = CommandProcessor::toGameCommand(test6, 1);
        results[6] = CommandProcessor::toGameCommand(test7, 1);
        results[7] = CommandProcessor::toGameCommand(test8, 6);
        results[8] = CommandProcessor::toGameCommand(test9, 6);
        results[9] = CommandProcessor::toGameCommand(test10, 6);
        results[10] = CommandProcessor::toGameCommand(test11, 2);
        results[11] = CommandProcessor::toGameCommand(test12, 3);
        results[12] = CommandProcessor::toGameCommand(test13, 1);
        results[13] = CommandProcessor::toGameCommand(test14, 1);
        results[14] = CommandProcessor::toGameCommand(test15, 12);
    }
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
    ASSERT(results[0] == gameCommand::TS_INFO);
    ASSERT(results[1] == gameCommand::IS_SPEAKING);
    ASSERT(results[2] == gameCommand::FREQ);
    ASSERT(results[3] == gameCommand::KILLED);
    ASSERT(results[4] == gameCommand::TRACK);
    ASSERT(results[5] == gameCommand::DFRAME);
    ASSERT(results[6] == gameCommand::SPEAKERS);
    ASSERT(results[7] == gameCommand::TANGENT);
    ASSERT(results[8] == gameCommand::TANGENT);
    ASSERT(results[9] == gameCommand::TANGENT);
    ASSERT(results[10] == gameCommand::RELEASE_ALL_TANGENTS);
    ASSERT(results[11] == gameCommand::SETCFG);
    ASSERT(results[12] == gameCommand::MISSIONEND);
    ASSERT(results[13] == gameCommand::unknown);
    ASSERT(results[14] == gameCommand::POS);
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(now - start);
    profiler::log(std::to_string(duration.count() / 1000000) + " nanoseconds per iteration");
    return duration;
}
#include <vector>
auto speedTestStringSplit() {
    std::vector<std::string> splitted;
    splitted.reserve(50);
    std::string toSplit("test\tTHIS is a\ttest\ttest\t\t\ttest\ttest\test");
    static size_t results[32];
    std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    for (auto i = 0; i < 1000000; ++i) {
        helpers::split(toSplit, '\t', splitted);
        results[0] = splitted.size();
        splitted.clear();
    }
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
    ASSERT(results[0] > 1);
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(now - start);
    profiler::log(std::to_string(duration.count() / 1000000) + " nanoseconds per iteration");
    return duration;
}

auto speedTestStringSplitRef() {
    std::vector<boost::string_ref> splitted;
    splitted.reserve(50);
    std::string toSplit("test\tTHIS is a\ttest\ttest\t\t\ttest\ttest\test");
    static size_t results[32];
    std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    for (auto i = 0; i < 1000000; ++i) {
        helpers::split(boost::string_ref(toSplit), '\t', splitted);
        results[0] = splitted.size();
        splitted.clear();
    }
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
    ASSERT(results[0] > 1);
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(now - start);
    profiler::log(std::to_string(duration.count() / 1000000) + " nanoseconds per iteration");
    return duration;
}

auto clientDataMapAccess() {
    std::unordered_map<std::string, std::shared_ptr<clientData>> data;
    std::map<TSClientID, std::shared_ptr<clientData>> data2;
    std::string name1("test1");
    std::string name2("test2");
    std::string name3("test3");
    std::string name4("test4");
    std::string name5("test5");
    std::string name6("test6");
    std::string name7("test7");

    auto findInData = [&](const std::string& str) {
        return data.find(str);
    };
    auto findInData2 = [&](const TSClientID& cid) {
        return data2.find(cid);
    };
    auto insertInData = [&](const std::string& str, TSClientID clientID) {
        data.insert_or_assign(str, nullptr);
        data2.insert_or_assign(clientID, nullptr);
    };

    insertInData(name1, 1);
    insertInData(name2, 2);
    insertInData(name3, 3);
    insertInData(name4, 4);
    insertInData(name5, 5);
    insertInData(name6, 6);
    insertInData(name7, 7);


    static std::unordered_map<std::string, std::shared_ptr<clientData>>::iterator results[32];
    static std::map<TSClientID, std::shared_ptr<clientData>>::iterator results2[32];
    std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    for (auto i = 0; i < 1000000; ++i) {
        results[0] = findInData(name1);
        results[1] = findInData(name2);
        results[2] = findInData(name3);
        results[3] = findInData(name4);
        results[4] = findInData(name5);
        results[5] = findInData(name6);
        results[6] = findInData(name7);
        results2[0] = findInData2(1);
        results2[1] = findInData2(2);
        results2[2] = findInData2(3);
        results2[3] = findInData2(4);
        results2[4] = findInData2(5);
        results2[5] = findInData2(6);
        results2[6] = findInData2(7);
    }
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();


    ASSERT(results[0] != data.end());
    ASSERT(results2[0] != data2.end());
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(now - start);
    profiler::log(std::to_string(duration.count() / 1000000) + " nanoseconds per iteration");
    return duration;
}

auto clientDataVectorAccess() {
    using clientDataDirectoryElement = std::tuple<size_t, TSClientID, std::shared_ptr<clientData>>;

    std::vector<clientDataDirectoryElement> data;

    std::string name1("test1");
    std::string name2("test2");
    std::string name3("test3");
    std::string name4("test4");
    std::string name5("test5");
    std::string name6("test6");
    std::string name7("test7");

    auto findInData = [&](const std::string& str) {
        auto range = std::equal_range(data.begin(), data.end(), std::make_tuple(std::hash<std::string>()(str), 0, nullptr), [](const auto& lhs, const auto& rhs) {
            return std::get<0>(lhs) < std::get<0>(rhs);
        });
        if (range.first == range.second) return data.end();
        return range.first;
    };

    auto findInData2 = [&](const TSClientID& cid) {
        return std::find_if(data.begin(), data.end(), [&cid](const auto& lhs) {
            return std::get<1>(lhs) == cid;
        });
    };

    auto insertInData = [&](const std::string& str, TSClientID clientID) {
        auto hash = std::hash<std::string>()(str);
        data.emplace(std::upper_bound(data.begin(), data.end(), hash, [](const size_t& hash, const auto& tup) {
            return hash < std::get<0>(tup);
        }), hash, clientID, std::shared_ptr<clientData>());
    };

    insertInData(name1, 1);
    insertInData(name2, 2);
    insertInData(name3, 3);
    insertInData(name4, 4);
    insertInData(name5, 5);
    insertInData(name6, 6);
    insertInData(name7, 7);


    static std::vector<clientDataDirectoryElement>::iterator results[32];
    std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    for (auto i = 0; i < 1000000; ++i) {
        results[0] = findInData(name1);
        results[1] = findInData(name2);
        results[2] = findInData(name3);
        results[3] = findInData(name4);
        results[4] = findInData(name5);
        results[5] = findInData(name6);
        results[6] = findInData(name7);
        results[0] = findInData2(1);
        results[1] = findInData2(2);
        results[2] = findInData2(3);
        results[3] = findInData2(4);
        results[4] = findInData2(5);
        results[5] = findInData2(6);
        results[6] = findInData2(7);
    }
    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();


    ASSERT(results[0] != data.end());
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(now - start);
    profiler::log(std::to_string(duration.count() / 1000000) + " nanoseconds per iteration");
    return duration;
}








int main() {
    Logger::registerLogger(LoggerTypes::profiler, std::make_shared<DebugStringLogger>());
    //auto durationStringToGameCommand = speedTestStringToGameCommand(); //should be < 300ns release <1300 ns debug
    auto durationStringSplit = speedTestStringSplit(); //should be < 260ns release
    auto durationStringSplit2 = speedTestStringSplitRef(); //should be < 140ns release
    clientDataVectorAccess();//150ns
    clientDataMapAccess();//250ns
    ASSERT(TFAR::Version("0.9.9") > TFAR::Version("0.9.8"));
    ASSERT(TFAR::Version("0.9.13") > TFAR::Version("0.9.12"));
    ASSERT(TFAR::Version("1.0.0.0") > TFAR::Version("0.9.8"));
    ASSERT(TFAR::Version("1.0.0.0") > TFAR::Version("0.9.12"));
    ASSERT(TFAR::Version("1.0.0") > TFAR::Version("0.9.12"));

    Position3D above(10, 10, 10);
    Position3D below(-10, -10, -10);
    float dist = above.distanceUnderwater(below);



    getchar();


    return 0;
}
