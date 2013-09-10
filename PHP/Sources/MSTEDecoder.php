<?php

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
	public $fns = array(
		'fn0', 'fn1', 'fn2', 'fnn', 'fnn',
		'fn5', 'fn6', 'fn7', 'fn8', 'fn9',
		'fnt', 'fnt', 'fnt', 'fnt', 'fnt',
		'fnt', 'fnt', 'fnt', 'fnt', 'fnt',
		'fn20', 'fn21', 'fn22', 'fn23', 'fn24', 
		'fn25', 'fn26', 'fn27', 'fnCls'
	);

	public $withClass = true;
	public $withMSString = false;

	protected static $trace = true;

	function __construct($source, $options=null) {
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
		for ($i=0; $i<$cn; $i++) { 
			$this->classes[$i] = $this->tokens[4+$i]; 
		}
		$kn = $this->tokens[4+$cn];
		for ($i=0; $i<$kn; $i++) { 
			$this->keys[$i] = $this->tokens[5+$cn+$i]; 
		}
		$this->index = 5+$cn+$kn;
		
		if ($options && sizeof($options)>0) {
			$this->withClass = array_key_exists('withClass', $options) ? (bool)$options['withClass'] : true; 
			$this->withMSString = array_key_exists('withMSString', $options) ? (bool)$options['withMSString'] : false; 
		}
	}

	public static function decodeObject($r, &$stack, $key, $uClsB=false, $uClsN='') {

		$code = $r->tokens[$r->index++] ;
		$futureClass = null;
		$bCls = $uClsB;
		if (($code > 27 && $code < 50) | $code < 0) {
			throw new Exception("Unable to decode token with code ".$code);
		}
		else if ($code >= 50) {
			$futureClass = $r->classes[floor(($code-50)/2)];
			
			// logEvent(MSTEResult::$trace, '<hr>Ready : '.(MSTEResult::isReadyForMSTE($futureClass)?'OUI':'NON').'<br>');
			if ($r->withClass  && MSTEResult::isReadyForMSTE($futureClass)) {
				$bCls = true;
				$code = 28;
			} else { 
				$code = 8;	
			}
			$uClsN = $futureClass;
		} 
		// logEvent(MSTEResult::$trace, "<hr>Fonction : $code<hr>");
		$fn = $r->fns[$code];
		call_user_func(get_class($r)."::".$fn, $r, $stack, $key, $bCls, $uClsN);
	}

	// generic function to retrieve byRef parameters 
	static function _getFuncParams(&$r, &$stack, &$key, &$uClsB, &$uClsN, $args){
		$r 		= $args[0];
		$stack 	= $args[1];
		$key 	= $args[2];
		$uClsB	= sizeof($args) >= 4 ? $args[3] : false;
		$uClsN 	= sizeof($args) >= 5 ? $args[4] : '';
	}

	// type 10 to 19
	static function fnt() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args()); 
		$stack[$key] = $r->tokens[$r->index++]; 
	}

	// type 3 & 4
	static function fnn() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		// decimal numbers are referenced but copied
		$v = $r->tokens[$r->index++] ;
		$r->objects[sizeof($r->objects)] = $v ;
		$stack->setObjectForKey($v, $key);
	}
	
	static function fn0() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey(null, $key); 
	}

	static function fn1() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args()); 
		$stack->setValueForKey(true, $key); 
	}

	static function fn2() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args()); 
		$stack->setValueForKey(false, $key); 
	}

	static function fn5() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$v = (!$r->withMSString ? $r->tokens[$r->index++] : new MSString($r->tokens[$r->index++])) ;
		$r->objects[sizeof($r->objects)] = &$v;
		$stack->setObjectForKey(&$v, $key);
	}

	static function fn6() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$timeInSeconds = $r->tokens[$r->index++];
		$d = new MSDate($timeInSeconds);
		$r->objects[sizeof($r->objects)] = &$d;
		$stack->setObjectForKey(&$d, $key);
	}

	static function fn7() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$trgb = $r->tokens[$r->index++];
		$color = new MSColor(($trgb >> 16) & 0xff, ($trgb >> 8) & 0xff, $trgb & 0xff, 0xff - (($trgb >> 24) & 0xff)) ;
		$r->objects[sizeof($r->objects)] = &$color ;
		$stack->setObjectForKey(&$color, $key) ;
	}

	static function fn8() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());

		// logEvent(MSTEResult::$trace, "<br><br>-- FN8 > deb");
		// logEvent(MSTEResult::$trace, "<br>&nbsp;&nbsp;&nbsp;&nbsp; classe : ".$uClsN);

		$n = $r->tokens[$r->index++];
		if (!$uClsB) {
			$a = new MSDict();
			$a->className = $uClsN; // give type to dict 
			$r->objects[sizeof($r->objects)] = &$a;
		} else {
			$a = &$stack;
		}

		for ($j=0;$j<$n;$j++) {
			$idx = $r->tokens[$r->index++];
			$k = $r->keys[$idx] ; // the key is a string
			MSTEResult::decodeObject($r, &$a, $k, $uClsB, $uClsN) ; // we decode the value
		}
		if (!$uClsB) {
			$stack->setObjectForKey(&$a,$key);
		}

		// logEvent(MSTEResult::$trace, "<br><br>-- FN8 > fin");
	}

	static function fnCls() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		// logEvent(MSTEResult::$trace, "<br><br>-- FN CLS > deb");

		if ($uClsB && MSTEResult::isReadyForMSTE($uClsN)) { 
			// logEvent(MSTEResult::$trace, "<br>-- FN CLS > cas CLS : ");
			$obj = call_user_func(MSClass::getNew($uClsN)); // instantiate blank object
			$r->objects[sizeof($r->objects)] = &$obj;
			$a = new MSDict();
			MSTEResult::fn8($r, &$a, $key, true, $uClsN); // generate dict obj for class constructor
			call_user_func(MSClass::getInit($uClsN), &$obj, &$a);
		} else {
			// logEvent(MSTEResult::$trace, "<br>-- FN CLS > cas dict : ");
			$obj = new MSDict();
			$r->objects[sizeof($r->objects)] = &$obj;
			MSTEResult::fn8($r, &$obj, $key, false, $uClsN);
		}

		$stack->setObjectForKey(&$obj, $key);
		// logEvent(MSTEResult::$trace, "<br><br>-- FN CLS > FIN");
	}

	static function fn9() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setObjectForKey(&$r->objects[$r->tokens[$r->index++]], $key) ;
	}

	// array
	static function fn20() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$n = $r->tokens[$r->index++];
		$a = new MSArray();
		$r->objects[sizeof($r->objects)] = $a ;
		for ($j=0;$j<$n;$j++) { 
			MSTEResult::decodeObject($r, $a, $j) ; 
		}
		$stack->setObjectForKey($a, $key);
	}

	static function fn21() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$j = $n = $r->tokens[$r->index++];
		$a = new MSNaturalArray() ;
		$r->objects[sizeof($r->objects)] = $a;
		for ($j=0; $j<$n; $j++) {
			$a->setObjectForKey($r->tokens[$r->index++], $j);
		}
		$stack->setObjectForKey($a, $key);		
	}

	static function fn22() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args()); 
		$c = new MSCouple();
		$r->objects[sizeof($r->objects)] = &$c;
		MSTEResult::decodeObject($r, &$c, MSCouple::FIRST_MEMBER);
		MSTEResult::decodeObject($r, &$c, MSCouple::SECOND_MEMBER) ; 
		$stack->setObjectForKey(&$c, $key);
	}

	static function fn23() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$a = new MSData($r->tokens[$r->index++]); 
		$r->objects[sizeof($r->objects)] = &$a;
		$stack->setObjectForKey(&$a, $key);
	}

	static function fn24() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setObjectForKey(MSDate::$datePast, $key);
	}

	static function fn25() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setObjectForKey(MSDate::$dateFuture, $key);
	}

	static function fn26() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey('', $key);
	}

	static function fn27() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setObjectForKey($r->objects[$r->tokens[$r->index++]], $key);
	}

	static function isReadyForMSTE($cls) {
		$methodArr = get_class_methods($cls);
		return in_array(MSClass::CONSTR, $methodArr) && in_array(MSClass::INIT, $methodArr);
	}
}
// -----------------------------------------------------------------------------

?>