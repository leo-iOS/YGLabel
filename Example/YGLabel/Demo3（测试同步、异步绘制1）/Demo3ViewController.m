//
//  Demo3ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo3ViewController.h"
#import <YGLabel/YGLabel.h>

@interface Demo3ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) YGLabel *label;

@property (weak, nonatomic) IBOutlet UISwitch *aSwitch;
@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, assign) BOOL isOpenSync;

@end

@implementation Demo3ViewController
- (IBAction)switchAction:(id)sender {
    self.isOpenSync = self.aSwitch.isOn;
}

- (void)setIsOpenSync:(BOOL)isOpenSync {
    _isOpenSync = isOpenSync;
    self.label.displayAsync = isOpenSync;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[YGLabel alloc] init];
    self.label.text = @"ไธ๐ธไบ๐ ไธ๐ฅๅ๐ ไบ๐ๅญ๐ณไธ๐ฟๅซ๐จไน๐ฆๅ๐ๅไธ๐ๅไบ๐ๅไธ๐ฆๅๅ๐ๆฏ๐ฆ๐๐ฆ๐๐ญ๐ฌ๐ญ๐๐ญ๐๐๐ฌ๐๐๐๐๐น๐๐๐๐๐๐๐๐๐๐ค๐๐๐๐๐ค๐๐ค๐๐๐๐๐๐ข๐ฅ๐ฅ๐๐ช๐๐ช๐๐ด๐ช๐ค๐ค๐ท๐๐๐๐ค๐ช๐ค๐ด๐ค๐ด๐๐๐๐๐๐๐๐๐๐ณ๐๐๐ฏ๐ฏ๐๐ด๐๐๐ฒ๐ฎ๐ธ๐ณ๐ธ๐๐ฒ๐๐ฒ๐๐๐๐ซ๐ข๐ณ๐ข๐ณ๐ท๐ฑ๐ต๐ง๐ง๐๐๐ ๐ ๐จ๐ณ๐ฉ๐ฟ๐จ๐ณ๐ฉ๐ฟ๐ฆ๐ซ๐ฆ๐ธ๐ฆ๐ด๐ฆ๐ผ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ฆ๐น๐ฆ๐นไธ๐ธไบ๐ ไธ๐ฅๅ๐ ไบ๐ๅญ๐ณไธ๐ฟๅซ๐จไน๐ฆๅ๐ๅไธ๐ๅไบ๐ๅไธ๐ฆๅๅ๐ๆฏ๐ฆ๐๐ฆ๐๐ญ๐ฌ๐ญ๐๐ญ๐๐๐ฌ๐๐๐๐๐น๐๐๐๐๐๐๐๐๐๐ค๐๐๐๐๐ค๐๐ค๐๐๐๐๐๐ข๐ฅ๐ฅ๐๐ช๐๐ช๐๐ด๐ช๐ค๐ค๐ท๐๐๐๐ค๐ช๐ค๐ด๐ค๐ด๐๐๐๐๐๐๐๐๐๐ณ๐๐๐ฏ๐ฏ๐๐ด๐๐๐ฒ๐ฎ๐ธ๐ณ๐ธ๐๐ฒ๐๐ฒ๐๐๐๐ซ๐ข๐ณ๐ข๐ณ๐ท๐ฑ๐ต๐ง๐ง๐๐๐ ๐ ๐จ๐ณ๐ฉ๐ฟ๐จ๐ณ๐ฉ๐ฟ๐ฆ๐ซ๐ฆ๐ธ๐ฆ๐ด๐ฆ๐ผ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ฆ๐น๐ฆ๐นไธ๐ธไบ๐ ไธ๐ฅๅ๐ ไบ๐ๅญ๐ณไธ๐ฟๅซ๐จไน๐ฆๅ๐ๅไธ๐ๅไบ๐ๅไธ๐ฆๅๅ๐ๆฏ๐ฆ๐๐ฆ๐๐ญ๐ฌ๐ญ๐๐ญ๐๐๐ฌ๐๐๐๐๐น๐๐๐๐๐๐๐๐๐๐ค๐๐๐๐๐ค๐๐ค๐๐๐๐๐๐ข๐ฅ๐ฅ๐๐ช๐๐ช๐๐ด๐ช๐ค๐ค๐ท๐๐๐๐ค๐ช๐ค๐ด๐ค๐ด๐๐๐๐๐๐๐๐๐๐ณ๐๐๐ฏ๐ฏ๐๐ด๐๐๐ฒ๐ฎ๐ธ๐ณ๐ธ๐๐ฒ๐๐ฒ๐๐๐๐ซ๐ข๐ณ๐ข๐ณ๐ท๐ฑ๐ต๐ง๐ง๐๐๐ ๐ ๐จ๐ณ๐ฉ๐ฟ๐จ๐ณ๐ฉ๐ฟ๐ฆ๐ซ๐ฆ๐ธ๐ฆ๐ด๐ฆ๐ผ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ฆ๐น๐ฆ๐นไธ๐ธไบ๐ ไธ๐ฅๅ๐ ไบ๐ๅญ๐ณไธ๐ฟๅซ๐จไน๐ฆๅ๐ๅไธ๐ๅไบ๐ๅไธ๐ฆๅๅ๐ๆฏ๐ฆ๐๐ฆ๐๐ญ๐ฌ๐ญ๐๐ญ๐๐๐ฌ๐๐๐๐๐น๐๐๐๐๐๐๐๐๐๐ค๐๐๐๐๐ค๐๐ค๐๐๐๐๐๐ข๐ฅ๐ฅ๐๐ช๐๐ช๐๐ด๐ช๐ค๐ค๐ท๐๐๐๐ค๐ช๐ค๐ด๐ค๐ด๐๐๐๐๐๐๐๐๐๐ณ๐๐๐ฏ๐ฏ๐๐ด๐๐๐ฒ๐ฎ๐ธ๐ณ๐ธ๐๐ฒ๐๐ฒ๐๐๐๐ซ๐ข๐ณ๐ข๐ณ๐ท๐ฑ๐ต๐ง๐ง๐๐๐ ๐ ๐จ๐ณ๐ฉ๐ฟ๐จ๐ณ๐ฉ๐ฟ๐ฆ๐ซ๐ฆ๐ธ๐ฆ๐ด๐ฆ๐ผ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ฆ๐น๐ฆ๐น";
    
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    self.label.frame = CGRectMake(10, 200, [UIScreen mainScreen].bounds.size.width - 20, 120);
    [self.view addSubview:self.label];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    CGRect rect = self.label.frame;
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height);
    CGRect touchRect = CGRectMake(center.x - 50, center.y - 50, UIScreen.mainScreen.bounds.size.width, 100);
    
    if (CGRectContainsPoint(touchRect, point)) {
        NSLog(@"touches");
        return YES;
    }
    NSLog(@"not touches");
    return NO;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
//    NSLog(@"panAction");
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.lastFrame = self.label.frame;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.view];
        CGRect newFrame = CGRectMake(self.lastFrame.origin.x, self.lastFrame.origin.y, self.lastFrame .size.width, self.lastFrame.size.height + point.y);
        self.label.frame = newFrame;
    }
    
//    NSLog(@"%@", NSStringFromCGPoint(point));
//    CGRect frame = self.label.frame;
//
//
}



@end
