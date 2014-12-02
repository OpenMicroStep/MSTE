//
//  MSTEColor.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEColor.h"

MSTEColor::MSTEColor()
{
	red = 0;
	blue = 0;
	green = 0;
	alpha = 0xFF;
    isAplhaDefined = false;
}

MSTEColor::MSTEColor(unsigned char red, unsigned char green, unsigned char blue)
{
	this->red = red;
	this->blue = blue;
	this->green = green;
	this->alpha = 0xFF;
    isAplhaDefined = false;
}

MSTEColor::MSTEColor(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha)
{
    this->red = red;
    this->blue = blue;
    this->green = green;
    this->alpha = alpha;
    isAplhaDefined = true;
}

MSTEColor::MSTEColor(unsigned long rgba)
{
    if(rgba & 0xFF000000)
    {
        red = ((rgba >> 24) & 0xFF);
        blue = (rgba >> 16) & 0xFF;
        green = (rgba >> 8) & 0xFF;
        alpha =  rgba & 0xFF;
        isAplhaDefined = true;
    }
    else
    {
        red = ((rgba >> 16) & 0xFF);
        blue = (rgba >> 8) & 0xFF;
        green = rgba & 0xFF;
        alpha =  0xFF;
        isAplhaDefined = false;
    }
}

MSTEColor::~MSTEColor()
{
    
}

long MSTEColor::getEncodedColor()
{
    if(isAplhaDefined)
        return (red<<24)|(green<<16)|(blue<<8)|alpha;
    else
        return (red<<16)|(green<<8)|blue;
}

void MSTEColor::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeColor(this, outputBuffer);
}
