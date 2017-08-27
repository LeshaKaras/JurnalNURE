//
//  KAVGroupVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const KAVViewControllerGroupReloadDataNotification;


@interface KAVGroupVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView* tableGroup;
@property (strong,nonatomic) UITableView* weakTableAllGroups;
@property (strong,nonatomic) IBOutlet UINavigationBar* navigationBar;
@property (strong,nonatomic) IBOutlet UIBarButtonItem* cancel;

-(IBAction)actionCancel:(UIBarButtonItem*)sender;
+(KAVGroupVC*) objectGroupUser;


@property (strong,nonatomic) NSArray* arrayData;
@property (strong,nonatomic) NSArray* arrayDataWeakTableAllGroups;

@property (assign, nonatomic) BOOL newDataIsSet;

@end
