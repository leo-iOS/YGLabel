//
//  YGViewController.m
//  YGLabel
//

#import "YGViewController.h"
#import <YGLabel/YGLabel.h>
#import <YGLabel/YGLabelQueueManager.h>
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"
#import "Demo4ViewController.h"
#import "Demo5ViewController.h"
#import "Demo6ViewController.h"

@interface YGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation YGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.datas =
    @[
        @"Demo1 (测试字体、颜色、行高、行数)",
        @"Demo2 (测试append, insert attribuString、Attachment)",
        @"Demo3（测试同步、异步绘制1）",
        @"Demo4（测试同步、异步绘制2）",
        @"Demo5（测试endtoken总是存在）",
        @"Demo6（测试endtoken隐藏)",
        @"Demo7（tap测试)",
        @"Demo8（长按背景色显示)",
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.datas[indexPath.row];
    cell.textLabel.numberOfLines = 2;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    CGFloat value = [self randomBetweenMin:20 max:30];
//    NSLog(@"value: %f", value);
//
//    return;
    
    switch (indexPath.row) {
        case 0: {
            Demo1ViewController *vc = [[Demo1ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            Demo2ViewController *vc = [[Demo2ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            Demo3ViewController *vc = [[Demo3ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            Demo4ViewController *vc = [[Demo4ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            Demo5ViewController *vc = [[Demo5ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5: {
            Demo6ViewController *vc = [[Demo6ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {
//            Demo7ViewController *vc = [[Demo7ViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}



@end
