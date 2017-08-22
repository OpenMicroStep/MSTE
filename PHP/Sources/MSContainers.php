<?php

function MSCapacityForCount($count)
{
    static $DEFAULT_CAPACITY_FOR_COUNTS= NULL;
    if ($DEFAULT_CAPACITY_FOR_COUNTS === NULL) {
        $DEFAULT_CAPACITY_FOR_COUNTS = array(
          /* 000 */   2,   2,   4,   4,   8,   8,   8,   8,
          /* 008 */  16,  16,  16,  16,  16,  16,  16,  16,
          /* 016 */  32,  32,  32,  32,  32,  32,  32,  32,
          /* 024 */  32,  32,  32,  32,  32,  32,  32,  32,
          /* 032 */  64,  64,  64,  64,  64,  64,  64,  64,
          /* 040 */  64,  64,  64,  64,  64,  64,  64,  64,
          /* 048 */  64,  64,  64,  64,  64,  64,  64,  64,
          /* 056 */ 128, 128, 128, 128, 128, 128, 128, 128,
          /* 064 */ 128, 128, 128, 128, 128, 128, 128, 128,
          /* 072 */ 128, 128, 128, 128, 128, 128, 128, 128,
          /* 080 */ 128, 128, 128, 128, 128, 128, 128, 128,
          /* 088 */ 128, 128, 128, 128, 128, 128, 128, 128,
          /* 096 */ 128, 128, 128, 128, 128, 128, 128, 128,
          /* 104 */ 256, 256, 256, 256, 256, 256, 256, 256,
          /* 112 */ 256, 256, 256, 256, 256, 256, 256, 256,
          /* 120 */ 256, 256, 256, 256, 256, 256, 256, 256
        ) ;
    }
    $count = (int)$count ;
    return ($count < 128 ? $DEFAULT_CAPACITY_FOR_COUNTS[$count] : (($count + ($count >> 1)) & (int)~255) + 256) ;
}

class MSArray extends SplFixedArray implements JsonSerializable {
    private $internalCount = 0 ;

    public function __construct($arr_or_capacity) {
        if (is_array($arr_or_capacity)) {
            $this->setSize(count($arr_or_capacity));
            $this->internalCount= $this->getSize();
            foreach($arr_or_capacity as $i => $o) {
                $this->offsetSet($i, $o) ;
            }
        }
        else if (is_numeric($arr_or_capacity)) {
            $this->setSize($arr_or_capacity);
        }
    }
    public function resizeForCount($n) {
        $size = $this->getSize() ;
        if ($n > $size) {
            $this->setSize(MSCapacityForCount($n)) ;
        }
    }
    public function count() { return $this->internalCount ; }
    public function offsetExists ($offset) {
        return $offset >= 0 && $offset < $this->internalCount ? parent::offsetExists($offset) : false ;
    }
    public function addObject(&$anObject) {
        $this->resizeForCount($this->internalCount + 1) ;
        $this->offsetSet($this->internalCount, $anObject) ;
        $this->internalCount += 1 ;
    }
    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {
            $encoder->pushItems($this) ;
        }
    }

    public function jsonSerialize() {
        return $this->toArray();
    }
}

class MSColor implements JsonSerializable {
    private $red = 0 ;
  private $green = 0 ;
  private $blue = 0 ;
  private $alpha = 255 ;

  static $NAMED_COLORS  = array(
    "beige"   => 'f5f5dc', "black"    => '000000', "blue"   => '0000ff',
    "brown"   => 'a52a2a', "cyan"     => '00ffff', "fuchsia"  => 'ff00ff',
    "gold"    => 'ffd700', "gray"     => '808080', "green"  => '008000',
    "indigo "   => '4b0082', "ivory"    => 'fffff0', "khaki"  => 'f0e68c',
    "lavender"  => 'e6e6fa', "magenta"    => 'ff00ff', "maroon"   => '800000',
    "olive"   => '808000', "orange"     => 'ffa500', "pink"   => 'ffc0cb',
    "purple"  => '800080', "red"      => 'ff0000', "salmon"   => 'fa8072',
    "silver"  => 'c0c0c0', "snow"     => 'fffafa', "teal"   => '008080',
    "tomato"  => 'ff6347', "turquoise"  => '40e0d0', "violet"   => 'ee82ee',
    "wheat"   => 'f5deb3', "white"    => 'ffffff', "yellow"   => 'ffff00'
  );

