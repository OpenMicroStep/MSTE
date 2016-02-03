<?php

require_once('MSContainers.php');

class MSTEEngine {
    static private $versions;
    static public $MSTE101;
    static public $MSTE102;

    private $version;
    private $types;
    private $tokens;

    static public function engineForVersion($version) {
        return static::$versions[$version];
    }
    public function __construct($version, $tokens) {
        static::$versions[$version] = $this;
        $this->version= $version;
        $this->tokens= $tokens;
        $this->types= array_flip($tokens);
    }
    public function version() {
        return $this->version;
    }
    public function tokenForType($type) {
        return $this->tokens[$type];
    }

    public function typeForToken($token) {
        return $this->types[$token];
    }
}
MSTEEngine::$MSTE101 = new MSTEEngine(0x0101, array(
    'nil' => 0,
    'true' => 1,
    'false' => 2,
    'integer'=> 3,
    'real'=> 4,
    'gmtDate' => 5,
    'color' => 7,
    'dictionary' => 8,
    'ref' => 9,
    'i1' => 10,
    'u1' => 11,
    'i2' => 12,
    'u2' => 13,
    'i4' => 14,
    'u4' => 15,
    'i8' => 16,
    'u8' => 17,
    'float' => 18,
    'double' => 19,
    'array' => 20,
    'naturals' => 21,
    'couple' => 22,
    'data' => 23,
    'distantPast' => 24,
    'distantFuture' => 25,
    'emptyString' => 26,
    'weakRef' => 27,
    'object' => 50,
    'weakObject' => 51
));
MSTEEngine::$MSTE102 = new MSTEEngine(0x0102, array(
    // v0101 compatibility
    'integer'=> 20,
    'real'=> 20,

    'nil' => 0,
    'true' => 1,
    'false' => 2,
    'emptyString' => 3,
    'emptyData' => 4,
    'ref' => 9,
    'i1' => 10,
    'u1' => 11,
    'i2' => 12,
    'u2' => 13,
    'i4' => 14,
    'u4' => 15,
    'i8' => 16,
    'u8' => 17,
    'float' => 18,
    'double' => 19,
    'decimal' => 20,
    'string' => 21,
    'localDate' => 22,
    'gmtDate' => 23,
    'color' => 24,
    'data' => 25,
    'naturals' => 26,
    'dictionary' => 30,
    'array' => 31,
    'couple' => 32,
    'object' => 50,
));

class MSTEncoder {

    const   ARRAY_IDENTIFIER    =   '$msteId' ;

    private $stream = array() ;                                 // intermediary output stream

    private $classes            = array() ;                     // an ordered array map with classes indexes
    private $nextClass          = 0 ;

    private $keys               = array() ;                     // an ordered array map with object attributes or array keys indexes
    private $nextKey            = 0 ;

    private $phpObjects  ;                                      // to keep track of all encoded objects

    private $stringsRefences    = array() ;                     // to keep track of all encoded strings
    private $encodedArrays      = array() ;                     // in order to clean all encoded arrays

    private $nextEncodedObject  = 0 ;

    private $engine;

    static public function protocolFromVersion($version) {
        return static::$versions[$version];
    }

    static public function encodedStringWithRootItem($o) {
        $encoder = new MSTEncoder() ;
        return $encoder->encodeRootItem($o) ;
    }

    public function __construct($options = array()) {
        $this->phpObjects = new SplObjectStorage() ;
        $this->engine = MSTEEngine::engineForVersion(isset($options["version"]) ? $options["version"] : 0x0102);
        if (!isset($this->engine))
            throw new Exception("Impossible to create MSTEncoder with version " . $options["version"]);
    }

    public function encodeRootItem($o) {
        $mste = null ;
        try {
            $this->encodeItem($o) ;
            $mste = $this->finalTokens() ;
        } catch (Exception $e) {
            $this->deleteTemporaryIdentifiers() ;
            echo 'MSTEncoder did caught exception: '.$e."\n" ;
            $mste = null ;
        }
        $ret = json_encode($mste);
        $crc = strtoupper(hash("crc32b", $ret));
        $idx = strpos($ret, "CRC00000000");
        $ret = substr_replace($ret, "$crc", $idx + 3, 8);
        return $ret ;
    }

    public function willEncodeValuesCount($valuesCount, $className = null) {
        $valuesCount = (int)($valuesCount + 0) ;

        if ($valuesCount < 0) { throw new Exception("MSTEncoder : wrong valuesCount for willEncodeValuesCount()") ; }

        if (isset($className)) {
            $objectCode = $this->objectCodeForClassName($className) ;
            $this->push($objectCode) ;
        }
        else { $this->pushTokenType('dictionary') ; }
        $this->push($valuesCount) ;
    }

