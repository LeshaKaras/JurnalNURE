//
//  KAVEntityFaculties+CoreDataProperties.h
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityFaculties+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KAVEntityFaculties (CoreDataProperties)

+ (NSFetchRequest<KAVEntityFaculties *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *idFacult;
@property (nullable, nonatomic, copy) NSString *nameFacult;
@property (nullable, nonatomic, retain) NSSet<KAVEntityGroup *> *listGroup;

@end

@interface KAVEntityFaculties (CoreDataGeneratedAccessors)

- (void)addListGroupObject:(KAVEntityGroup *)value;
- (void)removeListGroupObject:(KAVEntityGroup *)value;
- (void)addListGroup:(NSSet<KAVEntityGroup *> *)values;
- (void)removeListGroup:(NSSet<KAVEntityGroup *> *)values;

@end

NS_ASSUME_NONNULL_END
