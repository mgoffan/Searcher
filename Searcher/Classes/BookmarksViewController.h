//
//  BookmarksViewController.h
//  Searcher
//
//  Created by Martin Goffan on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface BookmarksViewController : UITableViewController {
    NSString *xmlfilelocation;
    GDataXMLDocument *xmlDocument;
    NSMutableArray *data_from_xml, *data;
}

@end
