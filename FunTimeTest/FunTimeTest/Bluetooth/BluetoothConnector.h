//
//  BluetoothConnector.h

#import "BluetoothConnector.h"

@protocol BluetoothConnectorDelegate <NSObject>
@required
- (void)didConnect;
- (void)didDisconnect;
- (void)didChangeBluetoothAvailable:(BOOL)available;
- (void)recivedMessage:(NSDictionary *)message;
@end

@interface BluetoothConnector : NSObject

@property (strong, nonatomic) id<BluetoothConnectorDelegate> delegate;
@property (strong, nonatomic) UIDevice *device;

- (instancetype)initWithDelegate:(id<BluetoothConnectorDelegate>)delegate;
- (void)startDiscover;
- (void)disconect;
- (NSData *)dataFrom:(id)obj;
- (void)sendMessage:(NSDictionary *)message;
@end

