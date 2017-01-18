//
//  RealName+CoreDataProperties.h
//  ibulb
//
//  Created by Interest on 16/1/21.
//  Copyright © 2016年 Interest. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RealName.h"

NS_ASSUME_NONNULL_BEGIN

@interface RealName (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *udid;

@end

NS_ASSUME_NONNULL_END
