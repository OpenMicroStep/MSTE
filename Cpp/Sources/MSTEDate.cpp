//
//  MSTEDate.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEDate.h"
#include <ctime>

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
	if (dateType == Utc)
		return date - GetLocalDiff();
	else
		return date;
}

long MSTEDate::getUtcDate()
{
	if (dateType == Local)
		return date + GetLocalDiff();
	else
		return date;
}

void MSTEDate::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    if(dateType==Local)
        e->encodeLocalDate(this, outputBuffer);
    else
        e->encodeUtcDate(this, outputBuffer);
}

std::string MSTEDate::getClassName()
{
	return "MSTEDate";
}

bool MSTEDate::_diffCalculated = false;

long MSTEDate::_localDiff = 0;

long MSTEDate::GetLocalDiff()
{
	if (!_diffCalculated)
	{
		// Calculates local and GMT timstamps
		time_t localNowTimestamp = time(0);
		tm *structGmtNow = gmtime(&localNowTimestamp);
		time_t gmtNowTimestamp = mktime(structGmtNow);

		// Calculates the diff
		_localDiff = gmtNowTimestamp - localNowTimestamp;
		if (structGmtNow->tm_isdst > 0) _localDiff -= 3600;
		_diffCalculated = true;
	}
	return _localDiff;
}
