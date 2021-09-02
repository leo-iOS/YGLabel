//
//  YGLabelQueueManager.h
//  YGLabel

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define LabelDispalyQueue YGLabelQueueManager.shareManager.getDispalyQueue

#define LabelReleaseQueue YGLabelQueueManager.shareManager.getReleaseQueue


@interface YGLabelQueueManager : NSObject

+ (YGLabelQueueManager *)shareManager;

- (dispatch_queue_t)getDispalyQueue;

- (dispatch_queue_t)getReleaseQueue;

@end

NS_ASSUME_NONNULL_END
