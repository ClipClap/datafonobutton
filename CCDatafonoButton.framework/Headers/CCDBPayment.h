//
//  CCBilleteraPayment.h
//  CCDatafonoButton
//
//  Created by Humberto Cetina on 12/5/15.
//  Copyright © 2015 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------------------------------

@class  CCBItem;
@interface CCDBPayment : NSObject

//-----------------------------------------------------------------

/**
 *  CCDatafonoButton No Documentation
 */
- (instancetype) init;

/**
 *  CCDatafonoButton No Documentation
 */
- (void) addItemWithName:(NSString *)name value:(int)value andCount:(int)count;

/**
 *  CCDatafonoButton No Documentation
 */
- (NSUInteger) itemsCount;

/**
 *  CCDatafonoButton No Documentation
 */
- (CCBItem *) itemAtIndex:(NSUInteger)index;

/**
 *  CCDatafonoButton No Documentation
 */
- (NSString *) itemJSONRepresentation;
@end
