//
//  SearcherViewController.m
//  Searcher
//
//  Created by Martin Goffan on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearcherViewController.h"
#import "RootViewController.h"

@implementation SearcherViewController

@synthesize webView, loadingLabel, activityIndicator, hudImage;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadingDisplay {
    if (!webView.loading) {
        [loadingLabel removeFromSuperview];
        [activityIndicator removeFromSuperview];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingLabel removeFromSuperview];
    [activityIndicator removeFromSuperview];
    [hudImage removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
    [webView addSubview:hudImage];
    [webView addSubview:activityIndicator];
    [webView addSubview:loadingLabel];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
    loadingLabel.text = (NSString *)error;
    [webView addSubview:hudImage];
    [webView addSubview:activityIndicator];
    [webView addSubview:loadingLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    loadingLabel.text = @"Loading";
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.minimumFontSize = 24.0f;
    loadingLabel.textAlignment = UITextAlignmentCenter;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(webView.bounds.size.width / 2, webView.bounds.size.height / 2);
    loadingLabel.center = CGPointMake(webView.bounds.size.width /2, activityIndicator.center.y + 35);
    
    hudImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud.png"]];
    hudImage.center = activityIndicator.center;
    hudImage.alpha = 0.3f;
    
    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"sT"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
