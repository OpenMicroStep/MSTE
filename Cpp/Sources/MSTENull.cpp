//
//  MSTENull.cpp
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTENull.h"

std::shared_ptr<MSTENull> MSTENull::_singleton = NULL;

std::shared_ptr<MSTENull> MSTENull::getSingleton()
{
	if (_singleton == NULL)
		_singleton = std::make_shared<MSTENull>(MSTENull());
	return _singleton;
}

MSTENull::MSTENull()
{
}

void MSTENull::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
	e->encodeNull(this, outputBuffer);
}

std::string MSTENull::getClassName()
{
	return "MSTENull";
}
