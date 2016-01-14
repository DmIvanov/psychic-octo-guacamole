#import <Foundation/Foundation.h>
#import "HTTPConnection.h"

#if DEBUG

@class MyWebSocket;

@interface MyHTTPConnection : HTTPConnection
{
	MyWebSocket *ws;
}

@end

#endif