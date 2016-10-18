//
//  MSTENull.h
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_NULL_H
#define _MSTE_NULL_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncoder.h"

class MSTENull : public MSTEObject
{
public:
	// Singleton Getter
	static std::shared_ptr<MSTENull> getSingleton();

	// Methods
	void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();

private:
	// Constructors
	MSTENull();
	static std::shared_ptr<MSTENull> _singleton;
};

#endif // _MSTE_BOOL_H
