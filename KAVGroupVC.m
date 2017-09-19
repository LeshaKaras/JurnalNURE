//
//  KAVGroupVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVGroupVC.h"
#import "KAVEntityGroup+CoreDataClass.h"
#import "KAVDataManager.h"
#import "KAVGroupsAPIVC.h"
#import "KAVLessonsVC.h"

typedef enum {
    KAVActionButtonPushGroupsAPIVC,
    KAVActionButtonAddNewGroupInSelectedLesson,
} KAVStateButtonAddNewGroup;

typedef enum {
    KAVActionButtonDismissedVC,
    KAVActionButtonCloseWeakTable,
} KAVStateButtonCancel;


NSString* const KAVViewControllerGroupReloadDataNotification = @"KAVViewControllerGroupReloadDataNotification";

@interface KAVGroupVC ()

@property (assign,nonatomic) KAVStateButtonAddNewGroup stateActionButton;
@property (assign,nonatomic) KAVStateButtonCancel stateActionButtonCancel;

@end

@implementation KAVGroupVC

-(void) loadView {
    [super loadView];
    [self loadData];
}

#pragma mark - Load Data

-(void) loadData {
    
    KAVDataManager* manager = [KAVDataManager sharedManager];
    
    switch (manager.stateVC) {
        case KAVVCShowAllGroups:{
            
            self.navigationBar.topItem.title = @"ALL My groups";
            self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestALLGroups];
            
            break;}
        case KAVVCShowGroupSelectedFaculty:{
            
            KAVDataManager* object = [KAVDataManager sharedManager];
            self.arrayData = [[KAVDataManager sharedManager] makeArrayGroupFromSetSelectedFaculty:object.selectedFaculty.listGroup];
            
            self.navigationBar.topItem.title = [NSString stringWithFormat:@"%@",object.selectedFaculty.nameFacult];
            
            self.stateActionButton = KAVActionButtonPushGroupsAPIVC;
            [self createdButtonAddNewGroup];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reloadDataTableGroup:)
                                                         name:KAVViewControllerGroupReloadDataNotification
                                                       object:nil];
            break;}
        case KAVVCShowGroupSelectedLesson:{
            
            KAVDataManager* object = [KAVDataManager sharedManager];
            self.navigationBar.topItem.title = [NSString stringWithFormat:@"%@ groups:",object.selectedLesson.nameLesson];
            self.arrayData = [[KAVDataManager sharedManager] makeArrayGroupFromSetSelectedLesson:object.selectedLesson.ownerGroup];
            
            self.stateActionButton = KAVActionButtonAddNewGroupInSelectedLesson;
            [self createdButtonAddNewGroup];
            
        }
    }
}

#pragma mark - Add Notifications

-(void) setNewDataIsSet:(BOOL)newDataIsSet {
    _newDataIsSet = newDataIsSet;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAVViewControllerGroupReloadDataNotification
                                                        object:nil];
    
}
-(void) reloadDataTableGroup:(NSNotification *) notification {
    
    KAVDataManager* object = [KAVDataManager sharedManager];
    self.arrayData = [[KAVDataManager sharedManager] makeArrayGroupFromSetSelectedFaculty:object.selectedFaculty.listGroup];
    [self.tableGroup reloadData];
}


#pragma mark - Action

-(IBAction)actionCancel:(UIBarButtonItem*)sender {
    
    if (self.stateActionButtonCancel == KAVActionButtonDismissedVC){
     [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.weakTableAllGroups removeFromSuperview];
        [self loadData];
        self.stateActionButtonCancel = KAVActionButtonDismissedVC;
    }
}

- (void) actionButtonAddNewGroup:(UIButton*) sender {
    
    switch (self.stateActionButton) {
        case KAVActionButtonPushGroupsAPIVC:{
            
            KAVGroupsAPIVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"groupAPI"];
            [self presentViewController:vc animated:YES completion:nil];
            
            break;}
            
        case KAVActionButtonAddNewGroupInSelectedLesson:{
            
            [self loadDataAddGroupsToSelectedLesson];
        
            break;}
    }
    
}


-(void) loadDataAddGroupsToSelectedLesson {
    
    self.navigationBar.topItem.title = @"Selecte group to add";
    self.stateActionButtonCancel = KAVActionButtonCloseWeakTable;
    
    [self createWeakTableAllGroups];
    self.arrayDataWeakTableAllGroups = [[KAVDataManager sharedManager] executeFetchRequestALLGroups];
    [self.weakTableAllGroups reloadData];
 
}

#pragma mark - Created Button and View

