//
//  StackViewController.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/24.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "StackViewController.h"
#import "ReactiveObjC.h"

@interface StackViewController ()

@end

@implementation StackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self testBasicSequenceOperation];
//    [self testStreamOperation];
    [self testMoreOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)testBasicSequenceOperation {
    RACSequence *sequence = @[@"1", @"2", @"3", @"4", @"5"].rac_sequence;
    
    // head头部  tail尾部
    NSLog(@"head:%@----tail:%@", sequence.head, sequence.tail);
    
    NSLog(@"array:%@\n*objectEnumerator:%@", sequence.array, sequence.objectEnumerator.allObjects);
    
    // 折叠序列
    NSInteger flodLeft = [[sequence foldLeftWithStart:@(1) reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return @([accumulator integerValue] + [value integerValue]);
    }]
    integerValue];
    NSLog(@"flodLeft ----%ld", flodLeft);
    
    // 这里的rest其实上一次执行reduce这个block的返回
    NSString *flodRight = [sequence foldRightWithStart:@"*" reduce:^id _Nullable(id  _Nullable first, RACSequence * _Nonnull rest) {
        NSString *tmp = [rest.array.lastObject stringByAppendingString:first];
//        NSLog(@"rest-->%@ lastObject:%@", rest.array, rest.array.lastObject);
//        NSLog(@"first:%@<-->tmp:%@", first, tmp);
        return tmp;
    }];
    NSLog(@"flodRight----%@", flodRight);

    // -any:任意元素满足就为YES  -all:所有元素都满足才为YES
    BOOL anyRet = [sequence any:^BOOL(id  _Nullable value) {
        return [value integerValue] > 5;
    }];
    BOOL allRet = [sequence all:^BOOL(id  _Nullable value) {
        return [value integerValue] > 1;
    }];
    NSLog(@"any-->%d,all-->%d", anyRet, allRet);
 
    // 返回序列中第一个满足block验证的元素
    NSString *passingTestObj = [sequence objectPassingTest:^BOOL(id  _Nullable value) {
        return [value integerValue] > 3;
    }];
    NSLog(@"firstOfPassingTest----->%@", passingTestObj);
    
    // 动态创建RACSequence
    RACSequence *dynamicSequence = [RACSequence sequenceWithHeadBlock:^id _Nullable{
        return @"*";
    } tailBlock:^RACSequence * _Nonnull{
        return @[@"!", @"@", @"#", @"$"].rac_sequence;
    }];
    NSLog(@"dynamic generate-->%@", dynamicSequence.array);
}

- (void)testStreamOperation {
    RACSequence *returnSequence = [RACSequence return:@"Hello"];
    NSLog(@"return:%@", returnSequence.array);
    
    // RACSequence的bind跟RACSignal的bind不一样，RACSignal是信号bind，RACSequence是元素bind
    RACSequence *sequence1 = @[@"1", @"2", @"3", @"4", @"5"].rac_sequence;
    RACSequence *sequence2 = @[@"a", @"b", @"c", @"d", @"e"].rac_sequence;
    RACSequence *bindSequence = [sequence1 bind:^RACSequenceBindBlock _Nonnull{
        return ^(id value, BOOL *stop){
            NSString *tmp = [value stringByAppendingString:@"*"];
            return [RACSequence return:tmp];
        };
    }];
    NSLog(@"bind sequence-->%@", bindSequence.array);
    
    // concat -- 简单的两个序列拼接
    RACSequence *concatSequence = [sequence1 concat:sequence2];
    NSLog(@"concat:%@", concatSequence.array);
    
    // -zipWith:
}

- (void)testMoreOperation {
    RACSequence *sequence1 = @[@"1", @"2", @"3", @"4", @"5"].rac_sequence;
    
    RACSequence *flattenMapSequence = [sequence1 flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
        return [RACSequence return:[value stringByAppendingString:@"*"]];
    }];
    NSLog(@"flattenMap sequence-->%@", flattenMapSequence.array);
    
    RACSequence *mapSequence = [sequence1 map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue] + 1);
    }];
    NSLog(@"map:-->%@", mapSequence.array);
    
    // 把序列中元素全部替换为所传的元素
    RACSequence *mapReplaceSequence = [sequence1 mapReplace:@"5"];
    NSLog(@"mapReplace:---->%@", mapReplaceSequence.array);
    
    RACSequence *filterSequence = [sequence1 filter:^BOOL(id  _Nullable value) {
        BOOL ret = [value integerValue] % 2 == 0;
        return ret;
    }];
    NSLog(@"filter--->%@", filterSequence.array);
    
    //
    RACSequence *ignoreSequence = [sequence1 ignore:@"5"];
    NSLog(@"ignore:%@", ignoreSequence.array);
    
    // -reduceEach: 针对元素为RACTulpe的序列
    
#pragma mark -- 到zip -- 补与RACSignal的zip差异
    
    
    RACSequence *scanSequence = [sequence1 scanWithStart:@"*" reduceWithIndex:^id _Nullable(id  _Nullable running, id  _Nullable next, NSUInteger index) {
        NSString *current = sequence1.array[index];
        return [next stringByAppendingString:current];
    }];
    /** 打印结果：
     (
     11,
     22,
     33,
     44,
     55
     )
     */
    NSLog(@"reduceWithIndex:%@", scanSequence.array);
    
}


@end
