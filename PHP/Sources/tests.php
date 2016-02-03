<?php

error_reporting( E_ALL | E_STRICT);
date_default_timezone_set('Europe/Paris');

require_once('MSTE.php');

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

function deep_equals($a ,$b, $rec = null) {
    if (is_object($a)) {
        if ($rec == null)
            $rec= new SplObjectStorage();
        if ($rec->contains($a))
            return true;
        else
            $rec->attach($a);
    }
    if ($a === $b) return true;
    if (is_numeric($a)) return is_numeric($b) && $a == $b;
    if ($a instanceof ArrayAccess) {
        $oa= $a;
        $a = array();
        foreach($oa as $k => $o) {
            $a[$k] = $o;
        }
    }
    if ($b instanceof ArrayAccess) {
        $ob= $b;
        $b = array();
        foreach($ob as $k => $o) {
            $b[$k] = $o;
        }
    }
    if (is_object($a)) {
        if (!is_object($b)) return false;
        if (get_class($a) != get_class($b)) return false;
        $oa= $a; $ob= $b;
        $a= array(); $b= array();
        $ra= new ReflectionObject($oa);
        $rb= new ReflectionObject($ob);
        foreach($ra->getProperties() as $prop) {
            $prop->setAccessible(true);
            $a[$prop->getName()] = $prop->getValue($oa);
        }
        foreach($rb->getProperties() as $prop) {
            $prop->setAccessible(true);
            $b[$prop->getName()] = $prop->getValue($ob);
        }
    }
    if (is_array($a)) {
        if (!is_array($b)) return false;
        if (count(array_diff_key($a, $b)) > 0) return false;
        $same= true;
        foreach($a as $k => $o) {
            $same = $same && deep_equals($a[$k], $b[$k], $rec);
        }
        if (!$same)
            var_dump($a, $b);
        return $same;
    }
    throw new Exception("Unsupport deep_equals with object type " . getType($a));
}

function tests_mste() {
    function test_mste($mste, $expect) {
        echo "---------" . PHP_EOL;
        try {
            $decoded= MSTEDecoder::decodeEncodedString($mste, array("person" => "Person"));
            if (!deep_equals($decoded, $expect)) {
                echo "Decoded object doesn't matches expected object:" . PHP_EOL;
                var_dump(array('mste'=>$mste, 'decoded'=>$decoded, 'expect'=>$expect));
            }
            else {
                try {
                    $encoded= MSTEncoder::encodedStringWithRootItem($expect);
                    $decoded= MSTEDecoder::decodeEncodedString($encoded, array("person" => "Person"));
                    if (!deep_equals($decoded, $expect)) {
                        echo "ReDecoded object doesn't matches expected object:" . PHP_EOL;
                        var_dump(array('mste'=>$mste, 'encoded'=>$encoded, 'decoded'=>$decoded, 'expect'=>$expect));
                    }
                    echo 'original: '. $mste .PHP_EOL;
                    echo 'rencoded: '. $encoded .PHP_EOL;
                } catch(Exception $e) {
                    echo "Unable to reencode MSTE:";
                    var_dump(array('mste'=>$mste, 'encoded'=>$encoded, 'decoded'=>$decoded, 'expect'=>$expect));
                    echo $e;
                }
            }
        } catch(Exception $e) {
            echo "Unable to decode MSTE: $mste";
            var_dump(array('mste'=>$mste));
            echo $e;
        }
    }

    test_mste("[\"MSTE0102\",6,\"CRC82413E70\",0,0,0]", null);
    test_mste("[\"MSTE0102\",6,\"CRC9B5A0F31\",0,0,1]", true);
    test_mste("[\"MSTE0102\",6,\"CRCB0775CF2\",0,0,2]", false);
    test_mste("[\"MSTE0102\",6,\"CRCA96C6DB3\",0,0,3]", "");
    test_mste("[\"MSTE0102\",6,\"CRCE62DFB74\",0,0,4]", new MSBuffer(0));
    test_mste("[\"MSTE0102\",7,\"CRCBF421375\",0,0,20,12.34]", 12.34);
    test_mste("[\"MSTE0102\",7,\"CRC09065CB6\",0,0,21,\"My beautiful string \\u00E9\\u00E8\"]", "My beautiful string éè");
    test_mste("[\"MSTE0102\",7,\"CRC4A08AB7A\",0,0,21,\"Json \\\\a\\/b\\\"c\\u00C6\"]", "Json \\a/b\"cÆ");
    test_mste("[\"MSTE0102\",7,\"CRC093D5173\",0,0,22,978307200]",  new MSLocalDate(2001,1,1,0,0,0));
    test_mste("[\"MSTE0102\",7,\"CRCFDED185D\",0,0,23,978307200.000000000000000]", new MSGMTDate(gmmktime(0,0,0,1,1,2001)));
    test_mste("[\"MSTE0102\",7,\"CRCAB284946\",0,0,24,4034942921]", new MSColor(128, 87, 201,15));
    test_mste("[\"MSTE0102\",7,\"CRC4964EA3B\",0,0,25,\"YTF6MmUzcjR0NA==\"]", new MSBuffer("a1z2e3r4t4"));
    test_mste("[\"MSTE0102\",8,\"CRCD6330919\",0,0,26,1,256]", new MSNaturalArray(array(256)));
    test_mste("[\"MSTE0102\",15,\"CRC891261B3\",0,2,\"key1\",\"key2\",30,2,0,21,\"First object\",1,21,\"Second object\"]", array('key1'=>'First object', 'key2' => 'Second object'));
    test_mste("[\"MSTE0102\",11,\"CRC1258D06E\",0,0,31,2,21,\"First object\",21,\"Second object\"]", new MSArray(array("First object", "Second object")));
    test_mste("[\"MSTE0102\",10,\"CRCF8392337\",0,0,32,21,\"First member\",21,\"Second member\"]", new MSCouple("First member", "Second member"));
    test_mste("[\"MSTE0102\",21,\"CRCD959E1CB\",0,3,\"20061\",\"entity\",\"0\",30,2,0,30,1,1,31,1,21,\"R_Right\",2,30,0]", array('20061'=> array('entity'=>new MSArray(array('R_Right'))), '0'=> array()));
    test_mste("[\"MSTE0102\",11,\"CRC1258D06E\",0,0,31,2,20,11,9,1]", new MSArray(array(11, 11)));
    $nomDurand = "Durand" ;
    $pers1 = new Person("Yves", "Durand", new MSGMTDate(-243820800)) ;
    $pers2 = new Person("Claire", "Durand", new MSGMTDate(-207360000)) ;
    $pers3 = new Person("Lou", "Durand", new MSGMTDate(552096000)) ;
    $o = new MSArray(array($pers1, $pers2, $pers3));

    $pers1->mariedTo= $pers2;
    $pers2->mariedTo= $pers1;
    $pers3->mother= $pers2;
    $pers3->father= $pers1;
    }
tests_mste();

