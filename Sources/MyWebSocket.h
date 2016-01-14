#if DEBUG

#import <Foundation/Foundation.h>
#import "WebSocket.h"
#import "FakeServer.h"


@interface MyWebSocket : WebSocket

@property (nonatomic, weak) FakeServer *FakeServer;

@end

#endif