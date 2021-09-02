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
    return [YGLabelTouchInfo touchInfo:content range:range color:nil];
}

+ (YGLabelTouchInfo *)touchInfo:(id)content
                          range:(NSRange)range
                          color:(UIColor *)color {
    
    return [YGLabelTouchInfo touchInfo:content range:range color:color highlightColor:nil showUnderline:NO];
    
}

+ (YGLabelTouchInfo *)touchInfo:(id)content
                          range:(NSRange)range
                          color:(UIColor *)color
                 highlightColor:(UIColor *)highlightColor showUnderline:(BOOL)showUnderline {
    YGLabelTouchInfo *info = [[YGLabelTouchInfo alloc] init];
    info.content = content;
    info.range = range;
    if (color == nil) {
        color = YGLabelDefaultTextColor;
    }
    info.color = color;
    if (highlightColor == nil ) {
        color = YGLabelDefaultTextColor;
    }
    info.highlightColor = highlightColor;
    info.showUnderline = showUnderline;
    return info;
}

@end
