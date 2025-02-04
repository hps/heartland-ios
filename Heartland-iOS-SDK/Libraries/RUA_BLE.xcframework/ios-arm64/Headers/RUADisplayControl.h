/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>


typedef enum {
    
	/** 0: EMVL1 Ingenico Proprietary character defined in Appendix A Section 11.1. */
	RUADisplayTextCharsetEMVL1,
	/** 1: EMVL2 Character Set (ISO 8859_1 + Euro Symbol) defined in Appendix A Section 11.2 */
	RUADisplayTextCharsetEMVL2,
    /** 9: EMVL9 Character Set (ISO 8859_9) - Identical to ISO 8859_9 but with support for Polish characters */
    RUADisplayTextCharsetEMVL9
} RUADisplayTextCharset;

/**
 * DisplayControl provides interface to control the display of ROAM device.<br>
 */
@protocol RUADisplayControl <NSObject>
/**
 * This method turns on the LCD of the back light PIN Pad
 *
 * @param enable                true to turn on the back light
 * @param response              OnResponse block
 */
- (void)enableBackLight:(BOOL)enable response:(OnResponse _Nonnull)response;

/**
 * This method clears the text that is being displayed on the screen
 *
 * @param response              OnResponse block
 */
- (void)clearDisplay:(OnResponse _Nonnull)response;


/**
 * This method starts the screen saver if the device supports
 *
 * @param response              OnResponse block
 */
- (void)startScreensaver:(OnResponse _Nonnull)response;

/**
 * This method stop the screen saver if the device supports
 *
 * @param response              OnResponse block
 */
- (void)stopScreensaver:(OnResponse _Nonnull)response;

/**
 * This method sets the display of the LCD on the PIN pad device
 *
 * @param mode                  ‘00’ for 4 lines, 16 columns. ‘01' for 8 lines, 16 columns.
 *                              ‘02’ for 8 lines, 21 columns.
 * @param response              OnResponse block
 */
- (void)setDisplayMode:(NSString * _Nonnull)mode response:(OnResponse _Nonnull)response;


/**
 * This method sets the back light control on the PIN pad device
 *
 * @param enableOnStartup       Enable on startup
 * @param backlightBrightness   Backlight brightness
 * @param response              OnResponse block
 */
- (void)setBackLightControl:(BOOL)enableOnStartup brightness:(Byte)backlightBrightness response:(OnResponse _Nonnull)response;

/**
 * This method writes the text to the LCD at the specified row and column,
 *
 * @param row                   Row number
 * @param column                Column number
 * @param charset               RUADisplayTextCharset.EMVL1 or DisplayTextCharset.EMVL2
 * @param text                  Textstring
 * @param response              OnResponse block
 */
- (void)writeText:(int)row column:(int)column charset:(RUADisplayTextCharset)charset test:(NSString * _Nonnull)text response:(OnResponse _Nonnull)response;

/**
 * This method returns the device to the home screen.
 *
 * @param response              OnResponse block
 */
- (void)returnToHomeScreen:(OnResponse _Nonnull)response;

/**
 * This method displays a custom menu screen and allows the user to select an option.
 * The map passed to the onResponse callback contains the RUAParameterCustomMenuSelectionResponse parameter as the key for the index of the menu selection (index starting at 1)
 *
 * @param menuTitle             title for the custom menu screen
 * @param menuOptions           a list of options to be shown on the device screen
 * @param menuCharset           code table to use for the menu screen title and options
 * @param respone               OnResponse block
 */
- (void)showMenuOptions:(NSString * _Nonnull)menuTitle options:(NSArray * _Nonnull)menuOptions charset:(RUADisplayTextCharset)menuCharset response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that displays a background image. The background image should be pre-loaded in USCFG otherwise there will be no image displayed.<br>
 Note: This command is supported on MOBY8500 v11.11 or above only.
 @param imageName image name in ASCII
 @param response OnResponse block
 */
-(void)changeBackgroundImage:(NSString * _Nonnull)imageName respone:(OnResponse _Nonnull)response;


@end