  CONST COLOR_REGEX           = '/[a-f0-9]{6}/' ;
  CONST SHORT_COLOR_REGEX     = '/[a-f0-9]{3}/' ;

  public function __construct($colorOrRed, $green= null, $blue= null, $alpha= 255) {
    if ($green === null) {
        if (is_string($colorOrRed)) { $this->setColorFromString($colorOrRed) ; }
        else { $this->setColorFromInteger($colorOrRed) ; }
    }
    else {
        $this->setRGBAColor($colorOrRed,$green,$blue,$alpha) ;
    }
  }

    public function setRGBAColor($r, $g, $b, $a) {
        if (is_int($r) && !is_nan($r) && $r >= 0 &&
            is_int($g) && !is_nan($g) && $g >= 0 &&
            is_int($b) && !is_nan($b) && $b >= 0 &&
            is_int($a) && !is_nan($a) && $a >= 0) {
            $this->alpha= $a;
            $this->red= $r;
            $this->green= $g;
            $this->blue= $b;
        }
        else {
            throw new Exception("MSColor : impossible to setRGBAColor() with (r:".getType($r).", g:".getType($g).", b:".getType($b).", a:".getType($a).").") ;
        }
    }
    public function setColorFromInteger($integer) {
        if (is_int($integer) && !is_nan($integer) && $integer >= 0) {
            $this->alpha = 0xff - (($integer >> 24) & 0xff) ;
            $this->red = ($integer >> 16) & 0xff ;
            $this->green = ($integer >> 8) & 0xff ;
            $this->blue = $integer & 0xff ;
        }
        else {
            throw new Exception("MSColor : impossible to setColorFromInteger() with a ".getType($integer).".") ;
        }
    }

    public function setColorFromString($str) {
        if (is_string($str)) {
        $ok = true ;
             $str = preg_replace('/\s\s+/', '', $str);
        $bits = null ;

          if (!strlen($str)) { $ok = false ; }
        if ($ok && $str[0] == '#') { $str = substr($str, 1); }
          if ($ok && strlen($str) < 3) { $ok = false ; }
          if ($ok) {
              $str = strtolower($str);
              $name = MSColor::$NAMED_COLORS[$str] ;
          if (isset($name)) { $str = $name ; }
          if (preg_match(MSColor::COLOR_REGEX, $str)) {
            $bits   = str_split($str, 2);
          }
          if (sizeof($bits) != 3) {
            if (preg_match(MSColor::SHORT_COLOR_REGEX, $str)) {
                  $bits = str_split($str, 1);
                }
            if (sizeof($bits) != 3) { $ok = false ; }
          }
          if ($ok) {
              $this->red    = hexdec('0x'.$bits[0]);
              $this->green  = hexdec('0x'.$bits[1]);
              $this->blue   = hexdec('0x'.$bits[2]);
          }
            }
        }
    }

    public function toString() {
        return $this->alpha == 255 ? "#".str_pad(dechex($this->red), 2, '0', STR_PAD_LEFT).
                                         str_pad(dechex($this->green), 2, '0', STR_PAD_LEFT).
                                         str_pad(dechex($this->blue), 2, '0', STR_PAD_LEFT) :
                                     "rgba(".$this->red.",".$this->green.",".$this->blue.",".round($this->alpha/255.0, 2).")" ;
    }
    public function toNumber() { return ((0xff - $this->alpha) * 16777216) + ($this->red * 65536) + ($this->green * 256) + $this->blue ;}

    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {
            $encoder->pushColor($this->toNumber()) ;
        }
    }

    public function jsonSerialize() {
        return $this->toString();
    }
}

class MSCouple implements JsonSerializable {
    private $first ;
    private $second ;

