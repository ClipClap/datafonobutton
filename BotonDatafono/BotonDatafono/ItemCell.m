//
//  ItemCell.m
//  IOSParkingAppSample
//
//  Created by Humberto Cetina on 1/5/16.
//  Copyright © 2016 My Organization. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell () <UIActionSheetDelegate>
@property (strong, nonatomic) UIResponder *currentResponder;
@end

@implementation ItemCell

#pragma mark - UIView Methods

- (void)awakeFromNib {
   
}


#pragma mark - UITableViewCell Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - My Methods

- (void) goToNextTexField{
    
    if ([self.currentResponder isEqual:self.itemName])
    {
        [self.itemPrice becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemPrice])
    {
        [self.itemCount becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemCount])
    {
        [self.itemName becomeFirstResponder];
    }
}

- (void) goToPreviousTexField{
    
    if ([self.currentResponder isEqual:self.itemName])
    {
        [self.itemCount becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemPrice])
    {
        [self.itemName becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemCount])
    {
        [self.itemPrice becomeFirstResponder];
    }
}

- (void) hideKeyboard{
    
    [self endEditing:YES];
}


#pragma mark - UITextFieldDelegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 568, 44)];
    toolbar.translucent = YES;
    [toolbar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"--->"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goToNextTexField)];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"<---"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(goToPreviousTexField)];
    
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithTitle:@"Esconder"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(hideKeyboard)];
    
    toolbar.items = @[hideButton, flexibleButton, previousButton, nextButton];
    textField.inputAccessoryView = toolbar;
    self.currentResponder = textField;
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && [textField isEqual:self.itemPrice])
    {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && [textField isEqual:self.itemPrice])
    {
        NSString *numberFormatted = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[textField.text doubleValue]]
                                                                     numberStyle:NSNumberFormatterDecimalStyle];
        
        textField.text = [NSString stringWithFormat:@"$%@", numberFormatted];
    }
}

@end
