/*
    MSTE Encoder is part of the MicroStep package
*/


function _msteEncodePrivate(rootObject) {
	// we encode no classes in JS
	// if we want to be thread safe or have concurrential access 
	// we should define a local hazard generated key for referencing
	// encoded objets
	// we never encode instance vars whose keys begin with a '_' or a '$'.
	// if you want to encode an instance var beginning with one of these characters, define
	// a whiteListKeys in your object. You also can define a black list. the black list comes
	// in complement of already blacklisted keys (those beginning with '_' and '$').
	// The white list takes over all black lists : it defines the exact keys to be encoded.
	var referenceKey = '$msteId' ;
	var tokens = ["MSTE0101", 0, "CRC00000000"], stream = [], encodedObjects = [], keyNames = [], keysIndexes = {}, classesNames = [], classesIndexes = {} ;
	var element, i, icount ;
	
	// _mustPushObject() can only be used by objects and arrays
	// because the parameter MUST BE passed by REFERENCE
	function _mustPushObject(o) {
		var identifier = o[referenceKey] ;
		if ($MSOK(identifier)) { stream[stream.length] = 9 ; stream[stream.length] = identifier ; return false ;}

		identifier = encodedObjects.length ;
		o[referenceKey] = identifier ;
		encodedObjects[identifier] = o ;
		return true ;
	}
	
	function _pushKey(aKey) {
		var index = keysIndexes[aKey] ;
		if (!$MSOK(index)) {
			index = keyNames.length ;
			keyNames[index] = aKey ;
			keysIndexes[aKey] = index ;
		}
		stream[stream.length] = index ;
	}
	
    function _pushClass(aClass) {
		var index = classesIndexes[aClass] ;
		if (!$MSOK(index)) {
			index = classesNames.length ;
			classesNames[index] = aClass ;
			classesIndexes[aClass] = index ;
		}
		stream[stream.length] = 50 + 2*index ;
	}

	function _encodeObject(o) {
		var identifier, c,v,cls, t, j, index, jcount, keys, forbiddenKeys = [] ;
		
		
		if ($MSOK(o)) {
			cls = o.isa ;
			switch (cls) {
				case 'Boolean': 
					stream[stream.length] = (o ? 1 : 2 ) ; 
					break ;
				case 'Number': 
					if (isFinite(o) && !isNaN(o)) {
						identifier = o[referenceKey] ;
						if ($MSOK(identifier)) { stream[stream.length] = 9 ; stream[stream.length] = identifier ;}
						else {
							identifier = encodedObjects.length ;
							o[referenceKey] = identifier ;
							encodedObjects[identifier] = o ;
							if ((o % 1) == 0) {
								stream[stream.length] = 3 ;
								stream[stream.length] = Math.round(o) ;
							}
							else {
								stream[stream.length] = 4 ;
								stream[stream.length] = o ;							
							}
						}
						return ;
					}
					throw "Impossible to encode an infinite number" ;
					break ;
				case 'String':
					if (o.length == 0) { stream[stream.length] = 26 ; }
					else {
						identifier = o[referenceKey] ;
						if ($MSOK(identifier)) { stream[stream.length] = 9 ; stream[stream.length] = identifier ;}
						else {
							identifier = encodedObjects.length ;
							o[referenceKey] = identifier ;
							encodedObjects[identifier] = o ;
							stream[stream.length] = 5 ;
							stream[stream.length] = o.toString() ; // KEEP IT HERE for MSString
						}						
					}
					break ;			
				case 'Date':
					t = o.getUTCSeconds() ;
					if (t >= 8640000000000) { stream[stream.length] = 25 ; }
					else if ( t <= -8640000000000) { stream[stream.length] = 24  ;}
					else {
						identifier = o[referenceKey] ;
						if ($MSOK(identifier)) { stream[stream.length] = 9 ; stream[stream.length] = identifier ;}
						else {
							identifier = encodedObjects.length ;
							o[referenceKey] = identifier ;
							encodedObjects[identifier] = o ;
							stream[stream.length] = 6 ;
							stream[stream.length] = t ;
						}
					}
					break ;
				case 'Data':
					if (_mustPushObject(o)) {
						stream[stream.length] = 23 ;
						stream[stream.length] = o.toString() ;
					}
					break ;
				case 'Color':
					if (_mustPushObject(o)) {
						stream[stream.length] = 7 ;
						stream[stream.length] = o.trgbValue() ;
					}
					break ;
				case 'Function':
					throw "Impossible to encode a function" ;
				break ;
				case 'Array':
					if (_mustPushObject(o)) {
						stream[stream.length] = 20 ;
						stream[stream.length] = jcount = o.length ;
						for (j = 0 ; j < jcount ; j++) _encodeObject(o[j]) ;
					}
					break ;
                case 'NaturalArray':
					if (_mustPushObject(o)) {
						stream[stream.length] = 21 ;
						stream[stream.length] = jcount = o.length ;
						for (j = 0 ; j < jcount ; j++) {
                            stream[stream.length] = Math.round(o[j]) ;
                        }
					}
					break ;
				case 'Couple':
					if (_mustPushObject(o)) {
						stream[stream.length] = 22 ;
						_encodeObject(o.firstMember) ;
						_encodeObject(o.secondMember) ;						
					}
					break ;
				default:
					// means an object
					if (_mustPushObject(o)) {
						var total = 0, idx ;
                        if ($MSLength(cls)) {
                            //user class
                            _pushClass(cls);
                        }
                        else {
                            //object as dictionary
                            stream[stream.length] = 8;
                        }
                        idx = stream.length ;
                        stream[idx] = 0;
                        
						if ((typeof o.msteKeys) === 'function') {
							keys = o.msteKeys() ;
						}

						if ($MSOK(keys) && (jcount = keys.length)) {
							// we take the keys the object gave us
							for (j = 0 ; j < jcount ; j++) {
								var localKey = keys[j], v = o[localKey], t = typeof v ;
								if (v !== null && t !== 'function' && t !== 'undefined') {
									total ++ ;
									_pushKey(k) ;
									_encodeObject(v) ;
								}
							}
						}
						else {
							// we loop on standard object keys
							if ((typeof o.msteNotKeys) === 'function') {
								forbiddenKeys = o.msteNotKeys() ;
								if (!$MSOK(keys)) { forbiddenKeys = [] ; }
							}
							
							for (var k in o) {
						        if (k.length && k !== 'isa') {
									c = k.charAt(0) ;
									if (c != '_' && c != '$') {
						            	var v = o[k], t = typeof v ;
										if (v !== null && t !== 'function' && t !== 'undefined' && forbiddenKeys.indexOfObject(k) == -1) {
											total ++ ;
											_pushKey(k) ;
											_encodeObject(v) ;
										}
									}
								}
							}
						}
						stream[idx] = total ;
					}
					break ;
			}
		}
		else {
			stream[stream.length] = 0 ;
		}
	}
			
	_encodeObject(rootObject) ;
	
	if (stream.length) {
		tokens[tokens.length] = icount = classesNames.length ;
		for (i = 0 ; i < icount ; i++)  { tokens[tokens.length] = classesNames[i] ; }

		tokens[tokens.length] = icount = keyNames.length ;
		for (i = 0 ; i < icount ; i++)  { tokens[tokens.length] = keyNames[i] ; }
		
		icount = stream.length ;
		for (i = 0 ; i < icount ; i++)  { tokens[tokens.length] = stream[i] ; }
		
		icount = encodedObjects.length ;
		for (i = 0 ; i < icount ; i++)  {
			element = encodedObjects[i] ;
			delete element[referenceKey] ;
		}
		
		tokens[1] = tokens.length ;
		
		return tokens ;
	}
	
	return null ;
}

