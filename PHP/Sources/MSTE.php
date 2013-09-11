<?php

require_once('MSContainers.php');
require_once('MSTEEncoder.php');
require_once('MSTEDecoder.php');

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

	// create MSTE array from object
	public static function tokenize($obj) {
		$r = null ;
		try {
			$r = MSTE::_msteEncodePrivate($obj);
		}
		catch (Exception $e) { 
			echo "Unable to create MSTE array : ".$e->getMessage(); 
		}
		return $r;
	}

	// create MSTE string from object
	public static function stringify($obj) {
		$r = null ;
		try {
			$r = MSTE::tokenize($obj);
			$s = json_encode($r);
		}
		catch (Exception $e) { 
			echo "Unable to create MSTE string : ".$e->getMessage(); 
		}
		return $s;
	}

	private static function _msteDecodePrivate($source, $options) {
		$r = new MSTEResult($source, $options) ;
		MSTEResult::decodeObject($r, &$r, 'root') ;
		// logEvent(true, "<br>Obbjet retenu : ".print_r($r->objects, true));
		// print_r($r->objects);
		// delete $r['tokens'] ;
		// delete $r['objects'] ;
		// delete $r['index'] ;
		return $r;
	}

	private static function _msteEncodePrivate($rootObject) {
		$e = new MSTEEncoder($rootObject);	
		// echo '<hr>'.print_r($e,true).'<hr>';
		return $e->getTokens();
	}
}


// -----------------------------------------------------------------------------
// Interce for user Classes
// -----------------------------------------------------------------------------
interface iMSTE {

	// must ovveride to use constructor and init with dict param return instance
	// return nothing
	public static function initWithDictionnary(&$obj,&$dict);

	// replace an empty constructor
	// return a blank object
	public static function newObject();
	
	// get the correspondance table for object attributes
	// return MSDict classValue => msteValue
	public static function MSTESnapshot();

}

class MSClass {

	const CONSTR = 'newObject';
	const INIT	 = 'initWithDictionnary'; 
	const SNAP 	 = 'MSTESnapshot';

	static function getNew($class) {
		return $class.'::'.MSClass::CONSTR;
	}

	static function getInit($class) {
		return $class.'::'.MSClass::INIT;
	}

	static function getSnap($class) {
		return $class.'::'.MSClass::SNAP;
	}

}

// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// functions
// -----------------------------------------------------------------------------

function object2Array ($o) {
	if (!is_object($o)) {
		return null;
	}

	$attr = (array) $o;
	$attrRes = array();
	$attrCount = sizeof($attr);
	foreach ($attr as $key => $value) {
		$keys = mb_split(chr(0), $key);
		if (sizeof($keys) >= 3) {
			$attrRes[$keys[2]] 	= $value;
		} else {
			$attrRes[$key] 		= $value;
		}
	}
	unset ($attr);
	return $attrRes;
}

function AsciiToInt($char){
	$success = "";
	if(strlen($char) == 1)
		return "char(".ord($char).")";
	else{
		for($i = 0; $i < strlen($char); $i++){
			if($i == strlen($char) - 1)
				$success .= ord($char[$i]);
			else
				$success .= ord($char[$i]).",";
		}
		return "char(".$success.")";
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
		// echo '<br>Log > ';
		echo $s;
	}
}
// -----------------------------------------------------------------------------


?>