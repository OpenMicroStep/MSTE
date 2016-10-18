//
//  MSTEBool.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEBool.h"

MSTEBool::MSTEBool()
{
}

MSTEBool::MSTEBool(bool tfBool)
{
	aBool = tfBool;
}

MSTEBool::~MSTEBool()
{
}

bool MSTEBool::getBool()
{
	return aBool;
}

void MSTEBool::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeBool(this, outputBuffer);
}

std::string MSTEBool::getClassName()
{
	return "MSTEBool";
}
