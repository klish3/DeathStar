//
//  ProfileEditViewController.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 28/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "ProfileEdit.h"
#import "CoreDataStack.h"



@interface ProfileEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *NameFieild;
@property (weak, nonatomic) IBOutlet UITextField *restNameField;


@end



@implementation ProfileEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.edit != nil) {
        self.NameFieild.text = self.edit.userName;
        self.restNameField.text = self.edit.resturauntName;
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) insertProfileEntry {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    ProfileEdit *edit = [NSEntityDescription insertNewObjectForEntityForName:@"ProfileEdit" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    edit.userName = self.NameFieild.text;
    edit.resturauntName = self.restNameField.text;
    [coreDataStack saveContext];
}



-(void)dismissSelf{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)updateProfileEntry {
    self.edit.userName = self.NameFieild.text;
    self.edit.resturauntName = self.restNameField.text;
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
    
    
    
}


/*
 
 
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
 
 if([segue.identifier isEqualToString:@"HomeSegue"]){
 
 [self insertProfileEntry];
 [self dismissSelf];
 
 }
 }
 
 */

-(void)updateProfileEdit {
    
    self.edit.userName = self.NameFieild.text;
    self.edit.resturauntName = self.restNameField.text;
    
    CoreDataStack *coredataStack = [CoreDataStack defaultStack];
    [coredataStack saveContext];
}

- (IBAction)doneWasPressed:(id)sender {
    
    if (self.edit != nil) {
        [self updateProfileEdit];
    } else {
        [self insertProfileEntry];
    }
    
    [self dismissSelf];
    NSLog(@"Done");
    
}
- (IBAction)cancelWasPressed:(id)sender {
    

    [self dismissSelf];
    NSLog(@"Cancel");
}




@end
