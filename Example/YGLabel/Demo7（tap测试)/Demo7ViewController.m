//
//  Demo7ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo7ViewController.h"
#import <YGLabel/YGLabel.h>
#import <YGLabel/YGLabelTouchInfo.h>
#import <YGLabel/NSMutableAttributedString+YG.h>


@interface Demo7ViewController ()
@property (weak, nonatomic) IBOutlet YGLabel *label;
@end

@implementation Demo7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    self.label.lineHeight = 35;
    self.label.numberOfLines = 0;
    
    [self.label appendWithText:@"测试图片的点击事件"];
    [self.label appendWithText:@"\n"];
    
    YGLabelTouchInfo *info3 = [YGLabelTouchInfo touchInfo:@"点击菠萝图片" range:NSMakeRange(self.label.textLength, 1)];
    [self.label addTouchInfo:info3];
    
    UIImage *image1 = [UIImage imageNamed:@"菠萝"];
    YGTextAttachment *imageAttachment1 = [[YGTextAttachment alloc] initWithContent:image1 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(35, 35)];
    [self.label appendAttachment:imageAttachment1];
    
    [self.label appendWithText:@"\n"];
    
    NSString *string1 = @"这是第一段用于测试点击的文字";
    YGLabelTouchInfo *info1 = [YGLabelTouchInfo touchInfo:@"第一段文字" range:NSMakeRange(self.label.textLength, string1.length)];
    [self.label addTouchInfo:info1];
    [self.label appendWithText:string1];


    [self.label appendWithText:@"\n"];
    [self.label appendWithText:@"\n"];
    [self.label appendWithText:@"\n"];
    
    NSMutableAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"这是第二段用于测试点击的很长的😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔颜文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor redColor]}].mutableCopy;
    [attribute yg_setUnderlineStyle:kCTUnderlineStyleSingle];
    YGLabelTouchInfo *info2 = [YGLabelTouchInfo touchInfo:@"第二段文字" range:NSMakeRange(self.label.textLength, attribute.length)];
    [self.label addTouchInfo:info2];
    [self.label appendAttributeText:attribute];
  
    [self.label appendWithText:@"\n"];
    [self.label appendWithText:@"\n"];
    
    
    NSMutableAttributedString *attribute2 = [[NSAttributedString alloc] initWithString:@"这是第三段用于测试点击的很长长长长长长长长长长长长长长长长长长长长长长的颜文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor blueColor]}].mutableCopy;
    [attribute2 yg_setUnderlineStyle:kCTUnderlineStyleThick];
    YGLabelTouchInfo *info4 = [YGLabelTouchInfo touchInfo:@"第三段文字" range:NSMakeRange(self.label.textLength, attribute2.length)];
    [self.label addTouchInfo:info4];
    [self.label appendAttributeText:attribute2];
   
    [self.label appendWithText:@"\n"];
    [self.label appendWithText:@"\n"];
    
    NSMutableAttributedString *attribute3 = [[NSAttributedString alloc] initWithString:@"https://github.com/leo-iOS/YGLabel" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor colorWithRed:0.2313 green:0.5137 blue:1.0 alpha:1]}].mutableCopy;
    [attribute3 yg_setUnderlineStyle:kCTUnderlineStyleSingle];
    YGLabelTouchInfo *info5 = [YGLabelTouchInfo touchInfo:@"https://github.com/leo-iOS/YGLabel" range:NSMakeRange(self.label.textLength, attribute2.length)];
    [self.label addTouchInfo:info5];
    [self.label appendAttributeText:attribute3];
        
    __weak typeof(self) weakSelf = self;
    [self.label touchWithBlock:^(id  _Nonnull content, NSRange range) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Label tap事件" message:content preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [weakSelf presentViewController:alertController animated:true completion:nil];
    }];
    
}

@end
