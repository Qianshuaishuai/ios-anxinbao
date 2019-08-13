/*!

 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BaseInfoController : BaseViewController
@property (nonatomic , retain) UINavigationController *navigationController;
@property NSString* pid;
-(void)setData:(NSDictionary*)data isOnline:(int)isOnline;
- (void)stopTimer;
-(void)startTimer;
@end
