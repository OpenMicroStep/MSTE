//
//  MSTEString.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;

class MSTEObject ;

class MSTEString : public MSTEObject{
    private :
	string chaine;
    wstring wchaine;
public:
	MSTEString();
	MSTEString(string aString);
    MSTEString(wstring aWString);
	MSTEString(MSTEString & msteString);
	virtual ~MSTEString();
	string getClassName();
	string getString();
    wstring getWString();
	unsigned char getTokenType();
	unsigned char getSingleEncodingCode();
	unsigned long length();
    unsigned long wlength();
	void encodeWithMSTEncodeur(MSTEncodeur* e);
};
