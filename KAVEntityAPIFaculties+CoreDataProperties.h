//
//  KAVEntityAPIFaculties+CoreDataProperties.h
//  JurnalNURE
//
//  Created by Alexei Karas on 11.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVEntityAPIFaculties+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KAVEntityAPIFaculties (CoreDataProperties)

+ (NSFetchRequest<KAVEntityAPIFaculties *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *idFacult;
@property (nullable, nonatomic, copy) NSString *nameFacult;

@end

NS_ASSUME_NONNULL_END
