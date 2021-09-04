//
//  Demo1ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo1ViewController.h"
#import <YGLabel/YGLabel.h>
#import "ControlView.h"
@interface Demo1ViewController ()

@property (weak, nonatomic) IBOutlet ControlView *fontControl;

@property (weak, nonatomic) IBOutlet ControlView *linesControl;

@property (weak, nonatomic) IBOutlet ControlView *lineHeightControl;

@property (weak, nonatomic) IBOutlet YGLabel *label;

@end

@implementation Demo1ViewController
- (IBAction)changeColor:(id)sender {
    NSInteger aRedValue = arc4random() %255;
    NSInteger aGreenValue = arc4random() %255;
    NSInteger aBlueValue = arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    self.label.textColor = randColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo1";
    self.view.backgroundColor = UIColor.whiteColor;
    self.fontControl.minCount = 10;
    self.fontControl.count = 18;
    self.fontControl.maxCount = 40;
    __weak typeof(self) weakSelf = self;
    self.fontControl.countBlock = ^(CGFloat count) {
        weakSelf.label.font = [UIFont systemFontOfSize:count];
//        self.lineHeightControl.count = [UIFont systemFontOfSize:count].lineHeight;
    };
    
    self.linesControl.minCount = 0;
    self.linesControl.count = 5;
    self.linesControl.maxCount = 20;
    self.linesControl.countBlock = ^(CGFloat count) {
        weakSelf.label.numberOfLines = count;
    };
    
    self.lineHeightControl.minCount = [UIFont systemFontOfSize:10].lineHeight;
    self.lineHeightControl.count = 35;
    self.lineHeightControl.maxCount = [UIFont systemFontOfSize:40].lineHeight;
    self.lineHeightControl.countBlock = ^(CGFloat count) {
        weakSelf.label.lineHeight = count;
    };
    
    UIFont *font = [UIFont systemFontOfSize:self.fontControl.count];
    NSUInteger lines = self.linesControl.count;
    CGFloat lineHeight = self.lineHeightControl.count;
    
    UIImage *image1 = [UIImage imageNamed:@"菠萝"];
    YGTextAttachment *imageAttachment1 = [[YGTextAttachment alloc] initWithContent:image1 margin:UIEdgeInsetsMake(0, 10, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(font.lineHeight, font.lineHeight)];
    
    UIImage *image2 = [UIImage imageNamed:@"菠萝莓"];
    YGTextAttachment *imageAttachment2 = [[YGTextAttachment alloc] initWithContent:image2 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(font.lineHeight, font.lineHeight)];
    
    UIImage *image3 = [UIImage imageNamed:@"香蕉"];
    YGTextAttachment *imageAttachment3 = [[YGTextAttachment alloc] initWithContent:image3 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(30, 30)];
    
    UIImage *image4 = [UIImage imageNamed:@"西瓜"];
    YGTextAttachment *imageAttachment4 = [[YGTextAttachment alloc] initWithContent:image4 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(35, 35)];
    
    
    self.label.font = font;
    self.label.lineHeight = lineHeight;
    self.label.numberOfLines = lines;
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    [self.view addSubview:self.label];
    
    [self.label appendAttachment:imageAttachment1];

    [self.label appendWithText:@"这是第一段用于测试的文字"];
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"这是第二段用于测试的文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor yellowColor]}];
    [self.label appendAttributeText:attribute];
    [self.label appendAttachment:imageAttachment2];
    [self.label appendWithText:@"这是第三段用于测试的文字"];
    
    NSAttributedString *attribute2 = [[NSAttributedString alloc] initWithString:@"这是第四段用于测试的文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:26], NSForegroundColorAttributeName : [UIColor redColor]}];
    [self.label appendAttributeText:attribute2];
    [self.label appendWithText:@"这是第五段用于测试的文字"];
    
    NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc] initWithString:@"这是第六段用于测试的文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:26], NSForegroundColorAttributeName : [UIColor greenColor]}];
    [attribute3 yg_setUnderlineStyle:(kCTUnderlineStyleSingle)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"自定义视图";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.frame = CGRectMake(10, 5, 100, 20);
    [view addSubview:label];
    YGTextAttachment *attchment2 = [[YGTextAttachment alloc] initWithContent:view];
    [self.label appendAttachment:attchment2];
    
    [self.label appendAttributeText:attribute];
    [self.label appendAttributeText:attribute3];
    [self.label appendAttachment:imageAttachment3];
    [self.label appendAttributeText:attribute2];
    [self.label appendAttributeText:attribute];
    [self.label appendWithText:@"这是第七段用于测试的很长长长长长长文字"];
    [self.label appendAttributeText:attribute3];
    [self.label appendAttributeText:attribute2];
    [self.label appendAttachment:imageAttachment3];
    [self.label appendWithText:@"这是第八段用于测试的很长长长长长长长长长长长长文字"];
    [self.label appendAttributeText:attribute];
    [self.label appendAttributeText:attribute3];
    [self.label appendAttachment:imageAttachment4];
    [self.label appendWithText:@"这是第九段段用于测试的很长长长长长长长长长长长长长长长长长长长长长长长长文字"];
    [self.label appendAttributeText:attribute2];
   
    NSLog(@"%@", self.label.text);
    NSLog(@"%d", self.label.text.length);
    NSLog(@"%@", self.label.attributedText);
    NSLog(@"%d", self.label.attributedText.length);
}


@end
