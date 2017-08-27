//
//  KAVEntityFaculties+CoreDataProperties.m
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityFaculties+CoreDataProperties.h"

@implementation KAVEntityFaculties (CoreDataProperties)

+ (NSFetchRequest<KAVEntityFaculties *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"KAVEntityFaculties"];
}

@dynamic idFacult;
@dynamic nameFacult;
@dynamic listGroup;

@end
