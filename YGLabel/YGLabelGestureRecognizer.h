//
//  YGLabelGestureRecognizer.h
//  YGLabel

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YGLabelGestureRecognizerDelegate <NSObject>

- (void)touchesBegan:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture;

- (void)touchesMoved:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture;

- (void)touchesEnded:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture;

- (void)touchesCancelled:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture;

@end

@interface YGLabelGestureRecognizer : UIGestureRecognizer

@property (nonatomic, weak) id<YGLabelGestureRecognizerDelegate> yg_delegate;

@end

NS_ASSUME_NONNULL_END
