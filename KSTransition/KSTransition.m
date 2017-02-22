//
//  KSTransition.m
//  KSTransition
//
//  Created by 康帅 on 17/2/22.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "KSTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "UIView+Extension.h"
@interface KSTransition()

@property(nonatomic,assign)TransitionType type;
@property(nonatomic,assign)CGPoint position;

@end

@implementation KSTransition
/*
 ** 构造方法
 */
-(instancetype)initWithTransitionType:(TransitionType)type{
    self=[super init];
    if (self) {
        _type=type;
    }
    return self;
}

#pragma UIViewControllerAnimatedTransitioning代理方法
/*
 ** 控制器过渡时间
 */
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
/*
 ** 过渡动画执行代码（核心）
 */
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case TransitionTypePush:
            [self push:transitionContext];
            break;
        case TransitionTypePop:
            [self pop:transitionContext];
            break;
        default:
            break;
    }
}
/*
 ** push动画
 */
-(void)push:(id<UIViewControllerContextTransitioning>)transitionContext{
    //分别拿到前一个和后一个控制器对象
    ViewController *firstVC=(ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *secondVC=(SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //拿到两个控制器的containerView
    UIView *containerView=[transitionContext containerView];
    
    //拿到后一个控制器的初始view以及尺寸
    UIView *secondV=secondVC.view;
    CGRect secondVRect=secondV.frame;
    
    //隐藏后一个控制器的子视图
    [secondV hideSubviews];
    
    //拿到前一个控制器的被点击cell的位置
    UITableViewCell *firstVCcell=[firstVC.tab cellForRowAtIndexPath:firstVC.currentIndexPath];
    CGRect selectcellframe=[[UIApplication sharedApplication].keyWindow convertRect:firstVCcell.frame fromView:firstVC.tab];
    secondV.frame=selectcellframe;
    self.position=secondV.layer.position;
    
    //将后一个视图的view加入containerView
    [containerView addSubview:secondV];
    /*
     ** 执行过渡动画
     */
    [UIView animateWithDuration:0.3 animations:^{
        firstVC.view.transform=CGAffineTransformScale(firstVC.view.transform, 0.9, 0.9);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                secondV.layer.position=self.position;
                secondV.frame=secondVRect;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [secondV showSubviews];
                    }];
                }
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    }];
}
/*
 ** pop动画
 */
-(void)pop:(id<UIViewControllerContextTransitioning>)transitionContext{
    //分别拿到前一个和后一个控制器对象
    SecondViewController *secondVC=(SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *firstVC=(ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //拿到两个控制器的containerView
    UIView *containerView=[transitionContext containerView];
    
    //拿到后一个控制器的初始view以及尺寸
    UIView *secondV=secondVC.view;
    [secondV hideSubviews];
    
    //将后一个视图的view加入containerView
    [containerView addSubview:secondV];
    [containerView addSubview:firstVC.view];
    
    [containerView bringSubviewToFront:secondV];

    //拿到前一个控制器的被点击cell的位置
    UITableViewCell *firstVCcell=[firstVC.tab cellForRowAtIndexPath:firstVC.currentIndexPath];
    CGRect selectcellframe=[[UIApplication sharedApplication].keyWindow convertRect:firstVCcell.frame fromView:firstVC.tab];
    
    /*
     ** 执行过渡动画
     */
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        secondV.frame=selectcellframe;
    } completion:^(BOOL finished) {
        secondV.alpha=0;
        if (finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                secondV.alpha=0;
                firstVC.view.transform=CGAffineTransformScale(secondVC.view.transform, 1, 1);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    }];
    
}
@end
