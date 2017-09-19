//
//  KAVLessonsVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVLessonsVC.h"
#import "KAVEntityLesson+CoreDataClass.h"
#import "KAVLessonCreatedVC.h"
#import "KAVDataManager.h"
#import "KAVGroupVC.h"

NSString* const KAVViewControllerReloadDataLessonsNotification = @"KAVViewControllerReloadDataLessonsNotification";

typedef enum {
    KAVActionButtonDismissedVC,
    KAVActionButtonCloseWeakTable,
} KAVStateButtonCancel;

@interface KAVLessonsVC ()

@property(assign, nonatomic) KAVStateButtonCancel stateActionButtonCancel;

@end

@implementation KAVLessonsVC

-(void) loadView {
    [super loadView];
    [self loadData];
    
}

#pragma mark - AddNotification

-(void)setReloadDataTable:(BOOL)reloadDataTable {
    _reloadDataTable = reloadDataTable;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAVViewControllerReloadDataLessonsNotification object:nil];
}

#pragma mark - Load Data

-(void) loadData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:KAVViewControllerReloadDataLessonsNotification
                                               object:nil];
    
    KAVDataManager* manager = [KAVDataManager sharedManager];
    switch (manager.stateLessonVC) {
        case KAVVCShowAllLessons:{
            
            self.navigationBar.topItem.title = @"My all lessons";
            [self createdButtonPushCreateLessonVC];
            manager.stateLessonCreateVC = KAVVCShowNCreateNewLesson;
            self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestAllLesson];
            
            break;}
        case KAVVCShowLessonsSelectedGroup:{
            
            self.navigationBar.topItem.title = [NSString stringWithFormat:@"%@ lessons:",manager.selectedGroup.nameGroup];
            [self createdButtonSelecteLessonToAdd];
            manager.stateLessonCreateVC = KAVVCShowNCreateNewLessonSelectedGroup;
            self.arrayData = [[KAVDataManager sharedManager]makeArrayLessonsFromSetSelectedGroup:manager.selectedGroup.listLessons];
            
            break;}
         
    }
    
}

-(void) reloadData:(NSNotification*) notification {
    
    KAVDataManager* manager = [KAVDataManager sharedManager];
    switch (manager.stateLessonVC) {
        case KAVVCShowAllLessons:{
            
            self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestAllLesson];
            [self.tableLesson reloadData];
            
            break;}
        case KAVVCShowLessonsSelectedGroup:{
            
            self.arrayData = [[KAVDataManager sharedManager]makeArrayLessonsFromSetSelectedGroup:manager.selectedGroup.listLessons];
            [self.tableLesson reloadData];
            
            break;}
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count;
    if (tableView == self.tableLesson) {
        count = [self.arrayData count];
    } else {
        count = [self.arrayDataTableWeakAllLesson count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* reuse = @"Reuse";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    if (tableView == self.tableLesson) {
        
        KAVEntityLesson* object = [self.arrayData objectAtIndex:indexPath.row];
        cell.textLabel.text = object.nameLesson;
        
    } else {
        
        KAVEntityLesson* object = [self.arrayDataTableWeakAllLesson objectAtIndex:indexPath.row];
        cell.textLabel.text = object.nameLesson;
        
    }
    
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BOOL state = false;
    if(tableView == self.tableLesson){
        state = YES;
    } else if (tableView == self.tableWeakAllLesson){
        state = NO;
    }
    return state;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableLesson) {
        KAVEntityLesson* objectLesson = [self.arrayData objectAtIndex:indexPath.row];
        
        KAVDataManager* manager = [KAVDataManager sharedManager];
        switch (manager.stateLessonVC) {
            case KAVVCShowAllLessons:{
                
                [[KAVDataManager sharedManager] deleteLesson:objectLesson];
                self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestAllLesson];
                break;}
            case KAVVCShowLessonsSelectedGroup:{
                
                [[KAVDataManager sharedManager] deleteLesson:objectLesson selectedGroup:manager.selectedGroup];
                self.arrayData = [[KAVDataManager sharedManager]makeArrayLessonsFromSetSelectedGroup:manager.selectedGroup.listLessons];
                
                break;}
        }
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableLesson) {
        
        KAVDataManager* manager = [KAVDataManager sharedManager];
        switch (manager.stateLessonVC) {
            case KAVVCShowAllLessons:{
                
                KAVEntityLesson* lesson = [self.arrayData objectAtIndex:indexPath.row];
                manager.selectedLesson = lesson;
                manager.stateVC = KAVVCShowGroupSelectedLesson;
                
                KAVGroupVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"groupUser"];
                [self presentViewController:vc animated:YES completion:nil];
                
                break;}
                
            case KAVVCShowLessonsSelectedGroup:{
                
                NSLog(@"Показать студентов - KAVLessonsVC");
                
                break;}
        }
    } else {
        
        KAVEntityLesson* objectLesson = [self.arrayDataTableWeakAllLesson objectAtIndex:indexPath.row];
        KAVDataManager* manager = [KAVDataManager sharedManager];
        [[KAVDataManager sharedManager] addNewLesson:objectLesson iNGroup:manager.selectedGroup];
        
        [self loadData];
        [self.tableLesson reloadData];
        
        self.stateActionButtonCancel = KAVActionButtonDismissedVC;
        [self.tableWeakAllLesson removeFromSuperview];
        
    }
}

