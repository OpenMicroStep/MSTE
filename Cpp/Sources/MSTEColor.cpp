//
//  MSTEColor.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"
#include<iostream>

MSTEColor::MSTEColor() {
	red_ = 0;
	blue_ = 0;
	green_ = 0;
	alpha_ = 0xFF;
    rgbaValue= (red_*65536)+(green_*256)+blue_;
    
}

MSTEColor::MSTEColor(unsigned char red, unsigned char green, unsigned char blue)
{
	red_ = red;
	blue_ = blue;
	green_ = green;
	alpha_ = 0xFF;
    rgbaValue= (red*65536)+(green*256)+blue;

}

MSTEColor::MSTEColor(float red, float green, float blue)
{
	red_ = red*255.0+.5;
	blue_ = blue*255.0+.5;
	green_ = green*255.0+.5;
	alpha_ = 1.0*255.0+.5;
    rgbaValue= (red*65536)+(green*256)+blue;

}

MSTEColor::MSTEColor(unsigned int rgba)
{
    red_ = ((rgba >> 24) & 0xFF);
	blue_ = (rgba >> 16) & 0xFF;
	green_ = (rgba >> 8) & 0xFF;
	alpha_ =  0xFF;
    rgbaValue = rgba;
}

MSTEColor::~MSTEColor() {
    
}

string MSTEColor::getClassName()
{
	return "MSTEColor";
}
unsigned char MSTEColor::getTokenType()
{
	return MSTE_TOKEN_TYPE_COLOR;
}

void MSTEColor::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeColor(this);
}
