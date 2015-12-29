#import "MyWebSocket.h"


@interface FakeServer (MyWebSocket)
+ (NSString *)responseForClientMessage:(NSString *)message;
@end


@implementation MyWebSocket

- (void)didOpen {
	[super didOpen];
}

- (void)didReceiveMessage:(NSString *)msg {
    NSString *response = [FakeServer responseForClientMessage:msg];
    if (response) {
        [self sendMessage:response];
    }
}

- (void)didClose {
	[super didClose];
}

@end
