//
//  FakeServer.m
//  Created by Dmitry Ivanov on 27.12.15.
//

#if DEBUG

#import "FakeServer.h"

#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


static const UInt16 kPort = 12345;


@interface FakeServer() {
    HTTPServer *_httpServer;
}
@end


@implementation FakeServer

#pragma mark - Public methods

+ (FakeServer *)sharedInstance {
    static FakeServer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FakeServer new];
    });
    return sharedInstance;
}

+ (void)recordMessage:(NSString *)message forMethod:(NSString *)method {
    [[self sharedInstance] recordMessage:message forMethod:method];
}

+ (NSString *)responseForClientMessage:(NSString *)message {
    return [[self sharedInstance] responseForClientMessage:message];
}

- (void)start {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setConnectionClass:[MyHTTPConnection class]];
    [_httpServer setType:@"_http._tcp."];
    [_httpServer setPort:kPort];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    [_httpServer setDocumentRoot:webPath];
    NSError *error;
    if(![_httpServer start:&error]) {
        //DDLogError(@"Error starting HTTP Server: %@", error);
    }
    
}

+ (NSString *)openRequestURLString {
    NSString *str = [NSString stringWithFormat:@"ws://localhost:%i/service", kPort];
    return str;
}


#pragma mark - Private methods

- (void)recordMessage:(NSString *)message forMethod:(NSString *)method {
    [self writeJSON:message forMethod:method];
}

- (NSString *)responseForClientMessage:(NSString *)message {
    NSString *method = [self.delegate requestMethodFromMessage:message];
    NSString *json = [self readJSONForMethod:method];
    if ([self.delegate respondsToSelector:@selector(jsonWithPrimaryJSON:replacedIDsFromMessage:)]) {
        json = [self.delegate jsonWithPrimaryJSON:json replacedIDsFromMessage:message];
    }
    return json;
}

- (void)writeJSON:(NSString *)json forMethod:(NSString *)method {
    NSString *path = [[self.delegate responsesFolderPath] stringByAppendingString:[NSString stringWithFormat:@"%@", method]];
    NSError *error;
    BOOL success = [json writeToFile:path
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:&error];
    NSString *logMessage;
    if (success) {
        logMessage = [NSString stringWithFormat:@"SocketRecorder: JSON successfully made from method %@", method];
    } else {
        logMessage = [NSString stringWithFormat:@"SocketRecorder: Error! Couldn,t write JSON for method %@", method];
    }
    NSLog(@"%@", logMessage);
}

- (NSString *)readJSONForMethod:(NSString *)method {
    NSError *error;
    NSString *path = [[self.delegate responsesFolderPath] stringByAppendingString:[NSString stringWithFormat:@"%@", method]];
    NSString *str = [NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
    return str;
}

@end

#endif
