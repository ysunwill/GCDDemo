//
//  FirstViewController.m
//  GCDDemo
//
//  Created by ysunwill on 2021/9/13.
//

#import "FirstViewController.h"

@interface FirstViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *modelArray;

@end

@implementation FirstViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - Private Methods

/// 自定义串行队列 + 同步
- (void)test0
{
    NSLog(@"--------自定义串行队列 + 同步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);


    // 自定义串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("ys.serial.queue", DISPATCH_QUEUE_SERIAL);

    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(serialQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<串行同步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }

    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(serialQueue, ^{
            NSLog(@"<串行同步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }

    NSLog(@"--------结束--------");
}

/// 自定义串行队列 + 异步
- (void)test1
{
    NSLog(@"--------自定义串行队列 + 异步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    // 自定义串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("ys.serial.queue", DISPATCH_QUEUE_SERIAL);
    
    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(serialQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<串行异步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(serialQueue, ^{
            NSLog(@"<串行异步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"--------结束--------");
}

/// 自定义并发队列 + 同步
- (void)test2
{
    NSLog(@"--------自定义并发队列 + 同步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    // 自定义并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(concurrentQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<并发同步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"<并发同步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"--------结束--------");
}

/// 自定义并发队列 + 异步
- (void)test3
{
    NSLog(@"--------自定义并发队列 + 异步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    // 自定义并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(concurrentQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<并发异步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"<并发异步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"--------结束--------");
}

/// 主队列 + 同步
- (void)test4
{
    NSLog(@"--------主队列 + 同步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);

    // 主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(mainQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<主队列同步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }

    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(mainQueue, ^{
            NSLog(@"<主队列同步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }

    NSLog(@"--------结束--------");
}

/// 主队列 + 异步
- (void)test5
{
    NSLog(@"--------主队列 + 异步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    // 主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(mainQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<主队列异步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(mainQueue, ^{
            NSLog(@"<主队列异步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"--------结束--------");
}

/// 全局并发队列 + 同步
- (void)test6
{
    NSLog(@"--------全局并发队列 + 同步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    // 全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(globalQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<全局并发同步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_sync(globalQueue, ^{
            NSLog(@"<全局并发同步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"--------结束--------");
}

/// 全局并发队列 + 异步
- (void)test7
{
    NSLog(@"--------全局并发队列 + 异步--------");
    NSLog(@"当前线程：%@", [NSThread currentThread]);
    
    // 全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 任务1
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(globalQueue, ^{
            sleep(1); // 模拟耗时操作
            NSLog(@"<全局并发异步>任务1：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    // 任务2
    for (NSInteger i = 0; i < 6; i++) {
        dispatch_async(globalQueue, ^{
            NSLog(@"<全局并发异步>任务2：%ld --- %@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"--------结束--------");
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
        _modelArray = @[@"自定义串行队列 + 同步",
                        @"自定义串行队列 + 异步",
                        @"自定义并发队列 + 同步",
                        @"自定义并发队列 + 异步",
                        @"主队列 + 同步",
                        @"主队列 + 异步",
                        @"全局并发队列 + 同步",
                        @"全局并发队列 + 异步"];
    }
    return _modelArray;
}

@end
