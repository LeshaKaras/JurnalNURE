//
//  KAVDataManager.m
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVDataManager.h"

@implementation KAVDataManager

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JurnalNURE"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

+(KAVDataManager*) sharedManager {
    static KAVDataManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KAVDataManager alloc]init];
    });
    return manager;
}

-(void) loadDataFacultyAPI:(id) response {
    
    NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:response
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    
    for (NSDictionary* responseDictionary in [parsedData objectForKey:@"faculties"]) {
        
        NSString* nameFaculty = [responseDictionary valueForKey:@"faculty_name"];
        NSString* idFaculty = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"faculty_id"]];
        
        KAVEntityAPIFaculties* obj = [NSEntityDescription insertNewObjectForEntityForName:@"KAVEntityAPIFaculties"
                                                                inManagedObjectContext:self.persistentContainer.viewContext];
        obj.nameFacult = nameFaculty;
        obj.idFacult = idFaculty;
    }
    
    [self saveContext];
}

-(void) loadDataGroupAPI:(id) response {
    
    NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:response
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    for (NSDictionary* responseDictionary in [parsedData objectForKey:@"groups"]) {
        
        NSString* nameGroup = [responseDictionary valueForKey:@"group_name"];
        NSString* idGroup = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"group_id"]];
        
        KAVEntityAPIGroup* object = [NSEntityDescription insertNewObjectForEntityForName:@"KAVEntityAPIGroup"
                                                                  inManagedObjectContext:self.persistentContainer.viewContext];
        object.nameGroup = nameGroup;
        object.idGroup = idGroup;
        
    }
    
    [self saveContext];
}


- (void) addNewFacultyDataUser:(KAVEntityAPIFaculties*) objectAPI {
    
    KAVEntityFaculties* objUser = [NSEntityDescription insertNewObjectForEntityForName:@"KAVEntityFaculties"
                                                               inManagedObjectContext:self.persistentContainer.viewContext];
    
    objUser.nameFacult = objectAPI.nameFacult;
    objUser.idFacult = objectAPI.idFacult;
    
    [self saveContext];
}

- (void) addNewGroupDataUser:(NSArray*) arrayObjectsAPI {
    
    for (KAVEntityAPIGroup* object in arrayObjectsAPI) {
        
        KAVEntityGroup* objUser = [NSEntityDescription insertNewObjectForEntityForName:@"KAVEntityGroup"
                                                                inManagedObjectContext:self.persistentContainer.viewContext];
        
        objUser.nameGroup = object.nameGroup;
        objUser.idGroup = object.idGroup;
        
        [self.selectedFaculty addListGroupObject:objUser];
        
    }

    [self saveContext];
    
}

