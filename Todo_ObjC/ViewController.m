//
//  ViewController.m
//  Todo_ObjC
//
//  Created by VietVQ on 3/18/20.
//  Copyright © 2020 VietVQ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSArray * categories;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@{@"name": @"Take out the trash", @"category": @"Home"}, @{@"name": @"Go Shopping", @"category": @"Home"}, @{@"name" : @"Reply to that important email", @"category" : @"Work"}].mutableCopy;
    self.categories = @[@"Home", @"Work"];
    
    self.navigationItem.title = @"To-do list";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    // Do any additional setup after loading the view.
}

#pragma mark - Adding items

- (void)addNewItem:(UIBarButtonItem *)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"New to-do item"
                                                                             message:@"Please enter the name of the new to-do item"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
     
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {}];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Add item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        UITextField* itemNameField = alertController.textFields.firstObject;
        NSString *itemName = itemNameField.text;
        NSDictionary *item = @{@"name" : itemName, @"category" : @"Home"};
        [self.items addObject:item];
        NSInteger numHomeItems = [self numberOfItemsInCategory:@"Home"];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:numHomeItems -1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Data source helper methods

- (NSArray *)itemsInCategory:(NSString *)targetCategory {
    NSPredicate *matchingPredicate = [NSPredicate predicateWithFormat:@"category = %@", targetCategory];
    NSArray *categoryItems = [self.items filteredArrayUsingPredicate:matchingPredicate];
    return categoryItems;
}

- (NSInteger)numberOfItemsInCategory:(NSString *)targetCategory {
    return [self itemsInCategory:targetCategory].count;
}

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *category = self.categories[indexPath.section];
    NSArray *categoryItems = [self itemsInCategory:category];
    NSDictionary *items = categoryItems[indexPath.row];
    
    return items;
}

- (NSInteger) itemIndexForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    NSInteger index = [self.items indexOfObjectIdenticalTo:item];
    
    return index;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    [self.items removeObjectAtIndex:index];
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInCategory:self.categories[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TodoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    cell.textLabel.text = item[@"name"];
    
    if ([item[@"completed"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.categories[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    
    NSMutableDictionary *item = [self.items[index] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    
    self.items[index] = item;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
