//
//  YGLabelTouchInfo.h
//  YGLabel
//
//  Created by leo on 2021/9/2.
//

#import <Foundation/Foundation.h>


@interface YGLabelTouchInfo : NSObject

@property (nonatomic, strong) id content;

@property (nonatomic, assign) NSRange range;


+ (YGLabelTouchInfo *)touchInfo:(id)content
                          range:(NSRange)range;

@end
