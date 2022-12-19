#import "HpsBinaryDataScanner.h"
// NS byte order stuff is not useful here -- CF byte order ensures we're always dealing
// with the right size on either 32 or 64 bit platforms.
#import <CoreFoundation/CFByteOrder.h>

@interface HpsBinaryDataScanner (Private)

-(id)initWithData:(NSData*)data littleEndian:(BOOL)littleEndian defaultEncoding:(NSStringEncoding)defaultEncoding;
-(NSException *)buildScanException;
-(void)moveBy:(NSUInteger)count;

@end

@implementation HpsBinaryDataScanner (Private)

-(id)initWithData:(NSData*)initData littleEndian:(BOOL)isLittleEndian defaultEncoding:(NSStringEncoding)theDefaultEncoding
{
    self = [super init];
    if (self != nil)
    {
        data = [initData copy];
        littleEndian = isLittleEndian;
        encoding = theDefaultEncoding;
        current = (const uint8_t *) [data bytes];
        scanRemain = [data length];
    }
    return self;
}

-(void)moveBy:(NSUInteger)count
{
    if (scanRemain < count)
    {
        @throw [self buildScanException];
    }
    
    scanRemain -= count;
    current += count;
}

-(NSException *)buildScanException
{
    return [NSException exceptionWithName:@"HpsScanException" reason:@"Failure scanning desired information from the bytes." userInfo:nil];
}

@end

@implementation HpsBinaryDataScanner

+(id)binaryDataScannerWithData:(NSData*)data littleEndian:(BOOL)littleEndian defaultEncoding:(NSStringEncoding)defaultEncoding
{
    return [[HpsBinaryDataScanner alloc] initWithData:data littleEndian:littleEndian defaultEncoding:defaultEncoding];
}

-(NSUInteger) remainingBytes
{
    return scanRemain;
}

-(const uint8_t *) currentPointer
{
    return current;
}

-(void) skipBytes:(NSUInteger)count
{
    [self moveBy:count];
}

-(uint8_t) readByte
{
    const uint8_t *old = current;
    [self moveBy:1];
    return old[0];
}

-(uint16_t) readWord
{
    const uint16_t *word = (const uint16_t *) current;
    [self moveBy:sizeof(uint16_t)];
    if (littleEndian)
    {
        return CFSwapInt16LittleToHost(*word);
    }
    else
    {
        return CFSwapInt16BigToHost(*word);
    }
}

-(uint32_t) readDoubleWord
{
    const uint32_t *dword = (const uint32_t *) current;
    [self moveBy:sizeof(uint32_t)];
    if (littleEndian)
    {
        return CFSwapInt32LittleToHost(*dword);
    }
    else
    {
        return CFSwapInt32BigToHost(*dword);
    }
}

-(NSString*) readNullTerminatedString
{
    return [self readNullTerminatedStringWithEncoding:encoding];
}

-(NSString*) readNullTerminatedStringWithEncoding:(NSStringEncoding)overrideEncoding
{
    return [self readStringUntilDelimiter:0 encoding:overrideEncoding];
}

-(NSString*) readStringUntilDelimiter:(uint8_t)delim
{
    return [self readStringUntilDelimiter:delim encoding:encoding];
}

-(NSString*) readStringUntilDelimiter:(uint8_t)delim encoding:(NSStringEncoding)overrideEncoding
{
    const uint8_t *start = current;
    NSUInteger stringLength = 0;
    Byte etx = 0x03; //end transaction
    while (scanRemain > 0 && *current != delim && *current != etx)
    {
        scanRemain -= 1;
        current += 1;
        stringLength += 1;
    }
    
    
    
    // move over the delimiter
    if (scanRemain > 0) [self moveBy:1];
    
    NSString *result = [[NSString alloc] initWithBytes:(const void*)start length:stringLength encoding:overrideEncoding];
    return result;
}

-(NSString*) readStringOfLength:(NSUInteger)count handleNullTerminatorAfter:(BOOL)handleNull
{
    return [self readStringOfLength:count handleNullTerminatorAfter:handleNull encoding:encoding];
}

-(NSString*) readStringOfLength:(NSUInteger)count handleNullTerminatorAfter:(BOOL)handleNull encoding:(NSStringEncoding)overrideEncoding
{
    const uint8_t *start = current;
    [self moveBy:count];
    
    if (handleNull)
    {
        const uint8_t *nullTerminator = current;
        [self moveBy:1];
        if (*nullTerminator != 0)
        {
            @throw [self buildScanException];
        }
    }
    
    NSString *result = [[NSString alloc] initWithBytes:(const void*)start length:count encoding:overrideEncoding];
    return result;
}

-(NSArray*) readArrayOfNullTerminatedStrings:(NSUInteger)count
{
    return [self readArrayOfNullTerminatedStrings:count encoding:encoding];
}

-(NSArray*) readArrayOfNullTerminatedStrings:(NSUInteger)count encoding:(NSStringEncoding)overrideEncoding
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++)
    {
        [array addObject:[self readNullTerminatedStringWithEncoding:overrideEncoding]];
    }
    
    return array;
}

@end
