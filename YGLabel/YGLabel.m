//
//  YGLabel.m
//  YGLabel

#import "YGLabel.h"
#import "YGLabelGestureRecognizer.h"
#import <CoreText/CoreText.h>
#import "YGLabelLayer.h"
#import "YGLabelDefines.h"
#import "YGLabel+Caculator.h"
static NSString* const EllipsesCharacter = @"\u2026";  // ... 的 unicode 编码

static NSString* const ReplacementCharacter = @"\uFFFC";  // attachment的 替换的 unicode 编码

typedef NS_ENUM(NSUInteger, LongPressBgState) {
    LongPressBgStateCancelDraw = 0,
    LongPressBgStateToDraw = 1,
};

@interface YGLabel()<YGLabelGestureRecognizerDelegate> {
    // attachments
    NSMutableArray<YGTextAttachment *> *_attachments;
    NSMutableArray<YGTextAttachment *> *_attachmentDoNotDraw;
    
    // font
    CGFloat _fontAscent;
    CGFloat _fontDescent;
    CGFloat _fontHeight;
    
    // tap手势
    YGLabelGestureRecognizer *_gesture;
    // 长按手势
    UILongPressGestureRecognizer *_longPressGesture;
    LongPressBgState _bgState;
    void (^_longBlock)(void);
    
    //URL
    NSMutableArray<YGLabelTouchInfo *> *_touchInfos;
    YGLabelTouchInfo *_touchedInfo;

    void (^_touchedBlock)(id content, NSRange range);
    
    // attributeText容器
    NSMutableAttributedString *_innerAttributeText;
    // 需要绘制的attributeText
    NSAttributedString *_attributeTextForDraw;
    
//    CTFrameRef _textFrame;
}

@end

@implementation YGLabel

#pragma mark - init
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

#pragma mark commonInit
- (void)_commonInit {
    _font = YGLabelDefaultFont;
    _textColor = YGLabelDefaultTextColor;
    
    _gesture = [[YGLabelGestureRecognizer alloc] init];
    _gesture.yg_delegate = self;
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    [self addGestureRecognizer:_longPressGesture];
    [self addGestureRecognizer:_gesture];
    [self _resetData];
    [self _layerDrawTask];
    _displayAsync = NO;
    _endTokenAlwaysShow = NO;
    _lineBreakMode = NSLineBreakByWordWrapping;
    self.userInteractionEnabled = YES;
}


#pragma mark - set text

- (void)setDisplayAsync:(BOOL)displayAsync {
    if (_displayAsync != displayAsync) {
        _displayAsync = displayAsync;
        ((YGLabelLayer *)self.layer).displayAsync = displayAsync;
        [self _drawText];
    }
}

- (void)setText:(NSString *)text {
    if (!text) {
        [self setAttributedText:nil];
        return;
    }

    if (![text isKindOfClass:[NSString class]]) {
        //类型不对，直接返回
        return;
    }

    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor}];
    [self setAttributedText:attributeText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self _resetData];
    if (!attributedText || ![attributedText isKindOfClass:[NSAttributedString class]]) {
        [self _drawText];
        return;
    }

    [_innerAttributeText appendAttributedString:attributedText];
    [self _drawText];
}

// insert
- (void)insertAtFirstWithText:(NSString *)text {
    [self insertText:text atIndex:0];
}

- (void)insertAtFirstWithAttributeText:(NSAttributedString *)attributeText {
    [self insertAttributeText:attributeText atIndex:0];
}

- (void)insertAtFirstWithAttachment:(YGTextAttachment *)attachment {
    [self insertAttachment:attachment atIndex:0];
}

- (void)appendWithText:(NSString *)text {
    [self insertText:text atIndex:_innerAttributeText.length];
}

- (void)appendAttributeText:(NSAttributedString *)attributeText {
    [self insertAttributeText:attributeText atIndex:_innerAttributeText.length];
}

- (void)appendAttachment:(YGTextAttachment *)attachment {
    [self insertAttachment:attachment atIndex:_innerAttributeText.length];
}

- (void)insertText:(NSString *)text atIndex:(NSInteger)index {
    if (!text || ![text isKindOfClass:[NSString class]] || text.length == 0) {
        return;
    }
    
    NSMutableAttributedString *attributeText = [[NSAttributedString alloc] initWithString:text].mutableCopy;
    [attributeText yg_setFont:self.font];
    [attributeText yg_setTextColor:self.textColor];
    [self insertAttributeText:attributeText atIndex:index];
}

