/*
 
 _MSColorPrivate.h
 
 This file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
 Herve Malaingre : herve@malaingre.com
 Jean-Michel Bertheas :  jean-michel.bertheas@club-internet.fr
 
 
 This software is a computer program whose purpose is to [describe
 functionalities and technical features of your software].
 
 This software is governed by the CeCILL-C license under French law and
 abiding by the rules of distribution of free software.  You can  use,
 modify and/ or redistribute the software under the terms of the CeCILL-C
 license as circulated by CEA, CNRS and INRIA at the following URL
 "http://www.cecill.info".
 
 As a counterpart to the access to the source code and  rights to copy,
 modify and redistribute granted by the license, users are provided only
 with a limited warranty  and the software's author,  the holder of the
 economic rights,  and the successive licensors  have only  limited
 liability.
 
 In this respect, the user's attention is drawn to the risks associated
 with loading,  using,  modifying and/or developing or reproducing the
 software by the user in light of its specific status of free software,
 that may mean  that it is complicated to manipulate,  and  that  also
 therefore means  that it is reserved for developers  and  experienced
 professionals having in-depth computer knowledge. Users are therefore
 encouraged to load and test the software's suitability as regards their
 requirements in conditions enabling the security of their systems and/or
 data to be ensured and,  more generally, to use and operate it in the
 same conditions as regards security.
 
 The fact that you are presently reading this means that you have had
 knowledge of the CeCILL-C license and that you accept its terms.
 
 WARNING : this header file IS PRIVATE, please direclty
 include <MSFoundation/MSFoundation.h>
 */
#import "MSColor.h"


typedef struct __MSColorLights {
#ifdef __BIG_ENDIAN__
    MSUInt r:8;
    MSUInt g:8;
    MSUInt b:8;
    MSUInt a:8;
#else
    MSUInt a:8;
    MSUInt b:8;
    MSUInt g:8;
    MSUInt r:8;
#endif
} _MSColorLights ;

@interface _MSRGBAColor : MSColor
{
@public
	_MSColorLights _color ;
}
@end

@interface _MSIndexedColor : _MSRGBAColor
{
@public
	NSString *_name ;
	int _colorIndex ;
}
@end

#define LIGHTER(X)	2.0*(X)*(X)/3.0+(X)/2.0+0.25
#define DARKER(X)	-(X)*(X)/3+5.0*(X)/6.0
#define OPAQUE_COLOR		((MSUInt)0xff)

Class __MSColorClass = Nil ;
Class __MSIndexedColorClass = Nil ;


static inline MSColor *_MSCreateIndexedColor(MSUInt rgba, int idx, NSString *name)
{
	_MSIndexedColor *ret = (_MSIndexedColor *)MSCreateObject(__MSIndexedColorClass) ;
	if (ret) {
		ret->_color.r = (MSByte)((rgba >> 24) & 0xff) ;
		ret->_color.g = (MSByte)((rgba >> 16) & 0xff) ;
		ret->_color.b = (MSByte)((rgba >> 8) & 0xff) ;
		ret->_color.a = (MSByte)(rgba & 0xff) ;
		ret->_name = RETAIN(name) ;
		ret->_colorIndex = idx ;
	}
	return (MSColor *)ret ;
}

static inline MSColor *_MSCreateComponentsColor(float rf, float gf, float bf, float af)
{
	_MSRGBAColor *ret = (_MSRGBAColor *)MSCreateObject(__MSColorClass) ;
	if (ret) {
		ret->_color.r = (MSByte)(MIN(1.0, rf)*255) ;
		ret->_color.g = (MSByte)(MIN(1.0, gf)*255) ;
		ret->_color.b = (MSByte)(MIN(1.0, bf)*255) ;
		ret->_color.a = (MSByte)(MIN(1.0, af)*255) ;
	}
	return ret ;
}

