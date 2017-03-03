//
//  NSObject+SPRouter.h
//  中间件，处理所有路由的控制器
//  请在所有需要跳转的文件引入本类
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>
#import "SPIntent.h"

@interface NSObject (SPRouter)

@property (nonatomic,strong)SPIntent *intent;

@end
