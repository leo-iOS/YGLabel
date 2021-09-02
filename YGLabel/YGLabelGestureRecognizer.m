//
//  YGLabelGestureRecognizer.m
//  YGLabel

#import "YGLabelGestureRecognizer.h"

@implementation YGLabelGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.yg_delegate && [self.yg_delegate respondsToSelector:@selector(touchesBegan:gesture:)]) {
        [self.yg_delegate touchesBegan:touches gesture:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.yg_delegate && [self.yg_delegate respondsToSelector:@selector(touchesMoved:gesture:)]) {
        [self.yg_delegate touchesMoved:touches gesture:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.yg_delegate && [self.yg_delegate respondsToSelector:@selector(touchesEnded:gesture:)]) {
        [self.yg_delegate touchesEnded:touches gesture:self];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.yg_delegate && [self.yg_delegate respondsToSelector:@selector(touchesCancelled:gesture:)]) {
        [self.yg_delegate touchesCancelled:touches gesture:self];
    }
}

@end
