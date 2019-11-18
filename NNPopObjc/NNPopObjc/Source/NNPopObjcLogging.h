//
//  NNPopObjcLogging.h
//  NNPopObjc
//
//  Created by 顾海军 on 2019/11/18.
//  Copyright © 2019 GuHaiJun. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sstream>

namespace popobjc {

typedef int LogSeverity;

// Default log levels. Negative values can be used for verbose log levels.
constexpr LogSeverity LOG_SEVERITY_INFO = 0;
constexpr LogSeverity LOG_SEVERITY_WARNING = 1;
constexpr LogSeverity LOG_SEVERITY_ERROR = 2;
constexpr LogSeverity LOG_SEVERITY_FATAL = 3;
constexpr LogSeverity LOG_SEVERITY_NUM_SEVERITIES = 4;

// LOG_SEVERITY_DFATAL is LOG_SEVERITY_FATAL in debug mode, ERROR in normal mode
#ifdef DEBUG
const LogSeverity LOG_SEVERITY_DFATAL = LOG_SEVERITY_FATAL;
#else
const LogSeverity LOG_SEVERITY_DFATAL = LOG_SEVERITY_ERROR;
#endif


// Settings which control the behavior of popobjc logging.
struct LogSettings {
    // The minimum logging level.
private:
    LogSeverity _minLogLevel = LOG_SEVERITY_INFO;
    
public:
    int minLogLevel();
    void minLogLevel(LogSeverity minLogLevel);
};


class LogMessageVoidify {
public:
    void operator&(std::ostream&) {}
};


class LogMessage {
public:
    LogMessage(LogSeverity severity,
               const char* file,
               int line,
               const char* condition);
    ~LogMessage();
    
    std::ostream& stream() { return stream_; }
    
private:
    std::ostringstream stream_;
    const LogSeverity severity_;
    const char* file_;
    const int line_;

    // Disallows copy assign and move
    LogMessage(const LogMessage&) = delete;
    LogMessage& operator=(const LogMessage&) = delete;
};

// Gets the POP_VLOG default verbosity level.
int GetVlogVerbosity();

// Returns true if |severity| is at or above the current minimum log level.
// LOG_SEVERITY_FATAL and above is always true.
bool ShouldCreateLogMessage(LogSeverity severity);


namespace state {

extern LogSettings settings;

}  // namespace state

}  // namespace popobjc


#define POP_LOG_STREAM(severity) \
        ::popobjc::LogMessage(::popobjc::LOG_SEVERITY_##severity, __FILE__, __LINE__, nullptr).stream()

#define POP_LAZY_STREAM(stream, condition) \
        !(condition) ? (void)0 : ::popobjc::LogMessageVoidify() & (stream)

#define POP_EAT_STREAM_PARAMETERS(ignored) \
        true || (ignored)                  \
            ? (void)0                      \
            : ::popobjc::LogMessageVoidify() & \
              ::popobjc::LogMessage(::popobjc::LOG_SEVERITY_FATAL, 0, 0, nullptr).stream()

#define POP_LOG_IS_ON(severity) \
        (::popobjc::ShouldCreateLogMessage(::popobjc::LOG_SEVERITY_##severity))

#define POP_LOG(severity) \
        POP_LAZY_STREAM(POP_LOG_STREAM(severity), POP_LOG_IS_ON(severity))

#define POP_CHECK(condition) \
        POP_LAZY_STREAM( \
            ::popobjc::LogMessage(::popobjc::LOG_SEVERITY_FATAL, __FILE__, __LINE__, #condition).stream(), \
            !(condition))

#define POP_VLOG_IS_ON(verbose_level) \
        ((verbose_level) <= ::popobjc::GetVlogVerbosity())

// The VLOG macros log with negative verbosities.
#define POP_VLOG_STREAM(verbose_level) \
        ::popobjc::LogMessage(-verbose_level, __FILE__, __LINE__, nullptr).stream()

#define POP_VLOG(verbose_level) \
        POP_LAZY_STREAM(POP_VLOG_STREAM(verbose_level), POP_VLOG_IS_ON(verbose_level))

#ifdef DEBUG
#define POP_DLOG(severity) POP_LOG(severity)
#define POP_DCHECK(condition) POP_CHECK(condition)
#else
#define POP_DLOG(severity) POP_EAT_STREAM_PARAMETERS(true)
#define POP_DCHECK(condition) POP_EAT_STREAM_PARAMETERS(condition)
#endif

#define POP_NOTREACHED() POP_DCHECK(false)

#define POP_NOTIMPLEMENTED() \
        POP_LOG(ERROR) << "Not implemented in: " << __PRETTY_FUNCTION__
