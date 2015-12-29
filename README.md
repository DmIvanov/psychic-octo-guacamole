# psychic-octo-guacamole
Simple web socket mock server

Server init and start:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FakeServer sharedInstance].delegate = [FakeServerDelegate new];
    [[FakeServer sharedInstance] start];
    ...
}

Record message:

```objc
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    ...
    [FakeServer recordMessage:message forMethod:method];
    ...
}
