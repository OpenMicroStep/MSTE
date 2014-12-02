//
//  RopeString.h
//  MSTECppTest
//
//  Created by Julien PAPILLON on 25/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#ifndef _ROPE_STRING_H
#define _ROPE_STRING_H

#include <string>
#include <vector>

struct RopeNode
{
    std::string content;
    unsigned long length;
    RopeNode *next;
};

class RopeString
{
public:
    RopeString();
    RopeString(const std::string&);
    
    void append(const std::string&);
    std::string* getString();
private:
    RopeNode *firstItem, *lastItem;
    unsigned long totalLength;
};

#endif // _ROPE_STRING_H
