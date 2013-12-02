<?php

// -----------------------------------------------------------------------------
// Existing MS Types
// -----------------------------------------------------------------------------
class MSType {

	const MSOBJECT 			= "MSObject";
	const MSARRAY 			= "MSArray"; 
	const MSNATURALARRAY	= "MSNaturalArray";
	const MSDICT 			= "MSDict";
	const MSCOUPLE			= "MSCouple";
	const MSDATE 			= "MSDate";
	const MSCOLOR 			= "MSColor";
	const MSDATA 			= "MSData";
	const MSSTRING 			= "MSString";
} 

// -----------------------------------------------------------------------------
// Class Object : bases class for decoding
// -----------------------------------------------------------------------------
class MSObject {
	protected $_values;
	public $className;
	public $isA;

	function __construct() {
		$this->isA = MSType::MSOBJECT; 
	}

	function getValueFromKey($key) {
		if (sizeof($this->_values) == 0) {return null;}
		return (array_key_exists($key, $this->_values) ? $this->_values[$key] : null);
		// return $this->_values[$key];
	}

	function setObjectForKey(&$value, $key) {
		$this->_values[$key] = $value;
	}

	function setValueForKey($value, $key) {
		$this->_values[$key] = $value;
	}

	function getValues() {
		return $this->_values;
	}
}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Array class
// -----------------------------------------------------------------------------
class MSArray extends MSObject {
	function __construct() {
		$this->isA = MSType::MSARRAY;
	}

	function getValueFromKey($key) {
		if (is_int($key)) return $this->_values[$key];
	}

	function setObjectForKey(&$value, $key) {
		if (is_int($key)) { 
			$this->_values[$key] = $value;
		}
	}
	function getSize() {
		return sizeof($this->_values);
	}
}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// NAtural Array class
// -----------------------------------------------------------------------------
class MSNaturalArray extends MSObject {
	function __construct($arr=null) {
		$this->isA = MSType::MSNATURALARRAY;
		$this->_values = array();
		if ($arr!=null) {
			for ($j=0; $j<sizeof($arr); $j++) {
				array_push($this->_values, round($arr[$j]));
			}

		}
	}

	function getValueFromKey($key) {
		if (is_int($key)) return $this->_values[$key];
	}

	function setObjectForKey(&$value, $key) {
		if (is_int($key)) { 
			array_push($this->_values, $value);
		}
	}

	// function getValues() {
	// 	return $this->_values;
	// }
}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Dictionnary Class
// -----------------------------------------------------------------------------
class MSDict extends MSObject {
	function __construct() {
		$this->isA = MSType::MSDICT;
	}

	public static function  initWithArray($arr) {
		if (isAssoc($arr)) {
			$d = new MSDict();
			foreach ($arr as $key => $value) {
				$d->setObjectForKey($value, $key);
			}
			return $d;
		}
		return null;
	}
}

function isAssoc($array) {
	return ($array !== array_values($array));
}

// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// COUPLE Class
// -----------------------------------------------------------------------------
class MSCouple extends MSObject {

	const FIRST_MEMBER = "firstMember"; 
	const SECOND_MEMBER = "secondMember"; 

	function __construct($f=null, $s=null) {
		$this->isA 			= MSType::MSCOUPLE;
		$this->setFirstMember($f);
		$this->setSecondMember($s);
	}

	function getValueFromKey($key) {
		if ($key == MSCouple::FIRST_MEMBER || $key == MSCouple::SECOND_MEMBER) { 
			return $this->_values[$key];
		}
	}

	function getFirstMember() {
		return $this->getValueFromKey(MSCouple::FIRST_MEMBER);
	}

	function getSecondMember() {
		return $this->getValueFromKey(MSCouple::SECOND_MEMBER);
	}

	function setObjectForKey(&$value, $key) {
		if ($key == MSCouple::FIRST_MEMBER || $key == MSCouple::SECOND_MEMBER) { 
			$this->_values[$key] = $value;
		}
	}

	function setFirstMember($value) {
		$this->setObjectForKey($value, MSCouple::FIRST_MEMBER);
	}

