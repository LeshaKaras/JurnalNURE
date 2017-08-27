//
//  KAVFacultiesVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString* const KAVViewControllerReloadDataNotification;


@interface KAVFacultiesVC : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView* tableFaculty;
@property (strong,nonatomic) IBOutlet UINavigationBar* navigationBar;

-(IBAction)actionCancel:(UIBarButtonItem*)sender;

@property (strong, nonatomic) NSArray* arrayData;
@property (assign, nonatomic) BOOL newDataSet;

+(KAVFacultiesVC*) objectFacultyUser;

@end
