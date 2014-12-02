//
//  MSTEString.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEString.h"
#include <memory>

MSTEString::MSTEString()
{
	chaine = "";
    wchaine = L"";
}

MSTEString::MSTEString(std::string aString)
{
	chaine = aString;
    wchaine = L"";
}

MSTEString::MSTEString(std::wstring aWString)
{
    chaine = "";
	wchaine = aWString;
}

MSTEString::MSTEString(MSTEString & msteString)
{
	chaine = msteString.chaine;
    wchaine = msteString.wchaine;
}

MSTEString::~MSTEString() {
	// TODO Auto-generated destructor stub
}

std::string MSTEString::getString()
{
	return chaine;
}

std::string MSTEString::getEncodedString()
{
    unsigned long length = chaine.length();
    const char * value = chaine.c_str();
    std::string result;
    
    for(int i=0; i < length; i++)
    {
        switch(value[i])
        {
            case 9 : // \t
                result += "\\t";
                break ;
            case 10 : // \n
                result += "\\n";
                break ;
            case 13 : // \r
                result += "\\r";
                break ;
            case 34 : // \"
                result += "\\\"";
                break ;
            case 92 : // antislash
                result += "\\\\";
                break ;
            case 8 : //
                result += "\\b";
                break ;
            case 12 : //
                result += "\\f";
                break ;
            default:
                result += value[i];
                break ;
        }
    }
    
    return result;
}

unsigned long MSTEString::length()
{
    return chaine.length();
}

std::wstring MSTEString::getWString()
{
	return wchaine;
}

unsigned long MSTEString::wlength()
{
	return wchaine.length();
}

std::string MSTEString::getEncodedWString()
{
    unsigned long length = wchaine.length();
    std::string result;

    for(int i=0; i < length; i++)
    {
        unsigned char c = wchaine.at(i);
        switch(c)
        {
            case 9 : // \t
                result += "\\t";
                break ;
            case 10 : // \n
                result += "\\n";
                break ;
            case 13 : // \r
                result += "\\r";
                break ;
            case 34 : // \"
                result += "\\\"";
                break ;
            case 92 : // antislash
                result += "\\\\";
                break ;
            case 8 : //
                result += "\\b";
                break ;
            case 12 : //
                result += "\\f";
                break ;
            default:
                if ((c < 32) || (c > 127))
                {
                    //escape non printable ASCII characters with a 4 characters in UTF16 hexadecimal format (\UXXXX)
                    result += "\\u";
                    result += hexChars[(c & 0xF000)>>12];
                    result += hexChars[(c & 0x0F00)>>8];
                    result += hexChars[(c & 0x00F0)>>4];
                    result += hexChars[(c & 0x000F)];
                }
                else
                {
                    result += c;
                }
                break ;
        }
    }
    
    return result;
}

void MSTEString::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    if(chaine != "")
    {
        e->encodeString(this, outputBuffer);
    }
    else
    {
        e->encodeWString(this, outputBuffer);
    }
}
