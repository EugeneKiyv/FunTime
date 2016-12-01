#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol CentralClientDelegate;

@interface CentralClient : NSObject

// Specify here which services you want to connect to and characteristics
// you want to read from.
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSArray *serviceUUIDs;  // CBUUIDs
@property (nonatomic, strong) NSArray *characteristicUUIDs;  // CBUUIDs

@property (nonatomic, weak) id<CentralClientDelegate> delegate;

- (CBCentralManager *)manager;
- (id)initWithDelegate:(id<CentralClientDelegate>)delegate;

// Tries to scan and connect to any peripheral.
- (void)connect;
- (BOOL)isConnected;
// Disconnects all connected services and peripherals.
- (void)disconnect;

// Subscribe to characteristics defined in characteristicUUIDs.
- (void)subscribe;

// Unsubscribe from characteristics defined in characteriticUUIDs
- (void)unsubscribe;

- (void)startScan;
- (void)stopScan;
@end

@protocol CentralClientDelegate <NSObject>

- (void)centralClient:(CentralClient *)central
       connectDidFail:(NSError *)error;

- (void)centralClient:(CentralClient *)central
        requestForCharacteristic:(CBCharacteristic *)characteristic
              didFail:(NSError *)error;

- (void)centralClientDidConnect:(CentralClient *)central;
- (void)centralClientDidDisconnect:(CentralClient *)central;

- (void)centralClientDidSubscribe:(CentralClient *)central;
- (void)centralClientDidUnsubscribe:(CentralClient *)central;

- (void)centralClient:(CentralClient *)central
       characteristic:(CBCharacteristic *)characteristic
       didUpdateValue:(NSData *)value;

@optional
- (void)centralClient:(CentralClient *)central
   discoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData;

- (void)centralClient:(CentralClient *)central
       characteristic:(CBCharacteristic *)characteristic
       didUpdateValue:(NSData *)value
           peripheral:(CBPeripheral *)peripheral;
@end
