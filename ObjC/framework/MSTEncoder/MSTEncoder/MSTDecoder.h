/*
 
 MSTDecoder.h
 
 This file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
 Jean-Michel Bertheas :  jean-michel.bertheas@club-internet.fr
 
 
 This software is a computer program whose purpose is to [describe
 functionalities and technical features of your software].
 
 This software is governed by the CeCILL-C license under French law and
 abiding by the rules of distribution of free software.  You can  use,
 modify and/ or redistribute the software under the terms of the CeCILL-C
 license as circulated by CEA, CNRS and INRIA at the following URL
 "http://www.cecill.info".
 
 As a counterpart to the access to the source code and  rights to copy,
 modify and redistribute granted by the license, users are provided only
 with a limited warranty  and the software's author,  the holder of the
 economic rights,  and the successive licensors  have only  limited
 liability.
 
 In this respect, the user's attention is drawn to the risks associated
 with loading,  using,  modifying and/or developing or reproducing the
 software by the user in light of its specific status of free software,
 that may mean  that it is complicated to manipulate,  and  that  also
 therefore means  that it is reserved for developers  and  experienced
 professionals having in-depth computer knowledge. Users are therefore
 encouraged to load and test the software's suitability as regards their
 requirements in conditions enabling the security of their systems and/or
 data to be ensured and,  more generally, to use and operate it in the
 same conditions as regards security.
 
 The fact that you are presently reading this means that you have had
 knowledge of the CeCILL-C license and that you accept its terms.
 
 WARNING : this header file cannot be included alone, please direclty
 include <MSFoundation/MSFoundation.h>
 */


#import "MSTETypes.h"
#import "MSTEncoder.h"
#import "MSColor.h"
#import "MSCouple.h"

static const char cb64[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const char cd64[]="|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\\]^_`abcdefghijklmnopq";
void encodeblock( const unsigned char *in, unsigned char *out, int len );
void decodeblock( const unsigned char *in, unsigned char *out );
NSData * Base64FromBytes(const unsigned char * str, NSUInteger len);
NSData * NSDataFromBase64(const unsigned char * str, unsigned long len);
id MSTDecodeRetainedObject(NSData *data, NSZone *zone, BOOL verifyCRC, BOOL allowsUnknownUserClasses);

/* MSTDecoding category on NSData : allows to decode objects from a buffer encoded with MSTEncoder (MicroStep Token Encoder) */
@interface NSData (MSTDecoding)
- (id)MSTDecodedObject ; //Most permissive mode : Does not verify CRC and allows to decode unknown user classes as dictionaries
- (id)MSTDecodedObjectAndVerifyCRC:(BOOL)verifyCRC ; //Lesser permissive mode : Allows to decode unknown user classes as dictionaries
- (id)MSTDecodedObjectAndVerifyCRC:(BOOL)verifyCRC allowsUnknownUserClasses:(BOOL)allowsUnknownUserClasses ;
@end

@interface NSObject (MSTDecoding)
- (id)initWithDictionary:(NSDictionary *)values ;
@end
