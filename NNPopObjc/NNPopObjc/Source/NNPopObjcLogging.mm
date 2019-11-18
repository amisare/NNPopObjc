//
//  NNPopObjcLogging.m
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/18.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import "NNPopObjcLogging.h"

#include <algorithm>
#include <iostream>
#include <syslog.h>


namespace popobjc {

int LogSettings::minLogLevel() {
    return std::min(this->_minLogLevel, LOG_SEVERITY_FATAL);
}
void LogSettings::minLogLevel(LogSeverity minLogLevel) {
    this->_minLogLevel = std::min(LOG_SEVERITY_FATAL, minLogLevel);
}


namespace {

const char* const kLogSeverityNames[LOG_SEVERITY_NUM_SEVERITIES] = {"INFO", "WARNING",
    "ERROR", "FATAL"};

const char* GetNameForLogSeverity(LogSeverity severity) {
    if (severity >= LOG_SEVERITY_INFO && severity < LOG_SEVERITY_NUM_SEVERITIES)
        return kLogSeverityNames[severity];
    return "UNKNOWN";
}

const char* StripDots(const char* path) {
    while (strncmp(path, "../", 3) == 0)
        path += 3;
    return path;
}

const char* StripPath(const char* path) {
    auto* p = strrchr(path, '/');
    if (p)
        return p + 1;
    else
        return path;
}

}  // namespace


LogMessage::LogMessage(LogSeverity severity,
                       const char* file,
                       int line,
                       const char* condition)
: severity_(severity), file_(file), line_(line) {
    
    stream_ << "[";
    
    if (severity >= LOG_SEVERITY_INFO) {
        stream_ << GetNameForLogSeverity(severity);
    }
    else {
        stream_ << "VERBOSE" << -severity;
    }
    
    stream_ << ":" << (severity > LOG_SEVERITY_INFO ? StripDots(file_) : StripPath(file_)) << "(" << line_ << ")] ";
    
    if (condition) {
        stream_ << "Check failed: " << condition << ". ";
    }
}

LogMessage::~LogMessage() {
    stream_ << std::endl;
    
    syslog(LOG_ALERT, "%s", stream_.str().c_str());
    
    if (severity_ >= LOG_SEVERITY_FATAL) {
        abort();
    }
}

int GetVlogVerbosity() {
    return std::max(-1, LOG_SEVERITY_INFO - state::settings.minLogLevel());
}

bool ShouldCreateLogMessage(LogSeverity severity) {
    return severity >= state::settings.minLogLevel();
}


namespace state {

LogSettings settings;

}  // namespace state

}  // namespace popobjc
