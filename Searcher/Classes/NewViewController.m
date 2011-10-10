//
//  NewViewController.m
//  Searcher
//
//  Created by Martin Goffan on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewViewController.h"
#import "RootViewController.h"
#import "GDataXMLNode.h"

@implementation NewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)hide:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)mailTo:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setCcRecipients:[[NSArray alloc] initWithObjects:@"martingof12@gmail.com",nil]];
        [mailViewController setSubject:@"New search engine"];
        [mailViewController setMessageBody:@"I'd like a search engine for: " isHTML:NO];
        
        [self presentModalViewController:mailViewController animated:YES];
        
    }
    
    else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end