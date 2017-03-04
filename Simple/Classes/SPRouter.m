//
//  SPRouter.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPRouter.h"

#import "SPUrlMap.h"
#import "SPUIManager.h"

#import "SPModule.h"
#import "SPService.h"

#import "NSObject+SPRouter.h"

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
            spModule.intent = intent;
            switch (intent.type) {
                case Service:{
                    SPService *service = [spModule serviceRunWithIntent:intent];
                    service.intent = intent;
                }
                    break;
                case Activity:{
                    UIViewController *activity = [spModule activityHanldeWithIntent:intent];
                    activity.intent = intent;
                    switch (intent.actType) {
                            case Activity_Push:{
                                [[SPUIManager shareSPRouter]pushViewController:activity];
                            }
                            break;
                            case Activity_Present:{
                                [[SPUIManager shareSPRouter]presentViewController:activity];
                            }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                    break;
                default:{
                    
                }
                    break;
            }
        }
    }
}

+(void)finish:(SPIntent *)intent{
    
}

- (SPUrlMap *)urlMap{
    if (!_urlMap) {
        _urlMap = [SPUrlMap shareMap];
    }
    return _urlMap;
}

@end
