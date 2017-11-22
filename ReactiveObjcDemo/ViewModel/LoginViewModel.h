//
//  LoginViewModel.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/22.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@interface LoginViewModel : NSObject

@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *password;

@property (strong, nonatomic) RACCommand *loginCommand;

@end
