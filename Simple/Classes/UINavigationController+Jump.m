//
//  UINavigationController+Jump.m
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import "UINavigationController+Jump.h"
#import <Aspects/Aspects.h>
#import "NSObject+SPRouter.h"

@implementation UINavigationController (Jump)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        //挂钩push方法，传递intent给下一个页面
        NSError *error;
        [UINavigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo, UIViewController *viewController, BOOL animated) {
            NSObject *instance = aspectInfo.instance;
            viewController.intent = instance.intent;
        } error:&error];
        if (error) {
            NSLog(@"push viewcontroller in navgation cause error:%@",error);
        }
        
        
    });
}


@end
