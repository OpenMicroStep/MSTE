//
//  MSTEColor.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;

class MSTEObject;

class MSTEColor : public MSTEObject {
    private :
	unsigned char red_, green_, blue_, alpha_;
    unsigned int rgbaValue;
public:
	MSTEColor();
	MSTEColor(unsigned char red, unsigned char green, unsigned char blue);
    MSTEColor(float red, float green, float blue);
    MSTEColor(unsigned int rgba);
    MSTEColor(const MSTEColor& rhs):red_(rhs.red_), green_(rhs.green_), blue_(rhs.blue_), alpha_(rhs.alpha_) {}
	virtual ~MSTEColor();
    
	string getClassName();
    
	//inline methods
    unsigned char& c_red() {return red_;}
    unsigned char& c_green() {return green_;}
    unsigned char& c_blue() {return blue_;}
    unsigned char& c_alpha() {return alpha_;}
    const unsigned char& c_red() const {return red_;}
    const unsigned char& c_green() const {return green_;}
    const unsigned char& c_blue() const {return blue_;}
    const unsigned char& c_alpha() const {return alpha_;}
    /*void set_f_red(float val) {red_=val*255.0+.5;}
    void set_f_green(float val) {green_=val*255.0+.5;}
    void set_f_blue(float val) {blue_=val*255.0+.5;}
    void set_f_alpha(float val) {alpha_=val*255.0+.5;}*/
    float get_f_red() const {return red_/255.0;}
    float get_f_green() const {return green_/255.0;}
    float get_f_blue() const {return blue_/255.0;}
    float get_f_alpha() const {return alpha_/255.0;}
    
    //unsigned int rgba() {return ((red_<<24)|(green_<<16)|(blue_<<8)|(alpha_<<0));}
    unsigned int rgba() {return rgbaValue;}
    
    unsigned char getTokenType();
    
    void encodeWithMSTEncodeur(MSTEncodeur* e);
};

