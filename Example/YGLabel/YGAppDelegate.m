//
//  YGAppDelegate.m
//  YGLabel
//

#import "YGAppDelegate.h"
#import "KMCGeigerCounter.h"
@implementation YGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    KMCGeigerCounter.sharedGeigerCounter.enabled = YES;
    return YES;
}

@end
