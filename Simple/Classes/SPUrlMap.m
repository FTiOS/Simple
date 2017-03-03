//
//  SPUrlMap.m
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import "SPUrlMap.h"

@implementation SPUrlMap

+(instancetype)shareMap{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public

//配置完成后必须调用load完成加载
-(void)loadSettings{
}

-(BOOL)addSingleModuleData:(NSDictionary *)data ForType:(ModuleSource)source{
    SPModuleModel *model = [SPModuleModel new];
    [model des:data];

    switch (source) {
        case Module_Net:{
            
        }
            break;
        case Module_Local:{
            
        }
            break;
        default:{
            
        }
            break;
    }
}

-(SPModuleModel *)moduleModleForKey:(NSString *)moduleName{
    if ([moduleName length]<=0) {
        return nil;
    }
    return [[SPUrlMap shareMap]objectForKey:moduleName];
}

#pragma mark - Getter

-(NSMutableDictionary *)localMap{
    if (!_localMap) {
        _localMap = [NSMutableDictionary new];
    }
    return _localMap;
}
-(NSMutableDictionary *)netMap{
    if (!_netMap) {
        _netMap = [NSMutableDictionary new];
    }
    return _netMap;
}
-(NSMutableDictionary *)tempMap{
    if (!_tempMap) {
        _tempMap = [NSMutableDictionary new];
    }
    return _tempMap;
}

@end
