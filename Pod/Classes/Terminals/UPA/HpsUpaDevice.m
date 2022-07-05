#import "HpsUpaDevice.h"
#import "HpsTerminalUtilities.h"
#import "HpsTerminalEnums.h"
#import "HpsUpaTcpInterface.h"
#import "NSObject+ObjectMap.h"

@implementation HpsUpaDevice

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
    if ((self = [super init])) {
        self.config = config;
        errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
        switch ((int)self.config.connectionMode) {
            case HpsConnectionModes_TCP_IP: {
                self.interface = [[HpsUpaTcpInterface alloc] initWithConfig:config];
                format = UPA;
                break;
            }
            case HpsConnectionModes_HTTP: {
                format = Visa2nd;
                @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Connection Method not available for UPA devices" userInfo:nil];
                break;
            }
            default: {
                format = Visa2nd;
                @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Connection Method not available for UPA devices" userInfo:nil];
                break;
            }
        }
    }
    return self;
}

    //  Admin

- (void) cancel:(void(^)(id<IHPSDeviceResponse> payload))responseBlock
{
    [self reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
        if (error) {
            responseBlock(nil);
        } else {
            responseBlock(payload);
        }
    }];
}

/// method to force close communication early
/// should only be used during administrative
/// commands like pings (and not transaction requests)
- (void)cancelPendingNetworkRequest {
    [_interface forceCloseStreams];
}

- (void) disableHostResponseBeep:(void(^)(id <IInitializeResponse>, NSError*))responseBlock
{
}

- (void) initialize:(void(^)(id <IInitializeResponse>, NSError*))responseBlock
{
}

- (void) lineItem:(NSString*)leftText withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
    [self lineItem:leftText withRightText:nil withResponseBlock:responseBlock];
}

- (void) lineItem:(NSString*)leftText withRightText:(NSString*)rightText withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_LINE_ITEM_DISPLAY ];
    request.data.EcrId = @"13";
    request.data.requestId = @"123";
    request.data.data = [[HpsUpaData alloc] init];
    request.data.data.params = [[HpsUpaParams alloc] init];
    request.data.data.params.lineItemLeft = leftText;
    request.data.data.params.lineItemRight = rightText;

    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];

    [self.interface send:data andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];
}

- (void) ping:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = @"Ping";
    request.data.EcrId = @"13";
    request.data.requestId = @"123";

    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];

    [self.interface send:data andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];
}

- (void) openLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
}

- (void) closeLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
}

- (void) reboot:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_REBOOT ];
    request.data.EcrId = @"13";
    request.data.requestId = @"123";

    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];

    [self.interface send:data andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];

}

- (void) reset:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_RESET ];
    request.data.EcrId = @"13";
    request.data.requestId = @"123";

    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];

    [self.interface send:data andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];
}

- (void) setSAFMode:(BOOL)isSAF response:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
}

- (void) GetLastResponse:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
}

#pragma mark -
#pragma mark Transactions

