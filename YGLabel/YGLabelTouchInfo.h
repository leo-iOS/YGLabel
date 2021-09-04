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

//@property (nonatomic, strong) UIColor *color;
//
//@property (nonatomic, strong) UIColor *highlightColor;

//@property (nonatomic, assign) BOOL showUnderline;

+ (YGLabelTouchInfo *)touchInfo:(id)content
                          range:(NSRange)range;

//+ (YGLabelTouchInfo *)touchInfo:(id)content
//                          range:(NSRange)range
//                          color:(UIColor *)color;
//
//+ (YGLabelTouchInfo *)touchInfo:(id)content
//                          range:(NSRange)range
//                          color:(UIColor *)color
//                 highlightColor:(UIColor *)highlightColor;

@end
