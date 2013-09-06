<?php

class Person implements iMSTE {

	
	private $firstName;
	private $mariedTo;
	private $name;
	private $birthday;
	private $mother;
	private $father;

	function __construct($n, $fn, $bd, $mt=null, $m=null, $f=null) {
		$this->name 		= $n;
		$this->firstName 	= $fn;
		$this->birthday 	= $bd;
		$this->mariedTo 	= $mt;
		$this->mother 		= $m;
		$this->father 		= $f;
	}

	function setName($s) {
		$this->name = $s;
	}
	function setFirstName($s) {
		$this->firstName = $s;
	}
	function setBirthday($d) {
		$this->birthday = $d;
	}
	function setMariedTo($pers) {
		$this->mariedTo = $pers;
	}
	function setMother($pers) {
		$this->mother = $pers;
	}
	function setFather($pers) {
		$this->father = $pers;
	}

	public static function newObject() {
		$p = new Person('', '', '');
		return $p;
	}


	public static function initWithDictionnary(&$obj, &$dict) {
		// if ($dict->isA != MSType::MSDICT) {
		// 	throw new Excpetion("method : newWithDictionnary > wrong parameter type must be MSDict");
		// }
		// logEvent(true, "<hr>newWithDictionnary <hr>");
		$n 	= $dict->getValueFromKey('name') ? $dict->getValueFromKey('name') : "";
		$fn = $dict->getValueFromKey('firstName') != '' ? $dict->getValueFromKey('firstName') : "";
		$bd = $dict->getValueFromKey('birthday') ? $dict->getValueFromKey('birthday') : null;
		$mt = $dict->getValueFromKey('maried-to') ? $dict->getValueFromKey('maried-to') : null;
		$m 	= $dict->getValueFromKey('mother') ? $dict->getValueFromKey('mother') : null;
		$f 	= $dict->getValueFromKey('father') ? $dict->getValueFromKey('father') : null;
		$obj->setName($n);
		$obj->setFirstName($fn);
		$obj->setBirthday($bd);
		$obj->setMariedTo($mt);
		$obj->setMother($m);
		$obj->setFather($f);
		// logEvent(true, "<hr>CLASS OBJECT <br>".print_r($obj,true)."<hr>");
	}

	public function MSTESnapshot() {
		$dict = new MSDict();
		$dict->setValueFromKey('toto', 'toto');
		return  $dict;
	}

}


class mother {
	private $attr1;
	private $attr2;
	private $attr3;
	private $attr4;
}

class daughter extends mother {
	private $attr5;
	private $attr6;
	private $attr7;
	private $attr8;
}

?>