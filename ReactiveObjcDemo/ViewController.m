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
#import "RWTFlickrSearchViewController.h"
#import "FlickrSearchViewModel.h"
#import "ViewModelServicesImpl.h"
#import "ProtocolView.h"

@interface ViewController () <ProtocolViewDelegate>
@property (weak, nonatomic) IBOutlet TestSignalView *signalView;
@property (weak, nonatomic) IBOutlet UIButton *mvvmButton;

@property (strong, nonatomic) RACSignal *showAlertSignal;

@property (strong, nonatomic) TestSignalViewModel *viewModel;

@property (strong, nonatomic) FlickrSearchViewModel *searchViewModel;
@property (strong, nonatomic) ViewModelServicesImpl *viewModelServices;

@property (strong, nonatomic) ProtocolView *protocolView;

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
    
    [self addProtocolView];
    
    self.viewModel.view = self.signalView;
//    [self testRAC];
//    [self testTransformingStreams];
//    [self testCombiningStreams];
//    [self testMergeSignal];
    
//    [self testParams:@"1", @"2", @"3", @"4"];
    
//    [self testBindSignal];
//    [self test];
//    [self testSubject];
    
//    [self testRACCommand];
    
    [self testDeepRAC];
    RACSignal *goSingle = [self.mvvmButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    self.viewModelServices = [[ViewModelServicesImpl alloc] init];
    self.searchViewModel = [[FlickrSearchViewModel alloc] initWithServices:self.viewModelServices];
   
    @weakify(self);
    [goSingle subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RWTFlickrSearchViewController *vc = [[RWTFlickrSearchViewController alloc] initWithViewModel:self.searchViewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // -rac_signalForSelector: 监听方法被执行，创建可以发出带有这个方法全部参数的信号，方法被执行，则执行-sendNext:
    [[self rac_signalForSelector:@selector(testSignalSelector:param:)]
     subscribeNext:^(id  _Nullable x) {
         NSLog(@"rac_signalForSelector---->%@", x);
     }];
    [[self rac_signalForSelector:@selector(protocolView:info:) fromProtocol:@protocol(ProtocolViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"rac_signalForSelector: fromProtocol:--->%@", x);
    }];
}

- (IBAction)testRac_SignalFromSelector:(id)sender {
    [self testSignalSelector:@"Hello" param:@"World"];
}

- (void)testSignalSelector:(NSString *)str1 param:(NSString *)str2 {
    
}

- (void)addProtocolView {
    ProtocolView *view = [[ProtocolView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 70, 100, 50)];
    [self.view addSubview:view];
    self.protocolView = view;
    view.delegate = self;
}

- (void)protocolView:(ProtocolView *)view info:(NSString *)info {
    NSLog(@"-------->*********");
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

- (void)testRACCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber*  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSInteger count = [input integerValue];
            for (NSInteger i = 0; i < count; i++) {
                [subscriber sendNext:@"Hello World"];
            }
            return nil;
        }];
    }];
    
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSLog(@"------>%@", x);
    }];
    
    sleep(2);
    
    [command execute:@(2)];
}

- (void)testDeepRAC {
    /**
     basic opertaion:
     empty
     bind -- 对原信号解包，按照新规则重新组包成一个新信号
     return
     zipWith
     concat
     */
    RACSignal *returnSignal = [RACSignal return:@(3)];
    [returnSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    RACSignal *sampleSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"Hello"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    /**
     typedef RACSignal * _Nullable (^RACSignalBindBlock)(ValueType _Nullable value, BOOL *stop);
     - (RACSignal *)bind:(RACSignalBindBlock (^)(void))block RAC_WARN_UNUSED_RESULT;
     */
    //
    RACSignal *bindSignal = [sampleSignal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSString *value, BOOL *stop){
            return [RACSignal return:[value stringByAppendingString:@" KennyBest"]];
        };
    }];
    
    [sampleSignal subscribeNext:^(NSString*  _Nullable x) {
        NSLog(@"sample---->%@", x);
    }];
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"bind--->%@", x);
    }];
  
    RACSignal *secondSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"concat second signal"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    // concat
    RACSignal *concatSignal = [sampleSignal concat:secondSignal];
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat----->%@", x);
    }];
    
    // operation
    
    
    // -- flattenMap:  内部执行bind操作
    RACSignal *flattenMapSignal = [sampleSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"flattenMap block value--->%@", value);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"flattenMap --> new signal"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [flattenMapSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe flattenMapSignal next event --->%@", x);
    }];
    
    // map 就是转换 将一个信号源的信号值转变为另一个形式 -- 内部执行flattenMap 快捷操作
    RACSignal *mapSignal = [sampleSignal map:^id _Nullable(id  _Nullable value) {
        return @([value length] > 3);
    }];
    [mapSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe map signal -->%@", x);
    }];
    
    // reduceEach
    RACSignal *tupleSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        RACTuple *tuple = [RACTuple tupleWithObjects:@"1", @"2", @"3", @"4", nil];
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *reduceEachSignal = [tupleSignal reduceEach:^id _Nullable (NSString *str1, NSString *str2, NSString *str3, NSString *str4) {
        return [NSString stringWithFormat:@"%@-%@-%@-%@", str1, str2, str3, str4];
    }];
    [reduceEachSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe reduceEachSignal -- %@", x);
    }];
    
    //zip --> 将多个信号合成一个元组
    RACSignal *zipSignal = [RACSignal zip:@[sampleSignal, secondSignal]];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe zipSignal --->%@", x);
    }];
    
    // -zip: reduce:
    RACSignal *zipReduceSignal = [RACSignal zip:@[sampleSignal, secondSignal] reduce:^id _Nullable (NSString *str1, NSString *str2){
        return [NSString stringWithFormat:@"%@ - %@", str1, str2];
    }];
    [zipReduceSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe zipReduceSignal --->%@", x);
    }];
    
    // - switchToLatest -- 获取被发送的信号  需要注意completed的时机（源信号和被发送信号都completed时才会执行新信号的completed）
    RACSignal *sendSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"a signal sent by other signal"];
            [subscriber sendCompleted];
            return nil;
        }];
        [subscriber sendNext:signal];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *latesSignal = [sendSignal switchToLatest];
    [latesSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"switchToLatest-->%@", x);
    }];
}

@end
