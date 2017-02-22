//
//  SecondViewController.m
//  KSTransition
//
//  Created by 康帅 on 17/2/22.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "SecondViewController.h"
#import "KSTransition.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tab;
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation SecondViewController
/*
 ** 最好在这里移除代理，防止内存泄漏
 */
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.navigationController.delegate==self) {
        self.navigationController.delegate = nil; 
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    [self setupUI];
    /*
     ** 加入手势交互过渡效果
     */
    UIScreenEdgePanGestureRecognizer *pop=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popProgress:)];
    pop.edges=UIRectEdgeLeft;
    [self.view addGestureRecognizer:pop];
}
/*
 ** 加入手势交互过渡效果
 */
-(void)popProgress:(UIScreenEdgePanGestureRecognizer *)popgest{
    // 计算用户手指划了多远
    CGFloat progress=[popgest translationInView:self.view].x/(self.view.bounds.size.width*1.0);
    progress=MIN(1.0, MAX(0.0, progress));
    
    if (popgest.state==UIGestureRecognizerStateBegan) {
        // 创建过渡对象，弹出viewController
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (popgest.state==UIGestureRecognizerStateChanged){
        // 更新 interactive transition 的进度
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }else if (popgest.state==UIGestureRecognizerStateCancelled||popgest.state==UIGestureRecognizerStateEnded){// 完成或者取消过渡
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}
-(void)setupUI{
    UITableView *tableview=[[UITableView alloc]initWithFrame:self.view.bounds];
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.rowHeight=80;
    [self.view addSubview:tableview];
    self.tab=tableview;
}
#pragma UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"testID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor yellowColor];
    
    cell.textLabel.text=[NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation==UINavigationControllerOperationPush) {
        return [[KSTransition alloc]initWithTransitionType:TransitionTypePush];
    }
    return [[KSTransition alloc]initWithTransitionType:TransitionTypePop];
}
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    // 检查是否是我们的自定义过渡
    if ([animationController isKindOfClass:[SecondViewController class]]) {
        return self.interactivePopTransition;
    }else {
        return nil;
    }
}
@end
