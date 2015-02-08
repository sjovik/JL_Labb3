//
//  JLITask.m
//  Labb3
//
//  Created by Johannes on 2015-02-06.
//  Copyright (c) 2015 Johannes. All rights reserved.
//

#import "JLITask.h"

@implementation JLITask

-(void)setIsUrgent:(BOOL)isUrgent {
    _isUrgent = isUrgent;
    
    if (_isUrgent) {
        self.isDone = NO;
    }

}

-(void)setIsDone:(BOOL) isDone {
    _isDone = isDone;
    
    if (_isDone) {
        self.isUrgent = NO;
    }
}

@end
