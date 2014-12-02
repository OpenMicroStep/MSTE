//
//  CRC32Calculator.h
//  MSTECppTest
//
//  Created by Julien PAPILLON on 26/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#ifndef _MSTE_CRC32_CALCULATOR_H
#define _MSTE_CRC32_CALCULATOR_H

#include <string>

class Crc32Calculator
{
public:
    static std::string calculateCRC32(const std::string&);
};

#endif // _MSTE_CRC32_CALCULATOR_H
