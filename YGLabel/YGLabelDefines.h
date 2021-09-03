//
//  YGLabelDefines.h
//  YGLabel


#ifndef YGLabelDefines_h
#define YGLabelDefines_h

#import <pthread.h>

#ifdef DEBUG 
#define YGLog(...) NSLog(__VA_ARGS__)
#else
#define YGLog(...)
#endif

#define YGLabelDefaultFont [UIFont systemFontOfSize:14]

#define YGLabelDefaultTextColor [UIColor blackColor]

//#define YGLabelDefaultTouchedTextColor [UIColor colorWithRed:0.2313 green:0.5137 blue:1.0 alpha:1]

static inline BOOL VPFloatIsEqual(CGFloat f1, CGFloat f2) {
    return ABS(f1 - f2) < DBL_EPSILON;
}

static inline void dispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

typedef NS_ENUM(NSUInteger, YGTextAttachmentAlignment) {
    YGTextAttachmentAlignmentTop,
    YGTextAttachmentAlignmentCenter,
    YGTextAttachmentAlignmentBottom,
};

#endif /* YGLabelDefines_h */