- (void)insertAttributeText:(NSAttributedString *)attributeText atIndex:(NSInteger)index {
    [_innerAttributeText insertAttributedString:attributeText atIndex:index];
    [self _drawText];
}

- (void)insertAttachment:(YGTextAttachment *)attachment atIndex:(NSInteger)index {
    if ([_attachments containsObject:attachment]) {
        YGLog(@"这个attachment已经添加过了");
        return;
    }
    [self _getFontProperty];
    [attachment caculateSizeWithAscent:_fontAscent descent:_fontDescent];
    NSMutableAttributedString *attachText   = [[NSMutableAttributedString alloc]initWithString:ReplacementCharacter];
    CTRunDelegateRef delegate = [attachment delegateForAttachment];
    [attachText setAttributes:@{(__bridge NSString *)kCTRunDelegateAttributeName : (__bridge id)delegate} range:NSMakeRange(0, 1)];
    [_attachments addObject:attachment];
    [self insertAttributeText:attachText atIndex:index];
}
#pragma mark - getter methods

- (NSUInteger)textLength {
    return  _innerAttributeText.length;
}

- (NSString *)text {
    return _innerAttributeText.string;
}

- (NSAttributedString *)attributedText {
    return _innerAttributeText.copy;
}

#pragma mark - setter methods
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self _drawText];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self _drawText];
}

- (void)setLineHeight:(CGFloat)lineHeight {
    if (!VPFloatIsEqual(_lineHeight, lineHeight)) {
        _lineHeight = lineHeight;
        [self _drawText];
    }
}

- (void)setFont:(UIFont *)font {
    if (font && _font != font) {
        _font = font;
        [self _getFontProperty];
        for (YGTextAttachment *attachment in _attachments) {
            [attachment caculateSizeWithAscent:_fontAscent descent:_fontDescent];
        }
        [_innerAttributeText yg_setFont:font];
        for (YGTextAttachment *attachment in _attachments) {
            [attachment caculateSizeWithAscent:_fontAscent descent:_fontDescent];
        }
        [self _drawText];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor && _textColor != textColor) {
        _textColor = textColor;
        [_innerAttributeText yg_setTextColor:textColor range:NSMakeRange(0, _innerAttributeText.length)];
        [self _drawText];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        [self _drawText];
    }
}

- (void)setLongPressColor:(UIColor *)longPressColor {
    if (_longPressColor != longPressColor) {
        _longPressColor = longPressColor;
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (_lineBreakMode != lineBreakMode) {
        _lineBreakMode = lineBreakMode;
        [self _drawText];
    }
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (_numberOfLines != numberOfLines) {
        _numberOfLines = numberOfLines;
        [self _drawText];
    }
}

- (void)setEndToken:(YGLabel *)endToken {
    if (_endToken != endToken) {
        _endToken = endToken;
        [self _drawText];
    }
}

- (void)setEndTokenAlwaysShow:(BOOL)endTokenAlwaysShow {
    if (_endTokenAlwaysShow != endTokenAlwaysShow) {
        _endTokenAlwaysShow = endTokenAlwaysShow;
        [self _drawText];
    }
}

//- (void)setEndIndentOffset:(CGFloat)endIndentOffset {
//    if (!VPFloatIsEqual(_endIndentOffset, endIndentOffset)) {
//        _endIndentOffset = endIndentOffset;
//        [self _drawText];
//    }
//}

#pragma mark - add methods
- (void)addTouchInfo:(YGLabelTouchInfo *)touchInfo {

    for (YGLabelTouchInfo *info in _touchInfos) {
        NSRange intersection = NSIntersectionRange(touchInfo.range, info.range);
        if (intersection.length != 0) {
            NSString *msg = [NSString stringWithFormat:@"新的touchinfo:%@与已经存在的touchInfo有range重合", touchInfo];
            NSAssert(NO, msg);
            return;
        }
    }
    
    if (![_touchInfos containsObject:touchInfo]) {
        [_touchInfos addObject:touchInfo];
    }
}

- (void)touchWithBlock:(void(^)(id content, NSRange range))block {
    _touchedBlock = block;
}

#pragma mark - private

- (void)_layerDrawTask {
    YGLabelLayer *layer = (YGLabelLayer *)self.layer;
    
    __weak typeof(self) weakSelf = self;
    
    // will display
    layer.willDisplay = ^CTFrameRef _Nonnull(CALayer * _Nonnull layer) {
        YGLog(@"layer will Display");
        NSAttributedString *attributeTextForDraw = [self _getAttributeTextForDraw];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //        [strongSelf _loadTextFrameWithAttributeText:attributeTextForDraw];
        CTFrameRef textFrame = [self _getTextFrameWithText:attributeTextForDraw];
        strongSelf->_attributeTextForDraw = attributeTextForDraw;
        return textFrame;
    };
//    layer.willDisplay = (CTFrameRef)^(CALayer * _Nonnull layer) {
//        YGLog(@"layer will Display");
//        NSAttributedString *attributeTextForDraw = [self _getAttributeTextForDraw];
//        __strong typeof(weakSelf) strongSelf = weakSelf;
////        [strongSelf _loadTextFrameWithAttributeText:attributeTextForDraw];
//        CTFrameRef textFrame = [self _getTextFrameWithText:attributeTextForDraw];
//        strongSelf->_attributeTextForDraw = attributeTextForDraw;
//        return;
//    };
    
    // displaying
    layer.displaying = ^(CGContextRef  _Nonnull context, CGSize size, CTFrameRef textFrame, BOOL (^ _Nonnull isCancelled)(void)) {
        YGLog(@"layer is displaying");
        if (isCancelled()) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _drawLongPressBackgroundColorIfNeeded:context size:size];
        [strongSelf _drawAttributeString:context size:size attributeText:strongSelf->_attributeTextForDraw textFrame:textFrame];
        [strongSelf _drawAttachments:context textFrame:textFrame];
    };
    
    // didDisplay
    layer.didDisplay = ^(CALayer * _Nonnull layer, BOOL finished) {
        if (!finished) {
            // display finished
            YGLog(@"layer didDisplay");
        }
    };
}

