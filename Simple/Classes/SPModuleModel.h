//
//  SPModuleModel.h
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import <Foundation/Foundation.h>

static NSString const * UrlKey = @"url";
static NSString const * ModuleKey = @"module";
static NSString const * VersionKey = @"version";

@interface SPModuleModel : NSObject

@property (nonatomic,strong) NSURL *url;//组件对应的URL
@property (nonatomic,assign) Class moduleClass;//组件类
@property (nonatomic,strong) NSString *version;

-(void)des:(NSDictionary *)data;

@end
