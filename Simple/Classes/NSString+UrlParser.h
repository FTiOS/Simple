//
//  NSString+UrlParser.h
//  Pods
//
//  Created by 何霞雨 on 17/3/2.
//
//

#import <Foundation/Foundation.h>

@interface NSString (UrlParser)

//截取URL中的参数
- (NSMutableDictionary *)getURLParameters;

@end