	function setSecondMember($value) {
		$this->setObjectForKey($value, MSCouple::SECOND_MEMBER);
	}
}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// DATA Class
// -----------------------------------------------------------------------------
class MSData extends MSObject{
	
	const B64_STRING = 'base64String';
	const B64_LENGHT = 'base64Length';
	
	function __construct($data) {
		$this->isA 	= MSType::MSDATA;

		$this->setString($data);
		$l = (strlen($data) > 1) ? strlen($data)-1 : 0 ; // we remove the final '=' from the length
		$this->setLength($l);
		// echo $this->_isBase64Valid() ? "<hr>OUI<hr>" : "<hr>NON<hr>";
	}

	// getters
	function getValueFromKey($key) {
		if ($key == MSData::B64_STRING || $key == MSData::B64_LENGHT) { 
			return $this->_values[$key];
		}
	}
	function getString() {
		return $this->getValueFromKey(MSData::B64_STRING);
	}
	function toString() {
		return $this->getString();
	}
	function getLength() {
		return $this->getValueFromKey(MSData::B64_LENGHT);
	}

	// setters
	function setObjectForKey(&$value, $key) {
		if ($key == MSData::B64_STRING || $key == MSData::B64_LENGHT) { 
			$this->_values[$key] = $value;
		}
	}
	function setString($value) {
		$this->setObjectForKey($value, MSData::B64_STRING);
	}
	function setLength($value) {
		$this->setObjectForKey($value, MSData::B64_LENGHT);
	}

	private function _isBase64Valid() {
 		return (bool) preg_match('/^[a-zA-Z0-9\/\r\n+]*={0,2}$/', $this->getString());
 		// return  (bool) (base64_encode(base64_decode($this->getString())) === $this->getString());

	}
	private function _isBase64ValidDecode() {
		return base64_decode($mystring, true);
	}

	public static function isValid($s) {
		return (bool) preg_match('/^[a-zA-Z0-9\/\r\n+]*={0,2}$/', $s);
	}
}
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// DATA Class
// -----------------------------------------------------------------------------
class MSString extends MSObject{
	
	const S_STRING = 'sString';
	const S_LENGHT = 'sLength';
	
	function __construct($data) {
		$this->isA 	= MSType::MSSTRING;
		$this->setString($data);
		$this->setLength(strlen($data));

	}

	// getters
	function getValueFromKey($key) {
		if ($key == MSString::S_STRING || $key == MSString::S_LENGHT) { 
			return $this->_values[$key];
		}
	}
	function getString() {
		return $this->getValueFromKey(MSString::S_STRING);
	}
	function toString() {
		return $this->getValueFromKey(MSString::S_STRING);
	}
	function getLength() {
		return $this->getValueFromKey(MSString::S_LENGHT);
	}

	// setters
	function setObjectForKey(&$value, $key) {
		if ($key == MSString::S_STRING || $key == MSString::S_LENGHT) { 
			$this->_values[$key] = $value;
		}
	}
	function setString(&$value) {
		$this->setObjectForKey($value, MSString::S_STRING);
	}
	function setLength(&$value) {
		$this->setObjectForKey($value, MSString::S_LENGHT);
	}
}
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Date Class
// -----------------------------------------------------------------------------
class MSDate {
	public $isA;
	private $orginalTimeValue;
	private $decodedTimeValue;

	const DISTANT_PAST 		= -8640000000000000 ;
	const DISTANT_FUTURE 	= 8640000000000000 ;

	public static $dateFuture;
	public static $datePast;
	private static $ddp;
	private static $ddf;

	function __construct($val, $isUTC=true) {
		$this->isA 				= MSType::MSDATE;
		$this->orginalTimeValue = $val;
		if (!$isUTC) {	
			$this->decodedTimeValue = $this->_decodeValue();
		} else {
			$this->decodedTimeValue = $this->orginalTimeValue;
		}
	}
	private function _decodeValue() {
		$timeInSeconds = $this->orginalTimeValue;
		$res = null;
		if ($timeInSeconds >= MSDate::DISTANT_FUTURE) { $res =  MSDate::DISTANT_FUTURE ; }
		else if ( $timeInSeconds <= MSDate::DISTANT_PAST) { $res = MSDate::DISTANT_PAST ; }
		else {
			$res = $this->_initWithUTCSeconds() ;
		}
		return $res;
	}

