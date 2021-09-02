//
//  YGViewController.m
//  YGLabel
//

#import "YGViewController.h"
#import <YGLabel/YGLabel.h>
#import <YGLabel/YGLabelQueueManager.h>
@interface YGViewController ()

@end

@implementation YGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < 100; i++) {
        NSLog(@"%@", LabelDispalyQueue);
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
