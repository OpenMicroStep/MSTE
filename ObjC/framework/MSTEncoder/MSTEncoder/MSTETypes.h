/*
 
 MSFoundationTypes.h
 
 This file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
Herve Malaingre : herve@malaingre.com
Eric Baradat :  k18rt@free.fr
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

#import "Foundation/NSArray.h"
#import "Foundation/NSException.h"
#import "Foundation/NSDate.h"
#import "Foundation/NSData.h"


#define XIsDigit(X)	((X)>='0' && (X)<='9')
#define MSRangeOK(X)    ((X).location != NSNotFound)
#define MSBadRange      NSMakeRange(NSNotFound, 0)
#define MSAfterRange(X) ({ NSRange __r = (X); (__r.location == NSNotFound ? NSNotFound : __r.location + __r.length) ; })
#define MSExport					extern
#define MSAllocateObject(X, Y, Z)	NSAllocateObject(X, Y, Z)
#define MSCreateObject(ACLASS)		MSAllocateObject(ACLASS, 0, NSDefaultMallocZone())
#ifdef RELEASE
#undef RELEASE
#endif
#define RELEASE(X)          [X release]

#ifdef DESTROY
#undef DESTROY
#endif
#define DESTROY(X)	({id __x__ = (id)X ; X = nil ; RELEASE(__x__) ; })

#ifdef RETAIN
#undef RETAIN
#endif
#define RETAIN(X)           [X retain]
#ifdef ASSIGN
#undef ASSIGN
#endif
#define ASSIGN(X,Y)     ({id __x__ = (id)X, __y__ = (id)(Y) ; \
if (__x__ != __y__) { X =  (__y__ ? RETAIN(__y__) : nil); if (__x__) RELEASE(__x__); } \
})

#if defined(WO451)
	typedef int NSInteger;
	typedef unsigned NSUInteger;

	// Microstep codifications for 8, 16, 32 et 64 bytes integers
	typedef char MSChar ;
	typedef unsigned char MSByte; 
	typedef short MSShort ;
	typedef unsigned short MSUShort ;
	typedef int MSInt ;
	typedef unsigned int MSUInt ;
	typedef long long MSLong ;
	typedef unsigned long long MSULong ;
	
	#define u_int8_t	MSByte
	#define u_int16_t	MSUShort
	#define u_int32_t	MSUInt
	#define u_int64_t	MSULong
	#define int8_t		char
	#define int16_t		short
	#define int32_t		int
	#define int64_t		MSLong

#elif defined(MAC_OS_X_VERSION_MAX_ALLOWED)
#if MAC_OS_X_VERSION_10_5 > MAC_OS_X_VERSION_MAX_ALLOWED
	typedef int NSInteger;
	typedef unsigned int NSUInteger;
#endif
	// Microstep codifications for 8, 16, 32 et 64 bytes integers
	typedef int8_t MSChar ;
	typedef uint8_t MSByte; 
	typedef int16_t MSShort ;
	typedef uint16_t MSUShort ;
	typedef int32_t MSInt ;
	typedef uint32_t MSUInt ;
	typedef int64_t MSLong ;
	typedef uint64_t MSULong ;
#elif defined(__COCOTRON__)
	#define u_int8_t	uint8_t
	#define u_int16_t	uint16_t
	#define u_int32_t	uint32_t
	#define u_int64_t	uint64_t
	
	typedef int8_t MSChar ;
	typedef uint8_t MSByte; 
	typedef int16_t MSShort ;
	typedef uint16_t MSUShort ;
	typedef int32_t MSInt ;
	typedef uint32_t MSUInt ;
	typedef int64_t MSLong ;
	typedef uint64_t MSULong ;

#endif


#define MSCharMin		-128
#define MSCharMax		127
#define MSByteMax		255
#define MSShortMin		-32768
#define MSShortMax		32767
#define MSUShortMax		65535
#define MSIntMax		2147483647
#define MSIntMin		(-MSIntMax-1)
#define MSUIntMax		4294967295U
#define MSLongMax		9223372036854775807LL
#define MSLongMin		(-MSLongMax-1)
#define	MSULongMax		18446744073709551615ULL
