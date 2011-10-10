//
//  Searcher.m
//  Searcher
//
//  Created by Martin Goffan on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Searcher.h"

@implementation Searcher

@synthesize title, description, image, category, urll;

- (id)init
{
    self = [super init];
    if (self) {
        title = [[NSString alloc] init];
        description = [[NSString alloc] init];
        image = [[UIImage alloc] init];
        category = [[NSString alloc] init];
        urll = [[NSString alloc] init];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)ttl category:(NSString *)cat image:(UIImage *)img description:(NSString *)desc url:(NSString *)ur {
    if (self = [super init]) {
        self.title = ttl;
        self.category = cat;
        self.image = img;
        self.description = desc;
        self.urll = ur;
    }
    return self;
}

@end