function MSTEResult(source)
{
	var i, kn, cn, n = 0 ;
	this.tokens = JSON.parse(source) ;
	if (this.tokens) { n = this.tokens.length ;}
	if (n < 4) { throw "Unable to create MSTEResult object : two few tokens" ; }
	this.count = this.tokens[1] ;
	if (this.count != n ) { throw "Unable to create MSTEResult object : bad control count" ;}
	
	this.version = this.tokens[0] ; 
	this.crc = this.tokens[2] ;
	this.index = 0 ;
	cn = this.tokens[3] ;
	this.keys = [] ;
	this.objects = [] ;
	this.classes = [] ;
	this.copyStrings = true ;
	this.correspondances = null ;
	
	for (i = 0 ; i < cn ; i++) { this.classes[i] = this.tokens[4+i] ; }
	kn = this.tokens[4+cn] ;
	for (i = 0 ; i < kn ; i++) { this.keys[i] = this.tokens[5+cn+i] ; }
	this.index = 5+cn+kn ;
}

function _msteDecodePrivate(source, options) {
	var r = new MSTEResult(source) ;
	
	//document.write('<p style="color:red">'+r.tokens+'</p>') ;
	
	if (options) {
		r.correspondances = options.classes ;
		r.copyStrings = (options.copyStrings ? true : false) ;
	}
	if (!_msteDecodePrivate.fns) {
		_msteDecodePrivate.fns = [ 
		fn0, fn1, fn2, fnn, fnn,
		fn5, fn6, fn7, fn8, fn9,
		fnt, fnt, fnt, fnt, fnt,
		fnt, fnt, fnt, fnt, fnt,
		fn20, fn21, fn22, fn23, fn24, 
		fn25, fn26, fn27
		] ;
	}

	//document.write("<p>tokens:"+ r.tokens + "</p>") ;

	function fnt(r, stack, key) { stack[key] = r.tokens[r.index++] ; }
	function fnn(r, stack, key) { 
		// decimal numbers are referenced but copied
		var v = r.tokens[r.index++] ;
		r.objects[r.objects.length] = v ;
		stack[key] = v ;
	}
	
	function fn0(r, stack, key) { stack[key] = null ; }
	function fn1(r, stack, key) { stack[key] = true ; }
	function fn2(r, stack, key) { stack[key] = false ; }
	function fn5(r, stack, key) { 
		var v = (r.copyStrings ? r.tokens[r.index++] : new MSString(r.tokens[r.index++])) ;
		r.objects[r.objects.length] = v ;
		stack[key] = v ;
	}
	function fn6(r, stack, key) {
		var timeInSeconds = r.tokens[r.index++];
		var d ;
		if (timeInSeconds >= 8640000000000) { stack[key] =  Date.DISTANT_FUTURE ; }
		else if ( timeInSeconds <= -8640000000000) { stack[key] = Date.DISTANT_PAST ; }
		else {
			d = Date.initWithUTCSeconds(timeInSeconds) ;
			r.objects[r.objects.length] = d ;
			stack[key] = d ; 
		}
	}
	function fn7(r, stack, key) {
		var trgb = r.tokens[r.index++] ;
//console.log("COLOR, receievr trgb, " + trgb);
		var color = new MSRGBAColor((trgb >> 16) & 0xff, (trgb >> 8) & 0xff, trgb & 0xff, 0xff - ((trgb >> 24) & 0xff)) ;
		r.objects[r.objects.length] = color ;
		stack[key] = color ;
	}
	function fn8(r, stack, key) {
		var k, j, n = r.tokens[r.index++], a = {} ;
		r.objects[r.objects.length] = a ;
		for (j=0;j<n;j++) {
			k = r.keys[r.tokens[r.index++]] ; // the key is a string
			_decodeObject(r, a, k) ; // we decode the value
		}
		stack[key] = a ;
	}
	function fn9(r, stack, key) { stack[key] = r.objects[r.tokens[r.index++]] ;}
	function fn20(r, stack, key) {
		var j, n = r.tokens[r.index++], a = [] ;
		r.objects[r.objects.length] = a ;
		for (j=0;j<n;j++) { _decodeObject(r, a, j) ; }
		stack[key] = a ;
	}
	function fn21(r, stack, key) {
		var j, n = r.tokens[r.index++], a = newMSNaturalArray() ;
		r.objects[r.objects.length] = a ;
		for (j=0;j<n;j++) a[j] = r.tokens[r.index++] ;
		stack[key] = a ;
	}
	function fn22(r, stack, key) { 
		var c = new MSCouple();
		r.objects[r.objects.length] = c ;
		_decodeObject(r, c, 'firstMember') ;
		_decodeObject(r, c, 'secondMember') ; 
		stack[key] = c ;
	}
	function fn23(r, stack, key) { 
		var b = new MSData(r.tokens[r.index++]) ; 
		r.objects[r.objects.length] = b ;
		stack[key] = b ;
	}
	function fn24(r, stack, key) { stack[key] = Date.DISTANT_PAST ; }
	function fn25(r, stack, key) { stack[key] = Date.DISTANT_FUTURE ; }
	function fn26(r, stack, key) { stack[key] = String.EMPTY_STRING ; }
	function _decodeObject(r, stack, key) {
		var code = r.tokens[r.index++] ;
		var futureClass = null, constructor= null, fn ;
		if ((code > 27 && code <50) | code < 0) {
			throw "Unable to decode token with code "+code ;
		}
		else if (code >= 50) {
			futureClass = r.classes[Math.floor((code-50)/2)] ;
			if (futureClass && r.correspondances) { constructor = r.correspondances[futureClass] ; }
			code = 8 ;
		}
		fn = _msteDecodePrivate.fns[code] ;
		fn(r, stack, key) ;
		
		if (constructor && (typeof constructor) == 'Function') {
			stack[key] = constructor(stack[key]) ;
		}
		else if (futureClass) {
            stack[key].isa = futureClass ;
        }
	}
	function fn27(r, stack, key) { stack[key] = r.objects[r.tokens[r.index++]] ;}
	_decodeObject(r, r, 'root') ;
	delete r['tokens'] ;
	delete r['objects'] ;
	delete r['index'] ;
	return r ;
}


