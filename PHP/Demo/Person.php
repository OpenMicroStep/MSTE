<?php

class Person {

	private $name;
	private $firstName;
	private $birthday;
	private $mariedTo;
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

	function setMariedTo($pers) {
		$this->mariedTo = $pers;
	}
	function setMother($pers) {
		$this->mother = $pers;
	}
	function setFather($pers) {
		$this->father = $pers;
	}


}

?>