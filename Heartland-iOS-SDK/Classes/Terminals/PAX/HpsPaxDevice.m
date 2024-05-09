#import "HpsPaxDevice.h"
#import "HpsPaxMessageIDs.h"
#import "HpsTerminalUtilities.h"
#import "HpsTerminalEnums.h"
#import "HpsPaxTcpInterface.h"
#import "HpsPaxLocalDetailResponse.h"

@implementation HpsPaxDevice

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
    if((self = [super init]))
    {
        self.config = config;
        errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
        portForCancellingTransaction = @"10010";
        portForRunningTransaction = @"10009";
        switch ((int)self.config.connectionMode) {
                
            case HpsConnectionModes_TCP_IP:
            {
                self.interface = [[HpsPaxTcpInterface alloc] initWithConfig:config];
                break;
            }
            case HpsConnectionModes_HTTP:
            {
                self.interface = [[HpsPaxHttpInterface alloc] initWithConfig:config];
                break;
            }
            default:
            {
                
            }
        }
        
    }
    return self;
}

#pragma mark -
#pragma Admin functions
- (void) initialize:(void(^)(HpsPaxInitializeResponse*, NSError*))responseBlock{
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:A00_INITIALIZE];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpsPaxInitializeResponse *response;
            @try {
                //parse data
                response = [[HpsPaxInitializeResponse alloc] initWithBuffer:data];
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
        }
    }];
}

//void results or error
- (void) cancel:(void(^)(NSError*))responseBlock{
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:A14_CANCEL];
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpsPaxInitializeResponse *response;
            @try {
                //parse data
                response = [[HpsPaxInitializeResponse alloc] initWithBuffer:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    responseBlock(nil);
                });
            } @catch (NSException *exception) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
                NSError *error = [NSError errorWithDomain:self->errorDomain
                                                     code:CocoaError
                                                 userInfo:userInfo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    responseBlock(error);
                });
            }
        }
    }];
}

- (void) reset:(void(^)(HpsPaxDeviceResponse*, NSError*))responseBlock{
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:A16_RESET];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpsPaxDeviceResponse *response;
            @try {
                //parse data
                response = [[HpsPaxDeviceResponse alloc] initWithMessageID:A17_RSP_RESET andBuffer:data];
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
        }
    }];
}

- (void) batchClose:(void(^)(HpsPaxBatchCloseResponse*, NSError*))responseBlock
{
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:B00_BATCH_CLOSE];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpsPaxBatchCloseResponse *response;
            @try {
                //parse data
                response = [[HpsPaxBatchCloseResponse alloc] initWithBuffer:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self printRecipt:response];
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
        }
    }];
    
}

- (void) reboot:(void(^)(HpsPaxDeviceResponse*, NSError*))responseBlock{
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:A26_REBOOT];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpsPaxDeviceResponse *response;
            @try {
                //parse data
                response = [[HpsPaxDeviceResponse alloc] initWithMessageID:A27_RSP_REBOOT andBuffer:data];
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
        }
    }];
}

- (void) setSafMode:(SafMode)safMode withResponseBlock:(void(^)(HpsPaxDeviceResponse*, NSError*))responseBlock{
    
    NSString *strSafMode = [NSString stringWithFormat:@"%ld",(long)safMode];
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    [commands addObject:strSafMode];
    NSString* fs_code = [HpsTerminalEnums controlCodeString:HpsControlCodes_FS];
    for (int i = 0; i < 10 ; i++) {
        [commands addObject:fs_code];
        [commands addObject:@""];
    }
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:A54_SET_SAF_PARAMETERS withElements:commands];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpsPaxDeviceResponse *response;
            @try {
                //parse data
                response = [[HpsPaxDeviceResponse alloc] initWithMessageID:A55_RSP_SET_SAF_PARAMETERS andBuffer:data];
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
        }
    }];
}

- (void) safUpload:(SafIndicator)safIndicator withResponseBlock:(void(^)(HpaPaxSafUploadResponse*, NSError*))responseBlock{
    
    NSString *strSafIndicator = [NSString stringWithFormat:@"%ld",(long)safIndicator];
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    [commands addObject:strSafIndicator];
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:B08_SAF_UPLOAD withElements:commands];
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpaPaxSafUploadResponse *response;
            @try {
                //parse data
                response = [[HpaPaxSafUploadResponse alloc] initWithBuffer:data];
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
        }
    }];
}

- (void) safDelete:(SafIndicator)safIndicator withResponseBlock:(void(^)(HpaPaxSafDeleteResponse*, NSError*))responseBlock{
    
    NSString *strSafIndicator = [NSString stringWithFormat:@"%ld",(long)safIndicator];
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    [commands addObject:strSafIndicator];
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:B10_DELETE_SAF_FILE withElements:commands];
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpaPaxSafDeleteResponse *response;
            @try {
                //parse data
                response = [[HpaPaxSafDeleteResponse alloc] initWithBuffer:data];
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
        }
    }];
}

- (void) safReport:(SafIndicator)safIndicator withResponseBlock:(void(^)(HpaPaxSafReportResponse*, NSError*))responseBlock{
    
    NSString *strSafIndicator = [NSString stringWithFormat:@"%ld",(long)safIndicator];
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    [commands addObject:strSafIndicator];
    
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:R10_SAF_SUMMARY_REPORT withElements:commands];
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"data returned: %@", dataview);
            HpaPaxSafReportResponse *response;
            @try {
                //parse data
                response = [[HpaPaxSafReportResponse alloc] initWithBuffer:data];
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
        }
    }];
}



#pragma mark -
#pragma mark Transactions

