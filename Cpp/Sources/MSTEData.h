//
//  MSTEData.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;

class MSTEObject ;

class MSTEData : public MSTEObject {
    private :
	char* data;
public:
	MSTEData();
	MSTEData(char* aData);
	MSTEData (MSTEData & msteData);
	virtual ~MSTEData();
	string getClassName();
	char* getData();
	unsigned char getTokenType();
	
    
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);
};
