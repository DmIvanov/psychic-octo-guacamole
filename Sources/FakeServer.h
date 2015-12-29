//
//  FakeServer.h
//  Created by Dmitry Ivanov on 27.12.15.
//

@protocol FakeServerDelegate <NSObject>

/**
 папка для записи на диске
*/
- (NSString *)responsesFolderPath;

/**
 метод из запроса к серверу
 @param message - JSON запроса на вервер
 */
- (NSString *)requestMethodFromMessage:(NSString *)message;

@optional
/**
 если необходимо, чтоб айди запроса совпадал с айди кэшированного ответа, 
 в этом методе нужно осуществить замену
 @param primaryJSON - JSON из кэша
 @param message - запрос на сервер, айдишники из которого нужно подставить в primaryJSON
 */
- (NSString *)jsonWithPrimaryJSON:(NSString *)primaryJSON replacedIDsFromMessage:(NSString *)message;

@end


@interface FakeServer : NSObject

@property (nonatomic, strong) id<FakeServerDelegate> delegate;

+ (FakeServer *)sharedInstance;

/**
 URL по которому нужно открывать сокет с клиента
*/
+ (NSString *)openRequestURLString;

/**
 записать ответ от сервера на диск (в кэш) для последующего использования
 */
+ (void)recordMessage:(NSString *)message forMethod:(NSString *)method;



/**
 запуск фэйкового сервера с сокетом
*/
- (void)start;

@end