    public function __construct($a, $b) { $this->first = $a ; $this->second = $b ; }
    public function firstMember() { return $this->first ; }
    public function secondMember() { return $this->second ; }
    public function setFirstMember($o) { $this->first = $o ; }
    public function setSecondMember($o) { $this->second = $o ; }
    public function setCouple(MSCouple $c) { $this->first = $c->firstMemner() ; $this->second = $c->secondMember() ; }
    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {
            $encoder->pushCouple($this->first, $this->second) ;
        }
    }

    public function jsonSerialize() {
        return array($this->first, $this->second);
    }
}

class MSNaturalArray extends MSArray {

    public static function fromArray($data, $save_indexes = NULL) {
        return new MSNaturalArray($data);
    }

    public function addNatural($n) {
        if ($n < 0) { throw new Exception("Impossible to add negative values in a MSNaturalArray") ; }
        parent::addObject($n);
    }

    public function addObject(&$o) {
        if (method_exists($o, 'isNumeric') && is_callable(array($o, 'isNumeric')) && $o->isNumeric()) {
            parent::addObject($n);
        }
        else { throw new Exception("Impossible to add non numeric values in a MSNaturalArray") ; }
    }

    public function offsetSet($index, $o) {
        if (is_numeric($o) || (is_object($o) && method_exists($o, 'isNumeric') && is_callable(array($o, 'isNumeric')) && $o->isNumeric())) {
            $o = (int)$o ;
            if ($o < 0) { throw new Exception("Impossible to set negative values in a MSNaturalArray") ; }
            parent::offsetSet($index, $o) ;
        }
        else { throw new Exception("Impossible to set non numeric values in a MSNaturalArray") ; }
    }

    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {
            $encoder->pushNaturals($this) ;
        }
    }
}

class MSBuffer implements ArrayAccess, JsonSerializable {
    private $_data;
    function __construct($data_or_size) {
        if (is_string($data_or_size))
            $this->_data= $data_or_size;
        else if (is_numeric($data_or_size))
            $this->_data= str_repeat('\0', $data_or_size);
    }
    public function length() {
        return strlen($this->_data);
    }
    public function bytes() {
        return $this->_data;
    }

    public function offsetExists ($offset) {
        return is_numeric($offset) && $offset >= 0 && $offset < strlen($this->_data);
    }
    public function offsetGet ($offset) {
        if ($this->offsetExists($offset))
            return $this->_data[$offset];
        throw new Exception("Impossible to set out of bounds offset");
    }
    public function offsetSet ($offset, $value) {
        $this->_data[$offset] = $value;
    }
    public function offsetUnset ($offset) {
        throw new Exception("Impossible to unset a byte in MSBuffer");
    }

    public function toMSTE(MSTEncoder $encoder) {
        if ($this->length() == 0) {
            $encoder->pushTokenType('emptyData');
        } else if ($encoder->shouldPushObject($this)) {
            $encoder->pushTokenType('data');
            $encoder->push(base64_encode($this->_data)) ;
        }
    }

    public function jsonSerialize() {
        return base64_encode($this->_data);
    }
}

class MSGMTDate implements JsonSerializable {
    const TIMEINTERVALSINCE1970 = 978307200.0;

    protected $_time;

    function __construct($unixTimestamp) {
        if (!is_numeric($unixTimestamp))
            throw new Exception("Impossible to create MSGMTDate with a non numeric timestamp");
        $this->_time = (double)$unixTimestamp;
    }

    function timeIntervalSince1970() {
        return $this->_time;
    }

    function timeIntervalSince2001() {
        return $this->_time + TIMEINTERVALSINCE1970;
    }

    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {
            $encoder->pushTokenType('gmtDate');
            $encoder->push($this->_time);
        }
    }

    public function jsonSerialize() {
        return date('c', $this->timeIntervalSince1970());
    }
}

