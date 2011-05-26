//
//  RootViewController.m
//  Moodle
//
//  Created by jerome Mouneyrac on 17/03/11.
//  Copyright 2011 Moodle. All rights reserved.
//

#import "RootViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "MoodleStyleSheet.h"


@interface RootViewController (Private) 
- (void)connChanged:(NSNotification*)notification;
@end


@implementation RootViewController

-(void)displaySettingsView {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://sites/"] applyAnimated:YES]];
}

/**
 * Set up dashboard
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *sitesButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Sites"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(displaySettingsView)];
    self.navigationItem.rightBarButtonItem = sitesButton;
    [sitesButton release];
    
}

- (void)loadView {
    [super loadView];
    CGRect rect = [[UIScreen mainScreen] applicationFrame];

    launcherView = [[TTLauncherView alloc]
                                    initWithFrame:self.view.bounds];
    launcherView.backgroundColor = UIColorFromRGB(ColorBackground);
    launcherView.columnCount = 2;
    webLauncherItem = [[TTLauncherItem alloc] initWithTitle:NSLocalizedString(@"Web", "Web") 
                                                        image:@"bundle://ToolGuide.png"
                                                        URL:@"" canDelete: NO];
    webLauncherItem.style = @"MoodleLauncherButton:";
    launcherView.pages = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:
                                [self launcherItemWithTitle:NSLocalizedString(@"Upload", "Upload") image: @"bundle://Upload.png" URL:@"tt://upload/"],
                                [self launcherItemWithTitle:NSLocalizedString(@"Participants", "Participants") image: @"bundle://Participants.png" URL:@"tt://participants/"],
                                webLauncherItem,
                                [self launcherItemWithTitle:NSLocalizedString(@"Help", "Help") image: @"bundle://MoodleHelp.png" URL:@"http://docs.moodle.org/"],
                                nil]
                          , nil];
    launcherView.delegate = self;
    
    [self.view addSubview: launcherView];
    TTButton *button = [TTButton buttonWithStyle:@"notificationButton:" title: NSLocalizedString(@"Sync", "Sync") ];
    [button addTarget:self
               action:@selector(launchNotification:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(-5, rect.size.height-72.0, rect.size.width+10, 36.0);
    [self.view addSubview:button];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connChanged:) name:@"testnotify" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"testnotify" 
														object: @"go"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connChanged:) name:@"NetworkReachabilityChangedNotification" object:nil];
    reachability = [Reachability reachabilityWithHostName:@"http://moodle.org"];
    [reachability startNotifier];

    [webLauncherItem setURL:[[NSUserDefaults standardUserDefaults] valueForKey:kSelectedSiteUrlKey]];
    self.navigationBarTintColor = UIColorFromRGB(ColorNavigationBar);
    self.title = [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedSiteNameKey];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //if there is no site selected go to the site selection
    NSString *defaultSiteUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedSiteUrlKey];
    if (defaultSiteUrl == nil) {
        [self displaySettingsView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    settingsViewController = nil;
    launcherView = nil;
    webLauncherItem = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    // release view controllers
    [settingsViewController release];
    [launcherView release];
    [webLauncherItem release];
    [super dealloc];
}
- (void)launchNotification: (id)sender {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://notification/"] applyAnimated:YES]];        
}

#pragma mark -
#pragma mark Private methods
- (TTLauncherItem *)launcherItemWithTitle:(NSString *)pTitle image:(NSString *)image URL:(NSString *)url {
	TTLauncherItem *launcherItem = [[TTLauncherItem alloc] initWithTitle:pTitle 
																   image:image
																	 URL:url canDelete:NO];
    launcherItem.style = @"MoodleLauncherButton:";
	return [launcherItem autorelease];
}
#pragma mark -
#pragma mark TTLauncherViewDelegate methods
- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:launcherView action:@selector(endEditing)];
	self.navigationItem.leftBarButtonItem = doneButton;
	[doneButton release];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	self.navigationItem.leftBarButtonItem = nil;
}

- (void)launcherView:(TTLauncherView *)launcher didSelectItem:(TTLauncherItem *)item {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:item.URL] applyAnimated:YES]];
}

-(void)connChanged:(NSNotification*)notification
{
	NSLog(@"Changed!!!%@", [notification valueForKey:@"object"]);
}
@end