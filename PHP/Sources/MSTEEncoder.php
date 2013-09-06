<?php

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

	private $stringIndexes = array();
	static $trace = false;

	function __construct($rootObject) {
		$this->_encodeObject($rootObject) ;
	
		if (sizeof($this->stream)>0) {
			
			$icount = sizeof($this->classesNames);
			// logEvent(MSTEEncoder::$trace, "<hr>ICOUNT : ".sizeof($this->tokens)."<hr>");
			$this->tokens[sizeof($this->tokens)] = $icount;
			for ($i=0; $i<$icount; $i++) { $this->tokens[sizeof($this->tokens)] = $this->classesNames[$i]; }
			// logEvent(MSTEEncoder::$trace, "<hr>Classes : <br>Tab : ".print_r($this->classesNames,true)."<hr>");

			$icount = sizeof($this->keyNames);
			$this->tokens[sizeof($this->tokens)] = $icount;
			for ($i=0; $i<$icount; $i++) { $this->tokens[sizeof($this->tokens)] = $this->keyNames[$i]; }
			logEvent(MSTEEncoder::$trace, "<hr>Keys : <br>Tab : ".print_r($this->keyNames,true)."<hr>");
			
			$icount = sizeof($this->stream);
			for ($i=0; $i<$icount; $i++) { $this->tokens[sizeof($this->tokens)] = $this->stream[$i]; }
			logEvent(MSTEEncoder::$trace, "<hr>Stream : <br>Tab : ".print_r($this->stream,true)."<hr>");

			logEvent(MSTEEncoder::$trace, "<hr>Encoded Objects : <br>Tab : ".print_r($this->encodedObjects,true)."<hr>");

			// print_r($this->tokens);
			
			$icount = sizeof($this->encodedObjects) ;
			for ($i=0; $i<$icount; $i++) {
				$element = $this->encodedObjects[$i];
				try {
					//unset ($element[$this->referenceKey]);
				} catch (Exception $e) {}
				// unset($element);
				// delete element[$referenceKey] ;
			}
			
			$this->tokens[1] = sizeof($this->tokens);
			// print_r($this->tokens);
		}		

	}

	public function getTokens() {
		return $this->tokens;
	}

	// -----------------------------------------------------------------------------
	// Encoding functions
	// -----------------------------------------------------------------------------
	// _mustPushObject() can only be used by objects and arrays
	// because the parameter MUST BE passed by REFERENCE
	private function _mustPushObject($o) {
		$identifier = null;
		logEvent(MSTEEncoder::$trace, "<br>_mustPushObject : ".""."<br>");
		if (array_key_exists($this->referenceKey, $o) || isset($o->{$this->referenceKey})) { 
			$identifier = $o->{$this->referenceKey};
			$this->stream[sizeof($this->stream)] = 9; 
			$this->stream[sizeof($this->stream)] = $identifier; 
			return false ;
		} else {
			$identifier = sizeof($this->encodedObjects) ;
			// logEvent(MSTEEncoder::$trace, "<br>Obj id : ".print_r($identifier,true)."<br>");
			if (gettype($o) === "object") {
				$o->{$this->referenceKey} = $identifier;
			} else {
				$o[$this->referenceKey] = $identifier;
			}
			$this->encodedObjects[$identifier] = $o;
			return true ;
		}
		
	}
	
	private function _pushKey($aKey) {
		if ($aKey) {
			// logEvent(MSTEEncoder::$trace, "<hr>Push key indexes: ".print_r($this->keysIndexes,true)."<hr>");
			if (!array_key_exists($aKey, $this->keysIndexes)) {
				$index = sizeof($this->keyNames);
				$this->keyNames[$index] = $aKey ;
				$this->keysIndexes[$aKey] = $index ;
			} else {
				$index = $this->keysIndexes[$aKey];
			}
			logEvent(MSTEEncoder::$trace, "<hr>Push key : $index<hr>");
			$this->stream[sizeof($this->stream)] = $index ;
		}
	}
	
    private function _pushClass($aClass) {
    	if ($aClass) {
			logEvent(MSTEEncoder::$trace, "<hr>_pushClass : $aClass<hr>");
			if (!array_key_exists($aClass, $this->classesIndexes)) { 
				$index = sizeof($this->classesNames) ;
				$this->classesNames[$index] = $aClass ;
				$this->classesIndexes[$aClass] = $index ;
			} else {
				$index = $this->classesIndexes[$aClass];
			}
			$this->stream[sizeof($this->stream)] = 50+2*$index ;
		}

		// logEvent(MSTEEncoder::$trace, "<hr>Class key : ".$this->stream[sizeof($this->stream)-1]."<hr>");
	}

	private function _encodeObject($o) {
		//identifier, c,v,cls, t, j, index, jcount, keys, 
		$forbiddenKeys = array() ;
		$keys = array();
		$jcount = 0;
		$cls = '';
		
		if ($o) {
			$cls = gettype($o); 
			// logEvent(MSTEEncoder::$trace, "<br>Type : ".$o->isA."<br>");
			if ($cls == 'object' && isset($o->isA)) {
				$cls = $o->isA; 
			}
			if ($cls == 'array' && array_key_exists('isA', $o)) {
				$cls = $o['isA']; 
			}

			// logEvent(MSTEEncoder::$trace, "<hr>Fonction ".print_r($o,true)."<hr>");
			// logEvent(MSTEEncoder::$trace, "<br>Type : $cls<br>");
			if ($cls=='boolean') { 
				$this->stream[sizeof($this->stream)] = ($o ? 1 : 2 ) ; 
			}
			else if ($cls=='integer' || $cls=='double') { 
				// if (isFinite($o) && !isNaN($o)) {
				// logEvent(MSTEEncoder::$trace, "<hr>TYPE numeric : ".print_r($o,true)."<hr>");
				if (!is_nan($o)) {
					$identifier = $o[$this->referenceKey] ;
					if ($identifier!=null) { 
						$this->stream[sizeof($this->stream)] = 9; 
						$this->stream[sizeof($this->stream)] = $identifier;
					} else {
						// $identifier = sizeof($this->encodedObjects);
						// logEvent(MSTEEncoder::$trace, "<hr>NUMERIC identifier : ".print_r($identifier,true)."<hr>");
						// (gettype($o) == "object") ?	$o->{$this->referenceKey} = $identifier : $o[$this->referenceKey] = $identifier;
						// $this->encodedObjects[$identifier] = $o ;
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
			}
			else if ($cls=='string' || $cls==MSType::MSSTRING) {
				if (($cls=='string' && strlen($o) == 0) ||($cls==MSType::MSSTRING && $o->getLength()==0) ) { 
					$this->stream[sizeof($this->stream)] = 26 ; 
				}
				else {
					$ch = $cls==MSType::MSSTRING ? $o->getString() : $o;
					if (isset($this->stringIndexes[$ch])) { 
						$this->stream[sizeof($this->stream)] = 9 ; 
						$this->stream[sizeof($this->stream)] = $this->stringIndexes[$ch];
					} else {
						$identifier = sizeof($this->encodedObjects);						
						$this->stringIndexes[$ch] = $identifier;
						$this->encodedObjects[$identifier] = $o ;
						$this->stream[sizeof($this->stream)] = 5 ;
						$this->stream[sizeof($this->stream)] = $cls==MSType::MSSTRING ? $o->toString() : $o;
						//->toString() ; // KEEP IT HERE for MSString
					}	
					// $identifier = $o[$this->referenceKey];
					// if (isset($identifier)) { 
					// 	$this->stream[sizeof($this->stream)] = 9 ; 
					// 	$this->stream[sizeof($this->stream)] = $identifier ;
					// } else {
					// 	$identifier = sizeof($this->encodedObjects) ;
					// 	$o[$this->referenceKey] = $identifier ;
					// 	$this->encodedObjects[$identifier] = o ;
					// 	$this->stream[sizeof($this->stream)] = 5 ;
					// 	$this->stream[sizeof($this->stream)] = $o->toString() ; // KEEP IT HERE for MSString
					// }						
				}
			}		
			else if ($cls==MSType::MSDATE) { 
				$t = $o->getValue();
				if ($t >= MSDate::DISTANT_FUTURE) { $this->stream[sizeof($this->stream)] = 25; }
				else if ($t <= MSDate::DISTANT_PAST) { $this->stream[sizeof($this->stream)] = 24; }
				else {
					if (isset($o->{$this->referenceKey})) { 
						$identifier = $o->{$this->referenceKey} ;
						$this->stream[sizeof($this->stream)] = 9;
						$this->stream[sizeof($this->stream)] = $identifier;
					} else {
						$identifier = sizeof($this->encodedObjects) ;
						$o->{$this->referenceKey} = $identifier ;
						$this->encodedObjects[$identifier] = $o ;
						$this->stream[sizeof($this->stream)] = 6 ;
						$this->stream[sizeof($this->stream)] = $t ;
					}
				}
			}
			else if ($cls==MSType::MSDATA) {
				if ($this->_mustPushObject($o)) {
					$this->stream[sizeof($this->stream)] = 23 ;
					$this->stream[sizeof($this->stream)] = $o->toString() ;
				}
			}
			else if ($cls==MSType::MSCOLOR) {
				if ($this->_mustPushObject($o)) {
					$this->stream[sizeof($this->stream)] = 7 ;
					$this->stream[sizeof($this->stream)] = $o->trgbValue() ;
				}
			}
			else if ($cls=='function') {
				throw "Impossible to encode a function" ;
			}
			else if ($cls=='array' || $cls==MSType::MSARRAY) {
				if ($this->_mustPushObject($o)) {
					$jcount = $cls==MSType::MSARRAY ? $o->getSize() : sizeof($o);
					// logEvent(MSTEEncoder::$trace, "<hr>Array size: ".print_r($jcount,true)."<hr>");
					$this->stream[sizeof($this->stream)] = 20;
					$this->stream[sizeof($this->stream)] = $jcount;
					for ($j=0; $j<$jcount; $j++) {
						$obj =  $cls==MSType::MSARRAY ? $o->getValueFromKey($j) : $o[$j];
						// logEvent(MSTEEncoder::$trace, "<hr>TYPE Array : <br>".print_r($obj,true)."<hr>");
						$this->_encodeObject($obj) ;
					}
				}
			}
			// a voir
            else if ($cls==MSType::MSNATURALARRAY) {
				if ($this->_mustPushObject($o)) {
					$jcount = sizeof($o);
					$this->stream[sizeof($this->stream)] = 21 ;
					$this->stream[sizeof($this->stream)] = $jcount;
					for ($j=0; $j<$jcount; $j++) {
						$this->stream[sizeof($this->stream)] = round($o[$j]) ;
					}
				}
			}
			else if ($cls==MSType::MSCOUPLE) {
				if ($this->_mustPushObject($o)) {
					$this->stream[sizeof($this->stream)] = 22 ;
					$this->_encodeObject($o->getFirstMember) ;
					$this->_encodeObject($o->getSecondMember) ;						
				}
			}
			else {
				$userCls = get_class($o);
				if ($userCls===MSType::MSOBJECT || $userCls===MSType::MSDICT) {
					$userCls = $o->className;
				}
				// $o = $o->getValues();
				logEvent(MSTEEncoder::$trace, "<hr>USER CLS obj : ".print_r($userCls,true)."<hr>");


				// means an object
				if ($this->_mustPushObject($o)) {
					$total = 0;
					logEvent(MSTEEncoder::$trace, "<hr>STRLEN : ".strlen($userCls)."<hr>");
					if ($userCls!==MSType::MSDICT) {
						if (strlen($userCls)>0) {
							//user class
							$this->_pushClass($userCls);
						} else {
							//object as dictionary
							$this->stream[sizeof($this->stream)] = 8;
						}
					}
                    $idx = sizeof($this->stream);
                    $this->stream[$idx] = 0;
                    
					if (method_exists($o, 'msteKeys')) {
						$keys = call_user_func(get_class($o)."->msteKeys");
					}

					$jcount = sizeof($keys);
					if ($jcount>0) {
						logEvent(MSTEEncoder::$trace, "<hr>JE suis PASSE PAR ICI<hr>");
						// we take the keys the object gave us
						for ($j=0; $j<$jcount; $j++) {
							$localKey = $keys[$j];
							$v = $o[$localKey]; // attention ici
							$t = gettype($v);
							if ($v !== null && $t !== 'function' && $t !== 'undefined') {
								$total++ ;
								$this->_pushKey($k) ;
								$this->_encodeObject($v) ;
							}
						}
					}
					else {
						// we loop on standard object keys
						if (method_exists($o, 'msteNotKeys')) {
							$forbiddenKeys = call_user_func(get_class($o)."->msteNotKeys");
							if ($forbiddenKeys) { $forbiddenKeys = array(); }
						}
						
						// $clsKeys = get_class_members($o);
						$arrObj = array();
						if (get_class($o)!==MSType::MSDICT) {
							$arrObj = object2Array($o);

							logEvent(MSTEEncoder::$trace, "<hr>TYPE objet2Array : ".print_r(array_keys($arrObj),true)."<hr>");
							foreach ($arrObj as $key => $value) {
								logEvent(MSTEEncoder::$trace, "<hr>Object for : [$key] = ".print_r($value,true)."<hr>");
						        if ($value != '') {
									$c = substr($key, 0, 1);
									if ($c != '_' && $c != '$') {
										$t = gettype($value);
										if ($value !== null && $t !== 'function' && $t !== 'undefined' && !isset($forbiddenKeys[$key]) ) {
											$total++;
											$this->_pushKey($key);
											$this->_encodeObject($value);
										}
									}
								}
							}
							unset ($arrObj);
						} else {

							logEvent(MSTEEncoder::$trace, "<hr>TYPE MSDICT : ".print_r(array_keys($arrObj),true)."<hr>");
							foreach ($o->getValues() as $key => $value) {
								logEvent(MSTEEncoder::$trace, "<hr>Object for : [$key] = ".print_r($value,true)."<hr>");
						        if ($value != '') {
									$c = substr($key, 0, 1);
									if ($c != '_' && $c != '$') {
										$t = gettype($value);
										if ($value !== null && $t !== 'function' && $t !== 'undefined' && !isset($forbiddenKeys[$key]) ) {
											$total++;
											$this->_pushKey($key);
											$this->_encodeObject($value);
										}
									}
								}
							}
						}
					}
					// logEvent(MSTEEncoder::$trace, "<hr>Total : $total<hr>");
					$this->stream[$idx] = $total ;
				}
			}
		}
		else {
			$this->stream[sizeof($this->stream)] = 0 ;
		}
	}

	// private function _processData($o) {
	// 	if ($this->_mustPushObject($o)) {
	// 		$this->stream[sizeof($this->stream)] = 23 ;
	// 		$this->stream[sizeof($this->stream)] = $o->toString() ;
	// 	}
	// }
}
// -----------------------------------------------------------------------------

?>