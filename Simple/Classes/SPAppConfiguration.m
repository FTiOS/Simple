//
//  SPAppConfiguration.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "SPAppConfiguration.h"

@interface SPAppConfiguration ()

@property (nonatomic, strong) NSString * appGroup;
@property (nonatomic, strong) NSString * appName;
@property (nonatomic, strong) NSString * appVersion;
@property (nonatomic, strong) NSString * settingPath;
@property (nonatomic, strong) NSString * appBaseUrl;
@property (nonatomic, strong) NSString * urlMapSettingsFilePath;

@end

@implementation SPAppConfiguration

+ (instancetype)sharedConfiguration
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (NSString *)appGroup
{
    return [SPAppConfiguration sharedConfiguration].appGroup;
}

+ (void)setAppGroup:(NSString *)appGroup
{
    [SPAppConfiguration sharedConfiguration].appGroup = appGroup;
}

+ (NSString *)appName
{
    return [SPAppConfiguration sharedConfiguration].appName ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (void)setAppName:(NSString *)appName
{
    [SPAppConfiguration sharedConfiguration].appName = appName;
}

+ (NSString *)appVersion
{
    return [SPAppConfiguration sharedConfiguration].appVersion ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (void)setAppVersion:(NSString *)appVersion
{
    [SPAppConfiguration sharedConfiguration].appVersion = appVersion;
}

+ (NSString *)settingsFilePath
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    return [SPAppConfiguration sharedConfiguration].settingPath ?: filePath;
}

+ (void)setSettingsFilePath:(NSString *)filePath
{
    [SPAppConfiguration sharedConfiguration].settingPath = filePath;
}

+ (NSString *)appBaseUrl
{
	return [SPAppConfiguration sharedConfiguration].appBaseUrl;
}

+ (void)setAppBaseUrl:(NSString *)appBaseUrl
{
	[SPAppConfiguration sharedConfiguration].appBaseUrl = appBaseUrl;
}

+ (NSString *)urlMapSettingsFilePath
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"simple" ofType:@"plist"];
	return [SPAppConfiguration sharedConfiguration].urlMapSettingsFilePath ?: filePath;
}

+ (void)seturlMapSettingsFilePath:(NSString *)filePath
{
	[SPAppConfiguration sharedConfiguration].urlMapSettingsFilePath = filePath;
}

@end
