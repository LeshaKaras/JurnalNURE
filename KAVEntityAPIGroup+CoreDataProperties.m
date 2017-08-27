//
//  KAVEntityAPIGroup+CoreDataProperties.m
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityAPIGroup+CoreDataProperties.h"

@implementation KAVEntityAPIGroup (CoreDataProperties)

+ (NSFetchRequest<KAVEntityAPIGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"KAVEntityAPIGroup"];
}

@dynamic idGroup;
@dynamic nameGroup;

@end
