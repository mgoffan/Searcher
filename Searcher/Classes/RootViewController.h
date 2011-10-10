//
//  RootViewController.h
//  Searcher
//
//  Created by Martin Goffan on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "GDataXMLNode.h"

enum {
    kIndexTitle,
    kIndexDescription,
    kIndexCategory,
    kIndexImage,
    kIndexURL
}kIndexes;

@class ASINetworkQueue;

@interface RootViewController : UIViewController <UISearchBarDelegate> {
    ASINetworkQueue *networkQueue;
    
    GDataXMLDocument *xmlDocument;
    NSString *xmlFileLocation;
    NSMutableArray *data_from_xml;
    
    NSMutableArray *categories, *m;
    
    UISearchBar *searchBarr;
    UITableView *myTableView;
    
    NSURLConnection *connection;
    NSMutableData *mData;
    
    bool crib[5][3];
    
    NSMutableArray *bookmarks;
    
    NSInteger count;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchBarr;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;

- (id)returnAll;

@end
