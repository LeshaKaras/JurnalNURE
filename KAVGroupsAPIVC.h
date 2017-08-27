//
//  KAVGroupsAPIVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

extern NSString* const KAVViewControllerReloadDataGroupNotification;

@interface KAVGroupsAPIVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic) Reachability* hostReachability;
@property (nonatomic) Reachability* internetReachability;

@property (strong, nonatomic) IBOutlet UITableView* tableGroupAPI;
@property (strong, nonatomic) IBOutlet UINavigationBar* navigationBarAPI;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* indicatorLoadData;
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (strong, nonatomic) IBOutlet UIButton* buttonAddGroup;

-(IBAction)actionCancel:(UIBarButtonItem*)sender;
-(IBAction)actionAddNewGroup:(UIButton*)sender;

@property (strong,nonatomic) NSArray* arrayData;
@property (assign,nonatomic) BOOL dataIsSet;

@end
