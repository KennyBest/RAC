//
//  RACLoginViewController.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/22.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "RACLoginViewController.h"
#import "LoginViewModel.h"

@interface RACLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) LoginViewModel *loginViewModel;
@end

@implementation RACLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self bindingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindingData {
    self.loginViewModel = [[LoginViewModel alloc] init];
    
    RAC(self.loginViewModel, phone) = self.phoneTextField.rac_textSignal;
    RAC(self.loginViewModel, password) = self.pwdTextField.rac_textSignal;
    self.loginButton.rac_command = self.loginViewModel.loginCommand;
    
    [[self.loginButton.rac_command.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        NSLog(@"receive executionSignals of command:%@", x);
        RACTuple *tuple = x;
        if ([tuple.first boolValue]) {
            // request success
            //  -- 这一步如何移到信号分发订阅时处理
            [RACScheduler.mainThreadScheduler schedule:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            // --- some error occur
            NSLog(@"login----->%@", [[tuple second] description]);
        }
    }];
    
    // ViewModel绑定Model，
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

/**
 View -> ViewModel
 ViewModel -> Model
 */
