//
//  KAVDataManager.h
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KAVEntityFaculties+CoreDataClass.h"
#import "KAVEntityGroup+CoreDataClass.h"
#import "KAVEntityLesson+CoreDataClass.h"

#import "KAVEntityAPIFaculties+CoreDataClass.h"
#import "KAVEntityAPIGroup+CoreDataClass.h"


typedef enum {
    KAVVCShowAllGroups,
    KAVVCShowGroupSelectedFaculty,
    KAVVCShowGroupSelectedLesson,
} KAVStateGropVCShowData;

typedef enum {
    KAVVCShowAllLessons,
    KAVVCShowLessonsSelectedGroup,
} KAVStateLessonVCShowData;

typedef enum {
    KAVVCShowNCreateNewLesson,
    KAVVCShowNCreateNewLessonSelectedGroup,
} KAVStateLessonCreateVCShowData;



@interface KAVDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) KAVEntityFaculties* selectedFaculty;
@property (strong, nonatomic) KAVEntityGroup* selectedGroup;
@property (strong, nonatomic) KAVEntityLesson* selectedLesson;

@property (assign, nonatomic) KAVStateGropVCShowData stateVC;
@property (assign, nonatomic) KAVStateLessonVCShowData stateLessonVC;
@property (assign, nonatomic) KAVStateLessonCreateVCShowData stateLessonCreateVC;

+(KAVDataManager*) sharedManager;
- (void)saveContext;

#pragma mark - Add New Objects

- (void) loadDataFacultyAPI:(id) response;
- (void) loadDataGroupAPI:(id) response;
- (void) addNewFacultyDataUser:(KAVEntityAPIFaculties*) objectAPI;
- (void) addNewGroupDataUser:(NSArray*) arrayObjectsAPI;
- (void) addNewLesson:(NSString*) nameLesson fromArrayGropups:(NSArray*) arrayGroups;
- (void) addNewGroup:(KAVEntityGroup*)group iNLesson:(KAVEntityLesson*) lesson;
- (void) addNewLesson:(KAVEntityLesson*) lesson iNGroup:(KAVEntityGroup*) group;

#pragma mark - Request Objects

- (NSArray*) executeFetchRequestFaculties;
- (NSArray*) executeFetchRequestFacultiesAPINURE;
- (NSArray*) executeFetchRequestGroupsAPINURE;
- (NSArray*) executeFetchRequestALLGroups;
- (NSArray*) executeFetchRequestSearchGroup:(NSString*) stringSearch;
- (NSArray*) executeFetchRequestAllLesson;

-(NSArray *) makeArrayLessonsFromSetSelectedGroup: (NSSet *) set;
-(NSArray *) makeArrayGroupFromSetSelectedFaculty: (NSSet *) set;
-(NSArray *) makeArrayGroupFromSetSelectedLesson: (NSSet *) set;

#pragma mark - Delete Objects

- (void) deleteFaculty:(KAVEntityFaculties*) faculty;
- (void) deleteGroup:(KAVEntityGroup*) group;
- (void) deleteLesson:(KAVEntityLesson*) lesson;
- (void) deleteGroup:(KAVEntityGroup*) group InLesson:(KAVEntityLesson*) lesson;

- (void) deleteLesson:(KAVEntityLesson*) lesson selectedGroup:(KAVEntityGroup*) group;

- (void) deleteDataFacultyAPI;
- (void) deleteDataGroupAPI;



@end
