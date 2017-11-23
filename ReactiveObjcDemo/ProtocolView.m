//
//  ProtocolView.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/23.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "ProtocolView.h"

@implementation ProtocolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Send" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button addTarget:self action:@selector(execute:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)execute:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolView:info:)]) {
        [self.delegate protocolView:self info:@"Hello, KennyBest!"];
    }
}

@end
