//
//  Demo5ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo5ViewController.h"
#import <YGLabel/YGLabel.h>


@interface Demo5ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) YGLabel *label;

@property (nonatomic, assign) CGRect lastFrame;

@property (nonatomic, strong) YGLabel *token;

@end

@implementation Demo5ViewController
- (IBAction)wrapAction:(id)sender {
    self.label.numberOfLines = 4;
    [self.label sizeToFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[YGLabel alloc] init];
//    self.label.text = @"一🐸二🐠三🐥四🐠五🐞六🐳七🐿八🐨九🦁十🐅十一😇十二🐅十三🦁十四🐅是🦁🐅🦁😂😭😬😭😂😭😁😅😬😋😉😆😉😹😇🙏🙏🙃🙃😋😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔😔😢😥😥👈💪👈💪👏😴😪🤐💤😷👍👉👍🤕💪🤕😴🤕😴🚕🚅🚚🚚🚎🚎🚓🚚🚔🈳🛐🕉🔯🔯🕎📴🛐🛐🈲💮🈸📳🈸🆎🈲🆎🈲🆎📛🆑🚫💢🚳💢🚳🚷🚱📵🏧🏧🌀🌀💠💠🇨🇳🇩🇿🇨🇳🇩🇿🇦🇫🇦🇸🇦🇴🇦🇼🇦🇹🇧🇩🇦🇹🇧🇩🇦🇹🇦🇹🇦🇹一🐸二🐠三🐥四🐠五🐞六🐳七🐿八🐨九🦁十🐅十一😇十二🐅十三🦁十四🐅是🦁🐅🦁😂😭😬😭😂😭😁😅😬😋😉😆😉😹😇🙏🙏🙃🙃😋😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔😔";
    
    self.label.text = @"一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四一二三四五六七八九十十一十二十三十四";
    
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    self.label.lineHeight = 25;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.frame = CGRectMake(10, 150, [UIScreen mainScreen].bounds.size.width - 20, 120);
    [self.view addSubview:self.label];
    [self.label sizeToFit];
    
    
    NSString *showText = @"显示全文";
    self.token = [[YGLabel alloc] init];
    NSMutableAttributedString *tokenString = [[NSMutableAttributedString alloc] initWithString:showText];
    [tokenString yg_setTextColor:[UIColor colorWithRed:0.2313 green:0.5137 blue:1.0 alpha:1]];
    [tokenString yg_setUnderlineStyle:kCTUnderlineStyleSingle];
    YGLabelTouchInfo *touchInfo = [YGLabelTouchInfo touchInfo:showText range:NSMakeRange(0, showText.length)];
    self.token.attributedText = tokenString;
    [self.token addTouchInfo:touchInfo];
    __weak typeof(self) weakSelf = self;
    [self.token touchWithBlock:^(id  _Nonnull content, NSRange range) {
        weakSelf.label.numberOfLines = 0;
        [weakSelf.label sizeToFit];
        NSLog(@"label font %f", weakSelf.label.font.pointSize);
        NSLog(@"endToken font %f", weakSelf.label.endToken.font.pointSize);
    }];
    self.label.endToken = self.token;
    
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
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.lastFrame = self.label.frame;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.view];
        CGFloat width = self.lastFrame.size.width + point.x;
        if (width <= 120) {
            width = 120;
        } else if (width >= UIScreen.mainScreen.bounds.size.width - 20) {
            width = UIScreen.mainScreen.bounds.size.width - 20;
        }
        CGFloat height = self.lastFrame.size.height + point.y;
        if (height <= 50) {
            height = 50;
        } else if (height >= UIScreen.mainScreen.bounds.size.height - 250) {
            height = UIScreen.mainScreen.bounds.size.height - 250;
        }
        CGRect newFrame = CGRectMake(self.lastFrame.origin.x, self.lastFrame.origin.y, width, height);
        self.label.frame = newFrame;
    }
}


@end
