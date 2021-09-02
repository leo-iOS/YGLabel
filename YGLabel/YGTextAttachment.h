//
//  YGTextAttachment.h
//  YGLabel

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "YGLabelDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface YGTextAttachment : NSObject

// only support UIView or UIImage
@property (nonatomic, strong) id content;

@property (nonatomic, assign) UIEdgeInsets margin;

@property (nonatomic, assign) YGTextAttachmentAlignment alignment;

@property (nonatomic, assign, readonly) CGFloat ascent;

@property (nonatomic, assign, readonly) CGFloat descent;

- (id)initWithContent:(id)content;

- (id)initWithContent:(id)content maxSize:(CGSize)maxSize;

- (id)initWithContent:(id)content margin:(UIEdgeInsets)margin;

- (id)initWithContent:(id)content margin:(UIEdgeInsets)margin alignment:(YGTextAttachmentAlignment)alignment;

- (id)initWithContent:(id)content margin:(UIEdgeInsets)margin alignment:(YGTextAttachmentAlignment)alignment maxSize:(CGSize)maxSize;

- (CTRunDelegateRef)delegateForAttachment;

- (void)caculateSizeWithAscent:(CGFloat)sacent descent:(CGFloat)descent;

@end

NS_ASSUME_NONNULL_END
