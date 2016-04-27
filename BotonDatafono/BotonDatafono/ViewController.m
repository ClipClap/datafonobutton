//
//  ViewController.m
//  BotonDatafono
//
//  Created by José David Mantilla on 4/18/16.
//  Copyright © 2016 José David Mantilla. All rights reserved.
//

#import "ViewController.h"
#import "ItemCell.h"
#import <CCDatafonoButton/CCDatafonoButton.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//---------------------------------------------------------------------

#define ADD_CELL_TYPE @"AddItemCell"
#define ITEM_CELL_TYPE @"ItemCell"

//---------------------------------------------------------------------

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

//---------------------------------------------------------------------

@implementation ViewController

- (NSString *) getUUIDToken{
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

- (NSString *) getNoDashUUIDToken{
    
    return [[self getUUIDToken] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString *) getNoDashUUIDTokenWithLenght:(NSUInteger)lenght{
    
    NSUInteger uuidTimes = ceil(lenght / 32.0);
    NSString *uuid = @"";
    
    for (int i = 0; i < uuidTimes; i++)
    {
        uuid = [uuid stringByAppendingString:[self getNoDashUUIDToken]];
    }
    
    return [uuid substringToIndex:lenght];
}

- (void) showErrorMessage{
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Paga con Billetera";
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Uno o más campos estan vacíos"
                               delegate:nil
                      cancelButtonTitle:@"Cerrar"
                      otherButtonTitles:nil] show];
}

- (IBAction)payAction:(id)sender {
    
    [self.view endEditing:YES];
    
    //------------------------------------------------------------------
    
    //Creating a CCBPayment object
    CCDBPayment *charge = [[CCDBPayment alloc] init];
    
    //Iterating all the cell to get the items information
    for (int i = 0; i < self.dataSource.count - 1; i++)
    {
        ItemCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (cell.itemName.text.length == 0 || [cell.itemName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            [self showErrorMessage]; return;
        }
        
        if (cell.itemPrice.text.length == 0 || [cell.itemPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            [self showErrorMessage]; return;
        }
        
        if (cell.itemCount.text.length == 0 || [cell.itemCount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            [self showErrorMessage]; return;
        }
        
        NSString *itemPrice = [cell.itemPrice.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        itemPrice = [itemPrice stringByReplacingOccurrencesOfString:@"." withString:@""];
        itemPrice = [itemPrice stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        //Adding the item information to the payment object
        [charge addItemWithName:cell.itemName.text
                           value:[itemPrice intValue]
                        andCount:[cell.itemCount.text intValue]];
    }
    
    //------------------------------------------------------------------
    
    //Commiting the payment with the retreive payment token
    [[CCDBHandler shareInstance] commitPayment:charge];
}

//---------------------------------------------------------------------

#pragma mark - UIVieController Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //-------------------------------------------
    
    UIColor *appColor = [UIColor colorWithRed:0.238 green:0.628 blue:0.843 alpha:1];
    
    [[UINavigationBar appearance] setBarTintColor:appColor];
    [self.navigationController.navigationBar setBarTintColor:appColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //-------------------------------------------
    
    self.dataSource = [NSMutableArray arrayWithObjects:@{@"cellType" : ADD_CELL_TYPE}, nil];
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---------------------------------------------------------------------

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Getting info cell from data source
    NSDictionary *infoCell = self.dataSource[indexPath.row];
    NSString *cellIdenfier = ITEM_CELL_TYPE;
    
    if ([ADD_CELL_TYPE isEqualToString:infoCell[@"cellType"]])
    {
        cellIdenfier = ADD_CELL_TYPE;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:cellIdenfier forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *infoCell = self.dataSource[indexPath.row];
    
    if ([ADD_CELL_TYPE isEqualToString:infoCell[@"cellType"]])
    {
        NSDictionary *newItemCell = @{@"cellType" : ITEM_CELL_TYPE};
        [self.dataSource insertObject:newItemCell atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *infoCell = self.dataSource[indexPath.row];
    
    if ([ADD_CELL_TYPE isEqualToString:infoCell[@"cellType"]])
    {
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSDictionary *newItemCell = @{@"cellType" : ITEM_CELL_TYPE};
        [self.dataSource insertObject:newItemCell atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
