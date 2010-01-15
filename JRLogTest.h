#import <SenTestingKit/SenTestingKit.h>
#define JRLogOverrideNSLog 1
#import "JRLog.h"

@interface MyJRLogMessage : NSObject {
@public
    JRLogLevel  callerLevel;
    NSString    *instance;
    const char  *file;
    unsigned    line;
    const char  *function;
    NSString    *message;
    NSString    *formattedMessage;
}
- (id)initWithLevel:(JRLogLevel)callerLevel_
           instance:(NSString*)instance_
               file:(const char*)file_
               line:(unsigned)line_
           function:(const char*)function_
            message:(NSString*)message_
   formattedMessage:(NSString*)formattedMessage_;
@end

@interface MyDebugLogger : NSObject<JRLogLogger> {
@public
    NSMutableArray *messages;
}
@end

@interface JRLogTest : SenTestCase {
    MyDebugLogger *debugLogger;
}
@end

@interface MyFormatter : NSObject<JRLogFormatter>
@end

@interface MyFormatterSubclass : JRLogDefaultFormatter
@end