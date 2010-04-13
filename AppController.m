#import "AppController.h"

@implementation AppController

- (void)awakeFromNib {
    JRLogSetLogger(self);
}

- (IBAction)logSomething:(id)sender {
    JRLogAssert(NO, nil);
    JRLogInfo(@"sender: %@", sender);
}

- (void)logWithCall:(JRLogCall*)call_ {
    NSString *formattedMessage = [JRLogGetFormatter() formattedMessageWithCall:call_];
    if (formattedMessage) {
        [[logView textStorage] appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", formattedMessage]] autorelease]];
    }
}

@end
