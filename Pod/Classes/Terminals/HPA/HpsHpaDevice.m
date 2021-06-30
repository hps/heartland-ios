#import "HpsHpaDevice.h"
#import "HpsTerminalUtilities.h"
#import "HpsTerminalEnums.h"
#import "HpsHpaTcpInterface.h"
#import "NSObject+ObjectMap.h"

//#define DISABLE_HOST_RESPONSE_BEEP @""

@implementation HpsHpaDevice

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
	if((self = [super init]))
		{
		self.config = config;
		errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
		switch ((int)self.config.connectionMode) {

			case HpsConnectionModes_TCP_IP:
			{
			self.interface = [[HpsHpaTcpInterface alloc] initWithConfig:config];
			format = HPA;
			break;
			}
			case HpsConnectionModes_HTTP:
			{
			format = Visa2nd;
			@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Connection Method not available for HPA devices" userInfo:nil];
			break;
			}
			default:
			{
			format = Visa2nd;
			@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Connection Method not available for HPA devices" userInfo:nil];
			}
				break;
		}

		}
	return self;
}

	//  Admin

- (void) cancel:(void(^)(id<IHPSDeviceResponse> payload))responseBlock{
	[self reset:^(id<IHPSDeviceResponse> payload, NSError *error)
	 {
		if (error)
			{
			responseBlock(nil);
			}else {
				responseBlock(payload);
			}
	 }];
}

- (void) disableHostResponseBeep:(void(^)(id <IInitializeResponse>, NSError*))responseBlock{
}

- (void) initialize:(void(^)(id <IInitializeResponse>, NSError*))responseBlock{

	NSString *strInitialize = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>GetAppInfoReport</Request><RequestId>%d</RequestId></SIP>",[self generateNumber]];

	id<IHPSDeviceMessage> request	= [HpsTerminalUtilities	BuildRequest:strInitialize withFormat:format];

	NSLog(@"Step 2");
	[self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"Step 4 with Error");

				responseBlock(nil, error);
			});
		}else{
			NSLog(@"Step 4 without Error");

				//done
			NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"response xml = \n  : %@", dataview);
			HpsHpaInitializeResponse *response;
			@try {
					//parse data

				response = [[HpsHpaInitializeResponse alloc]initWithHpaInitializeResponse:data withParameters:nil];
				dispatch_async(dispatch_get_main_queue(), ^{
					responseBlock(response, nil);
				});
			} @catch (NSException *exception) {
				NSLog(@"anurag exception =%@",exception);
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

- (void) openLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{

	NSString *strLaneOpen = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>LaneOpen</Request><RequestId>%d</RequestId></SIP>",[self generateNumber]];

	id<IHPSDeviceMessage> request	= [HpsTerminalUtilities	BuildRequest:strLaneOpen withFormat:format];

	[self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				responseBlock(nil, error);
			});
		}else{
				//done
			NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"response xml = \n  : %@", dataview);
			HpsHpaDeviceResponse *response;
			@try {
					//parse data

				response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];
					//response = [[HpsHpsHpaDeviceResponse alloc] initWithMessageID:A27_RSP_REBOOT andBuffer:data];
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

- (void) closeLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{

	NSString *strLaneClose = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>LaneClose</Request><RequestId>%d</RequestId></SIP>",[self generateNumber]];

	id<IHPSDeviceMessage> request	= [HpsTerminalUtilities	BuildRequest:strLaneClose withFormat:format];

	[self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				responseBlock(nil, error);
			});
		}else{
				//done
			NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"response xml = \n  : %@", dataview);
			HpsHpaDeviceResponse *response;
			@try {
					//parse data

				response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];

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

- (void) reboot:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{

	NSString *strReboot = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>Reboot</Request><RequestId>%d</RequestId></SIP>",[self generateNumber]];

	id<IHPSDeviceMessage> request	= [HpsTerminalUtilities	BuildRequest:strReboot withFormat:format];

	[self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				responseBlock(nil, error);
			});
		}else{
				//done
			NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"response xml = \n  : %@", dataview);
			HpsHpaDeviceResponse *response;
			@try {
					//parse data

				response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];

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