class MSLocalDate extends MSGMTDate {
    static private $DaysFrom00000229To20010101= 730792;
    static private $DaysFrom00010101To20010101= 730485;
    static private $SecsFrom00010101To20010101= 63113904000;
    static private $SecsFrom19700101To20010101= 978307200;
    static private $DaysInMonth= array(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    static private $DaysInPreviousMonth= array(0, 0, 0, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337);

    function __construct($intervalOrYear, $month= 0, $day= 0, $hours= 0, $minutes= 0, $seconds= 0) {
        if ($month > 0 && $day > 0)
            $this->_time = static::intervalFrom($intervalOrYear, $month, $day, $hours, $minutes, $seconds);
        else
            $this->_time = $intervalOrYear - static::$SecsFrom19700101To20010101;
    }

    public static function isLeapYear($y) {
        return ($y % 4 ? false : ( $y % 100 ? ($y > 7 ? true : false) : ($y % 400 || $y < 1600 ? false : true)));
    }
    public static function validDate($year, $month, $day) {
        if (!is_numeric($day) || !is_numeric($month) || !is_numeric($year) || $day < 1 || $month < 1 || $month > 12) { return false ; }
        if ($day > static::$DaysInMonth[$month]) { return ($month === 2 && $day === 29 && static::isLeapYear(year)) ? true : false ; }
        return true ;
    }
    public static function validTime($hour, $minute, $second) {
        return (is_numeric($hour) && is_numeric($minute) && is_numeric($second) && $hour >= 0 && $hour < 24 && $minute >= 0 && $minute < 60 && $second >= 0 && $second < 60);
    }
    public static function intervalFromYMD($year, $month, $day) {
        if ($month < 3) { $month += 12; $year--; }

        $leaps = floor($year/4) - floor($year/100) + floor($year/400);

        return floor(($day + static::$DaysInPreviousMonth[$month] + 365 * $year + $leaps - static::$DaysFrom00000229To20010101) * 86400) ;
    }
    public static function intervalFrom($year, $month, $day, $hours, $minutes, $seconds) {
        return static::intervalFromYMD($year, $month, $day) + $hours * 3600 + $minutes * 60 + $seconds ;
    }
    public static function timeFromInterval($t) { return (($t+static::$SecsFrom00010101To20010101) % 86400) ; }
    public static function dayFromInterval($t) { return floor(($t - static::timeFromInterval($t))/86400) ; }
    public static function secondsFromInterval($t) { return (($t+static::$SecsFrom00010101To20010101) % 60) ; }
    public static function minutesFromInterval($t) { return (int)(floor(($t+static::$SecsFrom00010101To20010101) %  3600) / 60) ; }
    public static function hoursFromInterval($t) { return (int)(floor(($t+static::$SecsFrom00010101To20010101) %  86400) /  3600) ; }
    public static function dayOfWeekFromInterval($t, $offset= 0) {
        return (static::dayFromInterval($t)+static::$DaysFrom00010101To20010101 + 7 - ($offset % 7)) % 7;
    }
    public static function componentsWithInterval($interval) {
        $Z =                  static::dayFromInterval($interval) + static::$DaysFrom00000229To20010101 ;
        $gg =                 $Z - 0.25 ;
        $CENTURY =            floor($gg/36524.25) ;
        $CENTURY_MQUART =     $CENTURY - floor($CENTURY/4) ;
        $ALLDAYS =            $gg + $CENTURY_MQUART ;
        $Y =                  floor($ALLDAYS / 365.25) ;
        $Y365 =               floor($Y * 365.25) ;
        $DAYS_IN_Y =          $CENTURY_MQUART + $Z - $Y365 ;
        $MONTH_IN_Y =         floor((5 * $DAYS_IN_Y + 456)/153) ;

        $ret = array(
            "day" => floor($DAYS_IN_Y - floor((153*$MONTH_IN_Y - 457) / 5)),
            "hour" => static::hoursFromInterval($interval),
            "minute" => static::minutesFromInterval($interval),
            "seconds" => static::secondsFromInterval($interval),
            "dayOfWeek" => (($Z + 2) % 7)
        );

        if ($MONTH_IN_Y > 12) {
            $ret["month"] = $MONTH_IN_Y - 12 ;
            $ret["year"] = $Y + 1 ;
        }
        else {
            $ret["month"] = $MONTH_IN_Y ;
            $ret["year"] = $Y ;
        }
        return $ret ;
    }
    public static function dateWithInt($decimalDate) {
        if (is_int($decimalDate)) {
            $day = $decimalDate % 100 ;
            $month = (int)(($decimalDate % 10000) /100) ;
            $year = (int)($decimalDate / 10000) ;
            if (static::validDate($year, $month, $day)) { return new MSDate($year, $month, $day) ; }
        }
        return null ;
    }
    public static function _lastDayOfMonth($year,$month) { return ($month === 2 && static::isLeapYear($year)) ? 29 : static::$DaysInMonth[$month]; } // not protected. use carrefully
    public static function _yearRef($y, $offset) {
        $firstDayOfYear = static::intervalFromYMD($y, 1, 1);
        $d = static::dayOfWeekFromInterval($firstDayOfYear, $offset) ;
        $d = ($d <= 3 ? -$d : 7-$d ); // Day of the first week
        return $firstDayOfYear + $d * 86400 ;
    }

    public function components() {
        return static::componentsWithInterval($this->_time);
    }
    public function __toString() {
        $c = $this->components();
        if (!is_array($c)) return null;
        return $c['year']
            . '-' . str_pad($c['month'], 2, "0", STR_PAD_LEFT)
            . '-' . str_pad($c['day'], 2, "0", STR_PAD_LEFT)
            . 'T' . str_pad($c['hour'], 2, "0", STR_PAD_LEFT)
            . ':' . str_pad($c['minute'], 2, "0", STR_PAD_LEFT)
            . ':' . str_pad($c['seconds'], 2, "0", STR_PAD_LEFT);
    }
    public function isLeap() {
        $c = $this->components();
        if (!is_array($c)) return false;
        return static::isLeapYear($c['year']);
    }
    public function yearOfCommonEra() { $c = $this->components() ; return $c !== null ? $c['year'] : NAN ; }
    public function monthOfYear() { $c = $this->components() ; return $c !== null ? $c['month'] : NAN ; }
    public function dayOfMonth() { $c = $this->components() ; return $c !== null ? $c['day'] : NAN ; }
    public function lastDayOfMonth() { $c = $this->components() ; return $c !== null ? static::lastDayOfMonth($c['month']) : NAN ; }

    public function dayOfWeek($offset) { return static::dayOfWeekFromInterval($this->_time, $offset) ; }

    public function hourOfDay() { return static::hoursFromInterval($this->_time) ; }
    public function secondOfDay() { return static::timeFromInterval($this->_time) ; }

    public function minuteOfHour() { return static::minutesFromInterval($this->_time) ; }

    public function secondOfMinute() { return static::secondsFromInterval($this->_time) ; }

    public function dateWithoutTime() { return new MSDate(this.interval - MSDate.timeFromInterval(this.interval)) ; }
    public function dateOfFirstDayOfYear() { $c = $this->components() ; return $c !== null ? new MSDate($c['year'],1, 1) : null ; }
    public function dateOfLastDayOfYear() { $c = $this->components() ; return $c !== null ? new MSDate($c['year'],12, 31) : null ; }
    public function dateOfFirstDayOfMonth() { $c = $this->components() ; return $c !== null ? new MSDate($c['year'], $c['month'], 1) : null ; }
    public function dateOfLastDayOfMonth() { $c = $this->components() ; return $c !== null ? new MSDate($c['year'], $c['month'], static::_lastDayOfMonth($c['year'], $c['month'])) : null ; }

    public function secondsSinceLocal1970() {
        return $this->_time + static::$SecsFrom19700101To20010101;
    }

    public function secondsSinceLocal2001() {
        return $this->_time;
    }

    public function timeIntervalSince1970() {
        $c = $this->components() ;
        return $c !== null ? mktime($c['hour'], $c['minute'], $c['seconds'], $c['month'], $c['day'], $c['year']) : 0;
    }

    public function timeIntervalSince2001() {
        return $this->timeIntervalSince1970() - static::$SecsFrom19700101To20010101;
    }

    public function toMSTE(MSTEncoder $encoder) {
        if ($encoder->shouldPushObject($this)) {
            $encoder->pushTokenType('localDate');
            $encoder->push($this->_time + static::$SecsFrom19700101To20010101);
        }
    }
}
