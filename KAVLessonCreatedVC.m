//
//  KAVLessonCreatedVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVLessonCreatedVC.h"
#import "KAVEntityGroup+CoreDataClass.h"
#import "KAVDataManager.h"

@interface KAVLessonCreatedVC ()

@property (strong, nonatomic) NSMutableArray* arraySelectedGroupCreateLesson;
@property (strong, nonatomic) NSString* nameLesson;

@end

@implementation KAVLessonCreatedVC

-(void) loadView {
    [super loadView];
    [self loadData];
}

#pragma mark - Load Data

-(void) loadData {
    
    KAVDataManager* manager = [KAVDataManager sharedManager];
    self.arraySelectedGroupCreateLesson = [NSMutableArray array];
    
    switch (manager.stateLessonCreateVC) {
        case KAVVCShowNCreateNewLesson:{
            
            self.navigationBar.topItem.title = @"Create lesson";
            self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestALLGroups];
            
            break;}
            
        case KAVVCShowNCreateNewLessonSelectedGroup:{
            
            self.navigationBar.topItem.title = [NSString stringWithFormat:@"Create lesson from:%@",manager.selectedGroup.nameGroup];
            
            [self.arraySelectedGroupCreateLesson addObject:manager.selectedGroup];
            self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestALLGroups];
            
            break;}
    }
    
}

#pragma mark - UITextFieldDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* reuse = @"Reuse";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    KAVEntityGroup* object = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = object.nameGroup;
    
    if ([self.arraySelectedGroupCreateLesson containsObject:object]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tableGroupsAddLesson.allowsMultipleSelection = YES;
    KAVEntityGroup* object = [self.arrayData objectAtIndex:indexPath.row];
    
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.arraySelectedGroupCreateLesson removeObject:object];
            
        }else{
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [self.arraySelectedGroupCreateLesson addObject:object];

        }
}

#pragma mark - UITextFieldDelegate



#pragma mark - Actions

-(IBAction)actionCancel:(UIBarButtonItem*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionCreateLesson:(UIBarButtonItem*)sender{
    
    if ([self.arraySelectedGroupCreateLesson count] == 0 || self.nameLesson.length == 0){
        if ([self.arraySelectedGroupCreateLesson count] == 0){
            NSLog(@"Выбери группу");
        }
        if (self.nameLesson.length == 0){
            NSLog(@"ВВеди название урока");
        }
        
    } else{
        
        [[KAVDataManager sharedManager] addNewLesson:self.nameLesson fromArrayGropups:self.arraySelectedGroupCreateLesson];
        KAVLessonsVC* obj = [KAVLessonsVC objectLessons];
        obj.reloadDataTable = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

-(IBAction)actionTextChanged:(UITextField*)sender {
    self.nameLesson = sender.text;
}



@end