- (NSAttributedString *)_getAttributeTextForDraw {
    if (_innerAttributeText) {
        NSMutableAttributedString *copyText = [_innerAttributeText mutableCopy];
        if (VPFloatIsEqual(_lineHeight, 0)) {
            _lineHeight = self.font.lineHeight;
        }
        
        CTLineBreakMode lineBreakMode = (CTLineBreakMode)_lineBreakMode;
        CTTextAlignment alignment = (CTTextAlignment)_textAlignment;
        CTParagraphStyleSetting settings[] =
        {
            {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&(alignment)},
            {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreakMode),&lineBreakMode},
            {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(_lineHeight), &_lineHeight},
            {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(_lineHeight), &_lineHeight}
        };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings,sizeof(settings) / sizeof(settings[0]));
        [copyText addAttribute:(id)kCTParagraphStyleAttributeName
                         value:(__bridge id)paragraphStyle
                         range:NSMakeRange(0, [copyText length])];
        CFRelease(paragraphStyle);
        return [copyText copy];
    } else {
        return nil;
    }
}

- (void)_resetData {
    for (YGTextAttachment *attachment in _attachments) {
        if ([attachment.content isKindOfClass:[UIView class]]) {
            [(UIView *)attachment.content removeFromSuperview];
        }
    }
    _innerAttributeText = [[NSMutableAttributedString alloc] init];
    _attachments = [NSMutableArray array];
    _touchInfos = [NSMutableArray array];
    _attachmentDoNotDraw = [NSMutableArray array];
    _lineBreakMode = NSLineBreakByWordWrapping;
}

- (YGLabelTouchInfo *)_checkTouchInfoForPoint:(CGPoint)point {
    CTFrameRef _textFrame = [(YGLabelLayer *)self.layer getCurrentTextFrame];
    if (!_textFrame) {
        return nil;
    }
    static const CGFloat margin = 0;
    CGRect newRect = CGRectInset(self.bounds, 0, -margin);
    if (self.numberOfLines != 0) {
        newRect.size.height = self.numberOfLines * self.lineHeight;
    }
    
    if (!CGRectContainsPoint(newRect, point)) {
        return nil;
    }
    
    CTFrameRef textFrame = CFRetain(_textFrame);
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) return nil;
    CFIndex count = CFArrayGetCount(lines);

    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);

    CGAffineTransform transform = [self transformForCoreText];
    for (int i = 0; i < count; i++)
    {
        CGPoint linePoint = origins[i];

        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self _getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, -margin);

        if (CGRectContainsPoint(rect, point))
        {
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            YGLog(@"idx %d", idx);
            YGLabelTouchInfo *info = [self _searchTouchInfoAtIndex:idx-1];
            if (info)
            {
                CFRelease(textFrame);
                return info;
            }
        }
    }
    CFRelease(textFrame);
    return nil;
}

