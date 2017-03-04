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

-(void)pushViewController:(UIViewController *)controller fromController:(UIViewController *)fromController{
    
}
-(void)presentViewController:(UIViewController *)controller fromController:(UIViewController *)fromController{
}
@end
