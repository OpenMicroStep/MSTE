//
//  MSTECouple.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;

class MSTEObject ;

class MSTECouple : public MSTEObject{
    private :
    
	MSTEObject* couple1;
    MSTEObject* couple2;
    
    
public:
    MSTECouple();
	MSTECouple(MSTEObject* firstMember,MSTEObject* secondMember);
	MSTECouple(MSTECouple &aCouple);
    ~MSTECouple();
	string getClassName();
    MSTEObject* getFirstMember();
	MSTEObject* getSecondMember();
	unsigned char getTokenType();
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);
};

