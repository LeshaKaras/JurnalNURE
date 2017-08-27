//
//  KAVLessonsVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAVDataManager.h"
extern NSString* const KAVViewControllerReloadDataLessonsNotification;

@interface KAVLessonsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView* tableLesson;
@property (strong,nonatomic) UITableView* tableWeakAllLesson;
@property (strong,nonatomic) IBOutlet UINavigationBar* navigationBar;

-(IBAction)actionCancel:(UIBarButtonItem*)sender;

@property (strong,nonatomic) NSArray* arrayData;
@property (strong,nonatomic) NSArray* arrayDataTableWeakAllLesson;
@property (assign, nonatomic) BOOL reloadDataTable;

+(KAVLessonsVC*) objectLessons;

@end
