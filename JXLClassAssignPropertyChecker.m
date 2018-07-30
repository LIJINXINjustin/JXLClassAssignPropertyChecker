//
//  JXLClassAssignPropertyChecker.m
//  AssignPropertyCheckDemo
//
//  Created by LeeJustin on 2018/7/10.
//  Copyright © 2018年 LI JINXIN. All rights reserved.
//

#import "JXLClassAssignPropertyChecker.h"
#import <objc/runtime.h>

@implementation JXLClassAssignPropertyChecker

+ (NSMutableSet<NSString*>*)doCheckAssignPropertiesAndGetResults:(NSSet<NSString*>*)classPropertiesNotInResults
{
    // Get all Classes
    int numClasses;
    Class * classes = NULL;
    
    NSMutableSet<NSString*>* foundAssignProrperties = [NSMutableSet set];
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class cls = classes[i];
            //NSLog(@"%s", class_getName(cls));
            NSBundle *bundle = nil;
            @try{
                bundle = [NSBundle bundleForClass:cls];
            }
            @catch(NSException* e)
            {
                bundle = nil;
            }
            if (bundle == nil || bundle != [NSBundle mainBundle])
            {
                // class not in app
            }
            else
            {
                // class inside app
                unsigned int outCount = 0;
                objc_property_t* propertys = class_copyPropertyList(cls, &outCount);
                for (unsigned i = 0; i < outCount; i++) {
                    objc_property_t property = propertys[i];
                    assert(property != nil);
                    const char* name = property_getName(property);
                    //NSLog(@"name: %s", name);
                    
                    NSString* attrs = @(property_getAttributes(property));
                    //NSLog(@"code: %@", attrs);
                    
                    NSArray<NSString*>* attrArr = [attrs componentsSeparatedByString:@","];
                    if ([attrArr count] > 0)
                    {
                        NSString* attr0 = attrArr[0];
                        if ([attr0 length] >=2 && [[attr0 substringToIndex:2] isEqualToString:@"T@"])
                        {
                            // It is an Object
                            BOOL isAssgin = YES;
                            for (NSInteger i = 1; i < [attrArr count]; ++i)
                            {
                                NSString* attri = attrArr[i];
                                NSString* firstStr = [attri substringToIndex:1];
                                if ([firstStr isEqualToString:@"&"] // retain
                                    || [firstStr isEqualToString:@"C"] // copy
                                    || [firstStr isEqualToString:@"W"] // weak
                                    || [firstStr isEqualToString:@"R"] // readonly
                                    || [firstStr isEqualToString:@"G"])
                                {
                                    isAssgin = NO;
                                }
                            }
                            if (isAssgin)
                            {
                                NSString* pptDescription = [NSString stringWithFormat:@"%@.%s",[cls description],name];
                                [foundAssignProrperties addObject:pptDescription];
                            }
                        }
                    }
                }
                
            }
        }
        free(classes);
    }
    
    // remove items in whitelist
    if (classPropertiesNotInResults && [classPropertiesNotInResults count] > 0)
    {
        for (NSString* item in classPropertiesNotInResults)
        {
            if ([foundAssignProrperties containsObject:item])
            {
                [foundAssignProrperties removeObject:item];
            }
        }
    }
    
    return foundAssignProrperties;
}

@end
