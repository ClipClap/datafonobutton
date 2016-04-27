//
//  ItemCell.h
//  IOSParkingAppSample
//
//  Created by Humberto Cetina on 1/5/16.
//  Copyright © 2016 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCDatafonoButton/CCDatafonoButton.h>

@interface ItemCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *itemName;
@property (strong, nonatomic) IBOutlet UITextField *itemPrice;
@property (strong, nonatomic) IBOutlet UITextField *itemCount;
@end
