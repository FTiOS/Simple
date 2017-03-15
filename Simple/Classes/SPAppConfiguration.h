//
//  SPAppConfiguration.h
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>

@interface SPAppConfiguration : NSObject

/**
 * @abstract Group or organization of your app, default value is nil.
 */
+ (NSString *)appGroup;
+ (void)setAppGroup:(NSString *) appGroup;

/**
 * @abstract Name of your app, default is value for CFBundleDisplayName in main bundle.
 */
+ (NSString *)appName;
+ (void)setAppName:(NSString *)appName;

/**
 * @abstract Version of your app, default is value for CFBundleShortVersionString in main bundle.
 */
+ (NSString *)appVersion;
+ (void)setAppVersion:(NSString *)appVersion;

/**
 * @abstract file path of your app settings, default is value for @"main.plist" in main bundle.
 */
+ (NSString *)settingsFilePath;
+ (void)setSettingsFilePath:(NSString *)filePath;

/**
 * @abstract BaseUrl of your app, default is nil.
 */
+ (NSString *)appBaseUrl;
+ (void)setAppBaseUrl:(NSString *)appBaseUrl;


/**
 * @abstract file path of your UrlMap settings, default is value for @"simple.plist" in main bundle.
 */
+ (NSString *)urlMapSettingsFilePath;
+ (void)seturlMapSettingsFilePath:(NSString *)filePath;

@end