- (void) doCredit:(NSString*)txnType
     andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock{
    
    //Blocks call chain
    [self doTransaction:T00_DO_CREDIT andTxnType:txnType andSubGroups:subGroups withResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                NSLog(@"data returned: %@", dataview);
                
                HpsPaxCreditResponse *response = [[HpsPaxCreditResponse alloc] initWithBuffer:data];
                
                [self printRecipt:response];
                responseBlock(response, error);
            });
        }
        
        
    }];
}

- (void) doDebit:(NSString*)txnType
    andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxDebitResponse*, NSError*))responseBlock{
    
    //Blocks call chain
    [self doTransaction:T02_DO_DEBIT andTxnType:txnType andSubGroups:subGroups withResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            dispatch_async(dispatch_get_main_queue(), ^{
                HpsPaxDebitResponse *response = [[HpsPaxDebitResponse alloc] initWithBuffer:data];
                [self printRecipt:response];
                responseBlock(response, error);
            });
        }
        
        
    }];
}

- (void) doGift:(NSString*)messageId
    withTxnType:(NSString*)txnType
   andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxGiftResponse*, NSError*))responseBlock{
    
    //Blocks call chain
    [self doTransaction:messageId andTxnType:txnType andSubGroups:subGroups withResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            dispatch_async(dispatch_get_main_queue(), ^{
                HpsPaxGiftResponse *response = [[HpsPaxGiftResponse alloc] initWithBuffer:data];
                [self printRecipt:response];
                responseBlock(response, error);
            });
        }
        
    }];
}

- (void) doReport:(NSString*)edcType
   andSearchInput:(NSDictionary*)searchInputDict
     andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxLocalDetailResponse*, NSError*))responseBlock
{
    [self doReportTransaction:(NSString *)R02_LOCAL_DETAIL_REPORT andEdcType:edcType andSearchInput:searchInputDict andSubGroups:subGroups withResponseBlock:^(NSData *data, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            dispatch_async(dispatch_get_main_queue(), ^{
                HpsPaxLocalDetailResponse *response = [[HpsPaxLocalDetailResponse alloc]initWithBuffer:data];
                [self printRecipt:response];
                responseBlock(response, error);
            });
        }
        
    }];
}

#pragma mark -
#pragma mark Private Methods

- (void) doTransaction:(NSString*)messageId
            andTxnType:(NSString*)txnType
          andSubGroups:(NSArray*)subGroups
     withResponseBlock:(void(^)(NSData*, NSError*))responseBlock{
    
    //load commands
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    [commands addObject:txnType];
    
    [commands addObject:[NSString stringWithFormat:@"%c",HpsControlCodes_FS]];
    if (subGroups.count > 0) {
        [commands addObject:[subGroups objectAtIndex:0]];
        for (int i = 1; i < subGroups.count ; i++) {
            
            [commands addObject:[NSString stringWithFormat:@"%c",HpsControlCodes_FS]];
            [commands addObject:[subGroups objectAtIndex:i]];
        }
    }else{
        [commands addObject:[NSString stringWithFormat:@"%c",HpsControlCodes_FS]];
    }
    
    //Run on device
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:messageId withElements:commands];
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            //NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            // NSLog(@"data returned device: %@", dataview);
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(data, nil);
            });
        }
    }];
}

#pragma mark - Report
#pragma mark Private Methods

- (void) doReportTransaction:(NSString*)messageId
                  andEdcType:(NSString*)edcType
              andSearchInput:(NSDictionary*)searchInputDict
                andSubGroups:(NSArray*)subGroups
           withResponseBlock:(void(^)(NSData*, NSError*))responseBlock{
    
    NSString* fs_code = [HpsTerminalEnums controlCodeString:HpsControlCodes_FS];
    //load commands
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    [commands addObject:edcType];
    [commands addObject:fs_code];
    [commands addObject:[searchInputDict valueForKey:PAX_SEARCH_CRITERIA_toString[TRANSACTION_TYPE]]];
    [commands addObject:fs_code];
    [commands addObject:[searchInputDict valueForKey:PAX_SEARCH_CRITERIA_toString[CARD_TYPE]]];
    [commands addObject:fs_code];
    [commands addObject:[searchInputDict valueForKey:PAX_SEARCH_CRITERIA_toString[RECORD_NUMBER]]];
    [commands addObject:fs_code];
    [commands addObject:[searchInputDict valueForKey:PAX_SEARCH_CRITERIA_toString[TERMINAL_REFERENCE_NUMBER]]];
    [commands addObject:fs_code];
    [commands addObject:[searchInputDict valueForKey:PAX_SEARCH_CRITERIA_toString[AUTH_CODE]]];
    [commands addObject:fs_code];
    [commands addObject:[searchInputDict valueForKey:PAX_SEARCH_CRITERIA_toString[REFERENCE_NUMBER]]];
    [commands addObject:fs_code];
    
    if (subGroups.count > 0) {
        [commands addObject:[subGroups objectAtIndex:0]];
        for (int i = 1; i < subGroups.count ; i++) {
            
            [commands addObject:fs_code];
            [commands addObject:[subGroups objectAtIndex:i]];
        }
    }else{
        [commands addObject:fs_code];
    }
    
    //Run on device
    id<IHPSDeviceMessage> request = [HpsTerminalUtilities buildRequest:messageId withElements:commands];
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            //NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            // NSLog(@"data returned device: %@", dataview);
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(data, nil);
            });
        }
    }];
}


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

- (void)interfaceCancelPendingTask {
    if (!_interface || ![(NSObject *)_interface isKindOfClass:HpsPaxHttpInterface.class]) {
        return;
    }
    
    HpsPaxHttpInterface *httpInterface = (HpsPaxHttpInterface *)_interface;
    
    [httpInterface cancelPendingTask];
}

@end
