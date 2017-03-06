//
//  SPUIManager.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPUIManager.h"

#import "SPErrorManager.h"

@implementation SPUIManager

+ (SPUIManager *)shareSPRouter{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(void)pushViewController:(UIViewController *)controller{
    if (!controller || ![controller isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    if (self.topViewController.presentedViewController) {
        [self.topViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.topViewController.navigationController) {
        [self.topViewController.navigationController pushViewController:controller animated:YES];
    }
}

-(void)presentViewController:(UIViewController *)controller{
    if (!controller || ![controller isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    if (self.topViewController.presentedViewController) {
        [self.topViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self.topViewController presentViewController:controller animated:YES completion:nil];
}

-(UIViewController *)topViewController{
    if (!_topViewController) {
        _topViewController = [self topViewController];//如果viewcontroller为空的情况，才会走这里
    }
    
    return _topViewController;
}

//仅仅满足主流TABBAR 和 NAVGATION的框架
- (UIViewController *)topmostViewController
{
    //rootViewController需要是TabBarController,排除正在显示FirstPage的情况
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

@end