-(void)processTransactionWithRequest:(HpsUpaRequest*)HpsUpaRequest withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities BuildRequest:[HpsUpaRequest JSONString] withFormat:format];

    [self.interface send:request andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];
}
#pragma mark -
#pragma mark EOD
-(void)processEndOfDay:(void(^)(HpsUpaResponse*, NSError*))responseBlock
{
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_EXECUTE_EOD ];
    request.data.EcrId = @"13";
    request.data.requestId = @"123";

    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];

    [self.interface send:data andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];
}
//#pragma mark -
//#pragma mark SAF
//-(void)sendStoreAndForward:(void(^)(HpsUpaResponse*, NSError*))responseBlock
//{
//    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
//    request.message = @"MSG";
//    request.data = [[HpsUpaCommandData alloc] init];
//    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_SEND_SAF ];
//    request.data.EcrId = @"13";
//    request.data.requestId = @"123";
//
//    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];
//
//    [self.interface send:data andResponseBlock:^(JsonDoc *data, NSError *error) {
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                responseBlock(nil, error);
//            });
//            return;
//        }
//
//        //done
//        NSString *dataview = [data toString];
//        NSLog(@"response json = \n  : %@", dataview);
//        HpsUpaResponse *response;
//
//        @try {
//            //parse data
//
//            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                responseBlock(response, nil);
//            });
//        } @catch (NSException *exception) {
//            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
//            NSError *error = [NSError errorWithDomain:self->errorDomain
//                                                 code:CocoaError
//                                             userInfo:userInfo];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                responseBlock(nil, error);
//            });
//        }
//    }];
//}
//  #pragma mark -
#pragma mark Get Diagnostic Report
- (void) getDiagnosticReport:(void(^)(HpsUpaResponse*, NSError*))responseBlock{

    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_GET_INFO_REPORT ];
    request.data.EcrId = @"13";
    request.data.requestId = @"123";

    id<IHPSDeviceMessage> data = [HpsTerminalUtilities BuildRequest:request.JSONString withFormat:format];

    [self.interface send:data andUPAResponseBlock:^(JsonDoc *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
            return;
        }

        //done
        NSString *dataview = [data toString];
        NSLog(@"response json = \n  : %@", dataview);
        HpsUpaResponse *response;

        @try {
            //parse data

            response = [[HpsUpaResponse alloc]initWithJSONDoc:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(response, nil);
            });
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }
    }];
}

#pragma mark -
#pragma mark Random Number Generator
-(int)generateNumber {

    return arc4random_uniform(999999999);
}

#pragma mark -
#pragma mark Private Methods

-(id)getValueOfObject:(id)value{

    return value == NULL?(id)@"":value;
}

-(void)printRecipt:(HpsTerminalResponse*)response
{
    NSMutableString *recipt = [[NSMutableString alloc]init];

    [recipt appendString:[NSString stringWithFormat:@"x_trans_type=%@",[self getValueOfObject:response.transactionType]]] ;
    [recipt appendString:[NSString stringWithFormat:@"&x_application_label=%@",[self getValueOfObject:response.applicationName]]];
    if (response.maskedCardNumber)[recipt appendString:[NSString stringWithFormat: @"&x_masked_card=************%@",response.maskedCardNumber]];
    else [recipt appendString:[NSString stringWithFormat: @"&x_masked_card="]];
    [recipt appendString:[NSString stringWithFormat:@"&x_application_id=%@",[self getValueOfObject:response.applicationId]]];

    switch (response.applicationCryptogramType)
    {
        case TC:
        [recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type=TC"]];
        break;
        case ARQC:
        [recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type=ARQC"]];
        break;
        default:
        [recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type="]];
        break;
    }

    [recipt appendString:[NSString stringWithFormat:@"&x_application_cryptogram=%@",[self getValueOfObject:response.applicationCrytptogram]]];
    [recipt appendString:[NSString stringWithFormat:@"&x_expiration_date=%@",[self getValueOfObject:response.expirationDate]]];
    [recipt appendString:[NSString stringWithFormat:@"&x_entry_method=%@",[HpsTerminalEnums entryModeToString:response.entryMode]]];
    [recipt appendString:[NSString stringWithFormat:@"&x_approval=%@",[self getValueOfObject:response.approvalCode]]];
    [recipt appendString:[NSString stringWithFormat:@"&x_transaction_amount=%@",response.transactionAmount.stringValue]];
    [recipt appendString:[NSString stringWithFormat:@"&x_amount_due=%@",response.amountDue.stringValue]];
    [recipt appendString:[NSString stringWithFormat:@"&x_customer_verification_method=%@",[self getValueOfObject:response.cardHolderVerificationMethod]]];
    [recipt appendString:[NSString stringWithFormat:@"&x_signature_status=%@",[self getValueOfObject:response.signatureStatus]]];
    [recipt appendString:[NSString stringWithFormat:@"&x_response_text=%@",[self getValueOfObject:response.responseText]]];
    
    NSLog(@"Recipt = %@", recipt);
}


@end
