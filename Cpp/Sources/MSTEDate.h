//
//  MSTEDate.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_DATE_H
#define _MSTE_DATE_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncodeur.h"

enum DateTimeType { Utc, Local};

class MSTEDate  : public MSTEObject
{
public:
	MSTEDate();
	MSTEDate(long aDate);
    MSTEDate(long aDate, DateTimeType dateType);
	MSTEDate (MSTEDate & msteDate);
	virtual ~MSTEDate();

    long getLocalDate();
    long getUtcDate();
    
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

private :
    long date;
    DateTimeType dateType;
};

#endif // _MSTE_DATE_H