-(void) createdButtonAddNewGroup {
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-90,
                                                                  CGRectGetMaxY(self.view.bounds)-90,
                                                                  80,
                                                                  80)];
    switch (self.stateActionButton) {
        case KAVActionButtonPushGroupsAPIVC:{
            
            [button setImage:[UIImage imageNamed:@"buttonGroupStateNormal.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"buttonGroupStateSelected.png"] forState:UIControlStateHighlighted];
            
            break;}
            
        case KAVActionButtonAddNewGroupInSelectedLesson:{
            
            [button setImage:[UIImage imageNamed:@"buttonAddGroupSelectedLessonStateNormal.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"buttonGroupStateSelected.png"] forState:UIControlStateHighlighted];
            
            break;}
    }
    
    [button addTarget:self action:@selector(actionButtonAddNewGroup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button aboveSubview:self.tableGroup];
}

-(void) createWeakTableAllGroups {
    CGRect frameMiniTableAllGroups = self.tableGroup.frame;
    self.weakTableAllGroups = [[UITableView alloc] initWithFrame:frameMiniTableAllGroups style:UITableViewStylePlain];
    self.weakTableAllGroups.delegate = self;
    self.weakTableAllGroups.dataSource = self;
    [self.view addSubview:self.weakTableAllGroups];
    
    //    [UIView transitionFromView:self.tableGroup
    //                        toView:self.weakTableAllGroups
    //                      duration:0.5
    //                       options:UIViewAnimationOptionTransitionFlipFromLeft
    //                    completion:^(BOOL finished) {
    //
    //                        [self.view.superview addSubview:self.weakTableAllGroups];
    //
    //                        [self.view.superview sendSubviewToBack:self.tableGroup];
    //                    }];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL state = false;
    if(tableView == self.tableGroup){
        state = YES;
    } else if (tableView == self.weakTableAllGroups){
        state = NO;
    }
    return state;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.tableGroup) {
        KAVEntityGroup* objectGroup = [self.arrayData objectAtIndex:indexPath.row];
        
        KAVDataManager* manager = [KAVDataManager sharedManager];
        switch (manager.stateVC) {
            case KAVVCShowAllGroups:{
                
                [[KAVDataManager sharedManager] deleteGroup:objectGroup];
                self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestALLGroups];
                
                break;}
            case KAVVCShowGroupSelectedFaculty:{
                
                [[KAVDataManager sharedManager] deleteGroup:objectGroup];
                KAVDataManager* object = [KAVDataManager sharedManager];
                self.arrayData = [[KAVDataManager sharedManager] makeArrayGroupFromSetSelectedFaculty:object.selectedFaculty.listGroup];
                
                break;}
            case KAVVCShowGroupSelectedLesson:{
                KAVDataManager* object = [KAVDataManager sharedManager];
                [[KAVDataManager sharedManager] deleteGroup:objectGroup InLesson:object.selectedLesson];
                self.arrayData = [[KAVDataManager sharedManager] makeArrayGroupFromSetSelectedLesson:object.selectedLesson.ownerGroup];
            }
        }
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.tableGroup){
        KAVEntityGroup* objectGroup = [self.arrayData objectAtIndex:indexPath.row];
        
        KAVDataManager* manager = [KAVDataManager sharedManager];
        switch (manager.stateVC) {
            case KAVVCShowAllGroups:{
                
                manager.selectedGroup = objectGroup;
                manager.stateLessonVC = KAVVCShowLessonsSelectedGroup;
                
                KAVLessonsVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonAll"];
                [self presentViewController:vc animated:YES completion:nil];
                
                break;}
            case KAVVCShowGroupSelectedFaculty:{
                
                manager.selectedGroup = objectGroup;
                manager.stateLessonVC = KAVVCShowLessonsSelectedGroup;
                
                KAVLessonsVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonAll"];
                [self presentViewController:vc animated:YES completion:nil];
                
                break;}
            case KAVVCShowGroupSelectedLesson:{
                
                NSLog(@"Показать студентов - KAVGroupVC");
            }
        }
    } else if (tableView == self.weakTableAllGroups){
        
        KAVEntityGroup* objectGroup = [self.arrayDataWeakTableAllGroups objectAtIndex:indexPath.row];
        KAVDataManager* manager = [KAVDataManager sharedManager];
        [[KAVDataManager sharedManager]addNewGroup:objectGroup iNLesson:manager.selectedLesson];
        
        [self loadData];
        [self.tableGroup reloadData];
        
        self.stateActionButtonCancel = KAVActionButtonDismissedVC;
        [self.weakTableAllGroups removeFromSuperview];
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count;
    if(tableView == self.tableGroup){
        count = [self.arrayData count];
    } else {
        count = [self.arrayDataWeakTableAllGroups count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* reuse = @"Reuse";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    if (tableView == self.tableGroup) {
        KAVEntityGroup* object = [self.arrayData objectAtIndex:indexPath.row];
        cell.textLabel.text = object.nameGroup;
    } else if (tableView == self.weakTableAllGroups){
        KAVEntityGroup* object = [self.arrayDataWeakTableAllGroups objectAtIndex:indexPath.row];
        cell.textLabel.text = object.nameGroup;
    }
    
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    return cell;
    
}

#pragma mark - Singleton

+(KAVGroupVC*) objectGroupUser {
    static KAVGroupVC* object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[KAVGroupVC alloc]init];
    });
    return object;
}

#pragma mark - Dealloc

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
