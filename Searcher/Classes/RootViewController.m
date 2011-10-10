//
//  RootViewController.m
//  Searcher
//
//  Created by Martin Goffan on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SearcherViewController.h"
#import "NewViewController.h"
#import "BookmarksViewController.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "Searcher.h"

@implementation RootViewController
@synthesize searchBarr;
@synthesize myTableView;

- (id)returnAll {
    return m;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSString *)miParseo:(NSString *)s {
    NSArray *q = [s componentsSeparatedByString:@"/"];
    NSArray *w = [[q objectAtIndex:q.count-1] componentsSeparatedByString:@"."];
    NSString *p = [w objectAtIndex:0];
    return p;
}


- (void)fetchImageFromArray:(NSMutableArray *)URLimages{
    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
	[networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
	[networkQueue setDelegate:self];
    ASIHTTPRequest *request;
    for (int i = 1; i <= URLimages.count; ++i) {
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[URLimages objectAtIndex:i-1]]];
        [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]]];
        [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request%d",i] forKey:@"name"]];
        [networkQueue addOperation:request];
    }
    [networkQueue go];
}

- (NSString *)generarNuevo:(NSString *)s {
    NSArray *q = [s componentsSeparatedByString:@"/"];
    NSString *e = [[NSString alloc] init];
    for (int r = 0; r < q.count - 1; ++r) {e = [e stringByAppendingString:[NSString stringWithFormat:@"%@/",[q objectAtIndex:r]]];}
    e = [e stringByAppendingString:[NSString stringWithFormat:@"%d.png",count]];
    return e;
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request {
    NSInteger i = [myTableView numberOfSections];
    NSInteger k;
    count++;
    for (int a = 0; a < i; ++a) {
        k = [myTableView numberOfRowsInSection:a];
        for (int b = 0; b < k; ++b) {
            if ([[[m objectAtIndex:a] objectAtIndex:b] image] == nil) {
                if (crib[a][b] == false) {
                    NSString *d = [self generarNuevo:[request downloadDestinationPath]];
                    [[[m objectAtIndex:a] objectAtIndex:b] setImage:[UIImage imageWithContentsOfFile:d]];
                    [myTableView reloadData];
                    crib[a][b] = true;
                    goto loop;
                }
            }
        }
    }
loop:;
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request {
//    NSLog(@"error");
    if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
        NSLog(@"%@",[request error]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to download images" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)reordenar:(NSMutableArray *)a {
    for (id e in m) {
        for (int i = 0; i < [e count]; ++i) {
            NSArray *q = [[[e objectAtIndex:i] description] componentsSeparatedByString:@"."];
            NSString *g = [NSString stringWithFormat:@"http://searcherapp.webs.com/%@.png",[q objectAtIndex:0]];
            [a addObject:g];
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([self connectedToNetwork]) {
        
        for (int q = 0; q < 5; ++q) {for (int z = 0; z < 3; ++z) {crib[q][z] = false;}}
        
        count = 0;
        
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"bookmarks"];
        if (dataRepresentingSavedArray != nil) {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                bookmarks = [[NSMutableArray alloc] initWithArray:oldSavedArray];
            else
                bookmarks = [[NSMutableArray alloc] init];
        }
        
        if (bookmarks.count == 0) searchBarr.showsBookmarkButton = NO;
        
        NSData *xmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://searcherapp.webs.com/Searchers.xml"]];
        NSError *error;
        xmlDocument = [[GDataXMLDocument alloc]initWithData:xmlData options:0 error:&error];
        
        NSArray *getData = [[xmlDocument rootElement] elementsForName:@"Searcher"];
        
        categories = [[NSMutableArray alloc] init];
        NSMutableArray *all = [[NSMutableArray alloc] init];
        NSMutableArray *fURL = [[NSMutableArray alloc] init];
        
        for (id e in getData) {
            NSString *t = [[e childAtIndex:kIndexTitle] stringValue];
            NSString *d = [[e childAtIndex:kIndexDescription] stringValue];
            NSString *c = [[e childAtIndex:kIndexCategory] stringValue];
            NSString *u = [[e childAtIndex:kIndexURL] stringValue];
            
            Searcher *searcher = [[Searcher alloc] initWithTitle:t category:c image:nil description:d url:u];
            [all addObject:searcher];
            [categories addObject:c];
        }
        
        for (int i=[categories count]-1; i>0; i--) {
            if ([categories indexOfObject: [categories objectAtIndex: i]]<i)
                [categories removeObjectAtIndex: i];
        }
        
        int i = 0;
        int k = 0;
        m = [[NSMutableArray alloc] init];
        for (id e in categories) {
            [m addObject:[[NSMutableArray alloc] init]];
            for (id t in all) {
                if ([[t category] isEqualToString:e]) {
                    [[m objectAtIndex:k] addObject:t];
                }
                ++i;
            }
            i = 0;
            k++;
        }
        
        [self reordenar:fURL];
        
        [self fetchImageFromArray:fURL];
        
        [[[self.navigationController.navigationBar items] objectAtIndex:0] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSearcher)] animated:YES];
    }
    else {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Searcher" message:@"Check your internet connection before you continue to use this app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [al show];
    }
}

- (void)viewDidUnload
{
    [self setSearchBarr:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    searchBarr.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [bookmarks addObject:searchBar.text];
    searchBarr.showsBookmarkButton = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:bookmarks] forKey:@"bookmarks"];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchBar.text forKey:@"search"];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    BookmarksViewController *bVC = [[BookmarksViewController alloc] initWithNibName:@"BookmarksViewController" bundle:nil];
    [self presentModalViewController:bVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addSearcher {
    NewViewController *n = [[NewViewController alloc] initWithNibName:@"NewViewController" bundle:nil];
    
    [self presentModalViewController:n animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[m objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [categories objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[[m objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text = [[[m objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
    cell.imageView.image = [[[m objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] image];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.tableView reloadData];
}
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    SearcherViewController *detailViewController = [[SearcherViewController alloc] initWithNibName:@"SearcherViewController_iPhone" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    NSString *sURl = [NSString stringWithFormat:@"http://%@%@",[[[m objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] urll],searchBarr.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:sURl forKey:@"sT"];
}

@end
