//
//  NewViewController.h
//  Searcher
//
//  Created by Martin Goffan on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface NewViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)hide:(id)sender;
- (IBAction)mailTo:(id)sender;

@end
