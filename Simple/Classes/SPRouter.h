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

+ (void)openUrl:(NSString *)url;
+ (void)startActivity:(SPIntent *)intent;
+ (void)startService:(SPIntent *)intent;


@end
