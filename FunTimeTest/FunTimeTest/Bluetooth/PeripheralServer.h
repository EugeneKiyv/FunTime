#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol PeripheralServerDelegate;

// Implements the Bluetooth 4.0 LE Peripheral (Server) interface
//
// This service works by using CoreBluetooth CBPeripheralManager to expose
// a Bluetooth Peripheral (Server) that contains one primary |service|.
//
// The service has one subscribable/notifable |characteristic| that is
// referenced by UUID "c0de".
//
// Any Bluetooth 4.0 LE Central (aka. Client) that subscribes to this peripheral
// will cause a delegate message to be sent. This in turn will allow the
// peripheral to respond with data by calling the |sendToSubscribers| method.
@interface PeripheralServer : NSObject

@property(nonatomic, assign) id<PeripheralServerDelegate> delegate;

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) NSString *deviceName;
@property(nonatomic, strong) CBUUID *serviceUUID;
@property(nonatomic, strong) CBUUID *characteristicUUID;

// Returns YES if Bluetooth 4 LE is supported on this operation system.
+ (BOOL)isBluetoothSupported;

- (id)initWithDelegate:(id<PeripheralServerDelegate>)delegate;

- (void)sendToSubscribers:(NSData *)data;

// Called by the application if it enters the background.
- (void)applicationDidEnterBackground;

// Called by the application if it enters the foregroud.
- (void)applicationWillEnterForeground;

// Allows turning on or off the advertisments.
- (void)startAdvertising;
- (void)stopAdvertising;
- (BOOL)isAdvertising;
- (void)enableService;
- (void)disableService;
@end

// Simplified protocol to respond to subscribers.
@protocol PeripheralServerDelegate <NSObject>

// Called when the peripheral receives a new subscriber.
- (void)peripheralServer:(PeripheralServer *)peripheral centralDidSubscribe:(CBCentral *)central;

- (void)peripheralServer:(PeripheralServer *)peripheral centralDidUnsubscribe:(CBCentral *)central;

@end
