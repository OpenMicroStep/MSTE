<?php

error_reporting( E_ALL | E_STRICT);
date_default_timezone_set('Europe/Paris');

require_once('Sources/MSTE.php');

class Person {
    public $firstName ;
    public $name ;
    public $birthday ;
    public $mother ;
    public $father ;
    public $mariedTo ;

    function __construct($newFirstName = null, $newName = null, $birthday = null) {
        $this->name = $newName ;
        $this->firstName = $newFirstName ;
        $this->birthday = $birthday;
    }

    public function mary(Person $p) {
        $this->mariedTo = $p ;
        $p->mariedTo = $this ;
    }

    public function initFromMSTE(MSTEDecoder $decoder) {
        $count = $decoder->nextToken() ;

        for ($i = 0 ; $i < $count; $i++) {
            $key = $decoder->parseKey() ;
            if ($key == 'maried-to') $key= 'mariedTo';
            $value = $decoder->parseItem() ;
            $this->$key = $value ;
        }
        // we could use $decoder->nextDictionary() instead
        // we would get a dico and do what we want with the dico
    }

    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {

            $n = 2 ;

            if (isset($this->birthday)) { $n++ ; }
            if (isset($this->mother))        { $n++ ; }
            if (isset($this->father))        { $n++ ; }
            if (isset($this->mariedTo))      { $n++ ; }

            $encoder->willEncodeValuesCount($n, "person") ;

            $encoder->pushKeyAndItem("name", $this->name) ;
            $encoder->pushKeyAndItem("firstName", $this->firstName) ;

            if (isset($this->birthday)) { $encoder->pushKeyAndItem("birthday", $this->birthday) ; }
            if (isset($this->mother)) { $encoder->pushKeyAndItem("mother", $this->mother) ; }
            if (isset($this->father)) { $encoder->pushKeyAndItem("father", $this->father) ; }
            if (isset($this->mariedTo)) { $encoder->pushKeyAndItem("mariedTo", $this->mariedTo) ; }
        }
    }
}

class MSTETests extends PHPUnit_Framework_TestCase
{
    public function assertMSTE($mste, $expect) {
        $decoded= MSTEDecoder::decodeEncodedString($mste, array("person" => "Person"));
        $this->assertEquals($expect, $decoded);
        $encoded= MSTEncoder::encodedStringWithRootItem($expect);
        $decoded= MSTEDecoder::decodeEncodedString($encoded, array("person" => "Person"));
        $this->assertEquals($expect, $decoded);
    }

    public function testBaseTypes() {
        $this->assertMSTE("[\"MSTE0102\",6,\"CRC82413E70\",0,0,0]", null);
        $this->assertMSTE("[\"MSTE0102\",6,\"CRC9B5A0F31\",0,0,1]", true);
        $this->assertMSTE("[\"MSTE0102\",6,\"CRCB0775CF2\",0,0,2]", false);
        $this->assertMSTE("[\"MSTE0102\",6,\"CRCA96C6DB3\",0,0,3]", "");
        $this->assertMSTE("[\"MSTE0102\",6,\"CRCE62DFB74\",0,0,4]", new MSBuffer(0));
        $this->assertMSTE("[\"MSTE0102\",7,\"CRCBF421375\",0,0,20,12.34]", 12.34);
        $this->assertMSTE("[\"MSTE0102\",7,\"CRC09065CB6\",0,0,21,\"My beautiful string \\u00E9\\u00E8\"]", "My beautiful string éè");
        $this->assertMSTE("[\"MSTE0102\",7,\"CRC4A08AB7A\",0,0,21,\"Json \\\\a\\/b\\\"c\\u00C6\"]", "Json \\a/b\"cÆ");
        $this->assertMSTE("[\"MSTE0102\",7,\"CRC093D5173\",0,0,22,978307200]",  new MSLocalDate(2001,1,1,0,0,0));
        $this->assertMSTE("[\"MSTE0102\",7,\"CRCFDED185D\",0,0,23,978307200.000000000000000]", new MSGMTDate(gmmktime(0,0,0,1,1,2001)));
        $this->assertMSTE("[\"MSTE0102\",7,\"CRCAB284946\",0,0,24,4034942921]", new MSColor(128, 87, 201,15));
        $this->assertMSTE("[\"MSTE0102\",7,\"CRC4964EA3B\",0,0,25,\"YTF6MmUzcjR0NA==\"]", new MSBuffer("a1z2e3r4t4"));
        $this->assertMSTE("[\"MSTE0102\",8,\"CRCD6330919\",0,0,26,1,256]", new MSNaturalArray(array(256)));
        $this->assertMSTE("[\"MSTE0102\",15,\"CRC891261B3\",0,2,\"key1\",\"key2\",30,2,0,21,\"First object\",1,21,\"Second object\"]", array('key1'=>'First object', 'key2' => 'Second object'));
        $this->assertMSTE("[\"MSTE0102\",11,\"CRC1258D06E\",0,0,31,2,21,\"First object\",21,\"Second object\"]", new MSArray(array("First object", "Second object")));
        $this->assertMSTE("[\"MSTE0102\",10,\"CRCF8392337\",0,0,32,21,\"First member\",21,\"Second member\"]", new MSCouple("First member", "Second member"));
    }

