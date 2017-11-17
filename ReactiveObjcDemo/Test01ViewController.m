//
//  Test01ViewController.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/17.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "Test01ViewController.h"
#import "ReactiveObjC.h"

@interface Test01ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation Test01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
//    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
//        return value.length < 4;
//    }] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
    // filter：信号过滤  map：信号转化
    [[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length < 3);
    }] subscribeNext:^(id  _Nullable x) {
        BOOL ret = [x boolValue];
        NSLog(@"%@", [x boolValue] ? @"vaild" : @"beyond length");
        self.view.backgroundColor = ret ? [UIColor cyanColor] : [UIColor magentaColor];
    }];
    
    RAC(self.textField, tintColor) = [self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return (value.length >= 3) ? [UIColor magentaColor] : [UIColor cyanColor];
    }];
    
    RACSignal *signal1 = [self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 3);
    }];
    RACSignal *signal2 = [self.textField2.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 3);
    }];
    RACSignal *nextSignal = [RACSignal combineLatest:@[signal1, signal2] reduce:^id (NSNumber *ret1, NSNumber *ret2){
        return @([ret1 boolValue] && [ret2 boolValue]);
    }];
    [nextSignal subscribeNext:^(id  _Nullable x) {
        BOOL ret = [x boolValue];
        self.nextButton.enabled = ret;
        UIColor *color = ret ? [UIColor greenColor] : [UIColor redColor];
        [self.nextButton setTitleColor:color forState:UIControlStateNormal];
    }];
    
    RACSignal *buttonSignal = [self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside];
//    [buttonSignal map:^id _Nullable(id  _Nullable value) {
//        return [self testHttpSignal];
//    }];
//    [buttonSignal subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"game over");
//    }];
    
    [[buttonSignal flattenMap:^id _Nullable(id  _Nullable value) {
        return [self testHttpSignal];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }] ;
}

- (IBAction)changeText:(id)sender {
    [self.textField.rac_newTextChannel sendNext:@"change text through textChanel of textField"];
}

- (RACSignal *)testHttpSignal {
    RACSignal *httpSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *str = @"http://192.168.117.146:4001/api/Account/GetmemberBindedWeight";
        NSURL *url = [NSURL URLWithString:str];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        //    [[NSURLSession sharedSession].configuration.HTTPAdditionalHeaders setValue:@"0ab674990c594e6dadec45a3a260a8a1" forKey:@"Token"];
        [request setValue:@"0ab674990c594e6dadec45a3a260a8a1" forHTTPHeaderField:@"Token"];
        //    [request.allHTTPHeaderFields setValue:@"0ab674990c594e6dadec45a3a260a8a1" forKey:@"Token"];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"----->%@", dict);
            if (error) {
                [subscriber sendError:error];
            }
            if (dict) {
                [subscriber sendNext:dict];
            }
            [subscriber sendCompleted];
        }];
        [task resume];
        return nil;
    }];
    
    return httpSignal;
}
@end
