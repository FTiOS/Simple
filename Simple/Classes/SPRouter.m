//
//  SPRouter.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPRouter.h"

#import "SPUrlMap.h"
#import "SPModule.h"

#import "SPService.h"
#import "SPViewController.h"

@interface SPRouter ()

@property (nonatomic,strong)SPUrlMap *urlMap;//组件URL映射表

@end


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

+ (void)start:(SPIntent *)intent{
    SPModuleModel *model = [[SPRouter shareSPRouter].urlMap moduleModleForKey:intent.URL.absoluteString];
    if (model.moduleClass) {
        id module = [[model.moduleClass alloc]init];
        if ([module isKindOfClass:[SPModule class]]) {
            SPModule *spModule = (SPModule *)module;
            switch (intent.type) {
                case Service:{
                    UIViewController *viewc = [spModule serviceRunWithIntent:intent];
                }
                    break;
                case Activity:{
                    SPService *service = [spModule activityHanldeWithIntent:intent];
                }
                    break;
                default:{
                    
                }
                    break;
            }
        }
    }
}

- (SPUrlMap *)urlMap{
    if (!_urlMap) {
        _urlMap = [SPUrlMap shareMap];
    }
    return _urlMap;
}

@end
