#import <SenTestingKit/SenTestingKit.h>
#define JRLogOverrideNSLog 1
#import "JRLog.h"

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