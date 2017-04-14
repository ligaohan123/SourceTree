//
//  ViewController.m
//  racTest
//
//  Created by 李高晗 on 2017/4/12.
//  Copyright © 2017年 李高晗. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dic = @{@"name":@"lgh",@"age":@25};
    
    [dic.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@ %@",key,value);
    }];
    
   
    
    NSArray *arr = @[@(1),@(2),@(3)];
    RACSequence *sq = [[arr rac_sequence] map:^id(id value) {
        return @([value integerValue]);
    }];
    NSLog(@"%@",[sq array]);
    
 
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"测试 racMUL"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
   

    //一次执行  相比多次执行不浪费资源
    RACMulticastConnection *connect = [signal publish];
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [connect connect];
    
 
    //延时方法 可用来检测更新
    [[RACSignal interval:3 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"吃药");
    }];
    
    __block NSInteger a = 0;
    
    //retry 多次执行
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        if (a < 100) {
            a++;
            NSLog(@"%@",[NSString stringWithFormat:@"第%ld次失败",a]);
            
            [subscriber sendError:nil];
        }
        else{
            NSLog(@"%@",[NSString stringWithFormat:@"在经历了%ld次失败之后",a]);
           [subscriber sendNext:nil];
        }
        
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }]retry]subscribeNext:^(id x) {
        NSLog(@"终于成功了");
    }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
