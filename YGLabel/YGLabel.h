//
//  YGLabel.h
//  YGLabel


#import <UIKit/UIKit.h>
#import "YGTextAttachment.h"
#import "YGLabelTouchInfo.h"

#import "NSMutableAttributedString+YG.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGLabel : UIView

@property (nonatomic, strong, nullable) UIFont *font;

@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, strong, nullable) UIColor *textColor;

@property (nonatomic, copy, nullable) NSString *text;

@property (nonatomic, copy, nullable) NSAttributedString *attributedText;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

@property(nonatomic, assign) NSInteger numberOfLines;

@property (nonatomic, strong, nullable) YGLabel *endToken;

@property (nonatomic, assign) BOOL endTokenAlwaysShow;

@property (nonatomic, assign, readonly) NSUInteger textLength;

/// 暂不实现
//@property (nonatomic, assign) CGFloat endIndentOffset;

/// 是否开始异步绘制，默认 NO
@property (nonatomic, assign) BOOL displayAsync;

/// 长按label，文字绘制区域的背景色，默认 nil
@property (nonatomic, strong, nullable) UIColor *longPressColor;

//@property (nonatomic, assign) BOOL autoDetectLinks;
//
//@property (nonatomic, strong) NSSet *allowLinkSchemes;

// insert methods
- (void)setText:(NSString * _Nullable)text;
- (void)setAttributedText:(NSAttributedString * _Nullable)attributedText;

- (void)insertAtFirstWithText:(NSString *)text;
- (void)insertAtFirstWithAttributeText:(NSAttributedString *)attributeText;
- (void)insertAtFirstWithAttachment:(YGTextAttachment *)attachment;

- (void)appendWithText:(NSString *)text;
- (void)appendAttributeText:(NSAttributedString *)attributeText;
- (void)appendAttachment:(YGTextAttachment *)attachment;


- (void)insertText:(NSString *)text atIndex:(NSInteger)index;
- (void)insertAttributeText:(NSAttributedString *)attributeText atIndex:(NSInteger)index;;
- (void)insertAttachment:(YGTextAttachment *)attachment atIndex:(NSInteger)index;


- (void)addTouchInfo:(YGLabelTouchInfo *)touchInfo;
- (void)touchWithBlock:(void(^)(id content, NSRange range))block;


// long press
- (void)longPressWithBlock:(void(^)(void))block;
- (void)cancelLongPress;

@end

NS_ASSUME_NONNULL_END
