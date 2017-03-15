//
//  SPRouter.h
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>

#import "SPIntent.h"

@interface SPRouter : NSObject

/**
 * @abstract Initializes router
 * @discussion set the default settings
 *
 **/
+ (void)initSDKEnviromentWithComplection:(void (^)(void))complection;

/**
 * 配置组件
 * @param filePath router
 * @param serverUrl the default settings
 * @param params the default settings
 **/
+ (void)startLoadUrlMapSettingsWithFilePath:(NSString *)filePath ServerUrl:(NSString *)serverUrl Params:(NSDictionary *)params;

+ (UIViewController *)start:(SPIntent *)intent;
+ (void)finish:(SPIntent *)intent;

@end
