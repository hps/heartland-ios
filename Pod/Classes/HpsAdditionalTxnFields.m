//
//  HpsAdditionalTxnFields.m
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/8/15.
//
//

#import "HpsAdditionalTxnFields.h"

@implementation HpsAdditionalTxnFields
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.invoiceNumber = @"";
    self.customerID = @"";
    self.desc = @"";
    
    return self;
}

- (NSString*) toXML
{    
    NSString *requestXMLhead = @"<hps:AdditionalTxnFields>";
    NSString *requestXMLTail = @"</hps:AdditionalTxnFields>";
    
    NSString *invoiceNumber = [NSString stringWithFormat:@"<hps:InvoiceNbr>%@</hps:InvoiceNbr>", self.invoiceNumber];
    NSString *customerID = [NSString stringWithFormat:@"<hps:CustomerID>%@</hps:CustomerID>", self.customerID];
    NSString *desc = [NSString stringWithFormat:@"<hps:Description>%@</hps:Description>", self.desc];
    
    NSString *xml = [NSString stringWithFormat:@"%@%@%@%@%@", requestXMLhead, invoiceNumber, customerID, desc, requestXMLTail];
    return xml;
}
@end
