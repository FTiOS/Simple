//
//  NSObject+SPRouter.m
//  Pods
//
//  Created by 何霞雨 on 17/2/23.
//
//

#import "NSObject+SPRouter.h"
#import <objc/runtime.h>

static const void *NSObject_key_tempObject = "name";

@implementation NSObject (SPRouter)
@dynamic intent;

#pragma mark - 动态绑定
- (SPIntent *)intent {
    return objc_getAssociatedObject(self, NSObject_key_tempObject);
}

- (void)setIntent:(SPIntent *)intent {
    objc_setAssociatedObject(self, NSObject_key_tempObject, intent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
