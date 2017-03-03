//
//  SPIntent.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPIntent.h"

#import "NSString+UrlParser.h"

@interface SPIntent ()

@property (nonatomic,copy)NSString* animationName;

@end

@implementation SPIntent

//初始化
-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.URL = [NSURL URLWithString:url];
        [self parserUrlParmas];
        [self parserUrlModule];
        [self parserUrlAction];
        [self parserUrlType];
    }
    return self;
}

-(void)setObject:(id)obj forKey:(NSString *)key{
    if (obj && key) {
        [self.params setObject:obj forKey:key];
    }
}

#pragma mark - Parse URL
//解析参数
-(void)parserUrlParmas{
    NSString *url = [self.URL absoluteString];
    if (url) {
        [self.params setDictionary:[url getURLParameters]];
    }
}

//解析组件名
-(void)parserUrlModule{
    self.moduleName = self.URL.host;
}

//解析url动作
-(void)parserUrlAction{
    if (self.URL.pathComponents) {
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:self.URL.pathComponents];
        [pathComponents removeObject:@"/"];
        self.action = [pathComponents componentsJoinedByString:@"/"];
    }
}

//解析意图类型
-(void)parserUrlType{
    id type = [self.params objectForKey:TypeKey];
    id activityType = [self.params objectForKey:ActivityTypeKey];
    
    if ([type isKindOfClass:[NSString class]] || [type isKindOfClass:[NSNumber class]]) {
        self.type = [type intValue];
    }
    if ([activityType isKindOfClass:[NSString class]] || [activityType isKindOfClass:[NSNumber class]]) {
        self.actType = [activityType intValue];
    }
}
#pragma mark - Setter and Getter

-(NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary new];
    }
    return _params;
}
@end
