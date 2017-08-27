//
//  KAVRequestManager.h
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface KAVRequestManager : NSObject

+(KAVRequestManager*) sharedManager;

-(void) getDataFaculty;
-(void) getDataGroup:(NSString*) idOwnerFaculty;

@end
