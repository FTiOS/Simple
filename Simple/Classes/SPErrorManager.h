//
//  SPErrorManager.h
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>

static NSInteger const ERROR_NO_TOPVIEWCONTRLLER = -1;//没有找到从哪儿跳转
static NSInteger const ERROR_NO_TOJUMPVIEWCONTRLLER = -2;//没有找到跳转到哪儿

@interface SPErrorManager : NSObject
+(UIViewController *)errorViewControllerForError:(NSError *)error;
@end
