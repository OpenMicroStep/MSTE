//
//  MSTEBool.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;
class MSTEObject ;

class MSTEBool : public MSTEObject{
private:
	bool aBool;
public:
	MSTEBool();
    MSTEBool(bool tfBool);
	virtual ~MSTEBool();
	string getClassName();
	bool getBool();
	unsigned char getSingleEncodingCode();
	unsigned char getTokenType();
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);
    
};

