//
//  KAVEntityLesson+CoreDataProperties.m
//  JurnalNURE
//
//  Created by Alexei Karas on 16.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityLesson+CoreDataProperties.h"

@implementation KAVEntityLesson (CoreDataProperties)

+ (NSFetchRequest<KAVEntityLesson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"KAVEntityLesson"];
}

@dynamic nameLesson;
@dynamic ownerGroup;

@end
