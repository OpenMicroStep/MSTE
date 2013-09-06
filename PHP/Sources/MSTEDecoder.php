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
	public $copyStrings;
	// public $correspondances;
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
		$this->copyStrings = true ;
		// $this->correspondances = null ;
		for ($i=0; $i<$cn; $i++) { 
			$this->classes[$i] = $this->tokens[4+$i]; 
		}
		$kn = $this->tokens[4+$cn];
		for ($i=0; $i<$kn; $i++) { 
			$this->keys[$i] = $this->tokens[5+$cn+$i]; 
		}
		$this->index = 5+$cn+$kn;
		
		if ($options && sizeof($options)>0) {
			// $r->correspondances = $options->classes ;
			$this->copyStrings = array_key_exists('copyStrings', $options) ? $options['copyStrings'] : false;
			$this->withClass = array_key_exists('withClass', $options) ? (bool)$options['withClass'] : true; 
			$this->withMSString = array_key_exists('withMSString', $options) ? (bool)$options['withMSString'] : true; 
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
			
			echo '<hr>Ready : '.(MSTEResult::isReadyForMSTE($futureClass)?'OUI':'NON').'<hr>';
			echo '<hr>Bool : '.(MSTEResult::isReadyForMSTE($futureClass)?'OUI':'NON').'<hr>';
			if ($r->withClass || MSTEResult::isReadyForMSTE($futureClass)) {
				echo '<hr>Cas Class <hr>';
				$bCls = true;
				$code = 28;
			} else { 
				echo '<hr>Cas Dict <hr>';
				$code = 8;	
			}
			echo '<hr>Code :'.$code.'<hr>';
			$uClsN = $futureClass;
		} 
		$fn = $r->fns[$code];
		// logEvent(MSTEResult::$trace, "<br>>Fonction $fn");

		call_user_func(get_class($r)."::".$fn, $r, $stack, $key, $bCls, $uClsN);

	}

	// generic function to retrieve byRef parameters 
	static function _getFuncParams(&$r, &$stack, &$key, &$uClsB, &$uClsN, $args){
		$r 		= $args[0];
		$stack 	= $args[1];
		$key 	= $args[2];
		$uClsB	= sizeof($args) == 4 ? $args[3] : false;
		$uClsN 	= sizeof($args) == 5 ? $args[4] : '';
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
		$stack->setValueForKey($v, $key);
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
		$v = ($r->copyStrings ? $r->tokens[$r->index++] : new MSString($r->tokens[$r->index++])) ;
		// $v = $r->tokens[$r->index++];
		$r->objects[sizeof($r->objects)] = &$v;
		$stack->setValueForKey(&$v, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	static function fn6() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$timeInSeconds = $r->tokens[$r->index++];
		$d = new MSDate($timeInSeconds);
		$r->objects[sizeof($r->objects)] = &$d;
		$stack->setValueForKey(&$d, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	static function fn7() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$trgb = $r->tokens[$r->index++];
		$color = new MSColor(($trgb >> 16) & 0xff, ($trgb >> 8) & 0xff, $trgb & 0xff, 0xff - (($trgb >> 24) & 0xff)) ;
		$r->objects[sizeof($r->objects)] = &$color ;
		$stack->setValueForKey(&$color, $key) ;
	}

	static function fn8() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());

		logEvent(MSTEResult::$trace, "<br><br>-- FN8 > deb");
		logEvent(MSTEResult::$trace, "<br>&nbsp;&nbsp;&nbsp;&nbsp; classe : ".$uClsN);

		$n = $r->tokens[$r->index++];
		// logEvent(MSTEResult::$trace, "<br>&nbsp;&nbsp;&nbsp;&nbsp; Nombre elts dict : ".$n);

		if (!$uClsB) {
			$a = new MSDict();
			$a->className = $uClsN; // new
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
			$stack->setValueForKey(&$a,$key);
			// logEvent(MSTEResult::$trace, "<br>&nbsp;&nbsp;&nbsp;&nbsp; Ajout clef : $key");
		}

		logEvent(MSTEResult::$trace, "<br><br>-- FN8 > fin");

	}

	static function fnCls() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		logEvent(MSTEResult::$trace, "<br><br>-- FN CLS > deb");
		logEvent(MSTEResult::$trace, "<br>-- FN CLS > class : ".$uClsN);
		logEvent(MSTEResult::$trace, "<br>-- FN CLS > classB : ".($uClsB?'OUI':'NON'));


		if ($uClsB && MSTEResult::isReadyForMSTE($uClsN)) { 
			logEvent(MSTEResult::$trace, "<br>-- FN CLS > cas CLS : ");
			$obj = call_user_func($uClsN.'::newObject');
			$r->objects[sizeof($r->objects)] = &$obj;
			$a = new MSDict();
			MSTEResult::fn8($r, &$a, $key, true, $uClsN); // generate dict obj for class constructor
			call_user_func($stack->className.'::initWithDictionnary', &$obj, &$a);
		} else {
			logEvent(MSTEResult::$trace, "<br>-- FN CLS > cas dict : ");
			$obj = new MSDict();
			$r->objects[sizeof($r->objects)] = &$obj;
			MSTEResult::fn8($r, &$obj, $key, false, $uClsN);
			// print_r($obj);
		}

		$stack->setValueForKey(&$obj, $key);
		logEvent(MSTEResult::$trace, "<br><br>-- FN CLS > FIN");
	}

	static function fn9() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey(&$r->objects[$r->tokens[$r->index++]], $key) ;
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';
	}

	// array
	static function fn20() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$n = $r->tokens[$r->index++];
		$a = new MSArray();
		$r->objects[sizeof($r->objects)] = $a ;
		for ($j=0;$j<$n;$j++) { 
			// logEvent(MSTEResult::$trace, "<hr><hr><br>ARRAY<br><br><hr><hr>");
			// logEvent(MSTEResult::$trace, "<hr><br>ARRAY<br>".print_r($stack->getValueFromKey($j),true)."<br><hr>");
			MSTEResult::decodeObject($r, $a, $j) ; 
		}
		$stack->setValueForKey($a, $key);
		// echo "<br>key : $key<br>";print_r($stack);echo '<br><br>';		
	}

	static function fn21() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$j = $n = $r->tokens[$r->index++];
		$a = new MSNaturalArray() ;
		$r->objects[sizeof($r->objects)] = $a ;
		for ($j=0; $j<$n; $j++) {
			$a->setValueForKey($r->tokens[$r->index++], $j);
		}
		$stack->setValueForKey($a, $key);		
	}

	static function fn22() {
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args()); 
		$c = new MSCouple();
		$r->objects[sizeof($r->objects)] = $c ;
		MSTEResult::decodeObject($r, $c, MSCouple::FIRST_MEMBER);
		MSTEResult::decodeObject($r, $c, MSCouple::SECOND_MEMBER) ; 
		$stack->setValueForKey($c, $key);
	}

	static function fn23() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$a = new MSData($r->tokens[$r->index++]) ; 
		$r->objects[sizeof($r->objects)] = $a ;
		$stack->setValueForKey($a, $key);
	}

	static function fn24() { 
		// $stack[$key] = Date.DISTANT_PAST ; 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey(MSDate::$datePast, $key);
	}

	static function fn25() { 
		// $stack[$key] = Date.DISTANT_FUTURE ; 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey(MSDate::$dateFuture, $key);
	}

	static function fn26() { 
		// $stack[$key] = String.EMPTY_STRING ; 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey('', $key);
	}

	static function fn27() { 
		$r=$stack=$key=$uClsB=$uClsN=null;
		MSTEResult::_getFuncParams($r, $stack, $key, $uClsB, $uClsN, func_get_args());
		$stack->setValueForKey($r->objects[$r->tokens[$r->index++]], $key);
	}

	static function isReadyForMSTE($cls) {
		$methodArr = get_class_methods($cls);
		return in_array('initWithDictionnary', $methodArr) && in_array('newObject', $methodArr);
	}
}
// -----------------------------------------------------------------------------