    public function testBugs() {
        $this->assertMSTE("[\"MSTE0102\",21,\"CRCD959E1CB\",0,3,\"20061\",\"entity\",\"0\",30,2,0,30,1,1,31,1,21,\"R_Right\",2,30,0]", array('20061'=> array('entity'=>new MSArray(array('R_Right'))), '0'=> array()));
        $this->assertMSTE("[\"MSTE0102\",11,\"CRC1258D06E\",0,0,31,2,20,11,9,1]", new MSArray(array(11, 11)));
    }

    public function testGraph() {
        $nomDurand = "Durand" ;
        $pers1 = new Person("Yves", "Durand", new MSGMTDate(-243820800)) ;
        $pers2 = new Person("Claire", "Durand", new MSGMTDate(-207360000)) ;
        $pers3 = new Person("Lou", "Durand", new MSGMTDate(552096000)) ;
        $o = new MSArray(array($pers1, $pers2, $pers3));

        $pers1->mariedTo= $pers2;
        $pers2->mariedTo= $pers1;
        $pers3->mother= $pers2;
        $pers3->father= $pers1;
        $this->assertMSTE("[\"MSTE0102\",59,\"CRC4A2D9DBB\",1,\"person\",6,\"name\",\"firstName\",\"birthday\",\"mariedTo\",\"mother\",\"father\",31,3,50,4,0,21,\"Durand\",1,21,\"Yves\",2,23,-243820800,3,50,4,0,9,2,1,21,\"Claire\",2,23,-207360000,3,9,1,9,5,50,5,0,9,2,1,21,\"Lou\",2,23,552096000,4,9,5,5,9,1]", $o);
    }

    public function testJSON() {
        $this->assertJsonStringEqualsJsonString(json_encode(null), "null");
        $this->assertJsonStringEqualsJsonString(json_encode(true), "true");
        $this->assertJsonStringEqualsJsonString(json_encode(false), "false");
        $this->assertJsonStringEqualsJsonString(json_encode(""), "\"\"");
        $this->assertJsonStringEqualsJsonString(json_encode(new MSBuffer("a1z2e3r4t4")), "\"YTF6MmUzcjR0NA==\"");
        $this->assertJsonStringEqualsJsonString(json_encode(new MSLocalDate(2001,1,1,0,0,0)), "\"2001-01-01T00:00:00+01:00\"");
        $this->assertJsonStringEqualsJsonString(json_encode(new MSGMTDate(gmmktime(0,0,0,1,1,2001))), "\"2001-01-01T01:00:00+01:00\"");
        $this->assertJsonStringEqualsJsonString(json_encode(new MSColor(128, 87, 201,15)), '"rgba(128,87,201,0.06)"');
        $this->assertJsonStringEqualsJsonString(json_encode(new MSNaturalArray(array(256))), '[256]');
        $this->assertJsonStringEqualsJsonString(json_encode(new MSArray(array("First object", "Second object"))), '["First object", "Second object"]');
        $this->assertJsonStringEqualsJsonString(json_encode(new MSCouple("First member", "Second member")), '["First member", "Second member"]');

        $pers1 = new Person("Yves", "Durand", new MSGMTDate(-243820800)) ;
        $pers2 = new Person("Claire", "Durand", new MSGMTDate(-207360000)) ;
        $pers3 = new Person("Lou", "Durand", new MSGMTDate(552096000)) ;
        $o = new MSArray(array($pers1, $pers2, $pers3));
        $this->assertJsonStringEqualsJsonString(json_encode($o), '[{"firstName":"Yves","name":"Durand","birthday":"1962-04-11T01:00:00+01:00","mother":null,"father":null,"mariedTo":null},{"firstName":"Claire","name":"Durand","birthday":"1963-06-07T01:00:00+01:00","mother":null,"father":null,"mariedTo":null},{"firstName":"Lou","name":"Durand","birthday":"1987-07-01T02:00:00+02:00","mother":null,"father":null,"mariedTo":null}]');
    }
}
