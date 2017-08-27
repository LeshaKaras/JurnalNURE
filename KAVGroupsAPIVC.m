//
//  KAVGroupsAPIVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVGroupsAPIVC.h"
#import "KAVEntityAPIGroup+CoreDataClass.h"
#import "KAVRequestManager.h"
#import "KAVDataManager.h"
#import "KAVGroupVC.h"

NSString* const KAVViewControllerReloadDataGroupNotification = @"KAVViewControllerReloadDataGroupNotification";

@interface KAVGroupsAPIVC ()
@property (strong, nonatomic) NSMutableArray* arraySelectedGroup;
@end

@implementation KAVGroupsAPIVC

-(void) loadView {
    [super loadView];
    self.arraySelectedGroup = [NSMutableArray array];
    [self loadData];
}

-(void) setDataIsSet:(BOOL)dataIsSet {
    _dataIsSet = dataIsSet;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAVViewControllerReloadDataGroupNotification
                                                        object:nil];
}

#pragma mark - Load DATA

-(void) loadData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataAPISet:)
                                                 name:KAVViewControllerReloadDataGroupNotification
                                               object:nil];
    
    self.navigationBarAPI.topItem.title = @"groups API NURE";
    self.arrayData = [[KAVDataManager sharedManager] executeFetchRequestGroupsAPINURE];
    
    if ([self.arrayData count] == 0) {
        [self.indicatorLoadData startAnimating];
        [self accessToTheInternet];
    }
}

#pragma mark - Methods Notification

- (void) dataAPISet:(NSNotification *)notification {
    
    self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestGroupsAPINURE];
    [self.indicatorLoadData stopAnimating];
    [self.tableGroupAPI reloadData];
    
}

#pragma mark - Action

-(IBAction)actionCancel:(UIBarButtonItem*)sender {
    
    [[KAVDataManager sharedManager]deleteDataGroupAPI];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionAddNewGroup:(UIButton*)sender {
    [self addNewGroupInDataUser:self.arraySelectedGroup];
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
    
    KAVEntityAPIGroup* object = [self.arrayData objectAtIndex:indexPath.row];
    
    if ([self.arraySelectedGroup containsObject:object]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = object.nameGroup;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tableGroupAPI.allowsMultipleSelection = YES;
    KAVEntityAPIGroup* objectAPI = [self.arrayData objectAtIndex:indexPath.row];
    
    KAVDataManager* object = [KAVDataManager sharedManager];
    NSArray* arrayALLGroupUser = [self createdArrayStringNameAllGroups:
                                  [[KAVDataManager sharedManager]makeArrayGroupFromSetSelectedFaculty:object.selectedFaculty.listGroup]];
    
    if ([arrayALLGroupUser containsObject:objectAPI.nameGroup]) {
        
        [self showAlertWarningAddObject];
        
    } else {
        
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.arraySelectedGroup removeObject:objectAPI];
            
        }else{
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [self.arraySelectedGroup addObject:objectAPI];
        }
    }
}


#pragma mark - Methods Add New Object in Data User


- (void) addNewGroupInDataUser:(NSArray*) arraySelectedGroups {
    
    if ([self.arraySelectedGroup count] == 0) {
        
        NSLog(@"Добавь алерт Отказа");
        
    } else {
        
        [[KAVDataManager sharedManager] addNewGroupDataUser:self.arraySelectedGroup];
        
        KAVGroupVC* object = [KAVGroupVC objectGroupUser];
        object.newDataIsSet = YES;
        
        [[KAVDataManager sharedManager] deleteDataGroupAPI];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

-(NSArray*) createdArrayStringNameAllGroups:(NSArray*) arrayObjects {
    
    NSMutableArray* arrayStringName = [NSMutableArray array];
    
    if ([[arrayObjects firstObject]isKindOfClass:[KAVEntityGroup class]]) {
    
        for (KAVEntityGroup* object in arrayObjects){
            NSString* name = object.nameGroup;
            [arrayStringName addObject:name];
        }
        
    } else {
        
        for (KAVEntityAPIGroup* object in arrayObjects){
            NSString* name = object.nameGroup;
            [arrayStringName addObject:name];
        }
        
    }
    
    return arrayStringName;
}

-(void) showAlertWarningAddObject {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                   message:@"You have this group"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDestructive
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if([searchText isEqualToString:@""]){
        self.arrayData = [[KAVDataManager sharedManager] executeFetchRequestGroupsAPINURE];
        [self.tableGroupAPI reloadData];
    } else {
        self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestSearchGroup:searchText];
        [self.tableGroupAPI reloadData];
    }
}

#pragma mark - Reachability

- (void) accessToTheInternet {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void) reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void) updateInterfaceWithReachability:(Reachability *)reachability {
    if (reachability == self.internetReachability){
        [self internetReachability:reachability];
    }
}

- (void) internetReachability:(Reachability*)reachability{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:{
            NSLog(@"Нет подкючения интернет");
            break;
        }
            
        case ReachableViaWWAN:{
            
            //self.dataIsSet = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    KAVDataManager* faculty = [KAVDataManager sharedManager];
                    [[KAVRequestManager sharedManager]getDataGroup:faculty.selectedFaculty.idFacult];
                    
                });
            });
            break;
        }
        case ReachableViaWiFi:{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    KAVDataManager* faculty = [KAVDataManager sharedManager];
                    [[KAVRequestManager sharedManager]getDataGroup:faculty.selectedFaculty.idFacult];
                    
                });
            });
            break;
        }
    }
}

#pragma mark - Dealloc

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