- (YGLabelTouchInfo *)_searchTouchInfoAtIndex:(CFIndex)index
{
    for (YGLabelTouchInfo *info in _touchInfos)
    {
        if (NSLocationInRange(index, info.range))
        {
            return info;
        }
    }
    return nil;
}


- (CGRect)_getLineBounds:(CTLineRef)line point:(CGPoint) point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

- (CGAffineTransform)transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (NSDictionary *)_attributesDicFor:(NSAttributedString *)attributeString atIndex:(NSInteger)index {
    NSDictionary *attributes = [attributeString attributesAtIndex:index effectiveRange:NULL];
    return attributes;
}

- (CTLineRef)_getTruncatedLineFor:(NSAttributedString *)attributeString width:(CGFloat)width tokenAttribute:(NSDictionary *)tokenAttributes  {
    CTLineTruncationType truncationType = kCTLineTruncationEnd;
    NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:EllipsesCharacter attributes:tokenAttributes];
    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
    
    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)attributeString);
    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, width, truncationType, truncationToken);
    
    if (!truncatedLine)
    {
        truncatedLine = CFRetain(truncationToken);
    }
    CFRelease(truncationLine);
    CFRelease(truncationToken);
    return truncatedLine;
}

- (CTFrameRef)_getTextFrameWithText:(NSAttributedString *)attributeText {
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributeText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.layer.bounds);
    CTFrameRef textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(frameSetter);
    return textFrame;
}

//- (void)_loadTextFrameWithAttributeText:(NSAttributedString *)attributeText {
//    if (!_textFrame) {
//        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributeText);
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, self.layer.bounds);
//        _textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
//        CFRelease(path);
//        CFRelease(frameSetter);
//    }
//}

- (NSInteger)_numberOfLinesForDisplay:(CTFrameRef)textFrame {
//    if (!_textFrame) {
//        return 0;
//    }
//    CTFrameRef textFrame = CFRetain(_textFrame);
    CFArrayRef lines = CFRetain(CTFrameGetLines(textFrame));
    if (lines) {
        NSInteger count =  CFArrayGetCount(lines);
        CFRelease(lines);
        return _numberOfLines > 0 ? MIN(count, _numberOfLines) : count;
    }
    
    return 0;
}

- (void)_getFontProperty {
    _fontAscent = ABS(self.font.ascender);
    _fontDescent = ABS(self.font.descender);
    _fontHeight = self.font.lineHeight;
}

#pragma mark - draw methods
- (void)_drawText {
    [self.layer setNeedsDisplay];
}

- (void)_drawLongPressBackgroundColorIfNeeded:(CGContextRef)context size:(CGSize)size{
    if (!_longPressColor) {
        return;
    }
    
    if (_bgState == LongPressBgStateCancelDraw) {
        return;
    }
    
    NSAttributedString *string = [self _getAttributeTextForDraw];
    CGSize longPressSize = [YGLabel caculateSizeWithAttributeText:string size:size numbersOfLines:_numberOfLines];
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, _longPressColor.CGColor);
    CGRect rect = CGRectMake(0, 0, longPressSize.width, longPressSize.height);
    CGAffineTransform transform = [self transformForCoreText];
    rect = CGRectApplyAffineTransform(rect, transform);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

- (void)_drawAttributeString:(CGContextRef)context size:(CGSize)size attributeText:(NSAttributedString *)attributeText textFrame:(CTFrameRef)textFrame {
    if (!textFrame) {
        return;
    }

    [_attachmentDoNotDraw removeAllObjects];

    NSInteger numberOfLines = [self _numberOfLinesForDisplay:textFrame];
    
    if (numberOfLines == 1) {
        CFArrayRef lines = CTFrameGetLines(textFrame);
        if (!lines) {
            return;
        }
        CFIndex lineCount = CFArrayGetCount(lines);
        CGPoint lineOrigins[lineCount];
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 1), lineOrigins);
        CGContextSetTextPosition(context, lineOrigins[0].x, lineOrigins[0].y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, 0);
        [self _drawLastLine:line context:context attributeText:attributeText size:size lastLineY:lineOrigins[0].y];
       
    } else {
        
        CFArrayRef lines = CTFrameGetLines(textFrame);
        if (!lines) {
            return;
        }
        CFIndex lineCount = CFArrayGetCount(lines);
        CGPoint lineOrigins[lineCount];
        
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, numberOfLines), lineOrigins);
        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
            CGPoint lineOrigin = lineOrigins[lineIndex];
            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            
            if (lineIndex == numberOfLines - 1) {
                CGFloat y = lineOrigins[0].y - lineOrigin.y;
                [self _drawLastLine:line context:context attributeText:attributeText size:size lastLineY:y];
            } else {
                CTLineDraw(line, context);
            }
        }
    }
}

