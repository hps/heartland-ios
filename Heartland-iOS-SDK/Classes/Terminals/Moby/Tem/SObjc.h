//
//  SObjc.h
//  Heartland-iOS-SDK
//
//

#import <Foundation/Foundation.h>
#import <TemCommunicationManager.h>

@class Sandbox;

NS_ASSUME_NONNULL_BEGIN


@interface SObjc : NSObject


+(SObjc *)getInstance;


/**
 Method in order to create sandbox for tem library
 Return an error if a problem occured, nil otherwise
 */
-(void) createSandbox : (NSString *) applicationId
                         AndVersion : (NSString *) applicationVersion
                              andIp : (NSString *) ip
                            andport : (int) port
                   andCallingMethod : (int) callingMethod
            andAuthorizedActivities : (int) authorizedActivities
              andOfflineInstallMode : (int) offlineInstallMode
                  andContractNumber : (NSString*) contractNumber
                             andSSL : (int) SSL
                      andCertClient : (NSString*) certClient
                       andKeyClient : (NSString *)keyClient
                        andCertServ : (NSString*) CertServ
                     andResultBlock : (void (^)(SandboxStatus))resultBlock;



-(void)createReaderContext:(NSString *)readerStateJson AndCompletionBlock : (void (^)(int))completionBlock;

-(void)updateReaderJsonState:(NSString *)readerStateJson AndCompletionBlock : (void (^)(int))completionBlock;

-(void) performCall : (ReasonForCalling) reasonForCalling
 andCompletionBlock : (void (^) (int)) completionBlock;


-(void)isUpdateAvailable: (NSString *)deviceSerialNumber andResultBlock : (void (^)(bool))resultBlock;


-(void)getUpdateFilePath: (NSString *)deviceSerialNumber andResultBlock : (void (^)(NSString *))resultBlock;

-(void)getRkiFileName: (NSString *)deviceSerialNumber andResultBlock : (void (^)(NSString *))resultBlock;

@end

NS_ASSUME_NONNULL_END