    public function encodeItem($o) {
        if (isset($o)) {
            //echo "will encode item of type ".getType($o).PHP_EOL ;

            switch (getType($o)) {
                case "boolean":
                    $this->pushBoolean($o) ;
                    break ;

                case "integer":
                    $this->pushInteger($o) ;
                    break ;

                case "double":
                    $this->pushFloat($o) ;
                    break ;

                case "string":
                    $this->encodeString($o) ;
                    break ;

                case "object":
                    if (method_exists($o, 'toMSTE') && is_callable(array($o, 'toMSTE'))) {
                        $o->toMSTE($this) ;
                    }
                    break ;

                case "array":
                    $this->encodeArray($o) ;
                    break ;

                default:
                    throw new Exception("Impossible to encode PHP item of type ".getType(o).".") ;
            }

        }
        else { $this->pushTokenType('nil') ; }
    }

    public function encodeString($str) {
        $str = (string)$str ;
        if (strlen($str) === 0) {
            $this->pushTokenType('emptyString') ;
        }
        else {
            if (isset($this->stringsRefences[$str])) {
                $this->pushReference($this->stringsRefences[$str]) ;
            }
            else {
                $identifier = $this->nextEncodedObject ;
                $this->stringsRefences[$str] = $identifier ;
                $this->nextEncodedObject = $identifier + 1 ;
                $this->pushTokenType('string') ;
                $this->push($str) ;
            }
        }

    }

    public function encodeArray(array $o) {
        if (isset($o[self::ARRAY_IDENTIFIER])) {
            $this->pushReference($o[self::ARRAY_IDENTIFIER]) ;
        }
        else {
            $identifier = $this->nextEncodedObject ;
            $o[self::ARRAY_IDENTIFIER] = $identifier ;
            $this->encodedArrays[$identifier] = $o ;
            $this->nextEncodedObject = $identifier + 1 ;
            $this->pushTokenType('dictionary') ;
            $this->push(count($o) - 1) ;

            // we need now to encode the array content as a dictionary since PHP arrays are ordered hashtables
            foreach ($o as $key => $value) {
                if ($key !== self::ARRAY_IDENTIFIER) {
                    $this->pushKey($key) ;
                    $this->encodeItem($value) ;
                }
            }
        }
    }

    public function pushItems($items) {
        $this->pushTokenType('array') ;
        $this->push($items->count()) ;
        foreach ($items as $item) {
            $this->encodeItem($item) ;
        }
    }

    public function pushNaturals($naturals) {
        $this->pushTokenType('naturals') ;
        $this->push($naturals->count()) ;
        foreach ($naturals as $item) {
            $this->push($item) ;
        }
    }

    public function pushColor($colorDefinition) {
        $this->pushTokenType('color') ;
        $this->push($colorDefinition) ;
    }

    public function pushCouple($firstMember, $secondMember) {
        $this->pushTokenType('couple') ;
        $this->encodeItem($firstMember) ;
        $this->encodeItem($secondMember) ;
    }

    public function pushBoolean($boolean) {
        if (is_bool($boolean)) {
            $this->pushTokenType($boolean ? 'true' : 'false') ;
        }
        else {
            throw new Exception("Impossible to MSTEncode a ".getType($boolean)." as a boolean") ;
        }
    }

    public function pushInteger($integer) {
        // just right now, we don't know how to cache serialized integers,
        // for that reason integers are dupplicated
        if (is_int($integer) && !is_nan($integer)) {
            $this->pushTokenType('integer') ;
            $this->push($integer) ;
        }
        else {
            throw new Exception("Impossible to MSTEncode a ".getType($integer)." as an integer") ;
        }
    }

    public function pushFloat($real) {
        // just right now, we don't know how to cache serialized reals,
        // for that reason reals are dupplicated
        if (is_float($real) && !is_nan($real)) {
            $this->pushTokenType('real') ;
            $this->push($real) ;
        }
        else {
            throw new Exception("Impossible to MSTEncode a ".getType($real)." as a float") ;
        }
    }


    public function shouldPushObject($o) {
        if (!is_object($o)) {
            throw new Exception("MSTEncoder shouldPushObject did expect valid objects: ".getType($o)." given.") ;
        }

        if (isset($this->phpObjects[$o])) {
            $this->pushReference($this->phpObjects[$o]) ;
            return false ;
        }
        $identifier = $this->nextEncodedObject ;
        $this->phpObjects[$o] = $identifier ;
        $this->nextEncodedObject = $identifier + 1 ;

        return true ;
    }

