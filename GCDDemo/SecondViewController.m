//
//  SecondViewController.m
//  GCDDemo
//
//  Created by ysunwill on 2021/9/13.
//

#import "SecondViewController.h"

@interface SecondViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *modelArray;

@end

@implementation SecondViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Private Methods

/// dispatch_once
/// 只执行一次，常用于创建单例、Method Swizzle等
- (void)test0
{
    NSLog(@"--------dispatch_once--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"dispatch_once：%@", [NSThread currentThread]);
    });
    
    NSLog(@"--------结束--------");
}

/// dispatch_after
/// 延迟操作，用于延迟弹窗等
- (void)test1
{
    NSLog(@"--------dispatch_after--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_after：%@", [NSThread currentThread]);
    });
    
    NSLog(@"--------结束--------");
}

/// dispatch_apply
/// 遍历操作，类似于高效的并行for循环（使用并发队列）
- (void)test2
{
    NSLog(@"--------dispatch_apply--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(10, concurrentQueue, ^(size_t index) {
        NSLog(@"dispatch_apply: %ld %@", index, [NSThread currentThread]);
    });
    
    NSLog(@"--------结束--------");
}

/// dispatch_group
/// 调度组，常用于一个界面请求多个接口，都请求完毕后刷新页面
- (void)test3
{
    NSLog(@"--------dispatch_group--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        sleep(2);
        NSLog(@"dispatch_group: 任务1完成 %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        sleep(1);
        NSLog(@"dispatch_group: 任务2完成 %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成，刷新页面 %@", [NSThread currentThread]);
    });
    
    NSLog(@"--------结束--------");
}

/// dispatch_barrier_sync
/// 同步栅栏函数，任务1和2完成，才会执行栅栏任务，同时会阻塞当前线程
- (void)test4
{
    NSLog(@"--------dispatch_barrier_sync--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        NSLog(@"任务1完成: %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        sleep(1);
        NSLog(@"任务2完成: %@", [NSThread currentThread]);
    });
    
    dispatch_barrier_sync(concurrentQueue, ^{
        NSLog(@"栅栏任务: %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务3完成: %@", [NSThread currentThread]);
    });
    
    NSLog(@"--------结束--------");
}

/// dispatch_barrier_async
/// 异步栅栏函数，任务1和2完成，才会执行栅栏任务，不会阻塞当前线程
- (void)test5
{
    NSLog(@"--------dispatch_barrier_async--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        NSLog(@"任务1完成: %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        sleep(1);
        NSLog(@"任务2完成: %@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"栅栏任务: %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务3完成: %@", [NSThread currentThread]);
    });
    
    NSLog(@"--------结束--------");
}

/// dispatch_semaphore
/// 经典的P、V操作，常用于线程同步
/// 比如，下面for循环如果不使用信号量，可能会乱序输出
/// 加入信号量，可保证顺序输出
- (void)test6
{
    NSLog(@"--------dispatch_semaphore--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    for (NSInteger i = 0; i < 30; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i: %ld %@", i, [NSThread currentThread]);
            dispatch_semaphore_signal(sem);
        });
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
    
    
    NSLog(@"--------结束--------");
}

/// dispatch_source
/// 有不同的DISPATCH_SOURCE_TYPE，常用于短信验证码倒计时
- (void)test7
{
    // 5s倒计时
    __block NSInteger timeout = 5;
    
    // 创建队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    
    // 设置1s触发一次，0s的误差
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
     // 触发的事件
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) { // 倒计时结束，关闭
            dispatch_source_cancel(timer); // 取消
        }else{
            timeout--;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"timer - %ld", timeout); // 更新主界面的操作
            });
        }
    });
    
    // 开始执行
    dispatch_resume(timer);
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.modelArray[indexPath.row];
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"test%ld", indexPath.row]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}

#pragma mark - Getter and Setter

- (NSArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = @[@"dispatch_once",
                        @"dispatch_after",
                        @"dispatch_apply",
                        @"dispatch_group",
                        @"dispatch_barrier_sync",
                        @"dispatch_barrier_async",
                        @"dispatch_semaphore",
                        @"dispatch_source"];
    }
    return _modelArray;
}


@end
