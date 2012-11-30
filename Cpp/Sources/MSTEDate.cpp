//
//  MSTEDate.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

MSTEDate::MSTEDate() {
	date = 0;
}

MSTEDate::MSTEDate(long aDate)
{
	date = aDate;
}

MSTEDate::MSTEDate(MSTEDate& msteDate)
{
	date = msteDate.date;
}

MSTEDate::~MSTEDate() {
    
}



string MSTEDate::getClassName()
{
	return "MSTEDate";
}


long MSTEDate::getDate()
{
	return date;
}

double MSTEDate::getSecondSince1970()
{
	return difftime(time(NULL),date);
}

long MSTEDate::getDistantPast()
{
	return DISTANT_PAST;
}

long MSTEDate::getDistantFuture()
{
	return DISTANT_FUTURE;
}

unsigned char MSTEDate::getTokenType()
{
	return MSTE_TOKEN_TYPE_DATE;
}

void MSTEDate::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeDate(this);
}

void MSTEDate::initWithTimeIntervalSince1970()
{
	date = time(NULL);
}

unsigned char MSTEDate::getSingleEncodingCode()
{
	if(date >= DISTANT_FUTURE)	return MSTE_TOKEN_TYPE_DISTANT_FUTURE;
	if(date <= DISTANT_PAST) return MSTE_TOKEN_TYPE_DISTANT_PAST;
	else return MSTE_TOKEN_MUST_ENCODE;
}