//Object.prototype.isa = 'Object' ;

String.prototype.isa = 'String' ;
String.EMPTY_STRING = '' ;
String.prototype.trim = function() { return $MSTrim(this) ; } ;
String.prototype.hasSuffix = function(str) { var r = new RegExp(str+"$") ; return (this.match(r) != null) ; } ;	
String.prototype.hasPrefix = function(str) { var r = new RegExp("^"+str) ; return (this.match(r) != null) ; } ;	
String.prototype.removeDiacritics = function() {
	return this.replace(/[^A-Za-z0-9]/g, function(x) { return _MSRemoveDiacriticsMap[x] || x; }) ;
};

Number.prototype.isa = 'Number' ;

Boolean.prototype.isa = 'Boolean' ;

Date.prototype.isa = 'Date' ;
Date.DISTANT_PAST = new Date(-8640000000000000) ;
Date.DISTANT_FUTURE = new Date(8640000000000000) ;

Date.prototype.date = function() {
	return new Date(this.getTime()) ;
} ;

Date.prototype.dateWithoutTime = function() {
	var utc = this.getTime() ;
	return new Date(utc - (utc % 86400000)) ;
} ;

Date.prototype.getDayTime = function() {
	var utc = this.getTime() ;
	return utc - (utc % 86400000) ;
} ;

Date.prototype.shiftDays = function(ndays) {
	this.setTime(this.getTime()+ndays*86400000) ;
} ;

Date.prototype.isLeap = function() { return $IsLeapYear(this.getFullYear()) ; } ;

Date.prototype.weekOfYear = function(offset) {
    var firstDayOfYear, firstDayOfWeek, reference, week, utc ;
    
    offset = $MSOK(offset) && !isNaN(offset) ? offset % 7 : 0 ;

    firstDayOfYear = new Date(this.getFullYear(),0,1) ;
    firstDayOfWeek = firstDayOfYear.getDay() ;
    
    reference = firstDayOfYear.getTime() - ((firstDayOfWeek + 7 - offset) % 7) * 86400000 ;
    utc = this.getTime() ;
    utc = utc - (utc % 86400000) ;
    
    week = Math.floor((utc - reference) / 604800000) ;
    if (firstDayOfWeek == 0 || firstDayOfWeek > 4) {
        if (week == 0) {
            // we take the last week of the preceding year
            reference = new Date(utc - 86400000) ;
            return reference.weekOfYear(offset) ;
        }
    }
    else { week++ ; }
    return week ;
} ;

Function.prototype.isa = 'Function' ;

Array.prototype.isa = 'Array' ;
Array.prototype.indexOfObject = function(item)
{
    var l = this.length ;
    for (var i = 0; i < l; i++) { if (this[i] == item) { return i ; }}
    return -1;
} ;

Array.prototype.containsObject = function(item) 
{
    var l = this.length ;
    for (var i = 0; i < l; i++) { if (this[i] == item) { return true ; }}
    return false ;
} ;

Array.prototype.copy = function() {
	var ret = [], i, count = this.length ;
	for (i = 0 ; i < count ; i++) ret[i] = this[i] ;
	return ret ; 
} ;

function newMSNaturalArray()
{
    var naturalArray = [] ;
    naturalArray.isa = 'NaturalArray' ;
    return naturalArray ;
}

