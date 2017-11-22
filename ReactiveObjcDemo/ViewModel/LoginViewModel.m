//
//  LoginViewModel.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/22.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "LoginViewModel.h"
#import "NSString+Util.h"
#import "LoginModel.h"

@interface LoginViewModel ()

@property (strong, nonatomic) LoginModel *loginModel;


@end

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    RACSignal *phoneSignal = [[RACObserve(self, phone)
                               map:^id _Nullable(NSString*  _Nullable value) {
                                   return @(value.length == 11);
                               }]
                              distinctUntilChanged] ;
    RACSignal *pwdSignal = [[RACObserve(self, password)
                             map:^id _Nullable(NSString*  _Nullable value) {
                                 return @(value.length > 0);
                             }]
                            distinctUntilChanged] ;
    RACSignal *combineSignal = [RACSignal combineLatest:@[phoneSignal, pwdSignal] reduce:^id (NSNumber *ret1, NSNumber *ret2){
        return @([ret1 boolValue] && [ret2 boolValue]);
    }];
    self.loginCommand = [[RACCommand alloc] initWithEnabled:combineSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"--------> excute signalBlock");
        return [self loginSignal];
    }];
}

- (RACSignal *)loginSignal {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSString *path = [NSString stringWithFormat:@"http://192.168.117.146:4001/api/Account/Login?LoginName=%@&LoginPassword=%@&DeviceNo=817F03FD-14ED-4703-AA38-DE65F5EB8A03", self.phone, [[self.password MD5Hash] lowercaseString]];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
        req.HTTPMethod = @"POST";
        [req setValue:@"722F6A98-E091-4432-8877-78D926EEBDF6" forHTTPHeaderField:@"salePlatformId"];
        NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }
            NSError *jsonError;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSLog(@"-----------> %@", dict);
            if (jsonError) {
                [subscriber sendError:jsonError];
            } else {
                self.loginModel.Token = dict[@"Data"][@"Token"];
                // --- 用户信息缓存操作在这做 ？？ 还是放到LoginModel去做
                BOOL ret = [dict[@"State"] boolValue];
                RACTuple *tuple = [RACTuple tupleWithObjects:@(ret), ret ? @"" : dict[@"Msg"], nil];
                [subscriber sendNext:tuple];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return nil;
    }];
}

@end