- (void)_drawAttachments:(CGContextRef)context textFrame:(CTFrameRef)textFrame{
    if (_attachments.count == 0 || !textFrame) {
        return;
    }
    
    CTFrameRef _textFrame = CFRetain(textFrame);
    
    for (YGTextAttachment *attachment in _attachments) {
        if ([attachment.content isKindOfClass:[UIView class]]) {
            dispatch_async_on_main_queue(^{
                [attachment.content removeFromSuperview];
            });
        }
    }
    
    CFArrayRef lines = CTFrameGetLines(_textFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    // 获取每一个line的位于baseline开始的点
    CTFrameGetLineOrigins(_textFrame, CFRangeMake(0, 0), lineOrigins);
    NSInteger numberOfLines = [self _numberOfLinesForDisplay:_textFrame];
    
    for (CFIndex i = 0; i < numberOfLines; i++)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CGPoint lineOrigin = lineOrigins[i];
        CGFloat lineAscent;
        CGFloat lineDescent;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
        CGFloat lineHeight = lineAscent + lineDescent;
        CGFloat lineBottomY = lineOrigin.y - lineDescent;
        
        //遍历找到对应的 attachment 进行绘制
        for (CFIndex k = 0; k < runCount; k++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, k);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (nil == delegate)
            {
                continue;
            }
            YGTextAttachment* attachment = (__bridge YGTextAttachment *)CTRunDelegateGetRefCon(delegate);
            if ([_attachmentDoNotDraw containsObject:attachment]) {
                continue;
            }
            
            CGFloat ascent = 0.0f;
            CGFloat descent = 0.0f;
            CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                               CFRangeMake(0, 0),
                                                               &ascent,
                                                               &descent,
                                                               NULL);
            
            CGFloat imageBoxHeight = attachment.boxSize.height;
            CGFloat contentHeight = imageBoxHeight - attachment.margin.top - attachment.margin.bottom;
            CGFloat contentWidth = width - attachment.margin.left - attachment.margin.right;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
            xOffset += attachment.margin.left;
            
            CGFloat imageBoxOriginY = 0.0f;
            switch (attachment.alignment) {
                case YGTextAttachmentAlignmentTop:
                    break;
                case YGTextAttachmentAlignmentCenter:
                    imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight) / 2.0;
                    break;
                case YGTextAttachmentAlignmentBottom:
                    break;
            }
            
            CGRect rect = CGRectMake(lineOrigin.x + xOffset, imageBoxOriginY, contentWidth, contentHeight);
            
            //这里先这么处理 之前没有考虑number为1的情况。
            if (i == numberOfLines - 1 &&
                k >= runCount - 2 &&
                 _lineBreakMode == kCTLineBreakByTruncatingTail && numberOfLines != 1)
            {
                //最后行最后的2个CTRun需要做额外判断
                CGFloat attachmentWidth = CGRectGetWidth(rect);
                const CGFloat kMinEllipsesWidth = attachmentWidth;
                if (CGRectGetWidth(self.bounds) - CGRectGetMinX(rect) - attachmentWidth <  kMinEllipsesWidth)
                {
                    continue;
                }
            }

            id content = attachment.content;
            
            if ([content isKindOfClass:[UIImage class]]) {
                CGContextDrawImage(context, rect, ((UIImage *)content).CGImage);
            } else if ([content isKindOfClass:[UIView class]])
            {
                dispatch_async_on_main_queue(^{
                    UIView *view = (UIView *)content;
                    
                    if (view.superview == nil) [self addSubview:view];
                    
                    CGFloat x = rect.origin.x;
                    CGFloat y = self.bounds.size.height - rect.origin.y - rect.size.height;
                    CGFloat width = rect.size.width;
                    CGFloat height = rect.size.height;
                    view.frame = CGRectMake(x, y, width, height);
                });
            }
        }
    }
    CFRelease(_textFrame);
}

