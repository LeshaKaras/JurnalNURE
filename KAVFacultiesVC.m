//
//  KAVFacultiesVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVFacultiesVC.h"
#import "KAVDataManager.h"
#import "KAVRequestManager.h"
#import "KAVEntityFaculties+CoreDataClass.h"
#import "KAVFacultiesAPIVC.h"
#import "KAVGroupVC.h"

NSString* const KAVViewControllerReloadDataNotification = @"KAVViewControllerReloadDataNotification";

@interface KAVFacultiesVC ()

@end

@implementation KAVFacultiesVC

-(void) loadView {
    [super loadView];
    [self loadData];
}

#pragma mark - Load Data VC

-(void) loadData {
    
    self.navigationBar.topItem.title = @"My faculties";
    
    [self createdButtonAddNewFaculty];
    self.arrayData = [[KAVDataManager sharedManager] executeFetchRequestFaculties];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDataTable:)
                                                 name:KAVViewControllerReloadDataNotification
                                               object:nil];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* reuse = @"Reuse";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    KAVEntityFaculties* object = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = object.nameFacult;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KAVEntityFaculties* object = [self.arrayData objectAtIndex:indexPath.row];
    
    [[KAVDataManager sharedManager] deleteFaculty:object];
    
    self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestFaculties];
    
    [tableView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KAVEntityFaculties* faculty = [self.arrayData objectAtIndex:indexPath.row];
    
    KAVDataManager* manager = [KAVDataManager sharedManager];
    manager.selectedFaculty = faculty;
    manager.stateVC = KAVVCShowGroupSelectedFaculty;
    
    KAVGroupVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"groupUser"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - Actions

-(IBAction)actionCancel:(UIBarButtonItem*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionButtonAddNewFaculty:(UIButton*) sender {
    self.newDataSet = NO;
    
    KAVFacultiesAPIVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"facultyAPI"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Created Button and View

-(void) createdButtonAddNewFaculty {
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-90,
                                                                CGRectGetMaxY(self.view.bounds)-90,
                                                                80,
                                                                80)];
    
    [button setImage:[UIImage imageNamed:@"buttonFacultyStateNormal.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"buttonFacultyStateSelected.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"buttonFacultyStateSelected.png"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(actionButtonAddNewFaculty:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button aboveSubview:self.tableFaculty];
}

#pragma mark - Singleton

+(KAVFacultiesVC*) objectFacultyUser {
    static KAVFacultiesVC* object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[KAVFacultiesVC alloc]init];
    });
    return object;
}

#pragma mark - Add Notifications

-(void)setNewDataSet:(BOOL)newDataSet {
    _newDataSet = newDataSet;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAVViewControllerReloadDataNotification object:nil];
}


-(void) reloadDataTable:(NSNotification *) notification {
    
    self.arrayData = [[KAVDataManager sharedManager] executeFetchRequestFaculties];
    [self.tableFaculty reloadData];
}

#pragma mark - Dealloc

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



@end
