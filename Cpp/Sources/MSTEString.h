//
//  MSTEString.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_STRING_H
#define _MSTE_STRING_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncoder.h"

constexpr static char hexChars[] = "0123456789ABCDEF";

class MSTEString : public MSTEObject
{
public:
    // Constructors
	MSTEString();
    MSTEString(std::string aString);
    MSTEString(std::wstring aWString);
	MSTEString(MSTEString & msteString);
    
    // Destructor
	virtual ~MSTEString();

    // String getters
    std::string getString();
    unsigned long length();
    std::string getEncodedString();

    // WString getters
    std::wstring getWString();
    unsigned long wlength();
    std::string getEncodedWString();
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();

private :
    std::string chaine;
    std::wstring wchaine;
};

#endif // _MSTE_STRING_H
