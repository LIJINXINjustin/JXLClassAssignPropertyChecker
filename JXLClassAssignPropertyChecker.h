//
//  JXLClassAssignPropertyChecker.h
//  AssignPropertyCheckDemo
//
//  Created by LeeJustin on 2018/7/10.
//  Copyright © 2018年 LI JINXIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXLClassAssignPropertyChecker : NSObject

+ (NSMutableSet<NSString*>*)doCheckAssignPropertiesAndGetResults:(NSSet<NSString*>*)classPropertiesNotInResults;

@end
