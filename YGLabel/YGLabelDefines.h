//
//  YGLabelDefines.h
//  YGLabel


#ifndef YGLabelDefines_h
#define YGLabelDefines_h

#import <pthread.h>
//#define OpenLog
#ifdef DEBUG
#ifdef OpenLog
#define YGLog(...) NSLog(__VA_ARGS__)
#else
#define YGLog(...)
#endif
#else
#define YGLog(...)
#endif

#define YGLabelDefaultFont [UIFont systemFontOfSize:14]

#define YGLabelDefaultTextColor [UIColor blackColor]


static inline BOOL YGFloatIsEqual(CGFloat f1, CGFloat f2) {
    return ABS(f1 - f2) < DBL_EPSILON;
}

static inline CGFLOAT_TYPE YG_Ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}

static CGFloat const YGFLOAT_MAX = 100000;

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
