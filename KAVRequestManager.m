//
//  KAVRequestManager.m
//  JurnalNURE
//
//  Created by Alexei Karas on 09.08.17.
//  Copyright © 2017 Alexei Karas. All rights reserved.
//

#import "KAVRequestManager.h"
#import "KAVDataManager.h"
#import "KAVFacultiesAPIVC.h"
#import "KAVGroupsAPIVC.h"

@implementation KAVRequestManager

+(KAVRequestManager*) sharedManager {
    static KAVRequestManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KAVRequestManager alloc]init];
    });
    return manager;
}

-(void) getDataFaculty{
    
    NSString* urlString = @"http://cist.nure.ua/ias/app/tt/get_faculties";
    NSURL* url = [NSURL URLWithString:urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url.absoluteString
      parameters:nil
        progress:^(NSProgress*  downloadProgress) {
            
        } success:^(NSURLSessionDataTask * task, id responseObject) {
            
            [[KAVDataManager sharedManager] loadDataFacultyAPI:responseObject];
            
            KAVFacultiesAPIVC* object = [[KAVFacultiesAPIVC alloc]init];
            object.dataIsSet = YES;
            

        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            NSLog(@"error: %@", error);
        }];
}

- (void) getDataGroup:(NSString*) idOwnerFaculty {
    
    NSString* string = [NSString stringWithFormat:@"http://cist.nure.ua/ias/app/tt/get_groups?faculty_id=%@",idOwnerFaculty];
    NSURL* url = [NSURL URLWithString:string];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url.absoluteString
      parameters:nil
        progress:^(NSProgress*  downloadProgress) {
            
        } success:^(NSURLSessionDataTask * task, id responseObject) {
            
            [[KAVDataManager sharedManager] loadDataGroupAPI:responseObject];
            
            KAVGroupsAPIVC* object = [[KAVGroupsAPIVC alloc]init];
            object.dataIsSet = YES;
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            NSLog(@"error: %@", error);
        }];
}
@end
