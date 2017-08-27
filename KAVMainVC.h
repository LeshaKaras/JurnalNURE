//
//  KAVMainVC.h
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAVRequestManager.h"
#import "KAVGroupVC.h"
#import "KAVDataManager.h"
#import "KAVLessonsVC.h"

@interface KAVMainVC : UIViewController

-(IBAction)actionFaculty:(UIButton*)sender;
-(IBAction)actionGroup:(UIButton*)sender;
-(IBAction)actionStudents:(UIButton*)sender;
-(IBAction)actionLessons:(UIButton*)sender;

@end