- (void) reset:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{

	NSString *strReset = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>Reset</Request><RequestId>%d</RequestId></SIP>",[self generateNumber]];

	id<IHPSDeviceMessage> request	= [HpsTerminalUtilities	BuildRequest:strReset withFormat:format];

	[self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				responseBlock(nil, error);
			});
		}else{
				//done
			NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"response xml = \n  : %@", dataview);
			HpsHpaDeviceResponse *response;
			@try {
					//parse data
				response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];

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

- (void) setSAFMode:(BOOL)isSAF response:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{
    NSLog(@"SAF Mode : %d",isSAF);
    NSString *strSetSAFMode = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>SetParameter</Request><RequestId>%d</RequestId><FieldCount>1</FieldCount><Key>STORMD</Key><Value>%d</Value></SIP>",[self generateNumber],isSAF?1:0];
    
    id<IHPSDeviceMessage> request    = [HpsTerminalUtilities    BuildRequest:strSetSAFMode withFormat:format];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"response xml = \n  : %@", dataview);
            HpsHpaDeviceResponse *response;
            @try {
                //parse data
                response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];
                
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

- (void) GetLastResponse:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{
    
    NSString *strGetLastResponse = [NSString stringWithFormat:@"<SIP><Version>1.0</Version><ECRId>1004</ECRId><Request>GetLastResponse</Request><RequestId>%d</RequestId></SIP>",[self generateNumber]];
    
    id<IHPSDeviceMessage> request    = [HpsTerminalUtilities    BuildRequest:strGetLastResponse withFormat:format];
  [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"response xml = \n  : %@", dataview);
            HpsHpaDeviceResponse *response;
            @try {
                //parse data
                response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];
                
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

-(void)processTransactionWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock
{
	id<IHPSDeviceMessage> request	= [HpsTerminalUtilities	BuildRequest:HpsHpaRequest.XMLString withFormat:format];

	[self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				responseBlock(nil, error);
			});
		}else{
				//done
			NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"response xml = \n  : %@", dataview);
			HpsHpaDeviceResponse *response;
			@try {
					//parse data

				response = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:data withParameters:nil];

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
#pragma mark EOD
-(void)processEODWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(HpsHpaEodResponse*, NSError*))responseBlock
{
    id<IHPSDeviceMessage> request    = [HpsTerminalUtilities    BuildRequest:HpsHpaRequest.XMLString withFormat:format];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"response xml = \n  : %@", dataview);
            
            HpsHpaEodResponse *response;
            @try {
                //parse SAF data
                response = [[HpsHpaEodResponse alloc]initWithHpaEodResponse:data];
                
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
#pragma mark SAF

-(void)processSAFWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(HpsHpaSafResponse*, NSError*))responseBlock
{
    id<IHPSDeviceMessage> request    = [HpsTerminalUtilities    BuildRequest:HpsHpaRequest.XMLString withFormat:format];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(nil, error);
            });
        }else{
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"response xml = \n  : %@", dataview);
            HpsHpaSafResponse *response;
            @try {
                //parse SAF data
                response = [[HpsHpaSafResponse alloc]initWithHpaSafResponse:data];
                
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
#pragma mark Get Diagnostic Report
- (void) getDiagnosticReport:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(HpsHpaDiagnosticResponse*, NSError*))responseBlock{
    
    id<IHPSDeviceMessage> request    = [HpsTerminalUtilities    BuildRequest:HpsHpaRequest.XMLString withFormat:format];
    
    [self.interface send:request andResponseBlock:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                responseBlock(nil, error);
            });
        }else{
            
            //done
            NSString *dataview = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"response xml = \n  : %@", dataview);
            HpsHpaDiagnosticResponse *response;
            @try {
                //parse data
                response = [[HpsHpaDiagnosticResponse alloc] initWithResponse:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    responseBlock(response, nil);
                });
                
            } @catch (NSException *exception) {
                NSLog(@"exception =%@",exception);
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
