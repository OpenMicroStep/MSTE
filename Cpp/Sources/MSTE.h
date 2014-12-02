//
//  MSTE.h
//  MSTECppTest
//
//  Created by Julien PAPILLON on 20/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#ifndef MSTE_MSTE
#define MSTE_MSTE

#include <string>

// MSTE version
const std::string MSTE_CURRENT_VERSION = "0102";

// Constants
const int MSTE_TYPE_NULL = 0;
const int MSTE_TYPE_TRUE = 1;
const int MSTE_TYPE_FALSE = 2;
const int MSTE_TYPE_EMPTY_STRING = 3;
const int MSTE_TYPE_EMPTY_DATA = 4;

// References
const int MSTE_TYPE_REFERENCE = 9;

// Basic types
const int MSTE_TYPE_CHAR = 10;
const int MSTE_TYPE_UNSIGNED_CHAR = 11;
const int MSTE_TYPE_SHORT = 12;
const int MSTE_TYPE_UNSIGNED_SHORT = 13;
const int MSTE_TYPE_INT32 = 14;
const int MSTE_TYPE_UNSIGNED_INT32 = 15;
const int MSTE_TYPE_INT64 = 16;
const int MSTE_TYPE_UNSIGNED_INT64 = 17;
const int MSTE_TYPE_FLOAT = 18;
const int MSTE_TYPE_DOUBLE = 19;

// Complex types
const int MSTE_TYPE_NUMBER = 20;
const int MSTE_TYPE_STRING = 21;
const int MSTE_TYPE_LOCAL_TIMESTAMP = 22;
const int MSTE_TYPE_UTC_TIMESTAMP = 23;
const int MSTE_TYPE_COLOR = 24;
const int MSTE_TYPE_BASE64_DATA = 25;
const int MSTE_TYPE_NATURAL_ARRAY = 26;

// Generic structures
const int MSTE_TYPE_DICTIONNARY = 30;
const int MSTE_TYPE_ARRAY = 31;
const int MSTE_TYPE_COUPLE = 32;

// User classes
const int MSTE_TYPE_USER_CLASS = 50;

class MSTE
{
public:
    MSTE();
    //MSTE(MSTEObject*);
    
    std::string getMSTEVersion();
    
protected:
    // List of classes
    int nbUserClasses = 0;
    std::string *userClasses = NULL;
    
    // List of keys
    int nbKeys = 0;
    std::string * keys = NULL;
    
    // Number of tokens
    int nbTokens = 0;
};

#endif // MSTE_MSTE
