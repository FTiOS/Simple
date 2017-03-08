//
//  SPBaseTransition.h
//  Pods
//
//  Created by 何霞雨 on 17/3/8.
//
//

#import <UIKit/UIKit.h>

@interface SPBaseTransition : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite, assign, getter = isPresenting) BOOL presenting;

@end
