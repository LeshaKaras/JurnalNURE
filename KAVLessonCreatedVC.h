//
//  KAVLessonCreatedVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAVLessonsVC.h"

@interface KAVLessonCreatedVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong,nonatomic) IBOutlet UITableView* tableGroupsAddLesson;
@property (strong,nonatomic) IBOutlet UINavigationBar* navigationBar;
@property (strong,nonatomic) IBOutlet UITextField* textFieldNameLesson;

-(IBAction)actionCancel:(UIBarButtonItem*)sender;
-(IBAction)actionCreateLesson:(UIBarButtonItem*)sender;
-(IBAction)actionTextChanged:(UITextField*)sender;

@property (strong,nonatomic) NSArray* arrayData;

@end
