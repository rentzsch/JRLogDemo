#import "JRLogTest.h"

@implementation JRLogTest

- (void)setUp {
    debugLogger = [[MyDebugLogger alloc] init];
    JRLogSetLogger(debugLogger);
}

- (JRLogCall*)consumeOnlyMessage {
    STAssertEquals([debugLogger->messages count], (unsigned)1, nil);
    JRLogCall *result = [[[debugLogger->messages objectAtIndex:0] retain] autorelease];
    [debugLogger->messages removeLastObject];
    return result;
}

- (void)testLevels {
    STAssertEquals((unsigned)0, [debugLogger->messages count], nil);
    
    JRLogDebug(@"testDebug");
    
    JRLogCall *logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Debug, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
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
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testInfo", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testInfo"].location == NSNotFound, nil);
    
    JRLogWarn(@"testWarn");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Warn, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testWarn", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testWarn"].location == NSNotFound, nil);
    
    JRLogError(@"testError");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Error, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testError", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testError"].location == NSNotFound, nil);
    
    JRLogAssert(1==2, nil);//JRLogAssert(1==2, @"test%@", @"Assert");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Assert, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"1==2", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"1==2"].location == NSNotFound, nil);
    
    JRLogAssert(1==2, @"test%@", @"Assert");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Assert, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"1==2 (testAssert)", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"1==2"].location == NSNotFound, nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testAssert"].location == NSNotFound, nil);
    
    /** Can't really test fatal since it calls exit(1).
    JRLogFatal(@"testFatal");
    
    logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Fatal, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
    STAssertEqualObjects(@"-[JRLogTest testLevels]", [NSString stringWithUTF8String:logMessage->function], nil);
    STAssertEqualObjects(@"testFatal", logMessage->message, nil);
    STAssertTrue([logMessage->formattedMessage length] > [logMessage->message length], nil);
    STAssertFalse([logMessage->formattedMessage rangeOfString:@"testFatal"].location == NSNotFound, nil);
    */
}

- (void)testCompiletimeLevels {
    STAssertEquals((unsigned)0, [debugLogger->messages count], nil);
    
    // TODO
}

- (void)testCustomFormatter {
    JRLogDebug(@"testCustomFormatter");
    
    JRLogCall *logMessage = [self consumeOnlyMessage];
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
    
    JRLogCall *logMessage = [self consumeOnlyMessage];
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
    
    JRLogCall *logMessage = [self consumeOnlyMessage];
    STAssertEquals(JRLogLevel_Info, logMessage->callerLevel, nil);
    STAssertFalse([logMessage->instance rangeOfString:@"JRLogTest"].location == NSNotFound, nil);
    STAssertEqualObjects(@"JRLogTest.m", [[NSString stringWithUTF8String:logMessage->file] lastPathComponent], nil);
    STAssertEquals((unsigned)__LINE__-6, logMessage->line, nil);
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

- (void)logWithCall:(JRLogCall*)call_ {
    [call_ setFormattedMessage:[JRLogGetFormatter() formattedMessageWithCall:call_]];
    [messages addObject:call_];
}

@end

@implementation MyFormatter

- (NSString*)formattedMessageWithCall:(JRLogCall*)call_ {
    return JRLogLevelNames[call_->callerLevel];
}

@end


@implementation MyFormatterSubclass

- (NSString*)formattedMessageWithCall:(JRLogCall*)call_ {
    return [NSString stringWithFormat:@"SUBCLASS %@", [super formattedMessageWithCall:call_]];
}

@end