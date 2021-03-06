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
//    self.label.text = @"ไธ๐ธไบ๐ ไธ๐ฅๅ๐ ไบ๐ๅญ๐ณไธ๐ฟๅซ๐จไน๐ฆๅ๐ๅไธ๐ๅไบ๐ๅไธ๐ฆๅๅ๐ๆฏ๐ฆ๐๐ฆ๐๐ญ๐ฌ๐ญ๐๐ญ๐๐๐ฌ๐๐๐๐๐น๐๐๐๐๐๐๐๐๐๐ค๐๐๐๐๐ค๐๐ค๐๐๐๐๐๐ข๐ฅ๐ฅ๐๐ช๐๐ช๐๐ด๐ช๐ค๐ค๐ท๐๐๐๐ค๐ช๐ค๐ด๐ค๐ด๐๐๐๐๐๐๐๐๐๐ณ๐๐๐ฏ๐ฏ๐๐ด๐๐๐ฒ๐ฎ๐ธ๐ณ๐ธ๐๐ฒ๐๐ฒ๐๐๐๐ซ๐ข๐ณ๐ข๐ณ๐ท๐ฑ๐ต๐ง๐ง๐๐๐ ๐ ๐จ๐ณ๐ฉ๐ฟ๐จ๐ณ๐ฉ๐ฟ๐ฆ๐ซ๐ฆ๐ธ๐ฆ๐ด๐ฆ๐ผ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ง๐ฉ๐ฆ๐น๐ฆ๐น๐ฆ๐นไธ๐ธไบ๐ ไธ๐ฅๅ๐ ไบ๐ๅญ๐ณไธ๐ฟๅซ๐จไน๐ฆๅ๐ๅไธ๐ๅไบ๐ๅไธ๐ฆๅๅ๐ๆฏ๐ฆ๐๐ฆ๐๐ญ๐ฌ๐ญ๐๐ญ๐๐๐ฌ๐๐๐๐๐น๐๐๐๐๐๐๐๐๐๐ค๐๐๐๐๐ค๐๐ค๐๐๐๐๐";
    
    self.label.text = @"ไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅไธไบไธๅไบๅญไธๅซไนๅๅไธๅไบๅไธๅๅ";
    
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    self.label.lineHeight = 25;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.frame = CGRectMake(10, 150, [UIScreen mainScreen].bounds.size.width - 20, 120);
    [self.view addSubview:self.label];
    [self.label sizeToFit];
    
    
    NSString *showText = @"ๆพ็คบๅจๆ";
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
