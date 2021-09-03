//
//  ControlView.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "ControlView.h"

@implementation ControlView

- (void)setCount:(CGFloat)count {
    _count = count;
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f", self.count];
    if (self.countBlock) {
        self.countBlock(self.count);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.leftButton];
    [self addSubview:self.numberLabel];
    [self addSubview:self.rightButton];
    self.minCount = 0;
    self.maxCount = 5;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat labelWidth = width - height * 2;
        
    
    self.leftButton.frame = CGRectMake(0, 0, height, height);
    self.rightButton.frame = CGRectMake(width - height, 0, height, height);
    self.numberLabel.frame = CGRectMake(height, 0, labelWidth, height);
    
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        UIColor *color = [UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1];
        _numberLabel.textColor = color;
        
        _numberLabel.font = [UIFont systemFontOfSize:18];
        _numberLabel.text = @"0";
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}


- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (void)leftAction {
    if (self.count > self.minCount) {
        self.count--;
    }
//    if (self.countBlock) {
//        self.countBlock(self.count);
//    }
}

- (void)rightAction {
    if (self.count < self.maxCount) {
        self.count++;
    }
    
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(120, 30);
}

@end