static inline MSColor *_MSCreateColor(MSByte r, MSByte g, MSByte b, MSByte a)
{
	_MSRGBAColor *ret = (_MSRGBAColor *)MSCreateObject(__MSColorClass) ;
	if (ret) {
		ret->_color.r = r ;
		ret->_color.g = g ;
		ret->_color.b = b ;
		ret->_color.a = a ;
	}
	return (MSColor *)ret ;
}

static inline float _MSColorLuminance(MSByte r, MSByte g, MSByte b, MSByte a) { return (0.3*r + 0.59*g +0.11*b)/255.0 ; }
static inline BOOL _MSIsPaleColor(MSByte r, MSByte g, MSByte b, MSByte a) { return _MSColorLuminance(r, g, b, a) > 0.4 ? YES : NO ; }

struct _MSColorDefinition {
	char *name ;
	MSUInt value ;
} ;

//static NSMutableDictionary *__namedColors = nil ;


#define	COLOR_LIST_COUNT	139
static const struct _MSColorDefinition __colorTable [COLOR_LIST_COUNT] = {
    {"AliceBlue", 0xf0f8ffff},
    {"AntiqueWhite",      0xfaebd7ff},
    {"Aqua", 0x00ffffff},
    {"Aquamarine", 0x7fffd4ff},
    {"Azure", 0xf0ffffff},
    {"Beige", 0xf5f5dcff},
    {"Bisque", 0xffe4c4ff},
    {"Black", 0x000000ff},
    {"BlanchedAlmond", 0xffebcdff},
    {"Blue", 0x0000ffff},
    {"BlueViolet", 0x8a2be2ff},
    {"Brown ", 0xa52a2aff},
    {"BurlyWood", 0xdeb887ff},
    {"CadetBlue", 0x5f9ea0ff},
    {"Chartreuse", 0x7fff00ff},
    {"Chocolate", 0xd2691eff},
    {"Coral", 0xff7f50ff},
    {"CornflowerBlue", 0x6495edff},
    {"Cornsilk", 0xfff8dcff},
    {"Crimson", 0xdc143cff},
    {"Cyan", 0x00ffffff},
    {"DarkBlue", 0x00008bff},
    {"DarkCyan", 0x008b8bff},
    {"DarkGoldenRod", 0xb8860bff},
    {"DarkGray", 0xa9a9a9ff},
    {"DarkGreen", 0x006400ff},
    {"DarkKhaki", 0xbdb76bff},
    {"DarkMagenta", 0x8b008bff},
    {"DarkOrange", 0xff8c00ff},
    {"DarkOrchid", 0x9932ccff},
    {"DarkRed",    0x8b0000ff},
    {"DarkSalmon", 0xe9967aff},
    {"DarkSeaGreen", 0x8fbc8fff},
    {"DarkSlateBlue", 0x483d8bff},
    {"DarkSlateGray", 0x2f4f4fff},
    {"DarkTurquoise", 0x00ced1ff},
    {"DarkViolet", 0x9400d3ff},
    {"DeepPink",   0xff1493ff},
    {"DeepSkyBlue", 0x00bfffff},
    {"DimGray",	0x696969ff},
    {"DodgerBlue", 0x1e90ffff},
    {"FireBrick",  0xb22222ff},
    {"FloralWhite", 0xfffaf0ff},
    {"ForestGreen", 0x228b22ff},
    {"Fuchsia",    0xff00ffff},
    {"Gainsboro",  0xdcdcdcff},
    {"GhostWhite", 0xf8f8ffff},
    {"Gold", 0xffd700ff},
    {"GoldenRod", 0xdaa520ff},
    {"Gray", 0x808080ff},
    {"Green", 0x008000ff},
    {"GreenYellow", 0xadff2fff},
    {"HoneyDew", 0xf0fff0ff},
    {"HotPink", 0xff69b4ff},
    {"IndianRed", 0xcd5c5cff},
    {"Indigo", 0x4b0082ff},
    {"Ivory", 0xfffff0ff},
    {"Khaki", 0xf0e68cff},
    {"Lavender", 0xe6e6faff},
    {"LavenderBlush", 0xfff0f5ff},
    {"LawnGreen", 0x7cfc00ff},
    {"LemonChiffon", 0xfffacdff},
    {"LightBlue", 0xadd8e6ff},
    {"LightCoral", 0xf08080ff},
    {"LightCyan", 0xe0ffffff},
    {"LightGoldenRodYellow", 0xfafad2ff},
    {"LightGray", 0xd3d3d3ff},
    {"LightGreen", 0x90ee90ff},
    {"LightPink", 0xffb6c1ff},
    {"LightSalmon", 0xffa07aff},
    {"LightSeaGreen", 0x20b2aaff},
    {"LightSkyBlue", 0x87cefaff},
    {"LightSlateGray", 0x778899ff},
    {"LightSteelBlue", 0xb0c4deff},
    {"LightYellow", 0xffffe0ff},
    {"Lime", 0x00ff00ff},
    {"LimeGreen", 0x32cd32ff},
    {"Linen", 0xfaf0e6ff},
    {"Magenta", 0xff00ffff},
    {"Maroon", 0x800000ff},
    {"MediumAquaMarine", 0x66cdaaff},
    {"MediumOrchid", 0xba55d3ff},
    {"MediumPurple", 0x9370d8ff},
    {"MediumSeaGreen", 0x3cb371ff},
    {"MediumStateBlue", 0x7b68eeff},
    {"MediumSpringGreen", 0x00fa9aff},
    {"MediumTurquoise", 0x48d1ccff},
    {"MediumVioletRed", 0xc71585ff},
    {"MidnightBlue", 0x191970ff},
    {"MintCream", 0xf5fffaff},
    {"MistyRose", 0xffe4e1ff},
    {"Moccasin", 0xffe4b5ff},
    {"NavajoWhite", 0xffdeadff},
    {"Navy", 0x000080ff},
    {"OldLace", 0xfdf5e6ff},
    {"Olive", 0x808000ff},
    {"OliveDrab", 0x6b8e23ff},
    {"Orange", 0xffa500ff},
    {"OrangeRed", 0xff4500ff},
    {"Orchid", 0xda70d6ff},
    {"PaleGoldenRod", 0xeee8aaff},
    {"PaleGreen", 0x98fb98ff},
    {"PaleTurquoise", 0xafeeeeff},
    {"PaleVioletRed", 0xd87093ff},
    {"PapayaWhip", 0xffefd5ff},
    {"PeachPuff", 0xffdab9ff},
    {"Peru", 0xcd853fff},
    {"Pink", 0xffc0cbff},
    {"Plum", 0xdda0ddff},
    {"PowderBlue", 0xb0e0e6ff},
    {"Purple", 0x800080ff},
    {"Red", 0xff0000ff},
    {"RosyBrown", 0xbc8f8fff},
    {"RoyalBlue", 0x4169e1ff},
    {"SaddleBrown", 0x8b4513ff},
    {"Salmon", 0xfa8072ff},
    {"SandyBrown", 0xf4a460ff},
    {"SeaGreen", 0x2e8b57ff},
    {"SeaShell", 0xfff5eeff},
    {"Sienna", 0xa0522dff},
    {"Silver", 0xc0c0c0ff},
    {"SkyBlue", 0x87ceebff},
    {"SlateBlue", 0x6a5acdff},
    {"SlateGray", 0x708090ff},
    {"Snow", 0xfffafaff},
    {"SpringGreen", 0x00ff7fff},
    {"SteelBlue", 0x4682b4ff},
    {"Tan", 0xd2b48cff},
    {"Teal", 0x008080ff},
    {"Thistle", 0xd8bfd8ff},
    {"Tomato", 0xff6347ff},
    {"Transparent", 0x00000000},
    {"Turquoise", 0x40e0d0ff},
    {"Violet", 0xee82eeff},
    {"Wheat", 0xf5deb3ff},
    {"White", 0xffffffff},
    {"WhiteSmoke", 0xf5f5f5ff},
    {"Yellow", 0xffff00ff},
    {"YellowGreen", 0x9acd32ff}
} ;
