//
//  SPService.m
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import "SPService.h"

@implementation SPService{
    BOOL isHandling;//执行中
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self onCreate];
    }
    return self;
}

-(void)startService{
    [self startService:0];
}

-(void)stopService{
    if (self.bindCount <=0 || !isHandling) {
        return;
    }
    if (self.bindCount == 1) {
        [self onDestroy];
        isHandling = NO;
    }
    [[SPServiceCenter shareedServiceCenter]unbindService:self];
    
    if (self.intent) {
        self.intent.sufCaller(self.intent,nil,0);
    }
    
    isHandling = NO;
    
}

-(void)bindService{
    [[SPServiceCenter shareedServiceCenter]bindService:self];
}

-(void)unbindService{
    if ([self onUnbind]) {
        [self stopService];
    }
}

-(void)send:(NSInteger)startId{
    [self startService:startId];
}

-(void)startService:(NSInteger)startId{
    if (self.intent && !isHandling) {
        BOOL isStart = self.intent.preCaller(self.intent);
        if (isStart) {
            [self onStart:isStart startId:startId];
            isHandling = YES;
        }else{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"服务前回调返回No"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"service.error" code:-1 userInfo:userInfo];
        }
    }else{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"服务执行错误"                                                                      forKey:NSLocalizedDescriptionKey];
        NSInteger code = -1;
        if (!self.intent) {
            code = -2;
            userInfo = [NSDictionary dictionaryWithObject:@"INTENT为空，该次调用无效"                                                                      forKey:NSLocalizedDescriptionKey];
        }
        
        if (isHandling) {
            code = -3;
            userInfo = [NSDictionary dictionaryWithObject:@"service正在执行中"                                                                      forKey:NSLocalizedDescriptionKey];
        }
        
        NSError *error = [NSError errorWithDomain:@"service.error" code:code userInfo:userInfo];
    }
}


//执行完成,调用
-(void)onStartCommand:(SPIntent *)intent finished:(BOOL)finished{
    isHandling = YES;
    if (self.intent) {
        self.intent.sufCaller(self.intent,nil,finished);
        
        if (finished) {
            [self stopService];
        }
    }
}
@end

@interface SPServiceCenter()
@property (nonatomic,strong)NSMutableDictionary *serviceMap;
@end
@implementation SPServiceCenter

static id _sharedInstance = nil;
static dispatch_once_t oncePredicate;

+ (SPServiceCenter *)shareedServiceCenter{
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(void)bindService:(SPService *)service{
    NSString *key = NSStringFromClass([service class]);
    if (key && service) {
        if ([self.serviceMap objectForKey:key]) {
            service.bindCount ++;
        }else
            [self.serviceMap setObject:service forKey:key];
    }
}
-(void)unbindService:(SPService *)service{
    NSString *key = NSStringFromClass([service class]);
    if (key && service) {
        if (service.bindCount > 1) {
            service.bindCount --;
        }else{
            [self.serviceMap removeObjectForKey:key];
            service.bindCount = 0;
        }
        
    }
}
-(NSMutableDictionary *)serviceMap{
    if (!_serviceMap) {
        _serviceMap = [NSMutableDictionary new];
    }
    return _serviceMap;
}
@end

