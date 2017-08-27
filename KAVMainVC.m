//
//  KAVMainVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVMainVC.h"

@interface KAVMainVC ()

@end

@implementation KAVMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionFaculty:(UIButton*)sender {
   
}
-(IBAction)actionGroup:(UIButton*)sender {
   
    KAVDataManager* manager = [KAVDataManager sharedManager];
    manager.stateVC = KAVVCShowAllGroups;
    
    KAVGroupVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"groupUser"];
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(IBAction)actionStudents:(UIButton*)sender {
    
}

-(IBAction)actionLessons:(UIButton*)sender{
    
    KAVDataManager* manager = [KAVDataManager sharedManager];
    manager.stateLessonVC = KAVVCShowAllLessons;
    
    KAVLessonsVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonAll"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
