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

	// create MSTE string from object
	public static function encode($obj) {
		$r = null ;
		try {
			$r = MSTE::_msteEncodePrivate($obj) ;
		}
		catch (Exception $e) { 
			echo "Unable to create MSTE string : ".$e->getMessage(); 
		}
		return $r;
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
		return $e->getTokens();
	}
}


// -----------------------------------------------------------------------------
// functions
// -----------------------------------------------------------------------------
function object2Array ($o) {
	if (gettype($o) !== "object") {
		return null;
	}

	$attr = array();
	$size =strlen(get_class($o))+2;
	while (list($key,$value) = each($o)) {
		if (strlen($key) > $size) {
			$k = substr($key, $size); // du to classe name separator
			$attr[$k] = $value;
		}
	}
	// logEvent(MSTEEncoder::$trace, "<hr>TABEEEEEE  : ".print_r(array_keys($attr), true)."<hr>");
	return $attr;
}

function get_class_members ($o) {
	if (gettype($o) != "object") {
		return null;
	}

	$attr = array();
	while (list($key,$value) = each($o)) {
		array_push($attr, str_replace(get_class($o), '', $key));
	}
	return $attr;
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