MSTE={
	parse:function(source, options) {
		var r = null ;
		try {
			r = _msteDecodePrivate(source, options) ;
		}
		catch (e) { console.log("error "+e+" during MSTE parsing") ; r = null ; }//+e.name + ":" + e.message + ":" + e.lineNumber + 
		return r ;
	},
	tokenize:function(rootObject) {
		var r = null ;
		try {
			r = _msteEncodePrivate(rootObject) ;
		}
		catch (e) { console.log("error "+e+" during MSTE tokenizing") ; r = null ; }
		return r ;
	},
	stringify:function(rootObject) {
		var r = this.tokenize(rootObject) ;
		if (r) {
			try {
				r = JSON.pureStringify(r) ; // uses a modified version of crockford stringify implementation in order to escape all non ASCII characters 
			}
			catch (e) { console.log("error "+e+" during MSTE stringify") ; r = null ; }
		}
		return r ;
	},
    
/*	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
	encodeBase64 :  function(input) {
	    var output = "";
	    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
	    var i = 0;

	    input = MSTE._utf8_encode(input);

	    while (i < input.length) {

	        chr1 = input.charCodeAt(i++);
	        chr2 = input.charCodeAt(i++);
	        chr3 = input.charCodeAt(i++);

	        enc1 = chr1 >> 2;
	        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
	        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
	        enc4 = chr3 & 63;

	        if (isNaN(chr2)) {
	            enc3 = enc4 = 64;
	        } else if (isNaN(chr3)) {
	            enc4 = 64;
	        }

	        output = output +
	        MSTE._keyStr.charAt(enc1) + MSTE._keyStr.charAt(enc2) +
	        MSTE._keyStr.charAt(enc3) + MSTE._keyStr.charAt(enc4);
	    }

	    return output;

	},
	decodeBase64 : function (input) {
	    var output = "";
	    var chr1, chr2, chr3;
	    var enc1, enc2, enc3, enc4;
	    var i = 0;

	    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

	    while (i < input.length) {

	        enc1 = MSTE._keyStr.indexOf(input.charAt(i++));
	        enc2 = MSTE._keyStr.indexOf(input.charAt(i++));
	        enc3 = MSTE._keyStr.indexOf(input.charAt(i++));
	        enc4 = MSTE._keyStr.indexOf(input.charAt(i++));

	        chr1 = (enc1 << 2) | (enc2 >> 4);
	        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
	        chr3 = ((enc3 & 3) << 6) | enc4;

	        output = output + String.fromCharCode(chr1);

	        if (enc3 != 64) {
	            output = output + String.fromCharCode(chr2);
	        }
	        if (enc4 != 64) {
	            output = output + String.fromCharCode(chr3);
	        }

	    }

	    output = MSTE._utf8_decode(output);

	    return output;
	},*/
	
	_utf8_encode : function (string) {
	    string = string.replace(/\r\n/g,"\n");
	    var utftext = "";

	    for (var n = 0; n < string.length; n++) {

	        var c = string.charCodeAt(n);

	        if (c < 128) {
	            utftext += String.fromCharCode(c);
	        }
	        else if((c > 127) && (c < 2048)) {
	            utftext += String.fromCharCode((c >> 6) | 192);
	            utftext += String.fromCharCode((c & 63) | 128);
	        }
	        else {
	            utftext += String.fromCharCode((c >> 12) | 224);
	            utftext += String.fromCharCode(((c >> 6) & 63) | 128);
	            utftext += String.fromCharCode((c & 63) | 128);
	        }

	    }

	    return utftext;
	},

	_utf8_decode : function (utftext) {
	    var string = "";
	    var i = 0;
	    var c = c1 = c2 = 0;

	    while ( i < utftext.length ) {

	        c = utftext.charCodeAt(i);

	        if (c < 128) {
	            string += String.fromCharCode(c);
	            i++;
	        }
	        else if((c > 191) && (c < 224)) {
	            c2 = utftext.charCodeAt(i+1);
	            string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
	            i += 2;
	        }
	        else {
	            c2 = utftext.charCodeAt(i+1);
	            c3 = utftext.charCodeAt(i+2);
	            string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
	            i += 3;
	        }

	    }
	    return string;
	}
};

