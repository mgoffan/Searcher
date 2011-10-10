//
//  main.m
//  Searcher
//
//  Created by Martin Goffan on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearcherAppDelegate.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
//    int retVal = 0;
//    @autoreleasepool {
//        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([SearcherAppDelegate class]));
//    }
//    return retVal;
}