- (void) addNewLesson:(NSString*) nameLesson fromArrayGropups:(NSArray*) arrayGroups {
    
    KAVEntityLesson* objectLesson = [NSEntityDescription insertNewObjectForEntityForName:@"KAVEntityLesson"
                                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    
    for (KAVEntityGroup* object in arrayGroups) {
        
        objectLesson.nameLesson = nameLesson;
        [object addListLessonsObject:objectLesson];
        
    }
    
    [self saveContext];
    
}

-(void) addNewGroup:(KAVEntityGroup*)group iNLesson:(KAVEntityLesson*) lesson {
    [lesson addOwnerGroupObject:group];
    [self saveContext];
}
-(void) addNewLesson:(KAVEntityLesson*) lesson iNGroup:(KAVEntityGroup*) group {
    [group addListLessonsObject:lesson];
    [self saveContext];
}

#pragma mark - REQUESTS

- (NSArray*) executeFetchRequestFaculties {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"KAVEntityFaculties"
                                                          inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameFacult" ascending:YES];
    NSArray* arraySd = @[sdName];
    
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

- (NSArray*) executeFetchRequestFacultiesAPINURE {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"KAVEntityAPIFaculties"
                                                          inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameFacult" ascending:YES];
    NSArray* arraySd = @[sdName];
    
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

- (NSArray*) executeFetchRequestGroupsAPINURE {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"KAVEntityAPIGroup"
                                                          inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameGroup" ascending:YES];
    NSArray* arraySd = @[sdName];
    
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

-(NSArray *) makeArrayGroupFromSetSelectedFaculty: (NSSet *) set; {
    
    NSMutableArray * array = [NSMutableArray array];
    for (KAVEntityGroup * object in set) {
        [array addObject:object];
    }
    
    NSArray * resultArray = [NSArray arrayWithArray:array];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameGroup" ascending:YES];
    NSArray* arraySd = @[sdName];
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

-(NSArray *) makeArrayGroupFromSetSelectedLesson: (NSSet *) set {
    
    NSMutableArray * array = [NSMutableArray array];
    for (KAVEntityGroup * object in set) {
        [array addObject:object];
    }
    
    NSArray * resultArray = [NSArray arrayWithArray:array];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameGroup" ascending:YES];
    NSArray* arraySd = @[sdName];
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}


- (NSArray*) executeFetchRequestALLGroups {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"KAVEntityGroup"
                                                          inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameGroup" ascending:YES];
    NSArray* arraySd = @[sdName];
    
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

- (NSArray*) executeFetchRequestSearchGroup:(NSString*) stringSearch {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"KAVEntityAPIGroup"
                                                          inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSMutableArray* arraySearchGroups = [NSMutableArray array];
    for (KAVEntityAPIGroup* object in resultArray) {
        if ([object.nameGroup hasPrefix:stringSearch]){
            [arraySearchGroups addObject:object];
        }
    }
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameGroup" ascending:YES];
    NSArray* arraySd = @[sdName];
    NSArray* sortedArray = [arraySearchGroups sortedArrayUsingDescriptors:arraySd];
    return sortedArray;
}


- (NSArray*) executeFetchRequestAllLesson {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"KAVEntityLesson"
                                                          inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameLesson" ascending:YES];
    NSArray* arraySd = @[sdName];
    
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

-(NSArray *) makeArrayLessonsFromSetSelectedGroup: (NSSet *) set {
    
    NSMutableArray * array = [NSMutableArray array];
    for (KAVEntityLesson * object in set) {
        [array addObject:object];
    }
    
    NSArray * resultArray = [NSArray arrayWithArray:array];
    
    NSSortDescriptor * sdName = [NSSortDescriptor sortDescriptorWithKey:@"nameLesson" ascending:YES];
    NSArray* arraySd = @[sdName];
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:arraySd];
    
    return sortedArray;
}

#pragma mark - Delete

- (void) deleteFaculty:(KAVEntityFaculties*) faculty {
    
    NSFetchRequest* requestGroup = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* descriptor = [NSEntityDescription entityForName:@"KAVEntityFaculties"
                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    [requestGroup setEntity:descriptor];
    
    NSError* error = nil;
    NSArray* array = [self.persistentContainer.viewContext executeFetchRequest:requestGroup
                                                                         error:&error];
    for (KAVEntityFaculties* obj in array) {
        
        if ([obj.nameFacult isEqualToString:faculty.nameFacult]) {
            
            [self.persistentContainer.viewContext deleteObject:obj];
            
        }
    }
    
    [self saveContext];
    
}

- (void) deleteGroup:(KAVEntityGroup*) group {
    
    NSFetchRequest* requestGroup = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* descriptor = [NSEntityDescription entityForName:@"KAVEntityGroup"
                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    [requestGroup setEntity:descriptor];
    
    NSError* error = nil;
    NSArray* array = [self.persistentContainer.viewContext executeFetchRequest:requestGroup
                                                                         error:&error];
    for (KAVEntityGroup* obj in array) {
        
        if ([obj.nameGroup isEqualToString:group.nameGroup]) {
            
            [self.persistentContainer.viewContext deleteObject:obj];
            
        }
    }
    
    [self saveContext];
    
}

- (void) deleteLesson:(KAVEntityLesson*) lesson {
    
    NSFetchRequest* requestGroup = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* descriptor = [NSEntityDescription entityForName:@"KAVEntityLesson"
                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    [requestGroup setEntity:descriptor];
    
    NSError* error = nil;
    NSArray* array = [self.persistentContainer.viewContext executeFetchRequest:requestGroup
                                                                         error:&error];
    for (KAVEntityLesson* obj in array) {
        
        if ([obj.nameLesson isEqualToString:lesson.nameLesson]) {
            
            [self.persistentContainer.viewContext deleteObject:obj];
            
        }
    }
    
    [self saveContext];
    
}

- (void) deleteLesson:(KAVEntityLesson*) lesson selectedGroup:(KAVEntityGroup*) group {
    
    NSArray* arrayAllLessonsSelectedGroup = [self makeArrayLessonsFromSetSelectedGroup:group.listLessons];
    
    for (KAVEntityLesson* object in arrayAllLessonsSelectedGroup) {
        if ([object.nameLesson isEqualToString:lesson.nameLesson]){
            
            [group removeListLessonsObject:object];
            
        }
    }
    
    [self saveContext];
    
}


-(void)deleteGroup:(KAVEntityGroup*) group InLesson:(KAVEntityLesson*) lesson {
    
    NSFetchRequest* requestGroup = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* descriptor = [NSEntityDescription entityForName:@"KAVEntityGroup"
                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    [requestGroup setEntity:descriptor];
    
    NSError* error = nil;
    NSArray* array = [self.persistentContainer.viewContext executeFetchRequest:requestGroup
                                                                         error:&error];
    
    for (KAVEntityGroup* object in array) {
        if ([object.nameGroup isEqualToString:group.nameGroup]){
            [group removeListLessonsObject:lesson];
        }
    }
    [self saveContext];
}


- (void) deleteDataFacultyAPI {
    
    NSFetchRequest* requestGroup = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* descriptor = [NSEntityDescription entityForName:@"KAVEntityAPIFaculties"
                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    [requestGroup setEntity:descriptor];
    
    NSError* error = nil;
    NSArray* array = [self.persistentContainer.viewContext executeFetchRequest:requestGroup
                                                                         error:&error];
    for (KAVEntityAPIFaculties* obj in array) {
        
            [self.persistentContainer.viewContext deleteObject:obj];
    }
    [self saveContext];
}

- (void) deleteDataGroupAPI {
    
    NSFetchRequest* requestGroup = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* descriptor = [NSEntityDescription entityForName:@"KAVEntityAPIGroup"
                                                  inManagedObjectContext:self.persistentContainer.viewContext];
    [requestGroup setEntity:descriptor];
    
    NSError* error = nil;
    NSArray* array = [self.persistentContainer.viewContext executeFetchRequest:requestGroup
                                                                         error:&error];
    for (KAVEntityAPIGroup* obj in array) {
        
        [self.persistentContainer.viewContext deleteObject:obj];
    }
    [self saveContext];
}

@end
