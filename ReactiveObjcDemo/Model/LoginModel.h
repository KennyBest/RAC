//
//  LoginModel.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/22.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

/**
 Data = {
 Token = 5c6fec6352124fcb95c884a3a04b3a9a;
 UserId = 6ee4577f-f62c-4bb3-b484-a569bc44bfd2;
 IsDisplayMobileVerificationCode = 0;
 ExpiredTime = 2017-11-29T10:29:00.4271388+08:00;
 IsNewUser = 0;
 IsDisplayImageVerificationCode = 0;
 FirstGift = 0;
 IsAppActivityUser = 0;
 UserName = 绿竹;
 IsCollectFirstGift = 0;
 };

 */

@property (copy, nonatomic) NSString *Token;
@property (copy, nonatomic) NSString *UserId;
@property (copy, nonatomic) NSString *UserName;
@property (assign, nonatomic) BOOL IsNewUser;
@property (assign, nonatomic) BOOL IsCollectFirstGift;

+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd;
@end
