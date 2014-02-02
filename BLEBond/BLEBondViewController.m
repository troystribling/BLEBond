//
//  BLEBondViewController.m
//  BLEBond
//
//  Created by Troy Stribling on 1/29/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import "BLEBondViewController.h"
#import "CBUUID+StringValue.h"

@interface BLEBondViewController ()

@property(nonatomic, strong) CBCentralManager* cbCentral;
@property(nonatomic, strong) CBPeripheral* cbPeripheral;

- (void)connect:(CBPeripheral*)__peripheral;

@end

@implementation BLEBondViewController

- (void)viewDidLoad {
    self.cbCentral = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral {
    NSLog(@"Peripheral connected: %@", peripheral.name);
    [self.cbPeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error {
    NSLog(@"Peripheral disconnected: %@", peripheral.name);
    [self connect:peripheral];
}

- (void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisements RSSI:(NSNumber*)RSSI {
    NSLog(@"Periphreal discovered: %@, %@\n%@", peripheral.name, [peripheral.identifier UUIDString], advertisements);
    [self connect:peripheral];
}

- (void)centralManager:(CBCentralManager*)central didFailToConnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error {
}

- (void)centralManager:(CBCentralManager*)central didRetrieveConnectedPeripherals:(NSArray*)peripherals {
}

- (void)centralManager:(CBCentralManager*)central didRetrievePeripherals:(NSArray*)peripherals {
}

- (void)centralManagerDidUpdateState:(CBCentralManager*)central {
	switch ([central state]) {
		case CBCentralManagerStatePoweredOff: {
            NSLog(@"CBCentralManager Powered OFF");
			break;
		}
		case CBCentralManagerStateUnauthorized: {
            NSLog(@"CBCentralManager Unauthorized");
			break;
		}
		case CBCentralManagerStateUnknown: {
            NSLog(@"CBCentralManager Unknown");
			break;
		}
		case CBCentralManagerStatePoweredOn: {
            NSLog(@"CBCentralManager Powered ON");
            [self.cbCentral scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
			break;
		}
		case CBCentralManagerStateResetting: {
            NSLog(@"CBCentralManager Resetting");
			break;
		}
        case CBCentralManagerStateUnsupported: {
            NSLog(@"CBCentralManager Unsupported");
        }
	}
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError*)error {
    for (CBService* service in peripheral.services) {
        NSLog(@"Discovered Service: %@", [service.UUID stringValue]);
        [self.cbPeripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverIncludedServicesForService:(CBService*)service error:(NSError*)error {
    NSLog(@"Discovered %lu Included Services", (unsigned long)[service.includedServices count]);
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error {
    for (CBCharacteristic* characteritc in service.characteristics) {
        NSLog(@"Discovered chracteristic: %@", [characteritc.UUID stringValue]);
        [self.cbPeripheral readValueForCharacteristic:characteritc];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error {
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error {
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error {
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {
        NSLog(@"Update value for characteristic: %@", [characteristic.UUID stringValue]);
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForDescriptor:(CBDescriptor*)descriptor error:(NSError*)error {
}

- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error {
}

- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForDescriptor:(CBDescriptor*)descriptor error:(NSError*)error {
}

- (void)peripheralDidUpdateName:(CBPeripheral*)peripheral {
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral*)peripheral error:(NSError*)__error {
}

#pragma Private

- (void)connect:(CBPeripheral*)__peripheral {
    self.cbPeripheral = __peripheral;
    self.cbPeripheral.delegate = self;
    [self.cbCentral connectPeripheral:self.cbPeripheral options:nil];
}

@end
