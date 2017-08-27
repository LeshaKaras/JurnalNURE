//
//  KAVFacultiesAPIVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

extern NSString* const KAVViewControllerSetDataNotification;

@interface KAVFacultiesAPIVC : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) Reachability* hostReachability;
@property (nonatomic) Reachability* internetReachability;

@property (strong, nonatomic) IBOutlet UITableView* tableFacultyAPI;
@property (strong, nonatomic) IBOutlet UINavigationBar* navigationBarAPI;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* indicatorLoad;

-(IBAction)actionCancel:(UIBarButtonItem*)sender;

@property (strong,nonatomic) NSArray* arrayData;
@property (assign,nonatomic) BOOL dataIsSet;

@end
