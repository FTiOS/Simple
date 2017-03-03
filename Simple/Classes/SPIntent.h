//
//  SPIntent.h
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>

//url 参数解析对应的意图类型和跳转类型
static NSString const * TypeKey = @"type";
static NSString const * ActivityTypeKey = @"activitytype";
static NSString const * AnimationKey = @"animation";

@interface SPIntent : NSObject

//意图启动的类型，是服务还是活动
typedef NS_ENUM(NSInteger,Type) {
    Service = 0,//不需要展示页面的服务，开始异步执行服务
    Activity = 1,//需要展示页面的活动,跳转
    Model = 2,//返回URL对应的对象，不执行任何操作
};

//组件活动跳转的类型
typedef NS_ENUM(NSInteger,ActivityType) {
    Activity_Push = 0,//从左到右推送
    Activity_Present = 1,//从下到上弹出
    Activity_Other = 2,//自定义跳转动画
};

typedef BOOL(^PreCaller)(SPIntent *intent);//预先执行的回调
typedef void(^SufCaller)(SPIntent *intent,NSError *error,NSInteger resultCode);//完成意图后的回调

@property (nonatomic,assign) Type type;//意图类型
@property (nonatomic,assign) ActivityType actType;//跳转类型

@property (nonatomic,strong) NSURL *URL;//意图对应的URL
@property (nonatomic,strong) NSString *moduleName;//组件名
@property (nonatomic,strong) NSString *action;//意图的动作
@property (nonatomic,strong) NSMutableDictionary *params;//意图传递参数

@property (nonatomic,strong) CATransition *animation;//跳转动画

@property (nonatomic,copy) PreCaller preCaller;//前回调
@property (nonatomic,copy) SufCaller sufCaller;//后回调

//初始化
-(instancetype)initWithUrl:(NSString *)url;

//设置参数
-(void)setObject:(id)obj forKey:(nonnull NSString *)key;

@end