#pragma mark - Actions

-(IBAction)actionCancel:(UIBarButtonItem*)sender {
    
    if (self.stateActionButtonCancel == KAVActionButtonDismissedVC){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.tableWeakAllLesson removeFromSuperview];
        [self loadData];
        self.stateActionButtonCancel = KAVActionButtonDismissedVC;
    }
    
}

- (void) actionButtonAddNewLesson:(UIButton*) sender {
    
    KAVLessonCreatedVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonCreated"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) actionButtonSelecteLessonToAdd:(UIButton*) sender {
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Add new lesson"
                                message:@"what do you whant do?"
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* createNewLesson = [UIAlertAction
                                      actionWithTitle:@"Create new lesson"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * _Nonnull action) {
                                          
        KAVLessonCreatedVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonCreated"];
        [self presentViewController:vc animated:YES completion:nil];
                                          
    }];
    
    UIAlertAction* showLishAllLessons = [UIAlertAction
                                      actionWithTitle:@"Show all lessons created"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * _Nonnull action) {
                                          
                                          self.navigationBar.topItem.title = @"Selecte lesson to add";
                                          
                                          [self createWeakTableAllLessons];
                                          self.arrayDataTableWeakAllLesson = [[KAVDataManager sharedManager]executeFetchRequestAllLesson];
                                          
                                      }];
    
    UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             
                                             [alert removeFromParentViewController];
                                             
                                         }];
    
    [alert addAction:createNewLesson];
    [alert addAction:showLishAllLessons];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Created Button and View

-(void) createWeakTableAllLessons {
    
    CGRect frameMiniTableAllGroups = self.tableLesson.frame;
    self.tableWeakAllLesson = [[UITableView alloc] initWithFrame:frameMiniTableAllGroups style:UITableViewStylePlain];
    self.tableWeakAllLesson.delegate = self;
    self.tableWeakAllLesson.dataSource = self;
    
    self.stateActionButtonCancel = KAVActionButtonCloseWeakTable;
    [self.view addSubview:self.tableWeakAllLesson];
    
}


-(void) createdButtonPushCreateLessonVC {
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-90,
                                                                  CGRectGetMaxY(self.view.bounds)-90,
                                                                  80,
                                                                  80)];
    
    [button setImage:[UIImage imageNamed:@"buttonLessonStateNormal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"buttonLessonStateSelected.png"] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(actionButtonAddNewLesson:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button aboveSubview:self.tableLesson];
}

-(void) createdButtonSelecteLessonToAdd {
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-90,
                                                                  CGRectGetMaxY(self.view.bounds)-90,
                                                                  80,
                                                                  80)];
    
    [button setImage:[UIImage imageNamed:@"buttonAddLessonSelectedGroupStateNormal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"buttonLessonStateSelected.png"] forState:UIControlStateHighlighted];
    
    
    [button addTarget:self action:@selector(actionButtonSelecteLessonToAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button aboveSubview:self.tableLesson];
}

#pragma mark - Singleton

+(KAVLessonsVC*) objectLessons {
    static KAVLessonsVC* object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[KAVLessonsVC alloc]init];
    });
    return object;
}

@end
