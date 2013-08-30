<?php

require_once('MSContainers.php');

// -----------------------------------------------------------------------------
// MSTE Class
// -----------------------------------------------------------------------------
class MSTE {

	// create object from MSTE string
	public static function decode($source,  $options=null) {
		$r = null ;
		try {
			$r = MSTE::_msteDecodePrivate($source, $options) ;
		}
		catch (Exception $e) { 
			 // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
			 echo "Unable to create MSTE object : ".$e->getMessage(); 
		}
		return $r ;
	}

	// create MSTE string from object
	public static function encode($obj) {
		$r = null ;
		try {
			$r = MSTE::_msteEncodePrivate($obj) ;
		}
		catch (Exception $e) { 
			echo "Unable to create MSTE string : ".$e->getMessage(); 
		}
		return $r ;
	}

	private static function _msteDecodePrivate($source, $options) {
		$r = new MSTEResult($source) ;
		if ($options) {
			$r->correspondances = $options->classes ;
			$r->copyStrings = ($options->copyStrings ? true : false) ;
		}
		MSTEResult::decodeObject($r, &$r, 'root') ;
		// delete $r['tokens'] ;
		// delete $r['objects'] ;
		// delete $r['index'] ;
		return $r;
	}

	private static function _msteEncodePrivate($rootObject) {
		$e = new MSTEEncoder($rootObject);	
	}
}

// -----------------------------------------------------------------------------
// MSTEEncoder Class
// -----------------------------------------------------------------------------
class MSTEEncoder {
	// we encode no classes in JS
	// if we want to be thread safe or have concurrential access 
	// we should define a local hazard generated key for referencing
	// encoded objets
	// we never encode instance vars whose keys begin with a '_' or a '$'.
	// if you want to encode an instance var beginning with one of these characters, define
	// a whiteListKeys in your object. You also can define a black list. the black list comes
	// in complement of already blacklisted keys (those beginning with '_' and '$').
	// The white list takes over all black lists : it defines the exact keys to be encoded.
	private $referenceKey = '$msteId' ;
	private $tokens = array("MSTE0101", 0, "CRC00000000");
	private $stream = array();
	private $encodedObjects = array();
	private $keyNames = array();
	private $keysIndexes = array(); // {}
	private $classesNames = array();
	private $classesIndexes = array(); //{} ;

	static $trace = true;

	function __construct($rootObject) {
		$this->_encodeObject($rootObject) ;
	
		if (sizeof($this->stream)>0) {
			$this->tokens[sizeof($this->tokens)] = $icount = sizeof($this->classesNames);
			for ($i=0; $i<$icount; $i++) { $this->tokens[sizeof($this->tokens)] = $this->classesNames[$i]; }

			$this->tokens[sizeof($this->tokens)] = $icount = sizeof($this->keyNames) ;
			for ($i=0; $i<$icount; $i++) { $this->tokens[sizeof($this->tokens)] = $this->keyNames[$i]; }
			
			$icount = sizeof($this->stream);
			for ($i=0; $i<$icount; $i++) { $this->tokens[sizeof($this->tokens)] = $this->stream[$i]; }
			
			$icount = sizeof($this->encodedObjects) ;
			for ($i=0; $i<$icount; $i++) {
				$element = $this->encodedObjects[$i];
				// a faire
				// delete element[$referenceKey] ;
			}
			
			$this->tokens[1] = sizeof($this->tokens);
			
			return $this->tokens ;
		}
		
		return null ;

	}

	// -----------------------------------------------------------------------------
	// Encoding functions
	// -----------------------------------------------------------------------------
	// _mustPushObject() can only be used by objects and arrays
	// because the parameter MUST BE passed by REFERENCE
	private function _mustPushObject($o) {
		$identifier = null;
		if (array_key_exists($this->referenceKey, $o)) { 
			$identifier = $o[$this->referenceKey];
			$this->stream[sizeof($this->stream)] = 9 ; 
			$this->stream[sizeof($this->stream)] = $identifier ; 
			return false ;
		}

		$identifier = sizeof($this->encodedObjects) ;
		$o[$this->referenceKey] = $identifier ;
		$this->encodedObjects[$identifier] = $o ;
		return true ;
	}
	
