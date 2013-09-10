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

	public function __destruct() {
		unset($this->name);
		unset($this->firstName);
		unset($this->birthday);
		unset($this->mariedTo);
		unset($this->mother);
		unset($this->father);
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

	// From interface

	public static function newObject() {
		$p = new Person('', '', '');
		return $p;
	}

	public static function initWithDictionnary(&$obj, &$dict) {
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
	}

	public static function MSTESnapshot() {
		$dict = new MSDict();
		$dict->setValueForKey('name', 'name');
		$dict->setValueForKey('firstName', 'firstName');
		$dict->setValueForKey('birthday', 'birthday');
		$dict->setValueForKey('maried-to', 'mariedTo');
		$dict->setValueForKey('mother', 'mother');
		$dict->setValueForKey('father', 'father');
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