function MSRGBAColor(r,g,b,a)
{
	if (r.isa == 'String') {
		var s, bits, ok = true ;
		r = r.replace(/ /g,'') ;
		if (!$MSLength(r)) { ok = false ; }
	    if (ok && r.charAt(0) == '#') { r = r.substr(1); }
		if (ok && $MSLength(r) < 3) { ok = false ; }
		if (ok) {
		    r = r.toLowerCase();
			s = MSRGBAColor.namedColors[r] ;
	        bits = MSRGBAColor.colorStringRegex.exec(s?s:r);

			if ($MSCount(bits) != 3) {
		        bits = MSRGBAColor.shortColorStringRegex.exec(s?s:r);
				if (!$MSCount(bits) != 3) { ok = false ; }
			}
			if (ok) {
			    this.red = (bits[0] < 0 || isNaN(bits[0])) ? 0 : ((bits[0] > 255) ? 255 : bits[0]);
			    this.green = (bits[1] < 0 || isNaN(bits[1])) ? 0 : ((bits[1] > 255) ? 255 : bits[1]);
			    this.blue = (bits[2] < 0 || isNaN(bits[2])) ? 0 : ((bits[2] > 255) ? 255 : bits[2]);
			}
		}		
		if (!ok) {
			this.red = this.green = this.blue = 0 ;
		}
		this.alpha = 255 ;
	}
	else {
		if ($MSOK(g) && $MSOK(b)) { // should tes $MSOK(a) here ?
			this.red = r ;
			this.green = g ;
			this.blue = b ;
			this.alpha = $MSOK(a) ? a : 255 ;
		}
		else {
			this.red = (r >> 16) & 0xff ;
			this.green = (r >> 8) & 0xff ;
			this.blue = r & 0xff ;
			this.alpha = 255 ;
		}
	}
}

MSRGBAColor.redColor = new MSRGBAColor(0xff,0,0) ;
MSRGBAColor.whiteColor = new MSRGBAColor(0xff, 0xff, 0xff) ;
MSRGBAColor.blackColor = new MSRGBAColor(0,0,0) ;

MSRGBAColor.colorStringRegex = /^(\w{2})(\w{2})(\w{2})$/ ;
MSRGBAColor.shortColorStringRegex = /^(\w{1})(\w{1})(\w{1})$/ ;
MSRGBAColor.namedColors = {
    beige: 'f5f5dc',
    black: '000000',
    blue: '0000ff',
    brown: 'a52a2a',
    cyan: '00ffff',
    fuchsia: 'ff00ff',
    gold: 'ffd700',
    gray: '808080',
    green: '008000',
    indigo : '4b0082',
    ivory: 'fffff0',
    khaki: 'f0e68c',
    lavender: 'e6e6fa',
    magenta: 'ff00ff',
    maroon: '800000',
    olive: '808000',
    orange: 'ffa500',
    pink: 'ffc0cb',
    purple: '800080',
    red: 'ff0000',
    salmon: 'fa8072',
    silver: 'c0c0c0',
    snow: 'fffafa',
    teal: '008080',
    tomato: 'ff6347',
    turquoise: '40e0d0',
    violet: 'ee82ee',
    wheat: 'f5deb3',
    white: 'ffffff',
    yellow: 'ffff00'
};

function $MSLighter(X)	{ X /= 255.0 ; return Math.round((2.0*(X)*(X)/3.0+(X)/2.0+0.25)*255) ; }
function $MSDarker(X)	{ X /= 255.0 ; return Math.round((-(X)*(X)/3+5.0*(X)/6.0)*255) ; }

MSRGBAColor.prototype.luminance = function () { return (0.3*this.red + 0.59*this.green +0.11*this.blue)/255.0 ; } ;
MSRGBAColor.prototype.isPale = function() { return this.luminance() > 0.6 ? true : false ; } ;

MSRGBAColor.prototype.lighterColor = function() {
	return new MSRGBAColor($MSLighter(this.red), $MSLighter(this.green), $MSLighter(this.blue), this.alpha) ;
} ;

MSRGBAColor.prototype.darkerColor = function() {
	return new MSRGBAColor($MSDarker(this.red), $MSDarker(this.green), $MSDarker(this.blue), this.alpha) ;
} ;

MSRGBAColor.prototype.darkestColor = function() {
	return new MSRGBAColor(	$MSDarker($MSDarker(this.red)), 
			 				$MSDarker($MSDarker(this.green)), 
							$MSDarker($MSDarker(this.blue)), this.alpha) ;
} ;

MSRGBAColor.prototype.lightestColor = function() {
	return new MSRGBAColor(	$MSLighter($MSLighter(this.red)), 
			 				$MSLighter($MSLighter(this.green)), 
							$MSLighter($MSLighter(this.blue)), this.alpha) ;
} ;


MSRGBAColor.prototype.matchingColor = function() { return this.isPale() ? this.darkestColor() : MSRGBAColor.whiteColor ; } ;

