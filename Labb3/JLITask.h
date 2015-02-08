//
//  JLITask.h
//  Labb3
//
//  Created by Johannes on 2015-02-06.
//  Copyright (c) 2015 Johannes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLITask : NSObject

@property (nonatomic) NSString* taskHeader;
@property (nonatomic) NSString* taskDescription;
@property (nonatomic) BOOL isDone;
@property (nonatomic) BOOL isUrgent;

@end
