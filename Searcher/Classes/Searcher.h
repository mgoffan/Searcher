//
//  Searcher.h
//  Searcher
//
//  Created by Martin Goffan on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Searcher : NSObject {
    NSString *category;
    NSString *title;
    NSString *description;
    NSString *urll;
    UIImage *image;
}

@property (nonatomic, retain, readwrite) NSString *category;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *description;
@property (nonatomic, retain, readwrite) NSString *urll;
@property (nonatomic, retain, readwrite) UIImage  *image;

- (id)initWithTitle:(NSString *)ttl category:(NSString *)cat image:(UIImage *)img description:(NSString *)desc url:(NSString *)ur;

@end
