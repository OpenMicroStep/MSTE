//
//  MSTENumber.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTENumber.h"

MSTENumber::MSTENumber()
{
    value = "0";
}

MSTENumber::MSTENumber(std::string aString)
{
    // TODO : check the string is really a decimal
    value = aString;
}

MSTENumber::~MSTENumber()
{
	// TODO Auto-generated destructor stub
}

std::string MSTENumber::getString()
{
    return value;
}

void MSTENumber::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeNumber(this, outputBuffer);
}

std::string MSTENumber::getClassName()
{
	return "MSTENumber";
}
