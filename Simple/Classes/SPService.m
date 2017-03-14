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
    SPService *service = [[SPServiceCenter shareedServiceCenter].serviceMap objectForKey:NSStringFromClass([self class])];
    if (service) {
        self = service;
    }else{
        self = [super init];
        [self onCreate];
    }
    
    if (self) {
        if (self.bindCount == 0) {
             self.bindCount = 1;
        }
    }
    return self;
}

-(void)startService{
    [self startService:self.intent.action withParamerters:self.intent.params];
}

-(void)stopService{
    if (self.bindCount <=0 || !isHandling) {
        return;
    }
    if (self.bindCount == 1) {
        [self onDestroy];
    }
    [[SPServiceCenter shareedServiceCenter]unbindService:self];
    
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

-(void)send:(NSString *)action withParamerters:(NSDictionary *)parmas{
    [self startService:action withParamerters:parmas];
}

-(void)startService:(NSString *)action withParamerters:(NSDictionary *)parmas{
    if (self.intent && !isHandling) {
        BOOL isStart = self.intent.preCaller(self.intent);
        if (isStart) {
            [self onStart:action paramerters:parmas];
            isHandling = YES;
        }else{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"服务前回调返回No"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"service.error" code:-1 userInfo:userInfo];
            
            if (self.intent) {
                self.intent.sufCaller(self.intent,error,YES);
            }
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
        
        if (self.intent) {
            self.intent.sufCaller(self.intent,error,YES);
        }
    }
}


//执行完成,调用
-(void)onFinishCommand:(BOOL)finished intent:(SPIntent *)intent{
    if (!intent) {
        intent = self.intent;
    }
    
    self.intent.sufCaller(intent,nil,finished);
    
    if (finished) {
        [self stopService];
    }
}
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

