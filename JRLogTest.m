#import "JRLogTest.h"


@implementation JRLogTest

- (void)setUp {
    debugLogger = [[MyDebugLogger alloc] init];
    JRLogSetLogger(debugLogger);
}

- (MyJRLogMessage*)consumeOnlyMessage {
    STAssertEquals([debugLogger->messages count], (unsigned)1, nil);
    MyJRLogMessage *result = [[[debugLogger->messages objectAtIndex:0] retain] autorelease];
    [debugLogger->messages removeLastObject];
    return result;
}

- (void)testLevels {
    STAssertEquals((unsigned)0, [debugLogger->messages count], nil);
    
    JRLogDebug(@"testDebug");
    
    MyJRLogMessage *logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Debug, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)21, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testDebug", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testDebug"].location == NSNotFound, nil);
    STAssertTrue([logMessage->formattedMessage rangeOfString:@"xyzzy"].location == NSNotFound, nil);
    
    JRLogInfo(@"testInfo");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Info, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)34, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testInfo", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testInfo"].location == NSNotFound, nil);
    
    JRLogWarn(@"testWarn");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Warn, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)46, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testWarn", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testWarn"].location == NSNotFound, nil);
    
    JRLogError(@"testError");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Error, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)58, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testError", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testError"].location == NSNotFound, nil);
    
    /** Can't really test fatal since it calls exit(1).
    JRLogFatal(@"testFatal");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Fatal, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)71, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testFatal", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testFatal"].location == NSNotFound, nil);
    */
}

- (void)testCustomFormatter {
    JRLogDebug(@"testCustomFormatter");
    
    MyJRLogMessage *logMessage = [self consumeOnlyMessage];
    STAssertFalse([logMessage->formattedMessage isEqualToString:@"DEBUG"], nil);
    
    JRLogSetFormatter([[[MyFormatter alloc] init] autorelease]);
    
    JRLogDebug(@"testCustomFormatter");
    logMessage = [self consumeOnlyMessage];
    STAssertEqualObjects(logMessage->formattedMessage, @"DEBUG", nil);
    
    JRLogError(@"testCustomFormatter");
    logMessage = [self consumeOnlyMessage];
    STAssertEqualObjects(logMessage->formattedMessage, @"ERROR", nil);
    
    JRLogSetFormatter(nil);
}

- (void)testFormatterSubclass {
    JRLogDebug(@"testWithoutFormatterSubclass");
    
    MyJRLogMessage *logMessage = [self consumeOnlyMessage];
    STAssertFalse([logMessage->formattedMessage hasPrefix:@"SUBCLASS"], nil);
    
    JRLogSetFormatter([[[MyFormatterSubclass alloc] init] autorelease]);
    
    JRLogDebug(@"testWithFormatterSubclass");
    logMessage = [self consumeOnlyMessage];
    STAssertTrue([logMessage->formattedMessage hasPrefix:@"SUBCLASS"], nil);
    
    JRLogSetFormatter(nil);
}

- (void)testNSLogOverride {
    STAssertEquals((unsigned)0, [debugLogger->messages count], nil);
    
    NSLog(@"testNSLogOverride");
    
    MyJRLogMessage *logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Info, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)122, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testNSLogOverride]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testNSLogOverride", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testNSLogOverride"].location == NSNotFound, nil);
    STAssertTrue([logMessage->formattedMessage rangeOfString:@"xyzzy"].location == NSNotFound, nil);
}

- (void)tearDown {
    JRLogSetLogger(nil);
    [debugLogger release];
}

@end

@implementation MyJRLogMessage

- (id)initWithLevel:(JRLogLevel)callerLevel_
           instance:(NSString*)instance_
               file:(const char*)file_
               line:(unsigned)line_
           function:(const char*)function_
            message:(NSString*)message_
   formattedMessage:(NSString*)formattedMessage_
{
    self = [super init];
    if (self) {
        callerLevel = callerLevel_;
        instance = [instance_ retain];
        file = file_;
        line = line_;
        function = function_;
        message = [message_ retain];
        formattedMessage = [formattedMessage_ retain];
    }
    return self;
}

- (void)dealloc {
    [instance release];
    [message release];
    [formattedMessage release];
    [super dealloc];
}

@end

@implementation MyDebugLogger

- (id)init {
    self = [super init];
    if (self) {
        messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [messages release];
    [super dealloc];
}

- (void)logWithLevel:(JRLogLevel)callerLevel_
			instance:(NSString*)instance_
				file:(const char*)file_
				line:(unsigned)line_
			function:(const char*)function_
			 message:(NSString*)message_;
{
    NSString *formattedMessage = [JRLogGetFormatter() formattedMessageWithLevel:callerLevel_
                                                                       instance:instance_
                                                                           file:file_
                                                                           line:line_
                                                                       function:function_
                                                                        message:message_];
    [messages addObject:[[[MyJRLogMessage alloc] initWithLevel:callerLevel_
                                                      instance:instance_
                                                          file:file_
                                                          line:line_
                                                      function:function_
                                                       message:message_
                                              formattedMessage:formattedMessage] autorelease]];
}

@end

@implementation MyFormatter

- (NSString*)formattedMessageWithLevel:(JRLogLevel)callerLevel_
                              instance:(NSString*)instance_
                                  file:(const char*)file_
                                  line:(unsigned)line_
                              function:(const char*)function_
                               message:(NSString*)message_
{
    return JRLogLevelNames[callerLevel_];
}

@end


@implementation MyFormatterSubclass

- (NSString*)formattedMessageWithLevel:(JRLogLevel)callerLevel_
                              instance:(NSString*)instance_
                                  file:(const char*)file_
                                  line:(unsigned)line_
                              function:(const char*)function_
                               message:(NSString*)message_
{
    return [NSString stringWithFormat:@"SUBCLASS %@", [super formattedMessageWithLevel:callerLevel_
                                                                              instance:instance_
                                                                                  file:file_
                                                                                  line:line_
                                                                              function:function_
                                                                               message:message_]];
}

@end