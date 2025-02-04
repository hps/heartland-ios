//
//  SObjc.m
//  Heartland-iOS-SDK
//
//

#import "SObjc.h"


@implementation SObjc

TemCommunicationManager * temCommunicationManager;


- (id) init
{
    self = [super init];
    temCommunicationManager = [[TemCommunicationManager alloc] init];
    return self;
}

+ (SObjc *)getInstance{
    static SObjc *sharedInstance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[SObjc alloc] init];
        });
        return sharedInstance;
}


-(void)createSandbox:(NSString *)applicationId
          AndVersion:(NSString *)applicationVersion
               andIp:(NSString *)ip
             andport:(int)port
    andCallingMethod:(int)callingMethod
andAuthorizedActivities:(int)authorizedActivities
andOfflineInstallMode:(int)offlineInstallMode
   andContractNumber:(NSString *)contractNumber
              andSSL:(int)SSL
       andCertClient:(NSString *)certClient
        andKeyClient:(NSString *)keyClient
         andCertServ:(NSString *)CertServ
     andResultBlock : (void (^)(SandboxStatus))resultBlock{
    [temCommunicationManager initTemWithIp:ip andport:port andResultBlock:resultBlock];
}




- (void)createReaderContext:(NSString *)readerStateJson
        AndCompletionBlock : (void (^)(int))completionBlock{
    [temCommunicationManager createReaderContext:readerStateJson AndCompletionBlock:completionBlock];
}

- (void)updateReaderJsonState:(NSString *)readerStateJson AndCompletionBlock:(void (^)(int))completionBlock{
    [temCommunicationManager updateReaderStateJson:readerStateJson AndCompletionBlock:completionBlock];
}

- (void)performCall:(ReasonForCalling)reasonForCalling
 andCompletionBlock:(void (^)(int))completionBlock{
    if(reasonForCalling == ReasonForCallingMANUAL){
        [temCommunicationManager pollForUpdate:completionBlock];
    }else{
        [temCommunicationManager reportFirmwareStatus:completionBlock];
    }
}



-(void)isUpdateAvailable : (NSString *)deviceSerialNumber
          andResultBlock : (void (^)(bool))resultBlock{
    [temCommunicationManager isUpdateAvailable:deviceSerialNumber andResultBlock:resultBlock];
}


-(void)getUpdateFilePath : (NSString *)deviceSerialNumber andResultBlock : (void (^)(NSString *))resultBlock{
    return [temCommunicationManager getUpdateFilePath:deviceSerialNumber andResultBlock:resultBlock];
}

-(void)getRkiFileName : (NSString *)deviceSerialNumber andResultBlock : (void (^)(NSString *))resultBlock{
    return [temCommunicationManager getRkiFileName:deviceSerialNumber andResultBlock:resultBlock];
}

@end