	private function _initWithUTCSeconds() {
		$dtBase = mktime(0, 0, 0, 1, 1, 1970);
		// $offset = Date('Z');
		// echo $offset.'<br>';
		$d 		= $dtBase + $this->orginalTimeValue ;
		return $d;
	}

	function getValue() {
		return $this->decodedTimeValue;
	}

	function getOriginalValue() {
		return $this->orginalTimeValue;
	}

	function getDateFormat($format='d-m-Y') {
		return date($format,$this->decodedTimeValue);

	}

	public static function getDatePast() {
		if (!isset(MSDate::$ddp)){
			MSDate::$ddp = new MSDate(MSDate::DISTANT_PAST);
		}
		// echo '<hr>'.MSDate::$ddp->getValue().'<hr>';
		return MSDate::$ddp->getValue();
	}
	public static function getDateFuture() {
		if (!isset(MSDate::$ddf)){
			MSDate::$ddf = new MSDate(MSDate::DISTANT_FUTURE);
		}
		// echo '<hr>'.MSDate::$ddf->getValue().'<hr>';
		return MSDate::$ddf->getValue();
	}
}
MSDate::$datePast = new MSDate(MSDate::DISTANT_PAST);
MSDate::$dateFuture = new MSDate(MSDate::DISTANT_FUTURE);
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Color Class
// -----------------------------------------------------------------------------
class MSColor {
	public $isA;
	private $red;
	private $green;
	private $blue;
	private $alpha;

	// public $redColor 	= MSColor(0xff,0,0);
	// public $whiteColor 	= new MSColor(0xff, 0xff, 0xff);
	// public $blackColor 	= new MSColor(0,0,0);

	public static $colorStringRegex 		= '/[a-f0-9]{6}/'; //'/^(\w{2})(\w{2})(\w{2})$/' ;
	public static $shortColorStringRegex 	= '/[a-f0-9]{3}/'; //'/^(\w{1})(\w{1})(\w{1})$/' ;
	public static $namedColors 	= array(
		"beige" 	=> 'f5f5dc', "black" 		=> '000000', "blue" 	=> '0000ff',
		"brown"	 	=> 'a52a2a', "cyan" 		=> '00ffff', "fuchsia" 	=> 'ff00ff',
		"gold" 		=> 'ffd700', "gray" 		=> '808080', "green" 	=> '008000',
		"indigo " 	=> '4b0082', "ivory" 		=> 'fffff0', "khaki" 	=> 'f0e68c',
		"lavender" 	=> 'e6e6fa', "magenta" 		=> 'ff00ff', "maroon" 	=> '800000',
		"olive" 	=> '808000', "orange" 		=> 'ffa500', "pink" 	=> 'ffc0cb',
		"purple" 	=> '800080', "red" 			=> 'ff0000', "salmon" 	=> 'fa8072',
		"silver" 	=> 'c0c0c0', "snow" 		=> 'fffafa', "teal"		=> '008080',
		"tomato" 	=> 'ff6347', "turquoise" 	=> '40e0d0', "violet" 	=> 'ee82ee',
		"wheat" 	=> 'f5deb3', "white" 		=> 'ffffff', "yellow" 	=> 'ffff00'
	);

	function __construct() {
		$this->isA 	= MSType::MSCOLOR;
		$nb 		= func_num_args();
		$args 		= func_get_args();

		// echo '<br>Args: '.gettype($args[0]).'<br>';
		if ($nb==1 && gettype($args[0]) == 'string') {
			$this->_initWithString($args);
		}
		else if ($nb>=3) {
			$this->_initWithValues($args);
		}
		else if ($nb>=1 && gettype($args[0]) == 'integer') {
			$this->_initWithValue($args);
		}
		else {
			$this->_initDefault();
		}
	}

