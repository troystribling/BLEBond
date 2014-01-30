//
//  BLEBondViewController.h
//  BLEBond
//
//  Created by Troy Stribling on 1/29/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEBondViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@end
