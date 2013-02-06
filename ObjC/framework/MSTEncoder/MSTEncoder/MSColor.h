/*
 
 MSColor.h
 
 This file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
 Herve Malaingre : herve@malaingre.com
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

/*
 if you intend to subclass MSColor class, you will need to
 implement - (Class)classForCoder ; method
 */
#import "MSTETypes.h"

@protocol MSColor <NSObject>

- (float)redComponent ;
- (float)greenComponent ;
- (float)blueComponent ;
- (float)alphaComponent ;

- (float)cyanComponent ;
- (float)magentaComponent ;
- (float)yellowComponent ;
- (float)blackComponent ;

- (MSByte)red ;
- (MSByte)green ;
- (MSByte)blue ;
- (MSByte)opacity ;
- (MSByte)transparency ;

- (MSUInt)rgbaValue ;
- (MSUInt)cssValue ;

- (BOOL)isPaleColor ;
- (float)luminance ;

- (id <MSColor>)lighterColor ;
- (id <MSColor>)darkerColor ;

- (id <MSColor>)lightestColor ;
- (id <MSColor>)darkestColor ;

- (id <MSColor>)matchingVisibleColor ;

- (id <MSColor>)colorWithAlpha:(MSByte)opacity ;

- (BOOL)isEqualToColorObject:(id <MSColor>)color ;
- (NSComparisonResult)compareToColorObject:(id <MSColor>)color ;

@end

@interface MSColor : NSObject <MSColor,NSCopying, NSCoding>

//+ (MSColor *)colorWithName:(NSString *)name ;

+ (MSColor *)colorWithRGBAValue:(MSUInt)color ;     //RRGGBBAA
+ (MSColor *)colorWithCSSValue:(MSUInt)color ; // TTRRGGBB

+ (MSColor *)colorWithRed:(MSByte)red green:(MSByte)green blue:(MSByte)blue ;
+ (MSColor *)colorWithRed:(MSByte)red green:(MSByte)green blue:(MSByte)blue opacity:(unsigned char)alpha ;

+ (MSColor *)colorWithRedComponent:(float)red greenComponent:(float)green blueComponent:(float)blue ;
+ (MSColor *)colorWithRedComponent:(float)red greenComponent:(float)green blueComponent:(float)blue alphaComponent:(float)alpha;

@end

MSExport MSColor *MSCreateColor(MSUInt rgbaValue) ;
MSExport MSColor *MSCreateCSSColor(MSUInt trgbValue) ;


