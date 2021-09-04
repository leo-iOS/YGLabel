//
//  YGLabel+Caculator.h
//  YGLabel


#import "YGLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGLabel (Caculator)

+ (CGSize)caculateSizeWithText:(NSString *)text
                          font:(UIFont *)font
                          size:(CGSize)size
                numbersOfLines:(NSInteger)numberOfLines;


+ (CGSize)caculateSizeWithText:(NSString *)text
                          font:(UIFont *)font
                          size:(CGSize)size
                    lineHeight:(NSNumber * _Nullable)lineHeight
                 textAlignment:(NSTextAlignment)textAlignment
                 lineBreakMode:(NSLineBreakMode)lineBreakMode
                numbersOfLines:(NSInteger)numberOfLines;


+ (CGSize)caculateSizeWithAttributeText:(NSAttributedString *)attributeText
                                   size:(CGSize)size
                         numbersOfLines:(NSInteger)numberOfLines;


@end

NS_ASSUME_NONNULL_END
