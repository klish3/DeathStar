//
//  CoreDataStack.h
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 23/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataStack : NSObject

+(instancetype)defaultStack;

@property (readonly, strong ,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong ,nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong ,nonatomic) NSPersistentStoreCoordinator *persistanceStoreCoordinator;

-(void)saveContext;
-(NSURL *)applicationDocumentDirectory;



@end
