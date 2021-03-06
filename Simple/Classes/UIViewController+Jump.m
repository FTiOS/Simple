//
//  UIViewController+Jump.m
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import "UIViewController+Jump.h"
#import <Aspects/Aspects.h>
#import "NSObject+SPRouter.h"
#import "SPUIManager.h"

@implementation UIViewController (Jump)

+(void)load{
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1,^{
        
        //挂钩present方法，传递intent给下一个页面
        NSError *error;
        [UIViewController aspect_hookSelector:@selector(presentViewController:animated:completion:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo, UIViewController *viewControllerToPresent, BOOL animated) {
            NSObject *instance = aspectInfo.instance;
            viewControllerToPresent.intent = instance.intent;
        } error:&error];
        if (error) {
            NSLog(@"In ViewController cause error:%@",error);
        }
        
        //挂钩addChild方法，传递intent给下一个页面
        error = nil;
        [UIViewController aspect_hookSelector:@selector(addChildViewController:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo, UIViewController *childController) {
            NSObject *instance = aspectInfo.instance;
            childController.intent = instance.intent;
        } error:&error];
        if (error) {
            NSLog(@"In ViewController cause error:%@",error);
        }
        
        //挂钩viewDidAppear方法，将最近展示的控制器交给uiManager持有
        error = nil;
        [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo, BOOL animated) {
            NSObject *instance = aspectInfo.instance;
            if ([instance isKindOfClass:[UIViewController class]]) {
                [SPUIManager shareSPRouter].topViewController = (UIViewController *)instance;
            }
        } error:&error];
        if (error) {
            NSLog(@"In ViewController cause error:%@",error);
        }
        
        
    });
}


@end