	private function _pushKey($aKey) {
		$index = $this->keysIndexes[$aKey] ;
		if (isset($index)) {
			$index = sizeof($this->keyNames);
			$this->keyNames[$index] = $aKey ;
			$this->keysIndexes[$aKey] = $index ;
		}
		$this->stream[sizeof($this->stream)] = $index ;
	}
	
    private function _pushClass($aClass) {
		$index = null;
		if (array_key_exists($aClass, $this->classesIndexes)) { 
			$index = $this->classesIndexes[$aClass];
			$index = sizeof($this->classesNames) ;
			$this->classesNames[$index] = $aClass ;
			$this->classesIndexes[$aClass] = $index ;
		}
		$this->stream[sizeof($this->stream)] = 50 + 2*$index ;
	}

	private function _encodeObject($o) {
		//identifier, c,v,cls, t, j, index, jcount, keys, 
		$forbiddenKeys = array() ;
		
		if ($o) {
			// $cls = $o->isa ; // attention comment faire ?
			$cls = gettype($o) ; 
			// logEvent(MSTEEncoder::$trace, "<hr>Fonction ".print_r($o,true)."<hr>");
			logEvent(MSTEEncoder::$trace, "<br>Type : $cls<br>");
			switch ($cls) {
				case 'boolean': 
					$this->stream[size($this->stream)] = ($o ? 1 : 2 ) ; 
					break ;
				case 'integer': 
					if (isFinite($o) && !isNaN($o)) {
						$identifier = $o[$this->referenceKey] ;
						if (isset($identifier)) { 
							$this->stream[sizeof($this->stream)] = 9; 
							$this->stream[sizeof($this->stream)] = $identifier;
						} else {
							$identifier = sizeof($this->encodedObjects);
							$o[$this->referenceKey] = $identifier;
							$this->encodedObjects[$identifier] = o ;
							if (($o % 1) == 0) {
								$this->stream[sizeof($this->stream)] = 3 ;
								$this->stream[sizeof($this->stream)] = round($o) ;
							} else {
								$this->stream[sizeof($this->stream)] = 4 ;
								$this->stream[sizeof($this->stream)] = $o ;							
							}
						}
						return ;
					}
					throw "Impossible to encode an infinite number" ;
					break ;
				case 'string':
					if (sizeof($o) == 0) { 
						$this->stream[sizeof($this->stream)] = 26 ; 
					}
					else {
						$identifier = $o[$this->referenceKey];
						if (isset($identifier)) { 
							$this->stream[sizeof($this->stream)] = 9 ; 
							$this->stream[sizeof($this->stream)] = $identifier ;
						} else {
							$identifier = sizeof($this->encodedObjects) ;
							$o[$this->referenceKey] = $identifier ;
							$this->encodedObjects[$identifier] = o ;
							$this->stream[sizeof($this->stream)] = 5 ;
							$this->stream[sizeof($this->stream)] = $o->toString() ; // KEEP IT HERE for MSString
						}						
					}
					break ;			
				case 'Date':
					$t = $o->getUTCSeconds() ;
					if ($t >= 8640000000000) { $this->stream[sizeof($this->stream)] = 25 ; }
					else if ( $t <= -8640000000000) { $this->stream[sizeof($this->stream)] = 24  ;}
					else {
						$identifier = $o[$this->referenceKey] ;
						if (isset($identifier)) { 
							$this->stream[sizeof($this->stream)] = 9;
							$this->stream[sizeof($this->stream)] = $identifier;
						} else {
							$identifier = sizeof($this->encodedObjects) ;
							$o[$this->referenceKey] = $identifier ;
							$this->encodedObjects[$identifier] = $o ;
							$this->stream[sizeof($this->stream)] = 6 ;
							$this->stream[sizeof($this->stream)] = t ;
						}
					}
					break ;
				case 'Data':
					if (_mustPushObject($o)) {
						$this->stream[sizeof($this->stream)] = 23 ;
						$this->stream[sizeof($this->stream)] = $o->toString() ;
					}
					break ;
				case 'Color':
					if (_mustPushObject(o)) {
						$this->stream[sizeof($this->stream)] = 7 ;
						$this->stream[sizeof($this->stream)] = $o->trgbValue() ;
					}
					break ;
				case 'Function':
					throw "Impossible to encode a function" ;
				break ;
				case 'array':
					if ($this->_mustPushObject($o)) {
						$this->stream[sizeof($this->stream)] = 20 ;
						$this->stream[sizeof($this->stream)] = $jcount = sizeof($o) ;
						for ($j=0; $j<$jcount; $j++) {
							logEvent(MSTEEncoder::$trace, "<hr>Val : ".print_r($o[$j],true)."<hr>");
							$this->_encodeObject($o[$j]) ;
						}
					}
					break ;
                case 'NaturalArray':
					if ($this->_mustPushObject(o)) {
						$this->stream[sizeof($this->stream)] = 21 ;
						$this->stream[sizeof($this->stream)] = $jcount = sizeof($o);
						for ($j=0; $j<$jcount; $j++) {
                            $this->stream[sizeof($this->stream)] = round($o[$j]) ;
                        }
					}
					break ;
				case 'Couple':
					if ($this->_mustPushObject($o)) {
						$this->stream[sizeof($this->stream)] = 22 ;
						$this->_encodeObject($o->getFirstMember) ;
						$this->_encodeObject($o->getSecondMember) ;						
					}
					break ;
				default:
					// means an object
					if ($this->_mustPushObject($o)) {
						$total = 0;
						logEvent(MSTEEncoder::$trace, "<hr>Obj Type : ".print_r($cls,true)."<hr>");
                        if (strlen($cls)>0) {
                            //user class
                            $this->_pushClass($cls);
                        } else {
                            //object as dictionary
                            $this->stream[sizeof($this->stream)] = 8;
                        }
                        $idx = sizeof($this->stream);
                        $this->stream[$idx] = 0;
                        
						if (method_exists($o, 'msteKeys')) {
							$keys = call_user_func(get_class($o)."->msteKeys");
						}

						// if (isset($keys) && ($jcount = sizeof($keys)) {
						// 	// we take the keys the object gave us
						// 	for ($j=0; $j<$jcount; $j++) {
						// 		$localKey = $keys[$j];
						// 		$v = $o[$localKey];
						// 		$t = gettype($v);
						// 		if ($v !== null && $t !== 'function' && $t !== 'undefined') {
						// 			$total ++ ;
						// 			$this->_pushKey($k) ;
						// 			$this->_encodeObject($v) ;
						// 		}
						// 	}
						// }
						// else {
						// 	// we loop on standard object keys
						// 	if (method_exists($o, 'msteNotKeys')) {
						// 		$forbiddenKeys = call_user_func(get_class($o)."->msteNotKeys");
						// 		if ($forbiddenKeys) { $forbiddenKeys = {} ; }
						// 	}
							
						// 	for (var k in o) {
						//         if (k.length && k !== 'isa') {
						// 			c = k.charAt(0) ;
						// 			if (c != '_' && c != '$') {
						//             	var v = o[k], t = typeof v ;
						// 				if (v !== null && t !== 'function' && t !== 'undefined' && forbiddenKeys.indexOfObject(k) == -1) {
						// 					total ++ ;
						// 					_pushKey(k) ;
						// 					_encodeObject(v) ;
						// 				}
						// 			}
						// 		}
						// 	}
						// }
						// stream[idx] = total ;
					}
					break ;
			}
		}
		else {
			$this->stream[sizeof($this->stream)] = 0 ;
		}
	}
}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// MSTEResult Class
// -----------------------------------------------------------------------------
class MSTEResult extends MSObject {

