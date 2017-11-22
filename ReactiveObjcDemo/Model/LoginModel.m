//
//  LoginModel.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/22.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd {
    NSString *path = [NSString stringWithFormat:@"http://192.168.117.146:4001/api/Account/Login?LoginName=%@&LoginPassword=%@&DeviceNo=817F03FD-14ED-4703-AA38-DE65F5EB8A03", phone, pwd];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"path"]];
    req.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [task resume];
}

@end