// class MSTENormalizer extends MSObject {

// 	public $objRes = array();

// 	function __construct($rootObject) {

// 		$this->_normalizeObj($rootObject) ;

// 	}

// 	private function _normalizeObj($o) {

// 		$cls = '';
		
// 		if ($o) {
// 			$cls = gettype($o); 
// 			if ($cls == 'object' && isset($o->isA)) {
// 				$cls = $o->isA; 
// 			}
// 			if ($cls == 'array' && array_key_exists('isA', $o)) {
// 				$cls = $o['isA']; 
// 			}
// 			logEvent(MSTEEncoder::$trace, "<br>Type : ".$cls."<br>");

//  			switch ($cls) {
//  				case 'boolean':
//  				case 'integer':
//  				case 'double':
//  				case 'string':
//  				case MSType::MSSTRING:
//  				case MSType::MSDATE:
//  				case MSType::MSDATA:
//  				case MSType::MSCOLOR:
//  				case MSType::MSNATURALARRAY:
// 				case MSType::MSCOUPLE:
//  					$this->objRes[sizeof($this->objeRes)] = $o;
//  					break;
//  				case 'array':
//  				case MSType::MSARRAY:
// 					$jcount = $cls==MSType::MSARRAY ? $o->getSize() : sizeof($o);
// 					for ($j=0; $j<$jcount; $j++) {
// 						$obj =  $cls==MSType::MSARRAY ? $o->getValueFromKey($j) : $o[$j];
// 						// logEvent(MSTEEncoder::$trace, "<hr>TYPE Array : <br>".print_r($obj,true)."<hr>");
// 						$this->_normalizeObj($obj) ;
// 					}
// 					break;
// 				 default:
// 					$userCls = get_class($o);
// 					if ($userCls===MSType::MSOBJECT || $userCls===MSType::MSDICT) {
// 						$userCls = $o->className;
// 					}
// 					logEvent(MSTEEncoder::$trace, "<br>Obj Type : ".$userCls."<br>");
// 					$arrObj = $o->getValues();

