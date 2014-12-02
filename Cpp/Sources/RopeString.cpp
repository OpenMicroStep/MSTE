//
//  RopeString.cpp
//  MSTECppTest
//
//  Created by Julien PAPILLON on 25/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#include "RopeString.h"

RopeString::RopeString()
{
    firstItem = lastItem = NULL;
    totalLength = 0;
}

RopeString::RopeString(const std::string& aString)
{
    RopeNode *node = new RopeNode;
    node->content = aString;
    totalLength = aString.length();
    node->next = NULL;
    firstItem = lastItem = node;
}

void RopeString::append(const std::string& aString)
{
    RopeNode *node = new RopeNode;
    node->content = aString;
    totalLength += aString.length();
    node->next = NULL;
    
    if(lastItem)
    {
        lastItem->next = node;
        lastItem = node;
    }
    else
        firstItem = lastItem = node;
    
}

std::string* RopeString::getString()
{
    std::string *result = new std::string();
    
    unsigned long totalLength = 0;
  
    result->reserve(totalLength + 1);
    
    RopeNode *current = firstItem;

    while(current)
    {
        (*result) += current->content;
        current = current->next;
    }

    return result;
}
