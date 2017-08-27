//
//  KAVEntityGroup+CoreDataProperties.h
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KAVEntityGroup (CoreDataProperties)

+ (NSFetchRequest<KAVEntityGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *idGroup;
@property (nullable, nonatomic, copy) NSString *nameGroup;
@property (nullable, nonatomic, retain) NSSet<KAVEntityLesson *> *listLessons;
@property (nullable, nonatomic, retain) KAVEntityFaculties *ownerFaculty;

@end

@interface KAVEntityGroup (CoreDataGeneratedAccessors)

- (void)addListLessonsObject:(KAVEntityLesson *)value;
- (void)removeListLessonsObject:(KAVEntityLesson *)value;
- (void)addListLessons:(NSSet<KAVEntityLesson *> *)values;
- (void)removeListLessons:(NSSet<KAVEntityLesson *> *)values;

@end

NS_ASSUME_NONNULL_END