// 					foreach ($o->getValues() as $key => $value) {
// 						$this->_normalizeObj($value);
// 					}
// 						if (in_array('newWithDictionnary', get_class_methods($userCls))) { 
// 							$obj = call_user_func($userCls.'::newWithDictionnary', $o);
// 							logEvent(true, "<br>---- Trace AV : ".print_r($o,true));
// 							logEvent(true, "<br>---- Trace AP : ".print_r($obj,true));
// 							$this->objRes[sizeof($this->objRes)] = $obj;
// 						}
// 						else {$this->objRes[sizeof($this->objRes)] = $o;}
// 			}

// 		}

// 	}

// }

// public static function decodeObject($r, &$stack, $key, $uCls=false) {
// 	$futureClass = null;
// 	$code = $r->tokens[$r->index++] ;
// 	if (($code > 27 && $code <50) | $code < 0) {
// 		throw new Exception('Unable to decode token with code '.$code) ;
// 	}
// 	else if ($code >= 50) {
// 		$futureClass = $r->classes[floor(($code-50)/2)];
// 		$r->currentClass = $futureClass;
// 		// $code = 28;
// 		$code = 8;
// 	}
// 	$fn = $r->fns[$code];
// 	logEvent(MSTEResult::$trace, "<hr>Fonction $fn<hr>");
// 	call_user_func(get_class($r)."::".$fn, $r, $stack, $key) ;
	
// 	if ($futureClass) {
// 		logEvent(MSTEResult::$trace, "<hr>FUTURE CLASS $futureClass<hr>");
// 		if (class_exists($futureClass)) {
// 			// logEvent(MSTEResult::$trace, "<hr>CLASS <br>".print_r($r, true)."<hr>");
// 			// logEvent(MSTEResult::$trace, "<hr>KEY $key<hr>");
// 			// logEvent(MSTEResult::$trace, "<hr>CLASS <br>".print_r($stack->getValueFromKey($key),true)."<hr>");
// 			// print_r(get_class_methods($futureClass));
// 			if (in_array('newWithDictionnary', get_class_methods($futureClass))) {
// 				$obj = $stack->getValueFromKey($key);
// 				$class = call_user_func($futureClass.'::newWithDictionnary', $stack->getValueFromKey($key));
// 				$obj->setValueForKey($class, $key);
// 				logEvent(MSTEResult::$trace, "<hr>CLASS <br>".print_r($stack, true)."<hr>");
// 			} else {
// 				throw new Exception('Unable to find class method newWithDictionnary') ;
// 			}
// 		} else {
// 			throw new Exception('Unable to find user class '.$futureClass) ;
// 		}
// 	}
// }


?>