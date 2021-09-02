//
//  YGLabelLayer.m
//  YGLabel

#import "YGLabelLayer.h"
#import <stdatomic.h>
#import "YGLabelQueueManager.h"

@interface _YGSentinel : NSObject {
    atomic_uint _value;
}

@end


@implementation _YGSentinel

- (atomic_uint)value {
    return _value;
}

- (atomic_uint)increase {
    atomic_fetch_add(&_value, 1);
    return [self value];
}

@end


@implementation YGLabelLayer {
    _YGSentinel *_sentinel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;;
        _sentinel = [[_YGSentinel alloc] init];
        _displayAsync = NO;
    }
    return self;
}

- (void)setNeedsDisplay {
    [_sentinel increase];
    [super setNeedsDisplay];
}

- (void)display {
    [self _displayAsync:self.displayAsync];
}

- (void)_displayAsync:(BOOL)async {
    if (!self.displaying) {
        if (self.willDisplay) self.willDisplay(self);
        self.contents = nil;
        if (self.didDisplay) self.didDisplay(self, NO);
        return;
    }
    
    CGSize size = self.bounds.size;
    BOOL opaque = self.opaque;
    CGFloat scale = self.contentsScale;
    
    if (async) {
        if (self.willDisplay) self.willDisplay(self);
        
        // 小于一个像素的不绘制
        if (size.width < 1 || size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)self.contents;
            self.contents = nil;
            if (image) {
                dispatch_async(LabelReleaseQueue, ^{
                    CGImageRelease(image);
                });
            }
            if (self.didDisplay) {
                self.didDisplay(self, YES);
            }
        }
        
        _YGSentinel *sentinel = _sentinel;
        [_sentinel increase];
        atomic_uint value = sentinel.value;
        
        BOOL (^isCancelled)(void) = ^BOOL{
            atomic_uint _value = sentinel.value;
            return value != _value;
        };
        

        dispatch_async(LabelDispalyQueue, ^{
            if (isCancelled()) {
                if (self.didDisplay) {
                    self.didDisplay(self, NO);
                }
                return;
            }
            UIGraphicsBeginImageContextWithOptions(size, opaque, [UIScreen mainScreen].scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -size.height);
            
            self.displaying(context, size, isCancelled);
            
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.didDisplay) self.didDisplay(self, NO);
                });
                return;
            }
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.didDisplay) self.didDisplay(self, NO);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled() ) {
                    if (self.didDisplay) self.didDisplay(self, NO);
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    if (self.didDisplay) self.didDisplay(self, YES);
                }
            });
        });
        
    } else {
        [_sentinel increase];
        if (self.willDisplay) {
            self.willDisplay(self);
        }
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 坐标系翻转
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0, -size.height);
        
        [self _fillBackgroundColorIfNeeded:context size:size opaque:opaque];
        
        self.displaying(context, size, ^BOOL{
            return NO;
        });
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.contents = (__bridge id)image.CGImage;
        if (self.didDisplay) {
            self.didDisplay(self, YES);
        }
    }
}

- (void)_fillBackgroundColorIfNeeded:(CGContextRef)context size:(CGSize)size opaque:(BOOL)opaque {
    if (context && opaque) {
        CGContextSaveGState(context); {
            CGColorRef bgColor = self.backgroundColor;
            if (!bgColor) {
                bgColor = [UIColor whiteColor].CGColor;
            }
            CGContextSetFillColorWithColor(context, bgColor);
            CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
            CGContextFillPath(context);
        } CGContextRestoreGState(context);
    }
    
}

@end
