//
//  YGLabelLinkInfo.m
//  YGLabelLinkInfo

#import "YGLabelLinkInfo.h"

@implementation YGLabelLinkInfo

+ (YGLabelLinkInfo *)linkInfo:(id)content range:(NSRange)range {
    YGLabelLinkInfo *info = [[YGLabelLinkInfo alloc] init];
    info.content = content;
    info.range = range;
    return info;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[self class]]) {
        YGLabelLinkInfo *_other = (YGLabelLinkInfo *)other;
        return [_other.content isEqual:self.content] && NSEqualRanges(_other.range, self.range);
    } else {
        return NO;
    }
}

@end
