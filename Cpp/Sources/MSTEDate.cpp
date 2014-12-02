//
//  MSTEDate.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEDate.h"

MSTEDate::MSTEDate()
{
	date = 0;
    dateType = Local;
}

MSTEDate::MSTEDate(long aDate)
{
	date = aDate;
    dateType = Local;
}

MSTEDate::MSTEDate(long aDate, DateTimeType dateType)
{
    date = aDate;
    this->dateType = dateType;
}

MSTEDate::MSTEDate(MSTEDate& msteDate)
{
	date = msteDate.date;
}

MSTEDate::~MSTEDate()
{
    
}

long MSTEDate::getLocalDate()
{
    return date;
}

long MSTEDate::getUtcDate()
{
    return date;
}

void MSTEDate::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    if(dateType==Local)
        e->encodeLocalDate(this, outputBuffer);
    else
        e->encodeUtcDate(this, outputBuffer);
}
