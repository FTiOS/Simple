//
//  SPModule.h
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>

#import "SPService.h"
#import "SPIntent.h"

@interface SPModule : NSObject

-(UIViewController *)activityHanldeWithIntent:(SPIntent *)intent;
-(SPService *)serviceRunWithIntent:(SPIntent *)intent;

@end
