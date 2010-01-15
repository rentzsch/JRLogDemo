#import <Cocoa/Cocoa.h>
#import "JRLog.h"

@interface AppController : NSObject<JRLogLogger> {
    IBOutlet NSTextView *logView;
}
- (IBAction)logSomething:(id)sender;
@end