	public $tokens;
	public $count;
	public $version;
	public $crc;
	public $index;
	public $keys;
	public $objects;
	public $classes;
	public $copyStrings;
	public $correspondances;
	public $fns = array(
		'fn0', 'fn1', 'fn2', 'fnn', 'fnn',
		'fn5', 'fn6', 'fn7', 'fn8', 'fn9',
		'fnt', 'fnt', 'fnt', 'fnt', 'fnt',
		'fnt', 'fnt', 'fnt', 'fnt', 'fnt',
		'fn20', 'fn21', 'fn22', 'fn23', 'fn24', 
		'fn25', 'fn26', 'fn27'
	);

	protected static $trace = false;

	function __construct($source) {
		$i = $kn = $cn = $n = 0 ;
		// echo "Source : $source<br>";
		$this->tokens = json_decode($source);
		if ($this->tokens === null) {
			throw new Exception("JSON string incorrect"); 
		}
		if ($this->tokens) { 
			$n = sizeof($this->tokens);
		}
		if ($n < 4) {
			throw new Exception("Unable to create MSTEResult object : two few tokens"); 
		}
		$this->count = $this->tokens[1] ;
		if ($this->count != $n ) { 
			throw new Exception("Unable to create MSTEResult object : bad control count");
		}
		$this->version = $this->tokens[0] ; 
		$this->crc = $this->tokens[2] ;
		$this->index = 0 ;
		$cn = $this->tokens[3] ;
		$this->keys = array() ;
		$this->objects = array() ;
		$this->classes = array() ;
		$this->copyStrings = true ;
		$this->correspondances = null ;
		for ($i=0; $i<$cn; $i++) { 
			$this->classes[$i] = $this->tokens[4+$i]; 
		}
		$kn = $this->tokens[4+$cn];
		for ($i=0; $i<$kn; $i++) { 
			$this->keys[$i] = $this->tokens[5+$cn+$i]; 
		}
		$this->index = 5+$cn+$kn;
	}


