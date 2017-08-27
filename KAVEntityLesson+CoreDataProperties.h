//
//  KAVEntityLesson+CoreDataProperties.h
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityLesson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KAVEntityLesson (CoreDataProperties)

+ (NSFetchRequest<KAVEntityLesson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nameLesson;
@property (nullable, nonatomic, retain) NSSet<KAVEntityGroup *> *ownerGroup;

@end

@interface KAVEntityLesson (CoreDataGeneratedAccessors)

- (void)addOwnerGroupObject:(KAVEntityGroup *)value;
- (void)removeOwnerGroupObject:(KAVEntityGroup *)value;
- (void)addOwnerGroup:(NSSet<KAVEntityGroup *> *)values;
- (void)removeOwnerGroup:(NSSet<KAVEntityGroup *> *)values;

@end

NS_ASSUME_NONNULL_END
