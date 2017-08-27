//
//  KAVEntityAPIFaculties+CoreDataProperties.m
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityAPIFaculties+CoreDataProperties.h"

@implementation KAVEntityAPIFaculties (CoreDataProperties)

+ (NSFetchRequest<KAVEntityAPIFaculties *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"KAVEntityAPIFaculties"];
}

@dynamic idFacult;
@dynamic nameFacult;

@end
