//
//  SPModuleModel.m
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import "SPModuleModel.h"
#import "SPModule.h"

@implementation SPModuleModel

-(void)des:(NSDictionary *)data{
    NSString *url = [data objectForKey:UrlKey];
    NSString *moduleName = [data objectForKey:ModuleKey];
}

@end
