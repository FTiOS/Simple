//
//  SPService.h
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import <Foundation/Foundation.h>

#import "NSObject+SPRouter.h"

@protocol SPServiceDelegate;
@interface SPService : NSObject<SPServiceDelegate>

@property (nonatomic,assign)NSInteger bindCount;//绑定次数

-(void)startService;
-(void)stopService;

-(void)bindService;
-(void)unbindService;
-(void)send:(NSString *)action withParamerters:(NSDictionary *)parmas;

//执行完成,调用
-(void)onStartCommand:(SPIntent *)intent finished:(BOOL)finished;

@end

#pragma mark - 需要实现的接口
@protocol SPServiceDelegate <NSObject>

@required
//开始执行回调,需要执行的代码都在这里实现
-(void)onStart:(NSString *)action paramerters:(NSDictionary *)parmas;

@optional
//创建时的回调
-(void)onCreate;
//销毁时的回调
-(void)onDestroy;
//取消绑定是的回调
-(Boolean)onUnbind;

@end

//服务管理中心
@interface SPServiceCenter : NSObject<SPServiceDelegate>
+ (SPServiceCenter *)shareedServiceCenter;
-(void)bindService:(SPService *)service;
-(void)unbindService:(SPService *)service;
@end
