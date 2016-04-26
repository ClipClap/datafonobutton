//
//  CCBPaymentHandler.h
//  CCDatafonoButton
//
//  Created by Humberto Cetina on 1/20/16.
//  Copyright © 2016 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCDBPayment;
@interface CCDBHandler : NSObject

/**
 *  Returns the singleton object of this class
 */
+ (CCDBHandler*) shareInstance;

/**
 *  CCDatafonoButton No Documentation
 */
- (void) commitPayment:(CCDBPayment *)payment andBlock:(void (^)(BOOL succeeded, NSError *error))successCallback;

@end
