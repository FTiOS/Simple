//
//  SPRouter.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPRouter.h"

@implementation SPRouter

+ (SPRouter *)shareSPRouter{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (void)initSDKEnviroment:(void (^)(void))complection{
    
}


+ (void)openUrl:(NSString *)url{
    SPIntent *intent = [[SPIntent alloc]initWithUrl:url];
    
}
+ (void)startActivity:(SPIntent *)intent{
}
+ (void)startService:(SPIntent *)intent{
}

+ (void) startIntent:(SPIntent *)intent{
    
}

@end
