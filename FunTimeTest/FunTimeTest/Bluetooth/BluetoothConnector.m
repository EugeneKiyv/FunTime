//
//  BluetoothConnector.m
//

#import "BluetoothConnector.h"
#import "PeripheralServer.h"
#import "CentralClient.h"

static NSString* const serviceName = @"FunTimeTest";
static NSString* const serviceUUID = @"7BE1";
static NSString* const characteristicUUID = @"BA46";

@interface BluetoothConnector() <PeripheralServerDelegate,CentralClientDelegate,CBPeripheralManagerDelegate>
@property (strong, nonatomic) CBPeripheralManager *peripheralMonitor;
@property (strong, nonatomic) PeripheralServer *peripheral;
@property (strong, nonatomic) CentralClient *central;
@property (strong, nonatomic) NSMutableSet *peripherals;

@end

@implementation BluetoothConnector

- (instancetype)initWithDelegate:(id<BluetoothConnectorDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _peripheralMonitor = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        _peripherals = [NSMutableSet new];
        _device = [UIDevice currentDevice];
        self.central = [[CentralClient alloc] initWithDelegate:self];
        self.central.serviceName = serviceName;
        self.peripheral = [[PeripheralServer alloc] initWithDelegate:self];
        self.peripheral.serviceName = serviceName;
        self.peripheral.serviceUUID = [CBUUID UUIDWithString:serviceUUID];
        self.peripheral.characteristicUUID = [CBUUID UUIDWithString:characteristicUUID];
        self.peripheral.deviceName = [NSString stringWithFormat:@"%@/%@",self.device.model,self.device.name];
        NSArray *coreBluetoothiOSPeripheralServiceUUIDs = @[[CBUUID UUIDWithString:serviceUUID]];
        
        self.central.serviceUUIDs = coreBluetoothiOSPeripheralServiceUUIDs;
        self.central.characteristicUUIDs = @[[CBUUID UUIDWithString:characteristicUUID]];
    }
    return self;
}

- (void)startDiscover {
    [self startScan];
}

- (void)startScan {
    [self.central startScan];
    [self.peripheral startAdvertising];
}

- (NSData *)dataFrom:(id)obj {
    NSError *error;
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    return paramData;
}

- (void)sendMessage:(NSDictionary *)message {
    [self.peripheral sendToSubscribers:[self dataFrom:message]];
}

- (void)disconect {
    [self.central unsubscribe];
    [self.central disconnect];
    [self.peripheral disableService];
    [self.peripheral enableService];
    [self didDisconnect];
}

#pragma mark - LXCBPeripheralServerDelegate

- (void)peripheralServer:(PeripheralServer *)peripheral centralDidSubscribe:(CBCentral *)central {
    [self.peripheral startAdvertising];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.central connect];
    });
}

- (void)peripheralServer:(PeripheralServer *)peripheral centralDidUnsubscribe:(CBCentral *)central {
    
}

#pragma mark - LXCBCentralClientDelegate

- (void)centralClientDidConnect:(CentralClient *)central {
    NSLog(@"Connnected to Peripheral");
    
    [self.central subscribe];
    [self startScan];
    [self.delegate didConnect];
}

- (void)didDisconnect {
    [self.delegate didDisconnect];
    [self startDiscover];
}

- (void)centralClientDidDisconnect:(CentralClient *)central {
    NSLog(@"didDisconnected to Peripheral");
    [self didDisconnect];
}

- (void)centralClient:(CentralClient *)central characteristic:(CBCharacteristic *)characteristic didUpdateValue:(NSData *)value {
    NSError *error;
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:value options:0 error:&error];
    if (params) {
        [self.delegate recivedMessage:params];
    }
}

- (void)centralClient:(CentralClient *)central connectDidFail:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Error: %@", [error description]);
}

- (void)centralClient:(CentralClient *)central requestForCharacteristic:(CBCharacteristic *)characteristic didFail:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Error: %@", [error description]);
}

- (void)centralClientDidSubscribe:(CentralClient *)central {
    
}

- (void)centralClientDidUnsubscribe:(CentralClient *)central {
    
}

#pragma mark -
- (void)centralClient:(CentralClient *)central discoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    NSString *deviceName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if ([deviceName hasPrefix:serviceName]) {
        if (![self.peripherals containsObject:peripheral]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.central connect];
            });
            [self.peripherals addObject:peripheral];
        }
    }
}

#pragma mark CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"peripheralStateChange: Powered On");
            [_peripheralMonitor startAdvertising:nil];
            [self.delegate didChangeBluetoothAvailable:YES];
            [self startDiscover];
            break;
        case CBPeripheralManagerStatePoweredOff: {
            NSLog(@"peripheralStateChange: Powered Off");
            [self didDisconnect];
            [self.delegate didChangeBluetoothAvailable:NO];
            [self.central stopScan];
            self.peripherals = [NSMutableSet new];
            break;
        }
        case CBPeripheralManagerStateResetting: {
            NSLog(@"peripheralStateChange: Resetting");
            [self.delegate didChangeBluetoothAvailable:NO];
            break;
        }
        case CBPeripheralManagerStateUnauthorized: {
            NSLog(@"peripheralStateChange: Deauthorized");
            [self.delegate didChangeBluetoothAvailable:NO];
            break;
        }
        case CBPeripheralManagerStateUnsupported: {
            NSLog(@"peripheralStateChange: Unsupported");
            [self.delegate didChangeBluetoothAvailable:NO];
            break;
        }
        case CBPeripheralManagerStateUnknown:
            NSLog(@"peripheralStateChange: Unknown");
            [self.delegate didChangeBluetoothAvailable:NO];
            break;
        default:
            break;
    }
}

@end
