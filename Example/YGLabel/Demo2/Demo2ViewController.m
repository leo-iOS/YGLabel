//
//  Demo2ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo2ViewController.h"
#import <YGLabel/YGLabel.h>

@interface Demo2ViewController ()

@property (weak, nonatomic) IBOutlet YGLabel *label;
@property (nonatomic, strong) NSArray *imageAttachments;


@property (nonatomic, strong) NSArray *strings;

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo2";
    
    self.label.layer.borderColor = UIColor.grayColor.CGColor;
    self.label.layer.borderWidth = 1.0;
    self.label.lineHeight = 35;
    UIImage *image1 = [UIImage imageNamed:@"菠萝"];
    YGTextAttachment *imageAttachment1 = [[YGTextAttachment alloc] initWithContent:image1 margin:UIEdgeInsetsMake(0, 10, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(20, 20)];
    
    UIImage *image2 = [UIImage imageNamed:@"菠萝莓"];
    YGTextAttachment *imageAttachment2 = [[YGTextAttachment alloc] initWithContent:image2 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(25, 25)];
    
    UIImage *image3 = [UIImage imageNamed:@"香蕉"];
    YGTextAttachment *imageAttachment3 = [[YGTextAttachment alloc] initWithContent:image3 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(30, 30)];
    
    UIImage *image4 = [UIImage imageNamed:@"西瓜"];
    YGTextAttachment *imageAttachment4 = [[YGTextAttachment alloc] initWithContent:image4 margin:UIEdgeInsetsMake(0, 5, 0, 5) alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeMake(35, 35)];
    self.imageAttachments = @[imageAttachment1, imageAttachment2, imageAttachment3, imageAttachment4];
    
    
    NSString *string1 = @"这是第一段用于测试的文字";
    NSAttributedString *attributeString2 = [[NSAttributedString alloc] initWithString:@"这是第二段用于测试的文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor yellowColor]}];
    NSAttributedString *attributeString3 = [[NSAttributedString alloc] initWithString:@"这是第三段用于测试的文字" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:26], NSForegroundColorAttributeName : [UIColor redColor]}];
    NSString *string4 = @"这是第四段用于测试的文字";
    self.strings = @[string1, attributeString2, attributeString3, string4];
}

- (IBAction)clearAction:(id)sender {
    self.label.text = nil;
}


- (IBAction)addUIImage:(id)sender {
    NSInteger index = [self randamIndex:self.imageAttachments.count];
    [self.label appendAttachment:self.imageAttachments[index]];
}

- (IBAction)insertUIImage:(id)sender {
    NSInteger index = [self randamIndex:self.imageAttachments.count];
    NSInteger randomInex = [self randamIndex:self.label.textLength];
    [self.label insertAttachment:self.imageAttachments[index] atIndex:randomInex];
}

- (IBAction)addUIView:(id)sender {
    NSArray *viewAttachments = [self viewAttchments];
    NSInteger index = [self randamIndex:viewAttachments.count];
    [self.label appendAttachment:viewAttachments[index]];
}

- (IBAction)insertUIView:(id)sender {
    NSArray *viewAttachments = [self viewAttchments];
    NSInteger index = [self randamIndex:viewAttachments.count];
    NSInteger randomInex = [self randamIndex:self.label.textLength];
    [self.label insertAttachment:viewAttachments[index] atIndex:randomInex];
}

- (IBAction)addString:(id)sender {
    
    NSInteger index = [self randamIndex:self.strings.count];
    id string = self.strings[index];
    if ([string isKindOfClass:[NSString class]]) {
        [self.label appendWithText:string];
    } else {
        [self.label appendAttributeText:string];
    }
}

- (IBAction)insertString:(id)sender {
    NSInteger index = [self randamIndex:self.strings.count];
    id string = self.strings[index];
    NSInteger randomInex = [self randamIndex:self.label.textLength];
    if ([string isKindOfClass:[NSString class]]) {
        [self.label insertText:string atIndex:randomInex];
    } else {
        [self.label insertAttributeText:string atIndex:randomInex];
    }
}



- (NSArray *)viewAttchments {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    view1.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"自定义视图";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.frame = CGRectMake(10, 5, 100, 20);
    [view1 addSubview:label];
    YGTextAttachment *viewAttchment1 = [[YGTextAttachment alloc] initWithContent:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view2.backgroundColor = [UIColor orangeColor];
    YGTextAttachment *viewAttchment2 = [[YGTextAttachment alloc] initWithContent:view2];
    return @[viewAttchment1, viewAttchment2];
}

- (NSInteger)randamIndex:(NSInteger)count {
    return [self randomBetweenMin:0 max:count];
}

- (double)randomBetweenMin:(double)min max:(double)max {
    double offset = max - min;
    double randomValue = ((double)arc4random() /  0x100000000) * offset;
    return min + randomValue;
}

@end
