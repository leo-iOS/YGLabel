//
//  NSMutableAttributedString+YG.h

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (YG)

- (void)yg_setTextColor:(UIColor *)color;

- (void)yg_setTextColor:(UIColor *)color range:(NSRange)range;

- (void)yg_setFont:(UIFont *)font;

- (void)yg_setFont:(UIFont *)font range:(NSRange)range;

- (void)yg_setUnderlineStyle:(CTUnderlineStyle)style;


- (void)yg_setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                       range:(NSRange)range;

- (void)yg_setEndIndentOffset:(CGFloat)endIndentOffset;

@end

NS_ASSUME_NONNULL_END
