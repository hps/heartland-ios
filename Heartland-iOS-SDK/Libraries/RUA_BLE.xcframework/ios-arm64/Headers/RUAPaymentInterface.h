/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#ifndef RUAPaymentInterface_h
#define RUAPaymentInterface_h

typedef NS_ENUM(NSInteger, RUAPaymentInterface) {
    
    /**
     * ICC (adaptive mode)
     */
    RUAPaymentInterfaceICC = 0,
    
    /**
     * SAM (adaptive mode)
     */
    RUAPaymentInterfaceSAM = 1,
    
    /**
     * Contacless
     */
    RUAPaymentInterfaceRF = 2,
    
    /**
     * ICC ISO mode
     */
    RUAPaymentInterfaceICCISO = 3,
    
    /**
     * SAM ISO mode
     */
    RUAPaymentInterfaceSAMISO = 4,
    
    /**
     * MifareRF
     */
    RUAPaymentInterfaceMifareRF = 5,
    
};

#endif /* RUAPaymentInterface_h */
