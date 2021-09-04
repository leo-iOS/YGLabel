//
//  YGLabelTouchInfo.m
//  YGLabel
//
//  Created by leo on 2021/9/2.
//

#import "YGLabelTouchInfo.h"
#import "YGLabelDefines.h"

@implementation YGLabelTouchInfo

+ (YGLabelTouchInfo *)touchInfo:(id)content
                          range:(NSRange)range {
    YGLabelTouchInfo *info = [[YGLabelTouchInfo alloc] init];
    info.content = content;
    info.range = range;
    return info;
}

@end
