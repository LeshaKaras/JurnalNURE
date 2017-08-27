//
//  KAVEntityAPIGroup+CoreDataProperties.h
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityAPIGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KAVEntityAPIGroup (CoreDataProperties)

+ (NSFetchRequest<KAVEntityAPIGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *idGroup;
@property (nullable, nonatomic, copy) NSString *nameGroup;

@end

NS_ASSUME_NONNULL_END
