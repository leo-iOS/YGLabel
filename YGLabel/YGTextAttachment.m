//
//  YGTextAttachment.m
//  YGLabel

#import "YGTextAttachment.h"

CGFloat attachemntAscentCallback(void *ref);
CGFloat attachmentDescentCallback(void *ref);
CGFloat attachmentWidthCallback(void *ref);

@implementation YGTextAttachment {
    CGSize _maxSize;
    CGSize _contentSize;
    CGSize _caculatedSize;
}

- (id)initWithContent:(id)content {
    return [self initWithContent:content margin:UIEdgeInsetsZero];
}

- (id)initWithContent:(id)content margin:(UIEdgeInsets)margin {
    return [self initWithContent:content margin:margin alignment:YGTextAttachmentAlignmentCenter maxSize:CGSizeZero];
}

- (id)initWithContent:(id)content margin:(UIEdgeInsets)margin alignment:(YGTextAttachmentAlignment)alignment; {
    return [self initWithContent:content margin:margin alignment:alignment maxSize:CGSizeZero];
}

- (id)initWithContent:(id)content maxSize:(CGSize)maxSize {
    return [self initWithContent:content margin:UIEdgeInsetsZero alignment:YGTextAttachmentAlignmentCenter maxSize:maxSize];
}

- (id)initWithContent:(id)content margin:(UIEdgeInsets)margin alignment:(YGTextAttachmentAlignment)alignment maxSize:(CGSize)maxSize {
    self = [super init];
    if (self) {
        _content = content;
        _margin = margin;
        _alignment = alignment;
        _maxSize = maxSize;
        
        if ([_content isKindOfClass:[UIImage class]])
        {
            _contentSize = [((UIImage *)_content) size];
            _caculatedSize = _contentSize;
        }
        else if ([_content isKindOfClass:[UIView class]])
        {
            _contentSize = [((UIView *)_content) bounds].size;
            _caculatedSize = _contentSize;
        } else {
            NSAssert(NO, @"不支持的 content 类型");
        }
    }
    return self;
}

- (void)caculateSizeWithAscent:(CGFloat)ascent descent:(CGFloat)descent {

    if (CGSizeEqualToSize(_maxSize, CGSizeZero)) {
        _ascent = ascent;
        _descent = descent;
        _caculatedSize = _contentSize;
        return;
    }
    
    if (ascent != _ascent || descent != _descent) {
        _ascent = ascent;
        _descent = descent;
        CGFloat width = _contentSize.width;
        CGFloat height = _contentSize.height;
        
        CGFloat maxWidth = _maxSize.width;
        CGFloat maxHeight = _maxSize.height;
        
        if (width <= maxWidth && height <= maxHeight) {
            _caculatedSize = _contentSize;
        }
        
        if (width / height > maxWidth / maxHeight) {
            _caculatedSize = CGSizeMake(maxWidth, maxWidth * height / width);
        } else {
            _caculatedSize = CGSizeMake(maxHeight * height / width , maxHeight);
        }
    }
}

- (CTRunDelegateRef)delegateForAttachment {
    NSAssert(!VPFloatIsEqual(_ascent, 0), @"ascent can no be zero");
    NSAssert(!VPFloatIsEqual(_descent, 0), @"descent can no be zero");
    
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = attachemntAscentCallback;
    callbacks.getDescent = attachmentDescentCallback;
    callbacks.getWidth = attachmentWidthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (void *)self);
    return delegate;
}

- (CGSize)boxSize {
    return CGSizeMake(_caculatedSize.width + self.margin.left + self.margin.right, _caculatedSize.height + self.margin.top + self.margin.bottom);
}

- (id)copyWithZone:(nullable NSZone *)zone {
    YGTextAttachment *attachment = [[YGTextAttachment alloc] initWithContent:self.content margin:self.margin alignment:self.alignment maxSize:self->_maxSize];
    return  attachment;;
}

@end

CGFloat attachemntAscentCallback(void *ref) {
    CGFloat ascent = 20;
    
    YGTextAttachment *attachment = (__bridge YGTextAttachment *)ref;
    CGFloat height = [attachment boxSize].height;
    switch (attachment.alignment) {
        case YGTextAttachmentAlignmentTop: {
            break;
        }
        case YGTextAttachmentAlignmentCenter: {
            CGFloat fontAscent = attachment.ascent;
            CGFloat fontDescent = attachment.descent;
            CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
            ascent = height / 2 + baseLine;
        }
            break;
        case YGTextAttachmentAlignmentBottom: {
            break;
        }
    }
    return ascent;
}

CGFloat attachmentDescentCallback(void *ref) {
    CGFloat descent = 10;
    
    YGTextAttachment *attachment = (__bridge YGTextAttachment *)ref;
    CGFloat height = [attachment boxSize].height;
    switch (attachment.alignment) {
        case YGTextAttachmentAlignmentTop: {
            break;
        }
        case YGTextAttachmentAlignmentCenter: {
            CGFloat fontAscent = attachment.ascent;
            CGFloat fontDescent = attachment.descent;
            CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
            descent = height / 2 - baseLine;
        }
            break;
        case YGTextAttachmentAlignmentBottom: {
            break;
        }
    }
    
    return descent;
}

CGFloat attachmentWidthCallback(void *ref) {
    YGTextAttachment *attachment = (__bridge YGTextAttachment *)ref;
    return attachment.boxSize.width;
}
