//
//  YGLabelLayer.h
//  YGLabel

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
NS_ASSUME_NONNULL_BEGIN

@interface YGLabelLayer : CALayer

/// 是否开启异步绘制，default is NO
@property (nonatomic, assign) BOOL displayAsync;

/// 绘制回调函数
@property (nullable, nonatomic, copy) CTFrameRef (^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void (^displaying)(CGContextRef context, CGSize size, CTFrameRef textFrame, BOOL(^isCancelled)(void));

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

- (CTFrameRef)getCurrentTextFrame;

@end

NS_ASSUME_NONNULL_END
