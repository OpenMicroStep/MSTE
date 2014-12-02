//
//  CRC32Calculator.cpp
//  MSTECppTest
//
//  Created by Julien PAPILLON on 26/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#include "CRC32Calculator.h"

#include <sstream>
#include <algorithm>
#include <string>

std::string Crc32Calculator::calculateCRC32(const std::string& inputString)
{
    const unsigned int polynomial = 0xEDB88320;
    unsigned int crc = 0xFFFFFFFF;
    
    for(unsigned int i = 0; i < inputString.length(); i++)
    {
        crc = crc ^ (unsigned char) inputString[i];
        
        for(unsigned int j = 0; j < 8; j++)
            if(crc & 1)
                crc = (crc >> 1) ^ polynomial;
            else
                crc = crc >> 1;
    }
    
    std::stringstream myHexStream;
    myHexStream << std::hex << ~crc;
    
    std::string result(myHexStream.str());
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    
    return result;
}
