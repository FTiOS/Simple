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

@interface SPModuleModel : NSObject

@property (nonatomic,strong) NSURL *URL;//组件对应的URL
@property (nonatomic,assign) Class moduleClass;//组件类

-(void)des:(NSDictionary *)data;

@end
