//
//  YGLabel+Caculator.m
//  YGLabel

#import "YGLabel+Caculator.h"
#import "YGLabelDefines.h"
#import <CoreText/CoreText.h>

@implementation YGLabel (Caculator)

+ (CGSize)caculateSizeWithText:(NSString *)text
                          font:(UIFont *)font
                          size:(CGSize)size
                numbersOfLines:(NSInteger)numberOfLines; {
    return [self caculateSizeWithText:text font:font size:size lineHeight:nil textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping numbersOfLines:numberOfLines];
}

+ (CGSize)caculateSizeWithText:(NSString *)text
                          font:(UIFont *)font
                          size:(CGSize)size
                    lineHeight:(NSNumber * _Nullable)lineHeight
                 textAlignment:(NSTextAlignment)textAlignment
                 lineBreakMode:(NSLineBreakMode)lineBreakMode
                numbersOfLines:(NSInteger)numberOfLines {
    
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return CGSizeZero;
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return CGSizeZero;
    }
    
    if (!font) {
        font = YGLabelDefaultFont;
    }
    
    NSMutableDictionary *attribute = @{NSFontAttributeName : font}.mutableCopy;
    if (lineHeight) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
          paragraphStyle.minimumLineHeight = lineHeight.floatValue;
          paragraphStyle.maximumLineHeight = lineHeight.floatValue;
          [attribute setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    
    NSRange range = NSMakeRange(0, text.length);
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeText setAttributes:attribute range:range];
    
    return [self caculateSizeWithAttributeText:attributeText size:size numbersOfLines:numberOfLines];
}

+ (CGSize)caculateSizeWithAttributeText:(NSAttributedString *)attributeText
                                   size:(CGSize)size
                         numbersOfLines:(NSInteger)numberOfLines {
    
    NSAttributedString *attributeString = [attributeText copy];
    if (!attributeString) {
        return CGSizeZero;
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return CGSizeZero;
    }
    
    size = size.height == 0 ? CGSizeMake(size.width, YGFLOAT_MAX) : size;
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)attributeString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
    CFRange range = CFRangeMake(0, 0);
    if (numberOfLines > 0 && framesetter)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (nil != lines && CFArrayGetCount(lines) > 0)
        {
            CFIndex idx = CFArrayGetCount(lines);
            NSInteger lastVisibleLineIndex = MIN(numberOfLines, idx) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            range = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        CFRelease(frame);
        CFRelease(path);
    }
    
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, size, NULL);
    CFRelease(framesetter);
    return CGSizeMake(YG_Ceil(newSize.width), MIN(YG_Ceil(newSize.height), size.height));
}

@end