	public static function decodeObject($r, &$stack, $key) {
		$code = $r->tokens[$r->index++] ;
		$futureClass = null;
		$constructor= null;
		if (($code > 27 && $code <50) | $code < 0) {
			throw new Exception("Unable to decode token with code ".$code) ;
		}
		else if ($code >= 50) {
			$futureClass = $r->classes[floor(($code-50)/2)] ;
			if ($futureClass && $r->correspondances) { 
				$constructor = $r->correspondances[$futureClass] ; 
			}
			$code = 8 ;
		}
		$fn = $r->fns[$code];
		logEvent(MSTEResult::$trace, "<hr>Fonction $fn<hr>");
		call_user_func(get_class($r)."::".$fn, $r, $stack, $key) ;
		
		// if ($constructor && (typeof $constructor) == 'Function') {
		if ($constructor) {
			$stack[$key] = $constructor($stack[$key]) ;
			echo "<br>>>>>>>>>>>>>>>>>Constructor : $key<br>";
		}
		else if ($futureClass) {
			// a verifier
            $stack->className = $futureClass ;
            // echo "<br>>>>>>>>>>>>>>>>>futureClass : $key<br>";
        }
	}

	// generic function to retrieve byRef parameters 
	static function _getFuncParams(&$r, &$stack, &$key, $args){
		$r = $args[0];
		$stack = $args[1];
		$key = $args[2];
	}

