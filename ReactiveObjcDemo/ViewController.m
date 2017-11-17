//
//  ViewController.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/14.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "TestSignalViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TestSignalView *signalView;

@property (strong, nonatomic) RACSignal *showAlertSignal;

@property (strong, nonatomic) TestSignalViewModel *viewModel;
@end

@implementation ViewController

- (RACSignal *)showAlertSignal {
    if (!_showAlertSignal) {
        _showAlertSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"receive signal"];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    return _showAlertSignal;
}

- (TestSignalViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TestSignalViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.viewModel.view = self.signalView;
//    [self testRAC];
//    [self testTransformingStreams];
//    [self testCombiningStreams];
//    [self testMergeSignal];
    
//    [self testParams:@"1", @"2", @"3", @"4"];
    
//    [self testBindSignal];
//    [self test];
    [self testSubject];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testBasicSignalOperation:(id)sender {
    
    [self.showAlertSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"------> %@", x);
    }];
    
    [self.viewModel.changeColorSignal subscribeCompleted:^{
        
    }];
}
- (IBAction)changeBackgroundColor:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    NSArray *colors = @[[UIColor blackColor], [UIColor cyanColor], [UIColor magentaColor]];
    [self.viewModel.changeColorSubject sendNext:colors[index]];
}

- (void)testRAC {
//    RACSignal *letters = [@"A B C D E F G H" componentsSeparatedByString:@" "].rac_sequence.signal;
//    [letters subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
    // cold signal -- 每次订阅都会执行一次操作
    __block unsigned subscriptions = 0;
    RACSignal *logginSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"-------------------------");
        subscriptions++;
        NSLog(@"didSubcribe --------");
        [subscriber sendCompleted];
        NSLog(@"***********");
        return nil;
    }];
    
    // injects effects (注入操作) -doCompleted: 在不订阅信号的基础上为信号添加一次操作
//    logginSignal = [logginSignal doCompleted:^{
//        NSLog(@"about to complete subscription %u", subscriptions);
//    }];
//    [logginSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"&&&&&&&&&-----%@", x);
//    }];
    
    NSLog(@"init success");
    
    [logginSignal subscribeCompleted:^{
        NSLog(@"subcribeCompleted --------");
        NSLog(@"subcription %u", subscriptions);
    }];
//    [logginSignal subscribeCompleted:^{
//        NSLog(@"subcription %u", subscriptions);
//    }];
}

- (void)testTransformingStreams {
    // Mapping
    RACSequence *letters = [@"A B C D E F G H" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *mapped = [letters map:^id _Nullable(id  _Nullable value) {
        return [value stringByAppendingString:@"+"];
    }];
    NSLog(@"%@", mapped.array);
    
    // Filtering
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *filtered = [numbers filter:^BOOL(id  _Nullable value) {
        return ([value intValue]) % 2 == 0;
    }];
    NSLog(@"filtered ---> %@", filtered.array);
}

- (void)testCombiningStreams {
    RACSequence *letters = [@"A B C D E F G H" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8" componentsSeparatedByString:@" "].rac_sequence;
    // concat
    RACSequence *concatenated = [letters concat:numbers];
    NSLog(@"sequece concat --> %@", concatenated.array);
    // flatten
    RACSequence *sequeceOfSequeces = @[letters, numbers].rac_sequence;
    NSLog(@"sequeceOfSequeces: %@", sequeceOfSequeces.array);
    RACSequence *flattened = [sequeceOfSequeces flatten];
    NSLog(@"flattened --> %@", flattened.array);
}

- (void)testMergeSignal {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSignal *signalOfSignals = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:letters];
        [subscriber sendNext:numbers];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *flattened = [signalOfSignals flatten];
    
    [flattened subscribeNext:^(id  _Nullable x) {
        NSLog(@"*** ---->%@", x);
    }];
    [letters sendNext:@"A"];
    [numbers sendNext:@"1"];
    [letters sendNext:@"B"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"2"];
}

- (void)testParams:(NSString *)str1, ... {
    va_list args;
    NSMutableArray *array = @[].mutableCopy;
    NSString *tmp;
    if (str1) {
        [array addObject:str1];
        va_start(args, str1);
        while ((tmp = va_arg(args, NSString *))) {
            [array addObject:tmp];
            NSLog(@"******--->%@", tmp);
        }
        va_end(args);
    }
    NSLog(@"%@", array);
}

- (void)testBindSignal {
    RACSignal *originSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"test bindSignal --- 1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // typedef RACSignal * _Nullable (^RACSignalBindBlock)(ValueType _Nullable value, BOOL *stop);
    RACSignal *bindingSignal = [originSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(NSString *str, BOOL *stop){
            return [RACSignal return:str];
        };
    }];
    [bindingSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    [bindingSignal subscribeCompleted:^{
        NSLog(@"bindingSignal subscribe complete");
    }];
    
    [originSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"******* %@", x);
    }];
    [originSignal subscribeCompleted:^{
        NSLog(@"origin signal sucribe completed");
    }];
    
}

- (void)testSubject {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-----%@", x);
    }];
    
    [subject sendNext:@"Hello World, know subject"];
}



- (void)test {
    NSArray *array = @[];
    CGFloat tmp = 3 / array.count;
    NSLog(@"---------> %f", tmp);
}




@end
