//
//  SPUIManager.h
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import <Foundation/Foundation.h>

@interface SPUIManager : NSObject

@property (nonatomic,weak)UIViewController *topViewController;//最后展示的vc
@property (nonatomic,weak)UIViewController *rootViewController;//框架的根目录

+ (SPUIManager *)shareSPRouter;

-(void)pushViewController:(UIViewController *)controller animated: (BOOL)flag ;
-(void)presentViewController:(UIViewController *)controller animated: (BOOL)flag ;

@end
