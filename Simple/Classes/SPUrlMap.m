//
//  SPUrlMap.m
//  Pods
//
//  Created by 何霞雨 on 17/3/3.
//
//

#import "SPUrlMap.h"
#import "AFNetworking.h"
#import "FMDatabase.h"

static NSString const *DataBaseName = @"SpUrlModule.sqlite";
static NSString const *TableName = @"t_url_module";
static NSString const *ColumnUrl = @"url";
static NSString const *ColumnModuleClass = @"module";
static NSString const *ColumnVersion = @"version";

@implementation SPUrlMap

+(instancetype)shareMap{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public

//配置完成后必须调用load完成加载
-(void)loadSettings{
	[self loadLocalSettings];
	[self loadCacheSettings];
	
	__weak typeof(self) weakSelf = self;
	
	[self loadNetSettingsWithComplete:^(SPUrlMap *map) {
		
		[weakSelf updateCacheMap];
		
		for (SPModuleModel *model in weakSelf.localMap) {
			[[SPUrlMap shareMap] setObject:model.moduleClass forKey:model.url];
		}
		for (SPModuleModel *model in weakSelf.tempMap) {
			[[SPUrlMap shareMap] setObject:model.moduleClass forKey:model.url];
		}
		for (SPModuleModel *model in weakSelf.netMap) {
			[[SPUrlMap shareMap] setObject:model.moduleClass forKey:model.url];
		}
		
	} error:^(NSError *error) {
		NSLog(@"Load netsettings failed!");
	}];
}

//从plist文件或去本地配置
-(void)loadLocalSettings{
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
	for (NSString *str in [dic allKeys]) {
		[self.localMap setObject:[dic objectForKey:str] forKey:str];
	}
}

//获取缓存的网络配置
-(void)loadCacheSettings{
	FMDatabase *db = [self dataBase];
	if (db && [db open]) {
		NSString *selectStr = [NSString stringWithFormat:@"select *from %@ order by version asc;",TableName];
		FMResultSet *resultSet = [db executeQuery:selectStr];
		while ([resultSet next]) {
			NSString *url = [resultSet stringForColumn:ColumnUrl];
			NSString *moduleClass = [resultSet stringForColumn:ColumnModuleClass];
			NSString *version = [resultSet stringForColumn:ColumnVersion];
			[self.netMap setObject:moduleClass forKey:url];
		}
	}
}

//请求接口获取网络配置
-(void)loadNetSettingsWithComplete:(void(^)(SPUrlMap *map))completeBlock error:(void(^)(NSError *error))errorBlock{
	AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
	manager.requestSerializer = [AFHTTPResponseSerializer serializer];
	[manager GET:self.serverUrl parameters:self.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"Get netMap succeed!");
		for (NSDictionary *dic in [responseObject objectForKey:@"result"]) {
			SPModuleModel *module = [[SPModuleModel alloc]init];
			[module des:dic];
			[self.netMap setObject:module.moduleClass forKey:module.url];
		}
		completeBlock(self.netMap);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"Get netMap failed!");
		errorBlock(error);
	}];
}

//更新cache的网络配置
-(void)updateCacheMap{
	FMDatabase *db = [self dataBase];
	if (db && [db open]) {
		for (SPModuleModel *model in self.netMap) {
			FMResultSet *resultSet = [db executeQuery:@"select * from %@ where %@=%@;",TableName,ColumnUrl,model.url];
			if (resultSet.columnCount > 0) {
				[db executeUpdate:@"update %@ set %@=%@ ,%@=%@ where %@=%@;",TableName,ColumnModuleClass,model.moduleClass,ColumnVersion,model.version,ColumnUrl,model.url];
			}else {
				[db executeUpdate:@"insert into %@(%@,%@,%@) values(%@,%@,%@);",TableName,ColumnUrl,ColumnModuleClass,ColumnVersion,model.url,model.moduleClass,model.version];
			}
		}
	}
}

-(BOOL)addSingleModuleData:(NSDictionary *)data ForType:(ModuleSource)source{
    SPModuleModel *model = [SPModuleModel new];
    [model des:data];
	
	[[SPUrlMap shareMap] setObject:model.moduleClass forKey:model.url];
	
	switch (source) {
        case Module_Net:{
			[self.netMap setObject:model.moduleClass forKey:model.url];
			[self updateCacheMap];
        }
            break;
        case Module_Local:{
			[self.localMap setObject:model.moduleClass forKey:model.url];
        }
            break;
        default:{
			[self.tempMap setObject:model.moduleClass forKey:model.url];
        }
            break;
    }
}

-(SPModuleModel *)moduleModleForKey:(NSString *)moduleName{
    if ([moduleName length] <= 0) {
        return nil;
    }
    return [[SPUrlMap shareMap] objectForKey:moduleName];
}

#pragma mark - Getter

-(NSMutableDictionary *)localMap{
    if (!_localMap) {
        _localMap = [NSMutableDictionary new];
    }
    return _localMap;
}
-(NSMutableDictionary *)netMap{
    if (!_netMap) {
        _netMap = [NSMutableDictionary new];
    }
    return _netMap;
}
-(NSMutableDictionary *)tempMap{
    if (!_tempMap) {
        _tempMap = [NSMutableDictionary new];
    }
    return _tempMap;
}

-(FMDatabase *)dataBase{
	NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString *fileName = [doc stringByAppendingPathComponent:DataBaseName];
	FMDatabase *db = [FMDatabase databaseWithPath:fileName];
	if ([db open]) {
		NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer PRIMARY KEY AUTOINCREMENT,%@ text NOT NULL,%@ text NOT NULL,%@ text);",TableName,ColumnUrl,ColumnModuleClass,ColumnVersion];
		BOOL result = [db executeUpdate:createTable];
		if (result) {
			return db;
		}
	}
	return nil;
}

@end
