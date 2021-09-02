//
//  YGLabelDefines.h
//  YGLabel


#ifndef YGLabelDefines_h
#define YGLabelDefines_h

#import <pthread.h>

#define YGLabelDefaultFont [UIFont systemFontOfSize:14]

#define YGLabelDefaultTextColor [UIColor blackColor]

#define YGLabelDefaultLinkTextColor [UIColor blueColor]

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
