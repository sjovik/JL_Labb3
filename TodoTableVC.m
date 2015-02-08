//
//  TodoTableVC.m
//  Labb3
//
//  Created by Johannes on 2015-02-05.
//  Copyright (c) 2015 Johannes. All rights reserved.
//

#import "TodoTableVC.h"
#import "TaskVC.h"
#import "JLITask.h"

@interface TodoTableVC ()

@property (nonatomic) NSDictionary* tasks;
@property (nonatomic) NSMutableArray* data;

@end


@implementation TodoTableVC
@synthesize data = _data;

-(NSMutableArray*)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}


- (NSDictionary*)tasks {
    if (!_tasks) {
        
        NSMutableArray* urgentTasks = [[NSMutableArray alloc] init];
        NSMutableArray* tasks = [[NSMutableArray alloc] init];
        NSMutableArray* doneTasks = [[NSMutableArray alloc] init];
        
        for (JLITask* task in self.data) {
            if (task.isUrgent) {
                [urgentTasks addObject:task];
            } else if (task.isDone) {
                [doneTasks addObject:task];
            } else {
                [tasks addObject:task];
            }
        }
        _tasks = [NSDictionary dictionaryWithObjectsAndKeys:
                  urgentTasks, @"urgent",
                  tasks, @"todo",
                  doneTasks, @"done", nil];
    }
    
    return _tasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) loadTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *taskDcts = [defaults objectForKey:@"tasks"];
    self.data = nil;
    
    
    if (taskDcts.count == 0) {
        JLITask *task = [[JLITask alloc] init];
        task.taskHeader = @"I'm a Todo item. Click me to read more.";
        task.taskDescription = @"You can edit Todo items like me in these boxes or create a new one by pressing the 'New' button on the startpage. Try to make me urgent on the switch below! Dont forget to press save.";
        task.isUrgent = NO;
        task.isDone = NO;
        
        JLITask *swipeTask = [[JLITask alloc] init];
        swipeTask.taskHeader = @"←  Try to swipe us to the left";
        swipeTask.isUrgent = NO;
        swipeTask.isDone = NO;
        
        JLITask *urgentTask = [[JLITask alloc] init];
        urgentTask.taskHeader = @"Im urgent. Finish me first.";
        urgentTask.isUrgent = YES;
        urgentTask.isDone = NO;
        
        JLITask *doneTask = [[JLITask alloc] init];
        doneTask.taskHeader = @"I'm finished. You can delete me by swiping.";
        doneTask.taskDescription = @"If you swipe to delete me i'm gone forever. But if you inspect me like you are doing now, you can make me active again by pressing 'Save' below. If you don't want to make me active again, just press 'back' in the top left.";
        doneTask.isUrgent = NO;
        doneTask.isDone = YES;
        [self.data addObjectsFromArray:@[task, swipeTask, urgentTask, doneTask]];
    }
    
    for (NSDictionary *taskAsDct in taskDcts) {
        JLITask *task = [[JLITask alloc] init];
        task.taskHeader = [taskAsDct objectForKey:@"head"];
        task.taskDescription = [taskAsDct objectForKey:@"description"];
        task.isUrgent = [[taskAsDct objectForKey:@"urgent"] boolValue];
        task.isDone = [[taskAsDct objectForKey:@"done"] boolValue];
        
        [self.data addObject:task];
    }
    
}

- (void) saveTasks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray* taskDcts = [[NSMutableArray alloc] initWithCapacity:self.data.count];
    
    
    for (JLITask *task in self.data) {
        NSDictionary* taskAsDct = @{ @"head": (task.taskHeader) ? task.taskHeader : @"",
                                     @"description":(task.taskDescription) ? task.taskDescription : @"",
                                     @"urgent":[NSNumber numberWithBool:task.isUrgent],
                                     @"done":[NSNumber numberWithBool:task.isDone] };

        
        [taskDcts addObject:taskAsDct];
    }
    
    [defaults setObject:taskDcts forKey:@"tasks"];
    [defaults synchronize];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.tasks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return [self.tasks[@"urgent"] count];
        case 1:
            return [self.tasks[@"todo"] count];
        case 2:
            return [self.tasks[@"done"] count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Urgent";
        case 1:
            return @"Todo";
        case 2:
            return @"Done";
        default:
            return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Todo Item Urgent"
                                                   forIndexPath:indexPath];
            
            JLITask *task = self.tasks[@"urgent"][indexPath.row];
            cell.textLabel.text = task.taskHeader;
            return cell;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Todo Item"
                                                   forIndexPath:indexPath];
            JLITask *task = self.tasks[@"todo"][indexPath.row];
            cell.textLabel.text = task.taskHeader;
            return cell;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Todo Item Done"
                                                   forIndexPath:indexPath];
            JLITask *task = self.tasks[@"done"][indexPath.row];
            cell.textLabel.text = task.taskHeader;
            return cell;
        }
        default:
            return nil;
    }
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
 
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 2) {
        UITableViewRowAction *doneAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:@"Done"
                                                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
        {
            [self.tableView setEditing:NO];
            
            JLITask *task;
            if (indexPath.section == 0) {
                task = self.tasks[@"urgent"][indexPath.row];
            } else task = self.tasks[@"todo"][indexPath.row];
            
            task.isDone = YES;
            [self invalidateTasks];
                                                                                
        }];
        
        doneAction.backgroundColor = [UIColor greenColor];
        
        
        return @[doneAction];
    } else {
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                                title:@"Delete"
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
        {
            [self.tableView setEditing:NO];
            JLITask *task = self.tasks[@"done"][indexPath.row];
            [self.data removeObject:task];
            [self invalidateTasks];
        }];
        
        return @[deleteAction];
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
    
}

- (void) invalidateTasks {
    self.tasks = nil;
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TaskVC *tvc = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"Edit Urgent Task"]) {
        tvc.task = self.tasks[@"urgent"][indexPath.row];
    } else if ([segue.identifier isEqualToString:@"Edit Task"]) {
        tvc.task = self.tasks[@"todo"][indexPath.row];
    } else if ([segue.identifier isEqualToString:@"Edit Done Task"]) {
        tvc.task = self.tasks[@"done"][indexPath.row];
    } else if ([segue.identifier isEqualToString:@"New Task"]) {
        
    }
}

- (IBAction)editedTaskCompleted:(UIStoryboardSegue *)segue {
    
    TaskVC *tvc = segue.sourceViewController;
    JLITask *task = tvc.task;
    
    if (![self.data containsObject:task]) {
        [self.data addObject:task];
    };
    [self invalidateTasks];
    
    
}



















@end