/*
	This part of the file is a direct copy of a part of the file json2.js form M. Crockford.
	Thanks to him to release that as public domain.
	
	Obviously we keep it public domain here
*/
var JSON;
if (!JSON) {
    JSON = {};
}

(function () {
    'use strict';

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return isFinite(this.valueOf())
                ? this.getUTCFullYear()     + '-' +
                    f(this.getUTCMonth() + 1) + '-' +
                    f(this.getUTCDate())      + 'T' +
                    f(this.getUTCHours())     + ':' +
                    f(this.getUTCMinutes())   + ':' +
                    f(this.getUTCSeconds())   + 'Z'
                : null;
        };

        String.prototype.toJSON      =
            Number.prototype.toJSON  =
            Boolean.prototype.toJSON = function (key) {
                return this.valueOf();
            };
    }

	// escapable was modified from initial json2.js in order to escape all control characters and all characters with diacritics signs
    var escapable = /[\\\"\x00-\x1f\u007f-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '\"' : '\\"',
            '\/' : '\\/',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0
                    ? '[]'
                    : gap
                    ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                    : '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    if (typeof rep[i] === 'string') {
                        k = rep[i];
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0
                ? '{}'
                : gap
                ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.pureStringify !== 'function') {
        JSON.pureStringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.pureStringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }

}());

