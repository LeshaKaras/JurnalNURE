//
//  KAVEntityGroup+CoreDataProperties.m
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityGroup+CoreDataProperties.h"

@implementation KAVEntityGroup (CoreDataProperties)

+ (NSFetchRequest<KAVEntityGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"KAVEntityGroup"];
}

@dynamic idGroup;
@dynamic nameGroup;
@dynamic listLessons;
@dynamic ownerFaculty;

@end
