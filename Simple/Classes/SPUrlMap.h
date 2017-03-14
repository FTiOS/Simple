//
//  SPUrlMap.h
//  Pods
//
//  所有映射关系表
//  Created by 何霞雨 on 17/3/3.
//
//

#import <Foundation/Foundation.h>
#import "SPModuleModel.h"


//映射关系来源
typedef NS_ENUM(NSInteger,ModuleSource) {
    Module_Local = 0,//本地配置
    Module_Net = 1,//网络配置
    Module_Temp = 2,//自定义代码配置
};

@interface SPUrlMap : NSMutableDictionary

@property (nonatomic,strong)NSString *netMapUrl;
@property (nonatomic,strong)NSDictionary *netMapDic;
@property (nonatomic,strong) NSMutableDictionary *localMap;//本地映射
@property (nonatomic,strong) NSMutableDictionary *netMap;//网络映射
@property (nonatomic,strong) NSMutableDictionary *tempMap;//代码临时设置映射

+(instancetype)shareMap;

//配置完成后必须调用load完成加载
-(void)loadSettings;
//加入单条数据到对应的数据关系中
-(BOOL)addSingleModuleData:(NSDictionary *)data ForType:(ModuleSource)source;
//根据组件名返回对应的组件
-(SPModuleModel *)moduleModleForKey:(NSString *)moduleName;

@end
