//
//  KAVFacultiesAPIVC.m
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVFacultiesAPIVC.h"
#import "KAVEntityAPIFaculties+CoreDataClass.h"
#import "KAVRequestManager.h"
#import "KAVDataManager.h"
#import "KAVFacultiesVC.h"

NSString* const KAVViewControllerSetDataNotification = @"KAVViewControllerSetDataNotification";

@interface KAVFacultiesAPIVC ()

@end

@implementation KAVFacultiesAPIVC

-(id) init {

    self = [super init];

    if (self) {
        _dataIsSet = NO;
    }
    return self;
}

-(void) loadView {
    [super loadView];
    [self loadData];
}

-(void) setDataIsSet:(BOOL)dataIsSet {
    _dataIsSet = dataIsSet;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAVViewControllerSetDataNotification
                                                        object:nil];
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
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [[KAVRequestManager sharedManager] getDataFaculty];
                    
                });
            });
            break;
        }
        case ReachableViaWiFi:{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [[KAVRequestManager sharedManager] getDataFaculty];
                    
                });
            });
            break;
        }
    }
}

#pragma mark - Action 

-(IBAction)actionCancel:(UIBarButtonItem*)sender {
    
    [[KAVDataManager sharedManager] deleteDataFacultyAPI];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load DATA

-(void) loadData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataAPISet:)
                                                 name:KAVViewControllerSetDataNotification
                                               object:nil];
    
    self.navigationBarAPI.topItem.title = @"Faculties API NURE";
    self.arrayData = [[KAVDataManager sharedManager] executeFetchRequestFacultiesAPINURE];
    
    if ([self.arrayData count] == 0) {
        [self.indicatorLoad startAnimating];
        [self accessToTheInternet];
    }
}

#pragma mark - Methods Notification

- (void) dataAPISet:(NSNotification *)notification {
    
    self.arrayData = [[KAVDataManager sharedManager]executeFetchRequestFacultiesAPINURE];
    [self.indicatorLoad stopAnimating];
    [self.tableFacultyAPI reloadData];
    
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
    
    KAVEntityAPIFaculties* object = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = object.nameFacult;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KAVEntityAPIFaculties* objectAPI = [self.arrayData objectAtIndex:indexPath.row];
    [self addNewObjectInDataUser:objectAPI];
}



#pragma mark - Methods Add New Object in Data User

- (void) addNewObjectInDataUser:(KAVEntityAPIFaculties*) objectAPI {
    
    NSArray* arrayFacultyUser = [[KAVDataManager sharedManager] executeFetchRequestFaculties];
    
    NSMutableArray* arrayNameFacultiesUser = [NSMutableArray array];
    for (KAVEntityFaculties* object in arrayFacultyUser) {
        NSString* name = object.nameFacult;
        [arrayNameFacultiesUser addObject:name];
    }
    
    if (![arrayNameFacultiesUser containsObject:objectAPI.nameFacult]){
        
        [[KAVDataManager sharedManager] addNewFacultyDataUser:objectAPI];
        
        KAVFacultiesVC* object = [KAVFacultiesVC objectFacultyUser];
        object.newDataSet = YES;
        
        [[KAVDataManager sharedManager] deleteDataFacultyAPI];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        [self showAlertWarningAddObject];
    }
    
}

-(void) showAlertWarningAddObject {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                   message:@"You have this faculty"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDestructive
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Dealloc

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
