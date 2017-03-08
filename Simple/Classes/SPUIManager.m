//
//  SPUIManager.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPUIManager.h"

#import "SPErrorManager.h"
#import "NSObject+SPRouter.h"

@interface SPUIManager()<UINavigationControllerDelegate>
@property (nonatomic,strong)SPBaseTransition *transition;
@end

@implementation SPUIManager

+ (SPUIManager *)shareSPRouter{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public
-(void)pushViewController:(UIViewController *)controller animated: (BOOL)flag {
    if (![self prePushOrPresent:controller isPush:YES]) {
        return;
    }
    
    if (self.topViewController.navigationController) {
        if (controller.intent.transitionType==Transition_Custom) {
            self.topViewController.navigationController.delegate = self;
            self.transition = controller.intent.transition;
        }
        [self.topViewController.navigationController pushViewController:controller animated:flag];
    }else{//如果当前展示的页面没有NAVGATIONCONTROLLER的时候
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
        if (controller.intent.transitionType==Transition_Custom) {
           nav.delegate = self;
            self.transition = controller.intent.transition;
        }
        [self.topViewController presentViewController:nav animated:flag completion:nil];
    }
}

-(void)presentViewController:(UIViewController *)controller animated: (BOOL)flag {
    if (![self prePushOrPresent:controller isPush:NO]) {
        return;
    }
    
    if (controller.intent.transitionType==Transition_Custom) {
        self.transition = controller.intent.transition;
        [self.topViewController setTransitioningDelegate:self.transition];
    }
    
    [self.topViewController presentViewController:controller animated:flag completion:nil];
}

#pragma mark - Private
-(BOOL)prePushOrPresent:(UIViewController *)controller isPush:(BOOL)isPush{
    if (!controller || ![controller isKindOfClass:[UIViewController class]]) {
        NSError *error = [NSError errorWithDomain:@"com.simple.jump" code:ERROR_NO_TOJUMPVIEWCONTRLLER userInfo:nil];
        [self.rootViewController presentViewController:[SPErrorManager errorViewControllerForError:error] animated:YES completion:nil];
        return NO;
    }
    
    if (!self.topViewController) {
        NSError *error = [NSError errorWithDomain:@"com.simple.jump" code:ERROR_NO_TOPVIEWCONTRLLER userInfo:nil];
        [self.rootViewController presentViewController:[SPErrorManager errorViewControllerForError:error] animated:YES completion:nil];
        return NO;
    }
    
    if (self.topViewController.presentedViewController) {
        [self.topViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    return YES;
}

#pragma mark - Getter
-(UIViewController *)topViewController{
    if (!_topViewController) {
        _topViewController = [self topViewController];//如果viewcontroller为空的情况，才会走这里
    }
    
    return _topViewController;
}

-(UIViewController *)rootViewController{
    if (!_rootViewController) {
        _rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return _rootViewController;
}
//仅仅满足主流TABBAR 和 NAVGATION的框架
- (UIViewController *)topmostViewController
{
   
    UIViewController *rootViewContoller = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewContoller) {
        return nil;
    }
    //当前显示哪个tab页
    UIViewController *rootNavController = nil;
    if([rootViewContoller isKindOfClass:[UITabBarController class]]){
        rootNavController = [(UITabBarController*)rootViewContoller selectedViewController];
    }else if([rootViewContoller isKindOfClass:[UINavigationController class]]){
        rootNavController = (UINavigationController *)rootViewContoller;
    } else {
        rootNavController = rootViewContoller;
    }
    
    if (!rootNavController || ![rootNavController isKindOfClass:[UIViewController class]]) {
        return nil;
    }
    
    if ([rootNavController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = rootNavController;
        while ([navController isKindOfClass:[UINavigationController class]]) {
            UIViewController *topViewController = [navController topViewController];
            if ([topViewController isKindOfClass:[UINavigationController class]]) { //顶层是个导航控制器，继续循环
                navController = (UINavigationController *) topViewController;
            } else {
                //是否有弹出presentViewControllr;
                UIViewController *presentedViewController = topViewController.presentedViewController;
                while (presentedViewController) {
                    topViewController = presentedViewController;
                    if ([topViewController isKindOfClass:[UINavigationController class]]) {
                        break;
                    } else {
                        presentedViewController = topViewController.presentedViewController;
                    }
                }
                navController = (UINavigationController *) topViewController;
            }
        }
        return (UIViewController *) navController;
    }else{
        if (rootNavController.presentedViewController) {
            return rootNavController.presentedViewController;
        }
        return rootNavController;
    }
}

#pragma mark - UINavigationControllerDelegate
//用来自定义转场动画
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return self.transition;
    }else{
        return nil;
    }
}

@end