    public function pushKeyAndItem($key, $item = null) {
        $this->pushKey($key) ;
        $this->encodeItem($item) ;
    }


    public function finalTokens() {
        $total =  1 + 1 + 1 + ($this->nextClass + 1) + ($this->nextKey + 1) + count($this->stream);

        $ret = ["MSTE".str_pad(dechex($this->engine->version()), 4, '0', STR_PAD_LEFT), $total, "CRC00000000"] ;

        $ret[] = $this->nextClass ;
        foreach ($this->classes as $className => $index) { $ret[] = (string)$className ; }

        $ret[] = $this->nextKey ;
        foreach ($this->keys as $key => $index) { $ret[] = (string)$key ; }

        foreach ($this->stream as $item) { $ret[] = $item ; }
        $this->deleteTemporaryIdentifiers() ;

        return $ret ;
    }

    public function deleteTemporaryIdentifiers() {
        foreach ($this->encodedArrays as $array) {
            unset($array[self::ARRAY_IDENTIFIER]);
        }
    }

    public function objectCodeForClassName($className) {
        if (isset($this->classes[$className])) {
            return $this->classes[$className] ;
        }
        else {
            $identifier = 50 + ($this->engine->version() >= 0x0102 ? $this->nextClass : $this->nextClass * 2) ;
            $this->classes[$className] = $identifier ;
            $this->nextClass ++ ;
            return $identifier ;
        }

    }
    public function pushKey($key) {
        if (is_numeric($key))
            $key= (string)$key;
        if (!is_string($key))
            throw new Exception("MSTEncoder pushKey expect a valid string key: ".getType($key)." given.") ;
        if (isset($this->keys[$key])) {
            $this->push($this->keys[$key]) ;
        }
        else {
            $identifier = $this->nextKey ;
            $this->keys[$key] = $identifier ;
            $this->nextKey = $identifier + 1 ;
            $this->push($identifier) ;
        }
    }

    public function pushReference($identifier) {
        $this->pushTokenType('ref');
        $this->stream[] = $identifier ;
    }

    public function pushTokenType($type) {
        $token = $this->engine->tokenForType($type);
        if (!isset($token))
            throw new Exception("Token type " . $type . " not found");
        $this->stream[] = $token;
    }

    public function push($item) {
        $this->stream[] = $item ;
    }

}

class MSTEDecoder {
    private $localClasses ;
    private $classes = array();
    private $keys = array();
    private $refs = array();

    private $tokens;
    private $idx;
    private $engine;


    public function __construct($conversionClasses = array()) {
        $this->localClasses = $conversionClasses ; // conversion from class keys (tokens) to real class names
    }


    static function decodeEncodedString($msteString, $conversionClasses = array()) {
        $decoder= new MSTEDecoder($conversionClasses);
        return $decoder->parseMSTE($msteString);
    }
    function parseMSTE($msteString) {
        return $this->parseTokens(json_decode($msteString));
    }

    function parseTokens($tokens) {
        $nb= count($tokens);
        $idx= 0;
        if ($nb < 4)
            throw new Exception("Unable to decode MSTE: two few tokens");
        $v= $tokens[$idx++];
        if (strpos($v, "MSTE") !== 0 || !is_object($this->engine= MSTEEngine::engineForVersion(intval(substr($v, 4), 16))))
            throw new Exception("Unable to decode MSTE: bad version");
        if ($tokens[$idx++] != $nb)
            throw new Exception("Unable to decode MSTE: bad control count");

        $crc= $tokens[$idx++];
        // TODO: check crc

        $cn= $tokens[$idx++];
        if (5 + $cn > $nb)
            throw new Exception("Unable to decode MSTE: not enough tokens to store classes and a stream");
        for ($i= 0; $i < $cn; $i++) {
            $tok = $tokens[$idx++] ;
            $this->classes[$i] = isset($this->localClasses[$tok]) ? $this->localClasses[$tok] : null ;
        }

        $kn= $tokens[$idx++];
        if (6 + $kn + $cn > $nb)
            throw new Exception("Unable to decode MSTE: not enough tokens to store classes and a stream");
        for ($i= 0; $i < $kn; $i++)
            $this->keys[$i]= $tokens[$idx++];
        $this->tokens= $tokens;
        $this->idx= $idx;
        return $this->parseItem();
    }

    function nextToken() {
        if ($this->idx < count($this->tokens))
            return $this->tokens[$this->idx++];
        throw new Exception("Unable to decode MSTE: not enough tokens");
    }

