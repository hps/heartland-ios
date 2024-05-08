# Change Log
All notable changes to this project will be documented in this file.

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
