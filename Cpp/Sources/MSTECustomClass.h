//
//  MSTECustomClass.h
//  MSTECppTest
//
//  Created by Julien PAPILLON on 25/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#ifndef _MSTE_CUSTOM_CLASS_H
#define _MSTE_CUSTOM_CLASS_H

#include "MSTEUserClass.h"

#include <map>

class MSTECustomClassBase
{
public:
    MSTECustomClassBase() {}
    MSTECustomClassBase(std::shared_ptr<MSTEUserClass>){}
    virtual ~MSTECustomClassBase() {}

    virtual operator std::unique_ptr<MSTEUserClass>() = 0;
    virtual std::string description() = 0;
};

template<class T> MSTECustomClassBase * createT(std::shared_ptr<MSTEUserClass> o) { return new T(o); }

class MSTECustomClassFactory
{
public:
    typedef std::map<std::string, MSTECustomClassBase*(*)(std::shared_ptr<MSTEUserClass>)> map_type;

    static MSTECustomClassBase * createInstance(std::shared_ptr<MSTEUserClass> o)
    {
        map_type::iterator it = getMap()->find(o->getClassName());
        if(it == getMap()->end())
            return NULL;
        return it->second(o);
    }
    
protected:
    static map_type* getMap()
    {
        if(!map) map = new map_type;
        return map;
    }
    
private:
    static map_type* map;
};

template<class T>
class MSTECustomClassRegister : public MSTECustomClassFactory
{
public:
    MSTECustomClassRegister(std::string const& s)
    {
        getMap()->insert(std::pair<std::string, MSTECustomClassBase*(*)(std::shared_ptr<MSTEUserClass>)>(s, &createT<T>));
    }
};

#endif // _MSTE_CUSTOM_CLASS_H