	// type 10 to 19
	static function fnt() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args()); 
		$stack[$key] = $r->tokens[$r->index++]; 
	}

	// type 3 & 4
	static function fnn() { 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		// decimal numbers are referenced but copied
		$v = $r->tokens[$r->index++] ;
		$r->objects[sizeof($r->objects)] = $v ;
		$stack[$key] = $v ;
	}
	
	static function fn0() { 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$stack->setValueForKey($v, $key); 
	}

	static function fn1() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args()); 
		$stack->setValueForKey($v, true) ; 
	}

	static function fn2() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args()); 
		$stack->setValueForKey($v, false) ; 
	}

	static function fn5() { 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$v = ($r->copyStrings ? $r->tokens[$r->index++] : new MSString($r->tokens[$r->index++])) ;
		// $v = $r->tokens[$r->index++];
		$r->objects[sizeof($r->objects)] = $v ;
		$stack->setValueForKey($v, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	static function fn6() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$timeInSeconds = $r->tokens[$r->index++];
		$d = new MSDate($timeInSeconds);
		$r->objects[sizeof($r->objects)] = $d;
		$stack->setValueForKey($d, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	static function fn7() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$trgb = $r->tokens[$r->index++];
		$color = new MSColor(($trgb >> 16) & 0xff, ($trgb >> 8) & 0xff, $trgb & 0xff, 0xff - (($trgb >> 24) & 0xff)) ;
		$r->objects[sizeof($r->objects)] = $color ;
		$stack[$key] = $color ;
	}

	static function fn8() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$n = $r->tokens[$r->index++];
		$a = new MSDict();
		$r->objects[sizeof($r->objects)] = $a ;
		for ($j=0;$j<$n;$j++) {
			$idx = $r->tokens[$r->index++];
			$k = $r->keys[$idx] ; // the key is a string
			// echo "=== dict obj > $k";
			MSTEResult::decodeObject($r, $a, $k) ; // we decode the value
		}
		$stack->setValueForKey($a, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	static function fn9() { 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$val = $r->objects[$r->tokens[$r->index++]];
		$stack->setValueForKey($val, $key) ;
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	// array
	static function fn20() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$n = $r->tokens[$r->index++];
		$a = new MSArray();
		$r->objects[sizeof($r->objects)] = $a ;
		for ($j=0;$j<$n;$j++) { 
			MSTEResult::decodeObject($r, $a, $j) ; 
		}
		$stack->setValueForKey($a, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';		
	}

	static function fn21() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$j = $n = $r->tokens[$r->index++];
		$a = new MSNaturalArray() ;
		$r->objects[sizeof($r->objects)] = $a ;
		for ($j=0; $j<$n; $j++) {
			$a->setValueForKey($r->tokens[$r->index++], $j);
		}
		$stack->setValueForKey($a, $key);		
	}

	static function fn22() {
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args()); 
		$c = new MSCouple();
		$r->objects[sizeof($r->objects)] = $c ;
		MSTEResult::decodeObject($r, $c, MSCouple::FIRST_MEMBER);
		MSTEResult::decodeObject($r, $c, MSCouple::SECOND_MEMBER) ; 
		$stack->setValueForKey($c, $key);
	}

	static function fn23() { 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$a = new MSData($r->tokens[$r->index++]) ; 
		$r->objects[sizeof($r->objects)] = $a ;
		$stack->setValueForKey($a, $key);
	}

	static function fn24() { 
		// $stack[$key] = Date.DISTANT_PAST ; 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$stack->setValueForKey(MSDate::$datePast, $key);
	}

	static function fn25() { 
		// $stack[$key] = Date.DISTANT_FUTURE ; 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$stack->setValueForKey(MSDate::$dateFuture, $key);
	}

	static function fn26() { 
		// $stack[$key] = String.EMPTY_STRING ; 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$stack->setValueForKey('', $key);
	}

	static function fn27() { 
		$r=$stack=$key=null;
		MSTEResult::_getFuncParams($r, $stack, $key, func_get_args());
		$stack->setValueForKey($r->objects[$r->tokens[$r->index++]], $key);
	}

}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Log functions
// -----------------------------------------------------------------------------
function logEventTab($disp, $arr) {
	if ($disp) {
		echo '<br>Tab : <br>';
		print_r($arr);
		echo '<br>';
	}
}

function logEvent($disp, $s) {
	if ($disp) {
		echo '<br>Log > ';
		echo $s;
	}
}
// -----------------------------------------------------------------------------

?>