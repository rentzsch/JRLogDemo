#import "AppController.h"

@implementation AppController

- (void)awakeFromNib {
    JRLogSetLogger(self);
}

- (IBAction)logSomething:(id)sender {
    JRLogInfo(@"sender: %@", sender);
}

- (void)logWithLevel:(JRLogLevel)callerLevel_
			instance:(NSString*)instance_
				file:(const char*)file_
				line:(unsigned)line_
			function:(const char*)function_
			 message:(NSString*)message_
{
    NSString *formattedMessage = [JRLogGetFormatter() formattedMessageWithLevel:callerLevel_
                                                                       instance:instance_
                                                                           file:file_
                                                                           line:line_
                                                                       function:function_
                                                                        message:message_];
    if (formattedMessage) {
        [[logView textStorage] appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", formattedMessage]] autorelease]];
    }
}

@end
