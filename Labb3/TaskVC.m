//
//  TaskVC.m
//  Labb3
//
//  Created by Johannes on 2015-02-06.
//  Copyright (c) 2015 Johannes. All rights reserved.
//

#import "TaskVC.h"

@interface TaskVC ()

@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UITextField *taskHeader;
@property (weak, nonatomic) IBOutlet UISwitch *taskIsUrgentSwitch;

@end

@implementation TaskVC

- (JLITask*)task {
    if (!_task) {
        _task = [[JLITask alloc] init];
    }
    return _task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.task) {
        
        self.taskDescription.text = self.task.taskDescription;
        self.taskHeader.text = self.task.taskHeader;
        [self.taskIsUrgentSwitch setOn:self.task.isUrgent];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.task.taskHeader = self.taskHeader.text;
    self.task.taskDescription = self.taskDescription.text;
    self.task.isUrgent = self.taskIsUrgentSwitch.isOn;
    self.task.isDone = NO;
}


@end
