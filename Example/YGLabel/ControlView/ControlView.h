//
//  ControlView.h
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ControlView : UIView

@property (nonatomic, assign) CGFloat count;

@property (nonatomic, assign) CGFloat minCount;

@property (nonatomic, assign) CGFloat maxCount;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) void(^countBlock)(CGFloat count);


@end

NS_ASSUME_NONNULL_END
