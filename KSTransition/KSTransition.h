//
//  KSTransition.h
//  KSTransition
//
//  Created by 康帅 on 17/2/22.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TransitionType) {
    TransitionTypePush,
    TransitionTypePop
};

@interface KSTransition : NSObject<UIViewControllerAnimatedTransitioning>
-(instancetype)initWithTransitionType:(TransitionType)type;
@end
