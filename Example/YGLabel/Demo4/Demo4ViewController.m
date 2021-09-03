//
//  Demo4ViewController.m
//  YGLabel_Example
//
//  Created by leo on 2021/9/3.
//

#import "Demo4ViewController.h"
#import <YGLabel/YGLabel.h>
static CFTimeInterval lastTime = 0;
static NSUInteger counter = 0;
void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的 loop 用来进行监控
        if (activity == kCFRunLoopBeforeWaiting) {
            if (lastTime == 0) {
                lastTime =  CACurrentMediaTime();
                counter = 0;
            } else {
                CFTimeInterval currentTime = CACurrentMediaTime();
                CFTimeInterval delta = currentTime - lastTime;
                if (delta >= 1) {
                    int fps = counter / delta;
                    NSLog(@"fps: %d", fps);
                    lastTime = currentTime;
                    counter = 0;
                } else {
                    counter++;
                }
            }
            
        }
        
//        while (YES) {
//            long semaphoreWait = dispatch_semaphore_wait(dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));
//            if (semaphoreWait != 0) {
//                if (!observer) {
////                    timeoutCount = 0;
////                    dispatchSemaphore = 0;
////                    runLoopActivity = 0;
//                    return;
//                }
//                //BeforeSources 和 AfterWaiting 这两个状态能够检测到是否卡顿
//                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting) {
//                    //将堆栈信息上报服务器的代码放到这里
//                } //end activity
//            }// end semaphore wait
//            timeoutCount = 0;
//        }// end while
    });
}

@interface DemoCell : UITableViewCell

@property (nonatomic, strong) YGLabel *label;

@end

@implementation DemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[YGLabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:10];
        self.label.lineHeight = [UIFont systemFontOfSize:10].lineHeight;
        [self.contentView addSubview:self.label];
        self.label.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 60);
    }
    return self;
}

@end

@interface Demo4ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISwitch *aSwitch;
@property (nonatomic, assign) BOOL isOpenSync;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation Demo4ViewController

- (IBAction)switchAction:(id)sender {
    self.isOpenSync = self.aSwitch.isOn;
}

- (void)setIsOpenSync:(BOOL)isOpenSync {
    _isOpenSync = isOpenSync;
//    self.label.displayAsync = isOpenSync;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
//    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities,YES,0,&runLoopObserverCallBack,&context);
    
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    CFRunLoopObserverRef runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), runLoopObserver, (__bridge CFStringRef)UITrackingRunLoopMode);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), runLoopObserver, kCFRunLoopDefaultMode);
//    NSArray *arr = (__bridge NSArray *)CFRunLoopCopyAllModes(CFRunLoopGetCurrent());
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DemoCell class] forCellReuseIdentifier:@"DemoCell"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < 10000; i++) {
        
        NSString *string = [NSString stringWithFormat:@"%d %@", i, @"一🐸二🐠三🐥四🐠五🐞六🐳七🐿八🐨九🦁十🐅十一😇十二🐅十三🦁十四🐅是🦁🐅🦁😂😭😬😭😂😭😁😅😬😋😉😆😉😹😇🙏🙏🙃🙃😋😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔😔😢😥😥👈💪👈💪👏😴😪🤐💤😷👍👉👍🤕💪🤕😴🤕😴🚕🚅🚚🚚🚎🚎🚓🚚🚔🈳🛐🕉🔯🔯🕎📴🛐🛐🈲💮🈸📳🈸🆎🈲🆎🈲🆎📛🆑🚫💢🚳💢🚳🚷🚱📵🏧🏧🌀🌀💠💠🇨🇳🇩🇿🇨🇳🇩🇿🇦🇫🇦🇸🇦🇴🇦🇼🇦🇹🇧🇩🇦🇹🇧🇩🇦🇹🇦🇹🇦🇹一🐸二🐠三🐥四🐠五🐞六🐳七🐿八🐨九🦁十🐅十一😇十二🐅十三🦁十四🐅是🦁🐅🦁😂😭😬😭😂😭😁😅😬😋😉😆😉😹😇🙏🙏🙃🙃😋😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔😔😢😥😥👈💪👈💪👏😴😪🤐💤😷👍👉👍🤕💪🤕😴🤕😴🚕🚅🚚🚚🚎🚎🚓🚚🚔🈳🛐🕉🔯🔯🕎📴🛐🛐🈲💮🈸📳🈸🆎🈲🆎🈲🆎📛🆑🚫💢🚳💢🚳🚷🚱📵🏧🏧🌀🌀💠💠🇨🇳🇩🇿🇨🇳🇩🇿🇦🇫🇦🇸🇦🇴🇦🇼🇦🇹🇧🇩🇦🇹🇧🇩🇦🇹🇦🇹🇦🇹一🐸二🐠三🐥四🐠五🐞六🐳七🐿八🐨九🦁十🐅十一😇十二🐅十三🦁十四🐅是🦁🐅🦁😂😭😬😭😂😭😁😅😬😋😉😆😉😹😇🙏🙏🙃🙃😋😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔😔😢😥😥👈💪👈💪👏😴😪🤐💤😷👍👉👍🤕💪🤕😴🤕😴🚕🚅🚚🚚🚎🚎🚓🚚🚔🈳🛐🕉🔯🔯🕎📴🛐🛐🈲💮🈸📳🈸🆎🈲🆎🈲🆎📛🆑🚫💢🚳💢🚳🚷🚱📵🏧🏧🌀🌀💠💠🇨🇳🇩🇿🇨🇳🇩🇿🇦🇫🇦🇸🇦🇴🇦🇼🇦🇹🇧🇩🇦🇹🇧🇩🇦🇹🇦🇹🇦🇹一🐸二🐠三🐥四🐠五🐞六🐳七🐿八🐨九🦁十🐅十一😇十二🐅十三🦁十四🐅是🦁🐅🦁😂😭😬😭😂😭😁😅😬😋😉😆😉😹😇🙏🙏🙃🙃😋😋😙😗🤓😐😘😑😑🤔😑🤔😑🙄😐😔😔😢😥😥👈💪👈💪👏😴😪🤐💤😷👍👉👍🤕💪🤕😴🤕😴🚕🚅🚚🚚🚎🚎🚓🚚🚔🈳🛐🕉🔯🔯🕎📴🛐🛐🈲💮🈸📳🈸🆎🈲🆎🈲🆎📛🆑🚫💢🚳💢🚳🚷🚱📵🏧🏧🌀🌀💠💠🇨🇳🇩🇿🇨🇳🇩🇿🇦🇫🇦🇸🇦🇴🇦🇼🇦🇹🇧🇩🇦🇹🇧🇩🇦🇹🇦🇹🇦🇹"];
        [tmpArr addObject:string];
    }
    self.datas = [tmpArr copy];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell" forIndexPath:indexPath];
    cell.label.displayAsync = self.isOpenSync;
    cell.label.text = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