- (void)_drawLastLine:(CTLineRef)line
              context:(CGContextRef)context
        attributeText:(NSAttributedString *)attributeText
                 size:(CGSize)size
            lastLineY:(CGFloat)lineLineY {

    // 得到最后一个line里面的run
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    // run的数量
    CFIndex runCount = CFArrayGetCount(runs);
    
    if (self.endToken) {
        // 如果有 endToekLabel 在 Label 的最后面显示
        
        // endToekLabel 的 size
        CGSize endTokenSize = [self.endToken sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        if (self.endTokenAlwaysShow) {
            // endTokenAlwaysShow为YES, endToekLabel永远显示在末尾
            dispatch_async_on_main_queue(^{
                // 在主线程 显示endToken
                self.endToken.hidden = NO;
            });
            
            // 最后一个line的 rect
            CGRect lineRect = CTLineGetBoundsWithOptions(line, kNilOptions);
                    
            if (size.width - lineRect.size.width > endTokenSize.width) {
                // 剩余空间显示的下，不用截取
                // 获取line最后一个run
                CTRunRef run = CFArrayGetValueAtIndex(runs, runCount - 1);
                CFRange runRange = CTRunGetStringRange(run);
                
                // 最后一个run的开始的x的坐标
                CGFloat startPoint = CTRunGetImageBounds(run, context, CFRangeMake(0, 1)).origin.x;
                
                //获取属性 倒数第一个字符串的属性
                NSDictionary *tokenAttributes = [self _attributesDicFor:attributeText atIndex:runRange.location + runRange.length - 1];
                NSMutableAttributedString *truncationString = [[attributeText attributedSubstringFromRange:NSMakeRange(runRange.location, runRange.length)] mutableCopy];
                
                //重新获得一个截断的line
                CTLineRef truncatedLine = [self _getTruncatedLineFor:truncationString width:size.width tokenAttribute:tokenAttributes];
                
                CGContextSaveGState(context);
                CGContextTranslateCTM(context, startPoint, 0);
                CTLineDraw(truncatedLine, context);
                CGContextRestoreGState(context);
                CFRelease(truncatedLine);
                
                // 将endTokenLabel添加到末尾
                CGRect rect = CTLineGetImageBounds(truncatedLine, context);
                dispatch_async_on_main_queue(^{
                    [self addSubview:self.endToken];
                    CGRect endTokenFrame = CGRectMake(rect.origin.x + rect.size.width + 2, lineLineY, endTokenSize.width, endTokenSize.height);
                    self.endToken.frame = endTokenFrame;
                });
            } else {
                // 需要截取
                for (int i = (int)runCount - 1; i >= 0; i--) {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, i);
                    CFRange runRange = CTRunGetStringRange(run);
                    CFIndex glyphCount = CTRunGetGlyphCount(run);
                    CGRect textRect = CTRunGetImageBounds(run, context, CFRangeMake(0, glyphCount));
                    CGFloat remainWidth = endTokenSize.width;
                    if (textRect.size.width > endTokenSize.width) {
                        //最后一个run的宽度 大于 endToken的宽度
                        
                        //计算需要截取的个数
                        NSInteger needToTruncatedCount = 0;
                        for (int j = (int)glyphCount - 1; j >= 1; j--) {
                            CGRect glyphRect = CTRunGetImageBounds(run, context, CFRangeMake(j, 1));
                            if (remainWidth > 0) {
                                needToTruncatedCount++;
                                remainWidth -= glyphRect.size.width;
                            } else {
                                if (!VPFloatIsEqual(glyphRect.size.width, 0)) {
                                    needToTruncatedCount++;
                                    break;
                                } else {
                                    needToTruncatedCount++;
                                    continue;
                                }
                            }
                        }
                        
                        NSUInteger truncationAttributePosition = runRange.location + runRange.length - 1;
                        NSDictionary *tokenAttributes = [attributeText attributesAtIndex:truncationAttributePosition
                                                                          effectiveRange:NULL];
                        NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:EllipsesCharacter
                                                                                          attributes:tokenAttributes];
                        CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                        
                        NSMutableAttributedString *truncationString = [[attributeText attributedSubstringFromRange:NSMakeRange(runRange.location, runRange.length)] mutableCopy];
                        if (runRange.length > needToTruncatedCount - 1)
                        {
                            [truncationString deleteCharactersInRange:NSMakeRange(runRange.length - needToTruncatedCount, needToTruncatedCount)];
                        }
                        [truncationString appendAttributedString:tokenString];
                        
                        //重新获得一个截断的line
                        CTLineRef truncatedLine = [self _getTruncatedLineFor:truncationString width:size.width tokenAttribute:tokenAttributes];
                        
                        CGRect rect = CTLineGetImageBounds(truncatedLine, context);
                        
                        CFRelease(truncationToken);
                        CGContextSaveGState(context);
                        CGFloat startPoint = CTRunGetImageBounds(run, context, CFRangeMake(0, 1)).origin.x;
                        CGContextTranslateCTM(context, startPoint, 0);
                        CTLineDraw(truncatedLine, context);
                        CGContextRestoreGState(context);
                        CFRelease(truncatedLine);
                        
                        dispatch_async_on_main_queue(^{
                            [self addSubview:self.endToken];
                            CGRect endTokenFrame = CGRectMake(rect.origin.x + rect.size.width + 2, lineLineY, endTokenSize.width, endTokenSize.height);
                            self.endToken.frame = endTokenFrame;
                        });
                    } else {
                        // 最后一个run的宽度 小于 endToken的宽度
                        // 这种情况很少见，暂不实现
                    }
                }
            }
        } else {
            // 只有在显示不下的情况下显示会后的endToken
            CGRect lineRect = CTLineGetBoundsWithOptions(line, kNilOptions);
            if (size.width - lineRect.size.width > endTokenSize.width) {
                // 显示的下，不用截取
                // 这种情况下，直接绘制
                dispatch_async_on_main_queue(^{
                    //在主线程 隐藏endToken
                    self.endToken.hidden = YES;
                });
                CTLineDraw(line, context);
            } else {
                
                // 显示的下，需要截取一部分字符串
                dispatch_async_on_main_queue(^{
                    //在主线程 显示endToken
                    self.endToken.hidden = NO;
                });
                
                for (int i = (int)runCount - 1; i >= 0; i--) {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, i);
                    CFRange runRange = CTRunGetStringRange(run);
                    CFIndex glyphCount = CTRunGetGlyphCount(run);
                    CGRect textRect = CTRunGetImageBounds(run, context, CFRangeMake(0, glyphCount));
                    CGFloat remainWidth = endTokenSize.width;
                    if (textRect.size.width > endTokenSize.width) {
                        //最后一个run的宽度 大于 endToken的宽度
                        
                        //计算需要截取的个数
                        NSInteger needToTruncatedCount = 0;
                        for (int j = (int)glyphCount - 1; j >= 1; j--) {
                            CGRect glyphRect = CTRunGetImageBounds(run, context, CFRangeMake(j, 1));
                            if (remainWidth > 0) {
                                needToTruncatedCount++;
                                remainWidth -= glyphRect.size.width;
                            } else {
                                if (!VPFloatIsEqual(glyphRect.size.width, 0)) {
                                    needToTruncatedCount++;
                                    break;
                                } else {
                                    needToTruncatedCount++;
                                    continue;
                                }
                            }
                        }
                        
                        NSUInteger truncationAttributePosition = runRange.location + runRange.length - 1;
                        NSDictionary *tokenAttributes = [attributeText attributesAtIndex:truncationAttributePosition
                                                                          effectiveRange:NULL];
                        NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:EllipsesCharacter
                                                                                          attributes:tokenAttributes];
                        CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                        NSMutableAttributedString *truncationString = [[attributeText attributedSubstringFromRange:NSMakeRange(runRange.location, runRange.length)] mutableCopy];
                        if (runRange.length > needToTruncatedCount - 1)
                        {
                            [truncationString deleteCharactersInRange:NSMakeRange(runRange.length - needToTruncatedCount, needToTruncatedCount)];
                        }
                        [truncationString appendAttributedString:tokenString];
                        //重新获得一个截断的line
                        CTLineRef truncatedLine = [self _getTruncatedLineFor:truncationString width:size.width tokenAttribute:tokenAttributes];
                        
                        
                        CFArrayRef runs = CTLineGetGlyphRuns(truncatedLine);
                        CFIndex runCount = CFArrayGetCount(runs);
                        CTRunRef endRun = CFArrayGetValueAtIndex(runs, runCount - 1);
                        CGPoint point;
                        CTRunGetPositions(endRun, CFRangeMake(0, 1), &point);
                        CGRect rect = CTLineGetImageBounds(truncatedLine, context);
                        
                        CFRelease(truncationToken);
                        CGContextSaveGState(context);
                        CGFloat startPoint = CTRunGetImageBounds(run, context, CFRangeMake(0, 1)).origin.x;
                        CGContextTranslateCTM(context, startPoint, 0);
                        CTLineDraw(truncatedLine, context);
                        CGContextRestoreGState(context);
                        CFRelease(truncatedLine);
                        
                        dispatch_async_on_main_queue(^{
                            [self addSubview:self.endToken];
                            CGRect endTokenFrame = CGRectMake(rect.origin.x + rect.size.width + 2, lineLineY, endTokenSize.width, endTokenSize.height);
                            self.endToken.frame = endTokenFrame;
                        });
                        
                    } else {
                        // 最后一个run的宽度 小于 endToken的宽度
                        // 这种情况很少见，暂不实现
                    }
                }
            }
        }

    } else {
        // 没有endTokenLabel的情况
        for (int i = 0; i < runCount; i++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            CFIndex glyphCount = CTRunGetGlyphCount(run);
            if (i != runCount - 1) {
                CTRunDraw(run, context, CFRangeMake(0, glyphCount));
            } else {
                // 判断这个run是不是一个attachment，如果是，就不绘制它
                // 用于处理要阶段的是一个attachment的情况
                NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
                CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
                BOOL isAttachment = NO;
                if (delegate) {
                    isAttachment = YES;

                }
                
                CFRange runRange = CTRunGetStringRange(run);
                
                // 计算每一个glyph在一个run中的位置和尺寸
                CGRect glyphRects[glyphCount];
                for (int i = 0; i < glyphCount; i++) {
                    CGRect rect = CTRunGetImageBounds(run, context, CFRangeMake(i, 1));
                    glyphRects[i] = rect;
                }
                YGLog(@"run last: %ld", runRange.location + runRange.length);
                YGLog(@"attributeText length: %ld", attributeText.length);
                if (runRange.location + runRange.length < attributeText.length) {
                    // 需要截断
                    // 如果是Attachment，则不绘制
                    if (isAttachment) {
                        YGTextAttachment* attachment = (__bridge YGTextAttachment *)CTRunDelegateGetRefCon(delegate);
                        [_attachmentDoNotDraw addObject:attachment];
                    }
                    NSUInteger truncationAttributePosition = runRange.location + runRange.length - 1;
                    NSDictionary *tokenAttributes = [attributeText attributesAtIndex:truncationAttributePosition
                                                                      effectiveRange:NULL];
                    NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:EllipsesCharacter
                                                                                      attributes:tokenAttributes];
                    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                    NSMutableAttributedString *truncationString = [[attributeText attributedSubstringFromRange:NSMakeRange(runRange.location, runRange.length)] mutableCopy];
                    
                    NSInteger needToTruncatedCount = 1;
                    
                    if (VPFloatIsEqual(glyphRects[glyphCount - 1].size.width, 0) && !isAttachment) {
                        needToTruncatedCount++;
                    }
                    
                    if (runRange.length > needToTruncatedCount - 1)
                    {
                        [truncationString deleteCharactersInRange:NSMakeRange(runRange.length - needToTruncatedCount, needToTruncatedCount)];
                    }
                    [truncationString appendAttributedString:tokenString];
                    
                    //重新获得一个截断的line
                    CTLineRef truncatedLine = [self _getTruncatedLineFor:truncationString width:size.width tokenAttribute:tokenAttributes];
                    
                    CFRelease(truncationToken);
                    CGContextSaveGState(context);
                    CGFloat startPoint = CTRunGetImageBounds(run, context, CFRangeMake(0, 1)).origin.x;
                    CGContextTranslateCTM(context, startPoint, 0);
                    CTLineDraw(truncatedLine, context);
                    CGContextRestoreGState(context);
                    CFRelease(truncatedLine);
                } else {
                    // 不需要截断，绘制整个run
                    CTRunDraw(run, context, CFRangeMake(0, glyphCount));
                }
            }
        }
    }
}


#pragma mark - YGLabelGestureRecognizerDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _touchedInfo = [self _checkTouchInfoForPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture {
    // do nothing
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture {
    if (_touchedInfo && _touchedBlock) {
        _touchedBlock(_touchedInfo.content, _touchedInfo.range);
    }
    _touchedInfo = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches gesture:(UIGestureRecognizer *)gesture {
    _touchedInfo = nil;
}

#pragma mark - font

#pragma mark - longpress
- (void)longPressWithBlock:(void(^)(void))block {
    _longBlock = block;
}

- (void)longpressAction:(UILongPressGestureRecognizer *)longpress {
    
    if (longpress.state == UIGestureRecognizerStateBegan) {
        _bgState = LongPressBgStateToDraw;
        if (_longBlock) {
            _longBlock();
        }
    }
    if (self.longPressColor) {
//        [self setNeedsDisplay];
        [self _drawText];
    }
}

- (void)cancelLongPress {
    _bgState = LongPressBgStateCancelDraw;
    if (self.longPressColor) {
        [self _drawText];
    }
}

#pragma mark - layer
+ (Class)layerClass {
    return [YGLabelLayer class];
}

@end
