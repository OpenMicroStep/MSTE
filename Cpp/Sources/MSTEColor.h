//
//  MSTEColor.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_COLOR_H
#define _MSTE_COLOR_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncoder.h"

class MSTEColor : public MSTEObject
{
public:
    // Constructors
	MSTEColor();
	MSTEColor(unsigned char red, unsigned char green, unsigned char blue);
    MSTEColor(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha);
    MSTEColor(unsigned long rgba);
    MSTEColor(const MSTEColor& rhs):red(rhs.red), green(rhs.green), blue(rhs.blue), alpha(rhs.alpha) {}
    
    // Destructor
	virtual ~MSTEColor();
    
    // Getters
    unsigned char getRed() {return red;}
    unsigned char getGreen() {return green;}
    unsigned char getBlue() {return blue;}
    unsigned char getAlpha() {return alpha;}
    long getEncodedColor();

    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();
    
private :
    unsigned char red, green, blue, alpha;
    bool isAplhaDefined;
};

#endif // _MSTE_COLOR_H