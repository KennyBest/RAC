//
//  ProtocolView.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/23.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProtocolViewDelegate;

@interface ProtocolView : UIView

@property (weak, nonatomic) id<ProtocolViewDelegate> delegate;

@end

@protocol ProtocolViewDelegate <NSObject>

- (void)protocolView:(ProtocolView *)view info:(NSString *)info;

@end