MSRGBAColor.prototype.toString = function() {
	return "rgba("+this.red+","+this.green+","+this.blue+","+(this.alpha/255.0)+")" ;
} ;

MSRGBAColor.prototype.trgbValue = function() {
	return ((255-this.alpha)<<24) | (this.red << 16) | (this.green << 8) | this.blue ;
} ;

MSRGBAColor.prototype.rgbaValue = function() {
	return (this.red << 24) | (this.green << 16) | (this.blue << 8) | this.alpha ;
} ;

MSRGBAColor.prototype.isa = 'Color' ;


function MSData(content)
{
	this.binary = content ;
	this.length = content.length ;
}

MSData.prototype.toString = function() { return MSTE.encodeBase64(this.binary) ; } ;
MSData.prototype.isa = 'Data' ;

function MSString(content)
{
	this.string = content ;
	this.length = content.length ;
}

MSString.prototype.toString = function() { return this.string ; } ;
MSString.prototype.isa = 'String' ;

function MSCouple(first, second)
{
	firstMember = $MSOK(first) ? first : null ;
	secondMember = $MSOK(second) ? second : null ;
}
MSCouple.prototype.isa = 'Couple' ;

var _MSRemoveDiacriticsMap = {
'Á': 'A',
'Ă': 'A',
'Ắ': 'A',
'Ặ': 'A',
'Ằ': 'A',
'Ẳ': 'A',
'Ẵ': 'A',
'Ǎ': 'A',
'Â': 'A',
'Ấ': 'A',
'Ậ': 'A',
'Ầ': 'A',
'Ẩ': 'A',
'Ẫ': 'A',
'Ä': 'A',
'Ǟ': 'A',
'Ȧ': 'A',
'Ǡ': 'A',
'Ạ': 'A',
'Ȁ': 'A',
'À': 'A',
'Ả': 'A',
'Ȃ': 'A',
'Ā': 'A',
'Ą': 'A',
'Å': 'A',
'Ǻ': 'A',
'Ḁ': 'A',
'Ⱥ': 'A',
'Ã': 'A',
'Ꜳ': 'AA',
'Æ': 'AE',
'Ǽ': 'AE',
'Ǣ': 'AE',
'Ꜵ': 'AO',
'Ꜷ': 'AU',
'Ꜹ': 'AV',
'Ꜻ': 'AV',
'Ꜽ': 'AY',
'Ḃ': 'B',
'Ḅ': 'B',
'Ɓ': 'B',
'Ḇ': 'B',
'Ƀ': 'B',
'Ƃ': 'B',
'Ć': 'C',
'Č': 'C',
'Ç': 'C',
'Ḉ': 'C',
'Ĉ': 'C',
'Ċ': 'C',
'Ƈ': 'C',
'Ȼ': 'C',
'Ď': 'D',
'Ḑ': 'D',
'Ḓ': 'D',
'Ḋ': 'D',
'Ḍ': 'D',
'Ɗ': 'D',
'Ḏ': 'D',
'ǲ': 'D',
'ǅ': 'D',
'Đ': 'D',
'Ƌ': 'D',
'Ǳ': 'DZ',
'Ǆ': 'DZ',
'É': 'E',
'Ĕ': 'E',
'Ě': 'E',
'Ȩ': 'E',
'Ḝ': 'E',
'Ê': 'E',
'Ế': 'E',
'Ệ': 'E',
'Ề': 'E',
'Ể': 'E',
'Ễ': 'E',
'Ḙ': 'E',
'Ë': 'E',
'Ė': 'E',
'Ẹ': 'E',
'Ȅ': 'E',
'È': 'E',
'Ẻ': 'E',
'Ȇ': 'E',
'Ē': 'E',
'Ḗ': 'E',
'Ḕ': 'E',
'Ę': 'E',
'Ɇ': 'E',
'Ẽ': 'E',
'Ḛ': 'E',
'Ꝫ': 'ET',
'Ḟ': 'F',
'Ƒ': 'F',
'Ǵ': 'G',
'Ğ': 'G',
'Ǧ': 'G',
'Ģ': 'G',
'Ĝ': 'G',
'Ġ': 'G',
'Ɠ': 'G',
'Ḡ': 'G',
'Ǥ': 'G',
'Ḫ': 'H',
'Ȟ': 'H',
'Ḩ': 'H',
'Ĥ': 'H',
'Ⱨ': 'H',
'Ḧ': 'H',
'Ḣ': 'H',
'Ḥ': 'H',
'Ħ': 'H',
'Í': 'I',
'Ĭ': 'I',
'Ǐ': 'I',
'Î': 'I',
'Ï': 'I',
'Ḯ': 'I',
'İ': 'I',
'Ị': 'I',
'Ȉ': 'I',
'Ì': 'I',
'Ỉ': 'I',
'Ȋ': 'I',
'Ī': 'I',
'Į': 'I',
'Ɨ': 'I',
'Ĩ': 'I',
'Ḭ': 'I',
'Ꝺ': 'D',
'Ꝼ': 'F',
'Ᵹ': 'G',
'Ꞃ': 'R',
'Ꞅ': 'S',
'Ꞇ': 'T',
'Ꝭ': 'IS',
'Ĵ': 'J',
'Ɉ': 'J',
'Ḱ': 'K',
'Ǩ': 'K',
'Ķ': 'K',
'Ⱪ': 'K',
'Ꝃ': 'K',
'Ḳ': 'K',
'Ƙ': 'K',
'Ḵ': 'K',
'Ꝁ': 'K',
'Ꝅ': 'K',
'Ĺ': 'L',
'Ƚ': 'L',
'Ľ': 'L',
'Ļ': 'L',
'Ḽ': 'L',
'Ḷ': 'L',
'Ḹ': 'L',
'Ⱡ': 'L',
'Ꝉ': 'L',
'Ḻ': 'L',
'Ŀ': 'L',
'Ɫ': 'L',
'ǈ': 'L',
'Ł': 'L',
'Ǉ': 'LJ',
'Ḿ': 'M',
'Ṁ': 'M',
'Ṃ': 'M',
'Ɱ': 'M',
'Ń': 'N',
'Ň': 'N',
'Ņ': 'N',
'Ṋ': 'N',
'Ṅ': 'N',
'Ṇ': 'N',
'Ǹ': 'N',
'Ɲ': 'N',
'Ṉ': 'N',
'Ƞ': 'N',
'ǋ': 'N',
'Ñ': 'N',
'Ǌ': 'NJ',
'Ó': 'O',
'Ŏ': 'O',
'Ǒ': 'O',
'Ô': 'O',
'Ố': 'O',
'Ộ': 'O',
'Ồ': 'O',
'Ổ': 'O',
'Ỗ': 'O',
'Ö': 'O',
'Ȫ': 'O',
'Ȯ': 'O',
'Ȱ': 'O',
'Ọ': 'O',
'Ő': 'O',
'Ȍ': 'O',
'Ò': 'O',
'Ỏ': 'O',
'Ơ': 'O',
'Ớ': 'O',
'Ợ': 'O',
'Ờ': 'O',
'Ở': 'O',
'Ỡ': 'O',
'Ȏ': 'O',
'Ꝋ': 'O',
'Ꝍ': 'O',
'Ō': 'O',
'Ṓ': 'O',
'Ṑ': 'O',
'Ɵ': 'O',
'Ǫ': 'O',
'Ǭ': 'O',
'Ø': 'O',
'Ǿ': 'O',
'Õ': 'O',
'Ṍ': 'O',
'Ṏ': 'O',
'Ȭ': 'O',
'Ƣ': 'OI',
'Ꝏ': 'OO',
'Ɛ': 'E',
'Ɔ': 'O',
'Ȣ': 'OU',
'Ṕ': 'P',
'Ṗ': 'P',
'Ꝓ': 'P',
'Ƥ': 'P',
'Ꝕ': 'P',
'Ᵽ': 'P',
'Ꝑ': 'P',
'Ꝙ': 'Q',
'Ꝗ': 'Q',
'Ŕ': 'R',
'Ř': 'R',
'Ŗ': 'R',
'Ṙ': 'R',
'Ṛ': 'R',
'Ṝ': 'R',
'Ȑ': 'R',
'Ȓ': 'R',
'Ṟ': 'R',
'Ɍ': 'R',
'Ɽ': 'R',
'Ꜿ': 'C',
'Ǝ': 'E',
'Ś': 'S',
'Ṥ': 'S',
'Š': 'S',
'Ṧ': 'S',
'Ş': 'S',
'Ŝ': 'S',
'Ș': 'S',
'Ṡ': 'S',
'Ṣ': 'S',
'Ṩ': 'S',
'ẞ': 'SS',
'Ť': 'T',
'Ţ': 'T',
'Ṱ': 'T',
'Ț': 'T',
'Ⱦ': 'T',
'Ṫ': 'T',
'Ṭ': 'T',
'Ƭ': 'T',
'Ṯ': 'T',
'Ʈ': 'T',
'Ŧ': 'T',
'Ɐ': 'A',
'Ꞁ': 'L',
'Ɯ': 'M',
'Ʌ': 'V',
'Ꜩ': 'TZ',
'Ú': 'U',
'Ŭ': 'U',
'Ǔ': 'U',
'Û': 'U',
'Ṷ': 'U',
'Ü': 'U',
'Ǘ': 'U',
'Ǚ': 'U',
'Ǜ': 'U',
'Ǖ': 'U',
'Ṳ': 'U',
'Ụ': 'U',
'Ű': 'U',
'Ȕ': 'U',
'Ù': 'U',
'Ủ': 'U',
'Ư': 'U',
'Ứ': 'U',
'Ự': 'U',
'Ừ': 'U',
'Ử': 'U',
'Ữ': 'U',
'Ȗ': 'U',
'Ū': 'U',
'Ṻ': 'U',
'Ų': 'U',
'Ů': 'U',
'Ũ': 'U',
'Ṹ': 'U',
'Ṵ': 'U',
'Ꝟ': 'V',
'Ṿ': 'V',
'Ʋ': 'V',
'Ṽ': 'V',
'Ꝡ': 'VY',
'Ẃ': 'W',
'Ŵ': 'W',
'Ẅ': 'W',
'Ẇ': 'W',
'Ẉ': 'W',
'Ẁ': 'W',
'Ⱳ': 'W',
'Ẍ': 'X',
'Ẋ': 'X',
'Ý': 'Y',
'Ŷ': 'Y',
'Ÿ': 'Y',
'Ẏ': 'Y',
'Ỵ': 'Y',
'Ỳ': 'Y',
'Ƴ': 'Y',
'Ỷ': 'Y',
'Ỿ': 'Y',
'Ȳ': 'Y',
'Ɏ': 'Y',
'Ỹ': 'Y',
'Ź': 'Z',
'Ž': 'Z',
'Ẑ': 'Z',
'Ⱬ': 'Z',
'Ż': 'Z',
'Ẓ': 'Z',
'Ȥ': 'Z',
'Ẕ': 'Z',
'Ƶ': 'Z',
'Ĳ': 'IJ',
'Œ': 'OE',
'ᴀ': 'A',
'ᴁ': 'AE',
'ʙ': 'B',
'ᴃ': 'B',
'ᴄ': 'C',
'ᴅ': 'D',
'ᴇ': 'E',
'ꜰ': 'F',
'ɢ': 'G',
'ʛ': 'G',
'ʜ': 'H',
'ɪ': 'I',
'ʁ': 'R',
'ᴊ': 'J',
'ᴋ': 'K',
'ʟ': 'L',
'ᴌ': 'L',
'ᴍ': 'M',
'ɴ': 'N',
'ᴏ': 'O',
'ɶ': 'OE',
'ᴐ': 'O',
'ᴕ': 'OU',
'ᴘ': 'P',
'ʀ': 'R',
'ᴎ': 'N',
'ᴙ': 'R',
'ꜱ': 'S',
'ᴛ': 'T',
'ⱻ': 'E',
'ᴚ': 'R',
'ᴜ': 'U',
'ᴠ': 'V',
'ᴡ': 'W',
'ʏ': 'Y',
'ᴢ': 'Z',
'á': 'a',
'ă': 'a',
'ắ': 'a',
'ặ': 'a',
'ằ': 'a',
'ẳ': 'a',
'ẵ': 'a',
'ǎ': 'a',
'â': 'a',
'ấ': 'a',
'ậ': 'a',
'ầ': 'a',
'ẩ': 'a',
'ẫ': 'a',
'ä': 'a',
'ǟ': 'a',
'ȧ': 'a',
'ǡ': 'a',
'ạ': 'a',
'ȁ': 'a',
'à': 'a',
'ả': 'a',
'ȃ': 'a',
'ā': 'a',
'ą': 'a',
'ᶏ': 'a',
'ẚ': 'a',
'å': 'a',
'ǻ': 'a',
'ḁ': 'a',
'ⱥ': 'a',
'ã': 'a',
'ꜳ': 'aa',
'æ': 'ae',
'ǽ': 'ae',
'ǣ': 'ae',
'ꜵ': 'ao',
'ꜷ': 'au',
'ꜹ': 'av',
'ꜻ': 'av',
'ꜽ': 'ay',
'ḃ': 'b',
'ḅ': 'b',
'ɓ': 'b',
'ḇ': 'b',
'ᵬ': 'b',
'ᶀ': 'b',
'ƀ': 'b',
'ƃ': 'b',
'ɵ': 'o',
'ć': 'c',
'č': 'c',
'ç': 'c',
'ḉ': 'c',
'ĉ': 'c',
'ɕ': 'c',
'ċ': 'c',
'ƈ': 'c',
'ȼ': 'c',
'ď': 'd',
'ḑ': 'd',
'ḓ': 'd',
'ȡ': 'd',
'ḋ': 'd',
'ḍ': 'd',
'ɗ': 'd',
'ᶑ': 'd',
'ḏ': 'd',
'ᵭ': 'd',
'ᶁ': 'd',
'đ': 'd',
'ɖ': 'd',
'ƌ': 'd',
'ı': 'i',
'ȷ': 'j',
'ɟ': 'j',
'ʄ': 'j',
'ǳ': 'dz',
'ǆ': 'dz',
'é': 'e',
'ĕ': 'e',
'ě': 'e',
'ȩ': 'e',
'ḝ': 'e',
'ê': 'e',
'ế': 'e',
'ệ': 'e',
'ề': 'e',
'ể': 'e',
'ễ': 'e',
'ḙ': 'e',
'ë': 'e',
'ė': 'e',
'ẹ': 'e',
'ȅ': 'e',
'è': 'e',
'ẻ': 'e',
'ȇ': 'e',
'ē': 'e',
'ḗ': 'e',
'ḕ': 'e',
'ⱸ': 'e',
'ę': 'e',
'ᶒ': 'e',
'ɇ': 'e',
'ẽ': 'e',
'ḛ': 'e',
'ꝫ': 'et',
'ḟ': 'f',
'ƒ': 'f',
'ᵮ': 'f',
'ᶂ': 'f',
'ǵ': 'g',
'ğ': 'g',
'ǧ': 'g',
'ģ': 'g',
'ĝ': 'g',
'ġ': 'g',
'ɠ': 'g',
'ḡ': 'g',
'ᶃ': 'g',
'ǥ': 'g',
'ḫ': 'h',
'ȟ': 'h',
'ḩ': 'h',
'ĥ': 'h',
'ⱨ': 'h',
'ḧ': 'h',
'ḣ': 'h',
'ḥ': 'h',
'ɦ': 'h',
'ẖ': 'h',
'ħ': 'h',
'ƕ': 'hv',
'í': 'i',
'ĭ': 'i',
'ǐ': 'i',
'î': 'i',
'ï': 'i',
'ḯ': 'i',
'ị': 'i',
'ȉ': 'i',
'ì': 'i',
'ỉ': 'i',
'ȋ': 'i',
'ī': 'i',
'į': 'i',
'ᶖ': 'i',
'ɨ': 'i',
'ĩ': 'i',
'ḭ': 'i',
'ꝺ': 'd',
'ꝼ': 'f',
'ᵹ': 'g',
'ꞃ': 'r',
'ꞅ': 's',
'ꞇ': 't',
'ꝭ': 'is',
'ǰ': 'j',
'ĵ': 'j',
'ʝ': 'j',
'ɉ': 'j',
'ḱ': 'k',
'ǩ': 'k',
'ķ': 'k',
'ⱪ': 'k',
'ꝃ': 'k',
'ḳ': 'k',
'ƙ': 'k',
'ḵ': 'k',
'ᶄ': 'k',
'ꝁ': 'k',
'ꝅ': 'k',
'ĺ': 'l',
'ƚ': 'l',
'ɬ': 'l',
'ľ': 'l',
'ļ': 'l',
'ḽ': 'l',
'ȴ': 'l',
'ḷ': 'l',
'ḹ': 'l',
'ⱡ': 'l',
'ꝉ': 'l',
'ḻ': 'l',
'ŀ': 'l',
'ɫ': 'l',
'ᶅ': 'l',
'ɭ': 'l',
'ł': 'l',
'ǉ': 'lj',
'ſ': 's',
'ẜ': 's',
'ẛ': 's',
'ẝ': 's',
'ḿ': 'm',
'ṁ': 'm',
'ṃ': 'm',
'ɱ': 'm',
'ᵯ': 'm',
'ᶆ': 'm',
'ń': 'n',
'ň': 'n',
'ņ': 'n',
'ṋ': 'n',
'ȵ': 'n',
'ṅ': 'n',
'ṇ': 'n',
'ǹ': 'n',
'ɲ': 'n',
'ṉ': 'n',
'ƞ': 'n',
'ᵰ': 'n',
'ᶇ': 'n',
'ɳ': 'n',
'ñ': 'n',
'ǌ': 'nj',
'ó': 'o',
'ŏ': 'o',
'ǒ': 'o',
'ô': 'o',
'ố': 'o',
'ộ': 'o',
'ồ': 'o',
'ổ': 'o',
'ỗ': 'o',
'ö': 'o',
'ȫ': 'o',
'ȯ': 'o',
'ȱ': 'o',
'ọ': 'o',
'ő': 'o',
'ȍ': 'o',
'ò': 'o',
'ỏ': 'o',
'ơ': 'o',
'ớ': 'o',
'ợ': 'o',
'ờ': 'o',
'ở': 'o',
'ỡ': 'o',
'ȏ': 'o',
'ꝋ': 'o',
'ꝍ': 'o',
'ⱺ': 'o',
'ō': 'o',
'ṓ': 'o',
'ṑ': 'o',
'ǫ': 'o',
'ǭ': 'o',
'ø': 'o',
'ǿ': 'o',
'õ': 'o',
'ṍ': 'o',
'ṏ': 'o',
'ȭ': 'o',
'ƣ': 'oi',
'ꝏ': 'oo',
'ɛ': 'e',
'ᶓ': 'e',
'ɔ': 'o',
'ᶗ': 'o',
'ȣ': 'ou',
'ṕ': 'p',
'ṗ': 'p',
'ꝓ': 'p',
'ƥ': 'p',
'ᵱ': 'p',
'ᶈ': 'p',
'ꝕ': 'p',
'ᵽ': 'p',
'ꝑ': 'p',
'ꝙ': 'q',
'ʠ': 'q',
'ɋ': 'q',
'ꝗ': 'q',
'ŕ': 'r',
'ř': 'r',
'ŗ': 'r',
'ṙ': 'r',
'ṛ': 'r',
'ṝ': 'r',
'ȑ': 'r',
'ɾ': 'r',
'ᵳ': 'r',
'ȓ': 'r',
'ṟ': 'r',
'ɼ': 'r',
'ᵲ': 'r',
'ᶉ': 'r',
'ɍ': 'r',
'ɽ': 'r',
'ↄ': 'c',
'ꜿ': 'c',
'ɘ': 'e',
'ɿ': 'r',
'ś': 's',
'ṥ': 's',
'š': 's',
'ṧ': 's',
'ş': 's',
'ŝ': 's',
'ș': 's',
'ṡ': 's',
'ṣ': 's',
'ṩ': 's',
'ʂ': 's',
'ᵴ': 's',
'ᶊ': 's',
'ȿ': 's',
'ß': 'ss',
'ɡ': 'g',
'ᴑ': 'o',
'ᴓ': 'o',
'ᴝ': 'u',
'ť': 't',
'ţ': 't',
'ṱ': 't',
'ț': 't',
'ȶ': 't',
'ẗ': 't',
'ⱦ': 't',
'ṫ': 't',
'ṭ': 't',
'ƭ': 't',
'ṯ': 't',
'ᵵ': 't',
'ƫ': 't',
'ʈ': 't',
'ŧ': 't',
'ᵺ': 'th',
'ɐ': 'a',
'ᴂ': 'ae',
'ǝ': 'e',
'ᵷ': 'g',
'ɥ': 'h',
'ʮ': 'h',
'ʯ': 'h',
'ᴉ': 'i',
'ʞ': 'k',
'ꞁ': 'l',
'ɯ': 'm',
'ɰ': 'm',
'ᴔ': 'oe',
'ɹ': 'r',
'ɻ': 'r',
'ɺ': 'r',
'ⱹ': 'r',
'ʇ': 't',
'ʌ': 'v',
'ʍ': 'w',
'ʎ': 'y',
'ꜩ': 'tz',
'ú': 'u',
'ŭ': 'u',
'ǔ': 'u',
'û': 'u',
'ṷ': 'u',
'ü': 'u',
'ǘ': 'u',
'ǚ': 'u',
'ǜ': 'u',
'ǖ': 'u',
'ṳ': 'u',
'ụ': 'u',
'ű': 'u',
'ȕ': 'u',
'ù': 'u',
'ủ': 'u',
'ư': 'u',
'ứ': 'u',
'ự': 'u',
'ừ': 'u',
'ử': 'u',
'ữ': 'u',
'ȗ': 'u',
'ū': 'u',
'ṻ': 'u',
'ų': 'u',
'ᶙ': 'u',
'ů': 'u',
'ũ': 'u',
'ṹ': 'u',
'ṵ': 'u',
'ᵫ': 'ue',
'ꝸ': 'um',
'ⱴ': 'v',
'ꝟ': 'v',
'ṿ': 'v',
'ʋ': 'v',
'ᶌ': 'v',
'ⱱ': 'v',
'ṽ': 'v',
'ꝡ': 'vy',
'ẃ': 'w',
'ŵ': 'w',
'ẅ': 'w',
'ẇ': 'w',
'ẉ': 'w',
'ẁ': 'w',
'ⱳ': 'w',
'ẘ': 'w',
'ẍ': 'x',
'ẋ': 'x',
'ᶍ': 'x',
'ý': 'y',
'ŷ': 'y',
'ÿ': 'y',
'ẏ': 'y',
'ỵ': 'y',
'ỳ': 'y',
'ƴ': 'y',
'ỷ': 'y',
'ỿ': 'y',
'ȳ': 'y',
'ẙ': 'y',
'ɏ': 'y',
'ỹ': 'y',
'ź': 'z',
'ž': 'z',
'ẑ': 'z',
'ʑ': 'z',
'ⱬ': 'z',
'ż': 'z',
'ẓ': 'z',
'ȥ': 'z',
'ẕ': 'z',
'ᵶ': 'z',
'ᶎ': 'z',
'ʐ': 'z',
'ƶ': 'z',
'ɀ': 'z',
'ﬀ': 'ff',
'ﬃ': 'ffi',
'ﬄ': 'ffl',
'ﬁ': 'fi',
'ﬂ': 'fl',
'ĳ': 'ij',
'œ': 'oe',
'ﬆ': 'st',
'ₐ': 'a',
'ₑ': 'e',
'ᵢ': 'i',
'ⱼ': 'j',
'ₒ': 'o',
'ᵣ': 'r',
'ᵤ': 'u',
'ᵥ': 'v',
'ₓ': 'x'
};