    function nextDictionary() {
        $dico = array() ;
        $count = $this->parse_numeric() ;
        $this->_parseDictionary($dico, $count) ;
        return $dico ;
    }
    function parseItem() {
        $token= $this->nextToken();

        //echo "parseItem " . $token . "(" . $this->engine->typeForToken($token) .")" .PHP_EOL;
        if ($token >= 50) {
            if ($this->engine->version() >= 0x0102) {
                 $clsidx= $token - 50 ;
            }
            else {
                $clsidsx = (int)(($token % 2) ? ($token - 50) / 2 : ($token - 51) / 2) ;
            }

            if (isset($this->classes[$clsidx])) {
                $cls = $this->classes[$clsidx];
                $obj = $this->pushRef(new $cls());
                if (method_exists($obj, 'initFromMSTE') && is_callable(array($obj, 'initFromMSTE'))) {
                    $obj->initFromMSTE($this) ;
                    return $obj;
                }
            }
            $token = $this->engine->tokenForType('dictionary') ;

        }
        $type= $this->engine->typeForToken($token);
        if (!isset($type)) {
            throw new Exception("Unable to decode MSTE: token not supported (" . $token .")");
        }
        return $this->{'parse_' . $type}();
    }
    function pushRef($o) {
        //echo "pushRef" . count($this->refs) . " " . ((getType($o) == 'object') ? get_class($o) : (getType($o) === 'array' ? 'array' : $o)) . PHP_EOL;
        $this->refs[] = $o;
        return $o;
    }

    function parse_nil() {
        return null;
    }
    function parse_true() {
        return true;
    }
    function parse_false() {
        return false;
    }
    function parse_emptyString() {
        return '';
    }
    function parse_emptyData() {
        return new MSBuffer(0);
    }
    function parse_ref() {
        $idx = $this->tokens[$this->idx++];
        $count = count($this->refs);
        if ($idx < $count)
            return $this->refs[$idx];
        throw new Exception("Unable to decode MSTE: referenced object index is too big ($idx < $count)");
    }
    function parse_numeric() {
        $ret= $this->nextToken();
        if (is_numeric($ret))
            return $ret;
        throw new Exception("Unable to decode MSTE: an integer was expected");
    }
    function parse_i1() { return $this->parse_numeric(); }
    function parse_u2() { return $this->parse_numeric(); }
    function parse_i4() { return $this->parse_numeric(); }
    function parse_u4() { return $this->parse_numeric(); }
    function parse_i8() { return $this->parse_numeric(); }
    function parse_u8() { return $this->parse_numeric(); }
    function parse_real() { return $this->parse_numeric(); }
    function parse_integer() { return $this->parse_numeric(); }
    function parse_float() { return $this->parse_numeric(); }
    function parse_double() { return $this->parse_numeric(); }
    function parse_decimal() { return $this->pushRef($this->parse_numeric()); }
    function parse_localDate() { return $this->pushRef(new MSLocalDate($this->nextToken())); }
    function parse_gmtDate() { return $this->pushRef(new MSGMTDate($this->nextToken())); }
    function parse_color() { return $this->pushRef(new MSColor($this->nextToken())); }
    function parse_string() {
        $ret= $this->nextToken();
        if (is_string($ret))
            return $this->pushRef($ret);
        throw new Exception("Unable to decode MSTE: a string was expected");
    }
    function parse_data() {
        return $this->pushRef(new MSBuffer(base64_decode($this->nextToken())));
    }
    function parse_naturals() {
        $count= $this->parse_numeric();
        $ret= $this->pushRef(new MSNaturalArray($count));
        while ($count > 0) {
            $ret->addNatural($this->nextToken());
            $count--;
        }
        return $ret;
    }

    function parseKey() {
        return $this->keys[$this->parse_numeric()];
    }

    function _parseDictionary(&$into, $count) {
        while ($count > 0) {
            $key= $this->parseKey() ;
            $obj= $this->parseItem();
            $into[$key]= $obj;
            $count--;
        }
    }
    function parse_dictionary($ref= true) {
        $count= $this->parse_numeric();
        $ret= $this->pushRef($into= array());
        $this->_parseDictionary($into, $count);
        return $into;
    }
    function parse_array() {
        $count= $this->parse_numeric();
        $ret= $this->pushRef(new MSArray($count));
        while ($count > 0) {
            $ret->addObject($this->parseItem());
            $count--;
        }
        return $ret;
    }
    function parse_couple() {
        return $this->pushRef(new MSCouple($this->parseItem(), $this->parseItem()));
    }
}
