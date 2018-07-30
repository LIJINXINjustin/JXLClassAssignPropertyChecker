# JXLClassAssignPropertyChecker

JXLClassAssignPropertyChecker is a tool to search **"assign"** **id** properties of Classes.
In **ARC** mode, **"assign"** **id** properties is risks for App if not in correct use. In my participated projects, too many crashes occurred like this:
```
@interface SomeClass: NSObject
@property (assign) NSString *info;
@end

//... some code

SomeClass* oneObj = [SomeClass new];
oneObj.info = [@"info " stringByAppendingString:@"blabla"];

//... some code

NSLog(@"%@",oneObj.info); // Whoops? Crashed!

```
JXLClassAssignPropertyChecker can search **"assign"** **id** properties of Classes and list them all in a NSSet, so you can revises all these **"assign"** **id** properties to make your APP robust.

## How to use
1. Drag **JXLClassAssignPropertyChecker.h** and **JXLClassAssignPropertyChecker.m** into your project.
2. Write one line code, just call **[JXLClassAssignPropertyChecker doCheckAssignPropertiesAndGetResults:]** to get list, and print it.
```
#import "JXLClassAssignPropertyChecker.h"

    // Put below code in [AppDelegate application:didFinishLaunchingWithOptions:] or main() in Debug Mode
#if defined(NDEBUG)
    NSMutableSet<NSString*>* results = [JXLClassAssignPropertyChecker doCheckAssignPropertiesAndGetResults:nil];
    // Print all "assign" id properties
    NSLog(%@,results);
#endif

```
Result will like this
```
{(
    "SomeClass.info"
)}
```

## Warning
**Remember do not use this tool in release version**, because the search function run over all the Classes including Libraries imported, it will be very very very slow. JXLClassAssignPropertyChecker is designed for developers to check their codes, but not for APP users.

##Ignore properties not in your code
All "assign" id properties of Classes including iOS/Mac Static Libraries and third party Libraries imported will be list out. Since you do not care some of them at all, you can ignore the properties you do not care by pass them through **"classPropertiesNotInResults"** parameter:
```
// Classes to test
@interface JXLTESTClass1: NSObject
@property (nonatomic, assign) NSString* str1;
@end

@interface JXLTESTClass2: NSObject
@property (nonatomic, assign) NSNumber int1;
@property (nonatomic, assign) NSNumber* num;
@end

+ (void)doCheck
{
    NSSet<NSString*>* notInteresting = [NSSet setWithObjects:@"JXLTESTClass2.num", nil];
    NSMutableSet<NSString*>* results = [JXLClassAssignPropertyChecker doCheckAssignPropertiesAndGetResults:notInteresting];
    NSLog(@"%@",results);
}
```
Results will filter out "JXLTESTClass2.num":
```
{(
    "JXLTESTClass1.str1",
    "JXLTESTClass2.int1",
)}
```

## LICENSE
MIT License

#### Hope it helpful for you.
It is my first open source in Github, may not satisfy you. Any questions and suggestions please let me know. Thank you. I am **LI JINXIN**, email: 438210981@qq.com

