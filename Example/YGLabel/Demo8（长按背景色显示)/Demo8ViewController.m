//
//  Demo8ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo8ViewController.h"
#import <YGLabel/YGLabel.h>
@interface Demo8ViewController ()

@property (weak, nonatomic) IBOutlet YGLabel *label;

@end

@implementation Demo8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.longPressColor = [UIColor lightGrayColor];
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    self.label.lineHeight = 20;
    
    self.label.text = @"长按背景测试 \n 第二行测试文字 \n 第三行测试测试测试测试测试测试测试文字 \n 😬😭😂😭😁😅😬😋😉😆😉😹\n";
    UIImage *image4 = [UIImage imageNamed:@"西瓜"];
    YGTextAttachment *imageAttachment4 = [[YGTextAttachment alloc] initWithContent:image4 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(20, 20)];
    [self.label appendAttachment:imageAttachment4];
    [self.label longPressWithBlock:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点击" message:@"长按" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.label cancelLongPress];
        }]];
        [self presentViewController:alertController  animated:YES completion:^{
            
        }];
    }];
}

@end
