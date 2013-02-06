/*
 
 MSCouple.h
 
 This header file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
Herve Malaingre : herve@malaingre.com
Eric Baradat :  k18rt@free.fr

 
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
#import "MSObjectAdditions.h"



@interface MSCouple : NSObject <NSCoding, NSCopying, NSMutableCopying>
{
@public
    id _members[2] ;
}

+ (id)coupleWithFirstMember:(id)o1 secondMember:(id)o2;
+ (id)coupleWithCouple:(MSCouple *)aCouple ;
- (id)initWithFirstMember:(id)o1 secondMember:(id)o2;
- (id)initWithCouple:(MSCouple *)aCouple ;
- (id)initWithMembers:(id *)members ;

- (id)firstMember;
- (id)secondMember;

- (NSArray *)allObjects ;
- (NSEnumerator *)objectEnumerator ;
- (NSEnumerator *)reverseObjectEnumerator ;


@end


@interface MSMutableCouple : MSCouple
- (void)setFirstMember:(id)firstMember ;
- (void)setSecondMember:(id)secondMember ;
- (void)setCouple:(MSCouple *)couple ;
@end

static inline BOOL MSEqualObjects(id o1, id o2) { return (o1 == o2 || [o1 isEqual:o2] ? YES : NO) ; }

MSExport MSCouple *MSCreateCouple(id first, id second) ; // returns a retained object
MSExport MSMutableCouple *MSCreateMutableCouple(id first, id second) ; // returns a retained object

#define COUPLE(XX, YY) AUTORELEASE(MSCreateCouple(XX, YY))
#define MCOUPLE(XX, YY) AUTORELEASE(MSCreateMutableCouple(XX, YY))

#define MSC1(XX)		((XX)->_members[0])
#define MSC2(XX)		((XX)->_members[1])
