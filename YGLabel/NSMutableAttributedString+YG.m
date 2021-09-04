//
//  NSMutableAttributedString+YG.m


#import "NSMutableAttributedString+YG.h"

@implementation NSMutableAttributedString (YG)

- (void)yg_setTextColor:(UIColor *)color {
    [self yg_setTextColor:color range:NSMakeRange(0, self.length)];
}

- (void)yg_setTextColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:NSForegroundColorAttributeName range:range];
    if (color)
    {
        [self addAttribute:NSForegroundColorAttributeName
                     value:color
                     range:range];
    }
}

- (void)yg_setFont:(UIFont *)font {
    [self yg_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)yg_setFont:(UIFont *)font range:(NSRange)range {
    if (font)
    {
        [self removeAttribute:NSFontAttributeName range:range];
        if (font)
        {
            [self addAttribute:NSFontAttributeName value:font range:range];
        }
    }
}


- (void)yg_setUnderlineStyle:(CTUnderlineStyle)style
{
    [self yg_setUnderlineStyle:style
                   modifier:kCTUnderlinePatternSolid
                      range:NSMakeRange(0, self.length)];
}

- (void)yg_setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range
{
    [self removeAttribute:(NSString *)kCTUnderlineColorAttributeName range:range];
    [self addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:(style|modifier)]
                 range:range];
}

#pragma mark - to do
- (void)yg_setEndIndentOffset:(CGFloat)endIndentOffset {
    
}
@end
