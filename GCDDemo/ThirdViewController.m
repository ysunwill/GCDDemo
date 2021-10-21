//
//  ThirdViewController.m
//  GCDDemo
//
//  Created by ysunwill on 2021/9/23.
//

#import "ThirdViewController.h"

@interface ThirdViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *modelArray;

@end

@implementation ThirdViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Private Methods

/// 主线程 + 主队列 + 同步
/// 死锁
- (void)test0
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        NSLog(@"1");
    });
}

/// 子线程 + 主队列 + 同步
/// 不会死锁
- (void)test1
{
    // 子线程执行「test0」
    [self performSelectorInBackground:@selector(test0) withObject:nil];
}

/// 主队列 + 异步 + 同步
/// 死锁
- (void)test2
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        NSLog(@"1");
        
        dispatch_sync(mainQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 主队列 + 异步 + 异步
/// 不会死锁
- (void)test3
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        NSLog(@"1");
        
        dispatch_async(mainQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列 + 同步 + 同步
/// 死锁
- (void)test4
{
    dispatch_queue_t serialQueue = dispatch_queue_create("ys.serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"1");
        
        dispatch_sync(serialQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列 + 同步 + 异步
/// 不会死锁
- (void)test5
{
    dispatch_queue_t serialQueue = dispatch_queue_create("ys.serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"1");
        
        dispatch_async(serialQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列 + 异步 + 同步
/// 死锁
- (void)test6
{
    dispatch_queue_t serialQueue = dispatch_queue_create("ys.serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"1");
        
        dispatch_sync(serialQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列 + 异步 + 异步
/// 不会死锁
- (void)test7
{
    dispatch_queue_t serialQueue = dispatch_queue_create("ys.serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"1");
        
        dispatch_async(serialQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列1同步 + 串行队列2同步
/// 不会死锁
- (void)test8
{
    dispatch_queue_t serialQueue1 = dispatch_queue_create("ys.serial.queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("ys.serial.queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue1, ^{
        NSLog(@"1");
        
        dispatch_sync(serialQueue2, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列1同步 + 串行队列2异步
/// 不会死锁
- (void)test9
{
    dispatch_queue_t serialQueue1 = dispatch_queue_create("ys.serial.queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("ys.serial.queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue1, ^{
        NSLog(@"1");
        
        dispatch_async(serialQueue2, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列1异步 + 串行队列2同步
/// 不会死锁
- (void)test10
{
    dispatch_queue_t serialQueue1 = dispatch_queue_create("ys.serial.queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("ys.serial.queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue1, ^{
        NSLog(@"1");
        
        dispatch_sync(serialQueue2, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 串行队列1异步 + 串行队列2异步
/// 不会死锁
- (void)test11
{
    dispatch_queue_t serialQueue1 = dispatch_queue_create("ys.serial.queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("ys.serial.queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue1, ^{
        NSLog(@"1");
        
        dispatch_async(serialQueue2, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 并发队列 + 同步 + 同步
/// 不会死锁
- (void)test12
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"1");
        
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 并发队列 + 同步 + 异步
/// 不会死锁
- (void)test13
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"1");
        
        dispatch_async(concurrentQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 并发队列 + 异步 + 同步
/// 不会死锁
- (void)test14
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1");
        
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
}

/// 并发队列 + 异步 + 异步
/// 不会死锁
- (void)test15
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ys.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1");
        
        dispatch_async(concurrentQueue, ^{
            NSLog(@"2");
        });
        
        NSLog(@"3");
    });
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
        _modelArray = @[@"主线程 + 主队列 + 同步",
                        @"子线程 + 主队列 + 同步",
                        @"主队列 + 异步 + 同步",
                        @"主队列 + 异步 + 异步",
                        @"串行队列 + 同步 + 同步",
                        @"串行队列 + 同步 + 异步",
                        @"串行队列 + 异步 + 同步",
                        @"串行队列 + 异步 + 异步",
                        @"串行队列1同步 + 串行队列2同步",
                        @"串行队列1同步 + 串行队列2异步",
                        @"串行队列1异步 + 串行队列2同步",
                        @"串行队列1异步 + 串行队列2异步",
                        @"并发队列 + 同步 + 同步",
                        @"并发队列 + 同步 + 异步",
                        @"并发队列 + 异步 + 同步",
                        @"并发队列 + 异步 +  异步"];
    }
    return _modelArray;
}

@end
