//
//  YGLabelQueueManager.m
//  YGLabel


#import "YGLabelQueueManager.h"
#include <stdatomic.h>

#define MAX_QUEUE_COUNT 32


static inline qos_class_t qosClass(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
        default: return QOS_CLASS_UNSPECIFIED;
    }
}

@interface YGLabelQueue : NSObject {
    atomic_uint _counter;
    qos_class_t _qos;
    NSString *_name;
}

@property (nonatomic, assign) NSUInteger queueTotalCount;

@property (nonatomic, strong) NSArray<dispatch_queue_t> *queues;

@end

@implementation YGLabelQueue

- (id)initWithCount:(NSUInteger)count qos:(NSQualityOfService)qos name:(NSString *)name {
    self = [super init];
    if (self ) {
        _counter = 0;
        _qos = qosClass(qos);
        _queueTotalCount = count <= 1 ? 1 : (count >= MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count);
        _name = name;
        NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:_queueTotalCount];
        for (int i = 0; i < _queueTotalCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, _qos, 0);
            NSString *name = [NSString stringWithFormat:@"%@_%d", _name, (int)i];
            dispatch_queue_t queue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], attr);
            [tmpArr addObject:queue];
        }
        _queues = tmpArr.copy;
    }
    return self;
}

- (dispatch_queue_t)currentQueue {
    atomic_fetch_add(&_counter, 1);
    return self.queues[_counter % _queueTotalCount];
}

@end

@interface YGLabelQueueManager()

@property (nonatomic, strong) YGLabelQueue *dispalyQueue;

@property (nonatomic, strong) YGLabelQueue *releaseQueue;

@end

@implementation YGLabelQueueManager

+ (YGLabelQueueManager *)shareManager {
    static dispatch_once_t onceToken;
    static YGLabelQueueManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[YGLabelQueueManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUInteger displayQueueCount = NSProcessInfo.processInfo.activeProcessorCount;
        self.dispalyQueue = [[YGLabelQueue alloc] initWithCount:displayQueueCount qos:NSQualityOfServiceUserInteractive name:@"com.yglabel.displayqueue"];
        self.releaseQueue = [[YGLabelQueue alloc] initWithCount:1 qos:NSQualityOfServiceBackground name:@"com.yglabel.releasequeue"];
    }
    return self;
}

- (dispatch_queue_t)getDispalyQueue {
    return [self.dispalyQueue currentQueue];
}

- (dispatch_queue_t)getReleaseQueue {
    return [self.releaseQueue currentQueue];
}

@end
