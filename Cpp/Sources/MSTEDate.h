//
//  MSTEDate.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#define DISTANT_PAST				        -8640000000000000
#define DISTANT_FUTURE	 			        8640000000000000

using namespace std;

class MSTEObject ;

class MSTEDate  : public MSTEObject{
    private :
	long date;
public:
	MSTEDate();
	MSTEDate(long aDate);
	MSTEDate (MSTEDate & msteDate);
	virtual ~MSTEDate();
	string getClassName();
	long getDate();
	double getSecondSince1970();
	long getDistantPast();
	long getDistantFuture();
	unsigned char getSingleEncodingCode();
	unsigned char getTokenType();
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);
	void initWithTimeIntervalSince1970();
};