	private function _initWithString($args) {
		$r = $args[0];
		if (gettype($r) == 'string') {
			$s = $bits = null; 
			$ok = true;
			$r = preg_replace('/\s\s+/', '', $r); 

			if (!strlen($r)>0) { $ok = false ; }
		    if ($ok && $r[0] == '#') { $r = substr($r, 1); }
		    if ($ok && strlen($r) < 3) { $ok = false ; }
			if ($ok) {
			    $r 		= strtolower($r);
				$s 		= isset(MSColor::$namedColors[$r]) ? MSColor::$namedColors[$r] : '';
				$v 		= $s?$s:$r;
				if (preg_match(MSColor::$colorStringRegex, $v)) { 
					$bits 	= str_split($v, 2);
				}
		        
				if (sizeof($bits) != 3) {
					if (preg_match(MSColor::$shortColorStringRegex, $v)) { 
			        	$bits = str_split($v, 1);
			        }
					if (sizeof($bits) != 3) { $ok = false ; }
				}
				if ($ok) {
				    $this->red 		= hexdec('0x'.$bits[0]);
				    $this->green 	= hexdec('0x'.$bits[1]);
				    $this->blue 	= hexdec('0x'.$bits[2]);
				}
			}		
			if (!$ok) {
				$this->red = $this->green = $this->blue = 0 ;
			}
			$this->alpha = 255 ;
		} 
	}

	private function _initWithValue($args) {
		if (isset($args[0])) { 
			$r = $args[0];
			$this->red 		= ($r >> 16) & 0xff;
			$this->green 	= ($r >> 8) & 0xff;
			$this->blue 	= $r & 0xff;
			$this->alpha 	= 255;
		} else {$this->_initDefault();}
	}

	private function _initWithValues($args) {
		// echo "Args 0 : ".$args[0].'<br>';
		// echo "Args 1 : ".$args[1].'<br>';
		// echo "Args 2: ".$args[2].'<br>';
		if ($args != null && sizeof($args)>1 && $args[1] !== '' && $args[2] !== '') { 
			$this->red 		= ($args[0] === '' || $args[0] < 0) ? 0 : ($args[0]>255 ? 255 : $args[0]);
			$this->green 	= ($args[1] === '' || $args[1] < 0) ? 0 : ($args[1]>255 ? 255 : $args[1]);
			$this->blue 	= ($args[2] === '' || $args[2] < 0) ? 0 : ($args[2]>255 ? 255 : $args[2]);

			$this->alpha 	= (isset($args[3]) && $args[3] !== '') ? $args[3] : 255;
		} else {$this->_initDefault();}
	}

	private function _initDefault() {
		$this->red 		= 0;
		$this->green 	= 0;
		$this->blue 	= 0;
		$this->alpha 	= 255;
	}

	public function getStringValue($withAlpha=false) {
		$r  = str_pad(dechex($this->red), 2, '0', STR_PAD_LEFT);
		$r .= str_pad(dechex($this->green), 2, '0', STR_PAD_LEFT);
		$r .= str_pad(dechex($this->blue), 2, '0', STR_PAD_LEFT);
		if ($withAlpha) { 
			$r .= str_pad(dechex($this->alpha), 2, '0', STR_PAD_LEFT); 
		}
		return '#'.$r;
	}

	public function getValue($withAlpha=false) {
		if ($withAlpha) {
			$res = ($this->red << 24) | ($this->green << 16) | ($this->blue << 8) | $this->alpha;
		} else {
			$res = ($this->red << 16) | ($this->green << 8) | ($this->blue);
		}
		return dechex($res);

	}

	public function toString() {
		$s  = 'Couleur RVB > ';
		$s .= '('.$this->red.', ';
		$s .= ''.$this->green.', ';
		$s .= ''.$this->blue.') ';
		$s .= 'A : '.$this->alpha.'';
		return $s;		
	}
}
// -----------------------------------------------------------------------------

?>