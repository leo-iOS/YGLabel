//
//  YGLabelLinkInfo.h


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGLabelLinkInfo : NSObject

@property (nonatomic, strong) id content;

@property (nonatomic, assign) NSRange range;

+ (YGLabelLinkInfo *)linkInfo:(id)content range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
