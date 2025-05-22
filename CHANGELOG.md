# Change Log
All notable changes to this project will be documented in this file.

## 2.1.3 2025-05-22
- iOS SDK: Fixed BBPOS incorrect card charged

## 2.1.2 2025-03-24
- iOS SDK: Fixing Surcharge fee calculation rounding up

## 2.1.1 2025-02-12
- iOS SDK: Fixing Default Timeout for UPA Device Connection

## 2.1.0 2025-02-04
- iOS SDK: Implemlentation of Moby/Ingenico Transactions.
- iOS SDK: Allow Surcharge less than 3%
- iOS SDK: Adding BanckRespCode to UPA response
- iOS SDK: Allowing JSON access to Portico Response for UPA.
- iOS SDK: Adding ClientTransactionId to Portico Response.

## 2.0.27 2024-08-21
- iOS SDK: Duplicated transaction due to Surcharge lookup result.

## 2.0.26 2024-08-19
- iOS SDK: Surcharge Fix under card reader.

## 2.0.25 2024-08-09
- iOS SDK: Surcharge Confirmation value improvement.

## 2.0.24 2024-07-24
- iOS SDK: Implement surchargeRequested parameter for integrators.

## 2.0.23 2024-07-08
- iOS SDK: Fixing tipAmount response for Tip Adjust transaction

## 2.0.22 2024-06-06
- iOS SDK: Fixing isSurchargeEnabled item for allow null

## 2.0.21 2024-06-04
- iOS SDK: Fixing the Pax Cancel Response

## 2.0.20 2024-05-14
- iOS SDK: Pax_Enable port 10010 for HTTP Cancel

## 2.0.19 2024-05-09
- iOS SDK: Pax_Cancel Command on HTTP Mode
- iOS SDK: Pay App New Sale and Refund Parameters
- iOS SDK: HPA / iOS SDK - TSI and TVR fields are not returned in the response

## 2.0.18 2024-04-25
- iOS SDK: Fix for C3X/C2X Surcharge 

## 2.0.16 2024-03-21
- iOS SDK: Pay App (UPA) - Add DeletePreAuth 
- iOS SDK: Add fallback to Pay App 2.18
- iOS SDK: Add ServiceCode Parameter to Pay App
- Updated the expDate parameter to expiryDate
- iOS SDK: C3X/C2X Surcharge 

## 2.0.15 2024-02-22
- C2X/C3X - Add RKI and update Configuration file
- Update code to allow for Firmware delegates to be accessible in Objc-C
- Iframe sample
- Cancel/ Reset command does nothing

## 2.0.13 2023-10-03
- UPA -  Test SAFType on SendSAF
- Verify SDKs for PAX
- C2X Issuer Response Code incorrect
- PAX-Support response code 000002 - PARTIALLY APPROVED
- C3X - GlobalMobileSDK to Heartland-iOS-SDK
- C3X - Update Heartland-iOS-SDK to support C3X Device
- C2X - OTA Configuration Update
- Added Transaction ID on Sample App Transaction Screen.
- Added Allow Partial Auth Toggle on Sample App Transaction Screen.
- Added Healthcare fields on Sample App Transaction Screen.

## 2.0.12 2023-08-22
- Improved the C2X Sample App
- Added UPA Sample App
- Removed ClerkID from TipAdjust Input Parameters 
- Added responseText and responseCode to Sale Output Parameters 
- Removed cardIsHSAFSA from UPA input parameters 
- Fixed Partial Refund Bug for PreAuth Transactions
- Added the DeleteSAF Feature  
- Added safReferenceNumber to SendSAF and GetSAFReport - Output Parameters

## 2.0.11 2023-07-06
- Added referenceNumber to TipAdjust Input Parameters
- Added PAX Parse ECR Ref number on Trace Number

## 2.0.10 2023-06-29
- Added isConnected method for checking if device is connected. C2X

## 2.0.9 2023-06-13
### Added
- Added UPA Signature Data. (US349346)
- Added UPA Pay App Canada (US346223)
- iOS SDK: C2X Refund Reversal (US359118)
- Bug fixes and improvements.

## 2.0.8 2023-05-23
### Added
- Added Timeout functionality to PayApp TCP connection. (US344949)
- Added token and card brand transaction id to the response for Pax. (US345636)


### Changed
 
### Fixed

## 2.0.10 2023-06-29
- Bug fixes and improvements.
