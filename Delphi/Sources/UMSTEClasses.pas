unit UMSTEClasses;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Contnrs, Graphics, UMSFoundation;

type

  TMSTETokenType
    = (
    tt_MUST_ENCODE = -1,
    tt_NULL = 0,
    tt_TRUE = 1,
    tt_FALSE = 2,
    tt_INTEGER_VALUE = 3,
    tt_REAL_VALUE = 4,
    tt_STRING = 5,
    tt_DATE = 6,
    tt_COLOR = 7,
    tt_DICTIONARY = 8,
    tt_STRONG_REFERENCED_OBJECT = 9,
    tt_CHAR = 10,
    tt_UNSIGNED_CHAR = 11,
    tt_SHORT = 12,
    tt_UNSIGNED_SHORT = 13,
    tt_INT32 = 14,
    tt_UNSIGNED_INT32 = 15,
    tt_INT64 = 16,
    tt_UNSIGNED_INT64 = 17,
    tt_FLOAT = 18,
    tt_DOUBLE = 19,
    tt_ARRAY = 20,
    tt_NATURAL_ARRAY = 21,
    tt_COUPLE = 22,
    tt_BASE64_DATA = 23,
    tt_DISTANT_PAST = 24,
    tt_DISTANT_FUTURE = 25,
    tt_EMPTY_STRING = 26,
    tt_WEAK_REFERENCED_OBJECT = 27,

    tt_USER_CLASS = 50

    );

const
  RecursiveToString = False;
  MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_USER_OBJECT = integer(tt_USER_CLASS);
  MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_USER_OBJECT = MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_USER_OBJECT + 1;

  MaxCapacity = 303;
  PrimeNumber: array[0..MaxCapacity - 1] of integer =
  (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
    101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
    211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
    307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397,
    401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
    503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
    601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
    701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
    809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
    907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997

    , 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103,
    1109, 1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231,
    1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373,
    1381, 1399, 1409, 1423, 1427, 1429, 1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493,
    1499, 1511, 1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, 1597, 1601, 1607, 1609, 1613, 1619,
    1621, 1627, 1637, 1657, 1663, 1667, 1669, 1693, 1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759,
    1777, 1783, 1787, 1789, 1801, 1811, 1823, 1831, 1847, 1861, 1867, 1871, 1873, 1877, 1879, 1889, 1901, 1907,
    1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987, 1993, 1997, 1999

    );

type

  PElement = ^TElement;

  TElement = record
    Key: Pchar;
    Value: Pointer;
    Next: PElement;
  end;

  TMSDictionary = class;

  TObject = class(System.TObject)
  public
    procedure Assign(AObject: TObject); dynamic;
    function IsCollection: Boolean; dynamic;
    function TokenType: TMSTETokenType; dynamic; //must be overriden by subclasse to be encoded
    function ToString: string; dynamic;
    function MSTESnapshot(Encoder: TObject): TMSDictionary; dynamic; //must be overriden by subclasse to be encoded as a dictionary
    function MSTEncodedString: string; dynamic; //returns a buffer containing the object encoded with MSTE protocol
    function SingleEncodingCode: TMSTETokenType; dynamic; // defaults returns MSTE_TOKEN_MUST_ENCODE
    procedure EncodeWithMSTEncoder(Encoder: TObject); dynamic;
  end;

  TObjectList = class(Contnrs.TObjectList)
  public
    procedure Assign(AObjectList: TObjectList); dynamic;
    function IsCollection: Boolean; dynamic;
    function TokenType: TMSTETokenType; dynamic; //dynamic;
    function ToString: string; dynamic;
    function MSTESnapshot(Encoder: TObject): TMSDictionary; dynamic; //must be overriden by subclasse to be encoded as a dictionary
    function MSTEncodedString: string; dynamic; //returns a buffer containing the object encoded with MSTE protocol
    function SingleEncodingCode: TMSTETokenType; dynamic; // defaults returns MSTE_TOKEN_MUST_ENCODE
    procedure EncodeWithMSTEncoder(Encoder: TObject); dynamic;

  end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
  TMSNull = class(TObject)
  private
    FValue: TObject;
  public
    constructor Create;
    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    function ToString: string; override;

    property Value: TObject read FValue;
  end;
//------------------------------------------------------------------------------
  TMSBool = class(TObject)
  private
    FValue: Boolean;
  public
    constructor Create(AValue: Boolean);

    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    function ToString: string; override;

    property Value: Boolean read FValue write FValue;
  end;
//------------------------------------------------------------------------------
  TMSString = class(TObject)
  private
    FValue: string;
  public
    constructor Create(AString: string = '');

    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property Value: string read FValue write FValue;
  end;
//------------------------------------------------------------------------------
  TMSDate = class(TObject)
  private
    FValue: TDateTime;
  public
    constructor Create(AValue: TDateTime = 0);

    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property Value: TDateTime read FValue write FValue;
  end;
//------------------------------------------------------------------------------
  TMSDictionary = class(TObject)
  private
    FOwnObject: Boolean;
    FCount, FCapacity: Cardinal;
    FDepth: Integer;
    FDictionary: array of PElement;
    procedure SetCapacity(NewCapacity: Integer);
    procedure Grow;
    function Hash(Akey: string): Cardinal;
    procedure FreeElement(Element: PElement);
    procedure PutElement(Index: Cardinal; Element: PElement);
    procedure FreeElementValue(Element: PElement);
    function GetElements: TList;
    procedure AddNew(pok: PElement);
  public
    function IsCollection: Boolean; override;
    function ToString: string; override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    procedure Assign(AObject: TObject); override;
    constructor Create(OwnObject: Boolean = False); overload;
    constructor Create(Capacity: Integer; OwnObject: Boolean = False); overload;
    destructor Destroy; override;

    procedure AddValue(Key: string; Value: TObject);
    function Remove(Key: string): Boolean;
    function SetValue(Key: string; Value: TObject): Boolean;

    function GetElementsKeys: TStringList;

//    function Find(Key: String): Boolean;
    function GetValue(Key: string): TObject;
    procedure Clear;
    property Count: Cardinal read FCount;
    property Capacity: Cardinal read FCapacity;
    property Depth: integer read FDepth;

  end;
//------------------------------------------------------------------------------
  TMSNaturalArray = class(TObject)
  private
    FValue: array of MSULong;
    function GetCount: Integer;
  protected
    function GetValue(Index: Integer): MSULong;
    procedure SetValue(Index: Integer; AValue: MSULong);

  public
    constructor Create(ALen: Integer);
    procedure Assign(AObject: TObject); override;
    function ToString: string; override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;

    property Count: Integer read GetCount;
    property Values[index: integer]: MSULong read GetValue write SetValue; default;

  end;
//------------------------------------------------------------------------------
  TMSNumberInstance = packed record
    case NType: Integer of
      0: (v0: MSChar); //Char
      1: (v1: MSByte); //Unsigned char
      2: (v2: MSShort); //Short
      3: (v3: MSUShort); //Unsigned short
      4: (v4: MSInt); //Int32
      5: (v5: MSUInt); //Unsigned int32
      6: (v6: MSLong); //Int64
      7: (v7: MSULong); //Unsigned int64
      8: (v8: Single); //Valeur flotante
      9: (v9: Double); //Valeur double
  end;

  TMSNumber = class(TObject)
  private
    FValue: TMSNumberInstance;
    procedure SetAsChar(const Value: MSChar);
    procedure SetAsByte(const Value: MSByte);
    procedure SetAsShort(const Value: MSShort);
    procedure SetAsInt(const Value: MSInt);
    procedure SetAsLong(const Value: MSLong);
    procedure SetAsUInt(const Value: MSUInt);
    procedure SetAsUShort(const Value: MSUShort);
    procedure SetAsDouble(const Value: Double);
    procedure SetAsFloat(const Value: Single);
    procedure SetAsULong(const Value: MSULong);
    function GetAsFloat: Single;
    function GetAsDouble: Double;
    function GetAsInt: MSInt;
    function GetAsChar: MSChar;
    function GetAsByte: MSByte;
    function GetAsShort: MSShort;
    function GetAsUShort: MSUShort;
    function GetAsUInt: MSUInt;
    function GetAsLong: MSLong;
    function GetULong: MSULong;
  public

    procedure Assign(AObject: TObject); override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function TokenType: TMSTETokenType; override;
    function ToString: string; override;

    property Char: MSChar read GetAsChar write SetAsChar;
    property Byte: MSByte read GetAsByte write SetAsByte;
    property Short: MSShort read GetAsShort write SetAsShort;
    property UShort: MSUShort read GetAsUShort write SetAsUShort;
    property Int: MSInt read GetAsInt write SetAsInt;
    property UInt: MSUInt read GetAsUInt write SetAsUInt;
    property Long: MSLong read GetAsLong write SetAsLong;
    property ULong: MSULong read GetULong write SetAsULong;
    property Float: Single read GetAsFloat write SetAsFloat;
    property Double: Double read GetAsDouble write SetAsDouble;
  end;
//------------------------------------------------------------------------------
  TMSColor = class(TObject)
  private
    FValue: TColor;
    FTransparency: Byte;
    function GetTRGBValue: MSUInt;
    procedure SetTRGBValue(const Value: MSUInt);
    function GetB: Byte;
    function GetG: Byte;
    function GetR: Byte;
  public
    procedure Assign(AObject: TObject); override;
    constructor Create(); overload;
    constructor Create(AColor: TColor; ATransparency: Byte = 0); overload;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property Color: TColor read FValue write FValue;
    property Transparency: Byte read FTransparency write FTransparency;
    property TRGB: MSUInt read GetTRGBValue write SetTRGBValue;
    property R: Byte read GetR;
    property G: Byte read GetG;
    property B: Byte read GetB;
  end;
//------------------------------------------------------------------------------
  TMSCouple = class(TObject)
  private
    FFirstMember: TObject;
    FSecondMember: TObject;
    FFreeOnDestroy: Boolean;
  public
    constructor Create(FirstMember: TObject = nil; SecondMember: TObject = nil);
    destructor Destroy; override;
    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property FreeOnDestroy: Boolean read FFreeOnDestroy write FFreeOnDestroy;
    property FirstMember: TObject read FFirstMember write FFirstMember;
    property SecondMember: TObject read FSecondMember write FSecondMember;
  end;
//------------------------------------------------------------------------------
  TMSData = class(TObject)
  private
    FValue: TMemoryStream;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    procedure SetBase64Data(AData: string);
    procedure SetHexData(AData: string);
    property Value: TMemoryStream read FValue;
  end;

var
  __MSNull: TMSNull;
  __MSTrue: TMSBool;
  __MSFalse: TMSBool;
  __MSEmptyString: TMSString;
  __theDistantPast: TMSDate;
  __theDistantFuture: TMSDate;

implementation
uses Dialogs, Math, StrUtils, DateUtils, EncdDecd, UMSTEEncoder;

//------------------------------------------------------------------------------
{ TMSNull }
//------------------------------------------------------------------------------
{$REGION 'TMSNull'}

procedure TMSNull.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
end;
//------------------------------------------------------------------------------

constructor TMSNull.Create;
begin
  inherited;
  FValue := nil;
end;
//------------------------------------------------------------------------------

function TMSNull.SingleEncodingCode: TMSTETokenType;
begin
  Result := tt_NULL;
end;
//------------------------------------------------------------------------------

function TMSNull.TokenType: TMSTETokenType;
begin
  Result := tt_NULL;
end;
//------------------------------------------------------------------------------

function TMSNull.ToString: string;
begin
  Result := 'NULL';
end;
{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSBool }
//------------------------------------------------------------------------------
{$REGION 'TMSBool'}

procedure TMSBool.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then
    MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else
    FValue := TMSBool(AObject).Value;
end;
//------------------------------------------------------------------------------

constructor TMSBool.Create(AValue: Boolean);
begin
  inherited Create;
  FValue := AValue
end;
//------------------------------------------------------------------------------

function TMSBool.SingleEncodingCode: TMSTETokenType;
begin
  if FValue then Result := tt_TRUE else Result := tt_FALSE;
end;
//------------------------------------------------------------------------------

function TMSBool.TokenType: TMSTETokenType;
begin
  if FValue then Result := tt_TRUE else Result := tt_FALSE;
end;
//------------------------------------------------------------------------------

function TMSBool.ToString: string;
begin
  if FValue then Result := 'TRUE' else Result := 'FALSE';
end;
{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSDictionary }
//------------------------------------------------------------------------------
{$REGION 'TMSDictionary'}

constructor TMSDictionary.Create(OwnObject: Boolean = False);
begin
  Create(11, OwnObject);
end;
//------------------------------------------------------------------------------

constructor TMSDictionary.Create(Capacity: Integer; OwnObject: Boolean = False);
begin
  FCount := 0;
  FCapacity := 0;
  FDepth := 0;
  FOwnObject := OwnObject;
  SetCapacity(Capacity);
end;
//------------------------------------------------------------------------------

function TMSDictionary.GetElements: TList;
var
  i: integer;
  list: TList;
  pok: PElement;
begin
  list := TList.Create();

  for i := 0 to FCapacity - 1 do begin
    if FDictionary[i] <> nil then begin
      pok := FDictionary[i];
      list.Add(pok);
      while pok.next <> nil do begin
        pok := pok.next;
        if pok <> nil then list.Add(pok)
      end;
    end
  end;

  Result := list
end;
//------------------------------------------------------------------------------

function TMSDictionary.GetElementsKeys: TStringList;
var
  i: integer;
  list: TStringList;
  pok: PElement;
  sKey: string;
begin
  list := TStringList.Create();

  for i := 0 to FCapacity - 1 do begin
    if FDictionary[i] <> nil then begin
      pok := FDictionary[i];
      sKey := pok.Key;
      list.Add(sKey);
      while pok.next <> nil do begin
        pok := pok.next;
        if pok <> nil then begin
          sKey := pok.Key;
          list.Add(sKey);
        end;
      end;
    end
  end;

  list.Sort;
  Result := list
end;
//------------------------------------------------------------------------------

procedure TMSDictionary.SetCapacity(NewCapacity: Integer);
var
  tmpList: TList;
  i, index: cardinal;
  el: PElement;
begin
  FDepth := 0;
  if FCount = 0 then begin
    SetLength(FDictionary, NewCapacity);
    FCapacity := NewCapacity;
  end else begin
    tmpList := GetElements;
    FCount := 0;
    FCapacity := NewCapacity;
    SetLength(FDictionary, 0);
    SetLength(FDictionary, FCapacity);

    for i := 0 to tmpList.Count - 1 do begin
      el := PElement(tmpList[i]);
      el.Next := nil;
      Index := Hash(el.Key);
      PutElement(index, PElement(el));
      Inc(FCount);
    end;

    tmpList.Free;
  end;

end;

//------------------------------------------------------------------------------
{ Destroy the hash map }

destructor TMSDictionary.Destroy;
begin
  Clear;
  inherited Destroy
end;

//------------------------------------------------------------------------------

procedure TMSDictionary.FreeElementValue(Element: PElement);
begin
  if FOwnObject and (Element.Value <> nil) then begin
    TObject(Element.Value).Free;
    Element.Value := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TMSDictionary.FreeElement(Element: PElement);
begin
  FreeElementValue(Element);
  FreeMem(Element.Key);
  FreeMem(Element);
  Dec(FCount);
end;

//------------------------------------------------------------------------------
{ Calculate the hash value of a string }

function TMSDictionary.Hash(Akey: string): Cardinal;
var
  i: Cardinal;
  x: Cardinal;
begin
  Result := 0;
  for i := 1 to Length(Akey) do begin
    Result := (Result shl 4) + Ord(Akey[i]);
    x := Result and $F0000000;
    if (x <> 0) then begin
      Result := Result xor (x shr 24);
    end;
    Result := Result and (not x);
  end;
  Result := Result mod FCapacity;
end;

//------------------------------------------------------------------------------

function TMSDictionary.SetValue(Key: string; Value: TObject): Boolean;
var
  Index: Cardinal;
  el, pok: PElement;
begin
  Result := False;
  index := Hash(key);

  el := FDictionary[index];
  if (el <> nil) and (CompareStr(Key, el.Key) = 0) then begin
    if CompareStr(Key, el.key) = 0 then begin
      FreeElementValue(el);
      el.Value := Value;
      Result := True;
    end else begin
      while (el.Next <> nil) and (CompareStr(Key, el.Next.Key) <> 0) do
        el := el.Next;
      if el <> nil then begin
        pok := el.Next;
        el.Next := pok.Next;
        FreeElementValue(el);
        el.Value := Value;
        Result := True;
      end;
    end;
  end

end;

//------------------------------------------------------------------------------
{ Add a new string to the hash table }

procedure TMSDictionary.AddValue(Key: string; Value: TObject);
var
  Index: Cardinal;
  el: PElement;
begin

  if FCount = FCapacity then Grow;
  Inc(FCount);
  Index := Hash(Key);

  GetMem(el, SizeOf(TElement));
  key := Key + #0;
  GetMem(el.Key, Length(Key));
  StrPCopy(el.Key, Key);
  el.Value := Value;
  el.Next := nil;

  PutElement(Index, el);

end;

//------------------------------------------------------------------------------

procedure TMSDictionary.PutElement(Index: Cardinal; Element: PElement);
var
  pok: PElement;
  xDepth: Integer;
begin
  xDepth := 0;
  if FDictionary[Index] = nil then
    FDictionary[Index] := Element
  else begin
    pok := FDictionary[Index];
    while pok.Next <> nil do begin
      pok := pok.Next;
      inc(xDepth);
    end;
    pok.Next := Element
  end;

  FDepth := Max(FDepth, xDepth);

end;

//------------------------------------------------------------------------------
{ Remove a string from the hash table }

function TMSDictionary.Remove(Key: string): Boolean;
var
  Index: Cardinal;
  el, pok: PElement;

begin
  Result := False;
  index := Hash(key);

  if (FDictionary[index] <> nil) then begin
    el := FDictionary[index];
    if CompareStr(Key, el.key) = 0 then begin
      FDictionary[index] := el.Next;
      FreeElement(el);
      Result := True;
    end else begin
      while (el.Next <> nil) and (CompareStr(Key, el.Next.Key) <> 0) do
        el := el.Next;
      if el <> nil then begin
        pok := el.Next;
        el.Next := pok.Next;
        FreeElement(pok);
        Result := True;
      end
    end;
  end

end;

//------------------------------------------------------------------------------

function TMSDictionary.GetValue(key: string): TObject;
var
  Index: Cardinal;
  el: PElement;
begin
  Result := nil;
  Index := Hash(key);
  el := FDictionary[index];

  while (el <> nil) do
    if CompareStr(Key, el.Key) = 0 then break else el := el.Next;

  if el <> nil then Result := el.Value;

end;
//------------------------------------------------------------------------------

procedure TMSDictionary.Grow;
var
  i: Integer;
  newCapacity: Cardinal;
begin

  if FCapacity >= 1999 then begin
    newCapacity := FCapacity + FCapacity div 4;
  end else
    for i := 0 to MaxCapacity - 1 do begin
      newCapacity := PrimeNumber[i];
      if newCapacity > FCapacity then begin
        Break;
      end;
    end;

  SetCapacity(newCapacity);

end;

//------------------------------------------------------------------------------

procedure TMSDictionary.AddNew(pok: PElement);
var
  sKey: string;
  xObj, xDest: TObject;
begin

  sKey := pok.Key;
  xObj := TObject(pok.Value);

  if FOwnObject then begin
    xDest := TObject(xObj.ClassType.Create);
    xDest.Assign(xObj);
    xObj := xDest;
  end;

  AddValue(sKey, xObj)

end;
//------------------------------------------------------------------------------

procedure TMSDictionary.Assign(AObject: TObject);
var
  i: integer;
  pok: PElement;
  xSrc: TMSDictionary;
begin

  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else begin
    Clear;
    xSrc := TMSDictionary(AObject);

    FOwnObject := xsrc.FOwnObject;

    for i := 0 to xSrc.FCapacity - 1 do begin
      if xSrc.FDictionary[i] <> nil then begin
        pok := xSrc.FDictionary[i];
        AddNew(pok);
        while pok.next <> nil do begin
          pok := pok.next;
          if pok <> nil then begin
            AddNew(pok);
          end;
        end;
      end
    end;

  end;

end;

//------------------------------------------------------------------------------

procedure TMSDictionary.Clear;
var
  i: integer;
  pok, prev: PElement;
begin
  for i := 0 to High(FDictionary) do begin
    if FDictionary[i] <> nil then begin
      pok := FDictionary[i];
      while pok.next <> nil do begin
        prev := pok;
        pok := pok.next;
        FreeElement(prev);
      end;
      FreeElement(pok);
      FDictionary[i] := nil;
    end;

  end;
  FCount := 0;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

function TMSDictionary.IsCollection: Boolean;
begin
  Result := True;
end;
//------------------------------------------------------------------------------

procedure TMSDictionary.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeDictionary(Self);
end;
//------------------------------------------------------------------------------

function TMSDictionary.TokenType: TMSTETokenType;
begin
  Result := tt_DICTIONARY;
end;
//------------------------------------------------------------------------------

function TMSDictionary.ToString: string;
var
  sl: TStringList;
  i: integer;
  s, sKey, sObj: string;
  xObj: TObject;
begin

  sl := GetElementsKeys;

  s := #13#10'{'#13#10;

  for I := 0 to sl.Count - 1 do begin
    sKey := sl[i];
    xObj := GetValue(sKey);
    if xObj.IsCollection then begin
      s := s + sKey + '=' + xObj.ClassName + #13#10;
    end else begin
      sObj := xObj.ToString;
      s := s + sKey + '=' + sObj + #13#10;
    end;
  end;
  s := s + '}';

  sl.Free;
  Result := s;
end;

{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSString }
//------------------------------------------------------------------------------
{$REGION 'TMSString'}

procedure TMSString.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then
    MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else
    FValue := TMSString(AObject).Value;
end;
//------------------------------------------------------------------------------

constructor TMSString.Create(AString: string = '');
begin
  inherited Create;
  FValue := AString;
end;
//------------------------------------------------------------------------------

procedure TMSString.EncodeWithMSTEncoder(Encoder: TObject);
begin
  if FValue <> '' then begin
    TMSTEEncoder(Encoder).EncodeString(FValue, False);
  end;
end;
//------------------------------------------------------------------------------

function TMSString.SingleEncodingCode: TMSTETokenType;
begin
  if FValue <> '' then Result := tt_MUST_ENCODE else Result := tt_EMPTY_STRING;
end;
//------------------------------------------------------------------------------

function TMSString.TokenType: TMSTETokenType;
begin
  Result := tt_STRING;
end;
//------------------------------------------------------------------------------

function TMSString.ToString: string;
begin
  Result := FValue;
end;
{$ENDREGION}
//------------------------------------------------------------------------------
{ TMSDate }
//------------------------------------------------------------------------------

{$REGION 'TMSDate'}

procedure TMSDate.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else
    FValue := TMSDate(AObject).Value;
end;
//------------------------------------------------------------------------------

constructor TMSDate.Create(AValue: TDateTime);
begin
  inherited Create;
  FValue := AValue;
end;
//------------------------------------------------------------------------------

procedure TMSDate.EncodeWithMSTEncoder(Encoder: TObject);
begin
  if not (
    SameDateTime(FValue, __theDistantPast.Value)
    or
    SameDateTime(FValue, __theDistantFuture.Value)
    ) then
    TMSTEEncoder(Encoder).EncodeLongLong(DateTimeToUnix(FValue), False);

end;
//------------------------------------------------------------------------------

function TMSDate.SingleEncodingCode: TMSTETokenType;
begin
  if SameDateTime(FValue, __theDistantPast.Value) then Result := tt_DISTANT_PAST
  else if SameDateTime(FValue, __theDistantFuture.Value) then Result := tt_DISTANT_FUTURE
  else Result := tt_MUST_ENCODE;
end;

//------------------------------------------------------------------------------

function TMSDate.TokenType: TMSTETokenType;
begin
  Result := tt_DATE;
end;
//------------------------------------------------------------------------------

function TMSDate.ToString: string;
begin
  Result := FormatDateTime('dd/mm/yyyy', FValue)
end;
{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSColor }
//------------------------------------------------------------------------------
{$REGION 'TMSColor'}

procedure TMSColor.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else begin
    FValue := TMSColor(AObject).Color;
    FTransparency := TMSColor(AObject).Transparency;
  end;
end;
//------------------------------------------------------------------------------

constructor TMSColor.Create(AColor: TColor; ATransparency: Byte);
begin
  inherited Create;
  FValue := AColor;
  FTransparency := ATransparency;
end;
//------------------------------------------------------------------------------

constructor TMSColor.Create;
begin
  Create(0, 0);
end;
//------------------------------------------------------------------------------

procedure TMSColor.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeUnsignedInt(TRGB, False);
end;
//------------------------------------------------------------------------------

function TMSColor.GetB: Byte;
begin
  Result := ColorToRGB(FValue) shr 16;
end;
//------------------------------------------------------------------------------

function TMSColor.GetG: Byte;
begin
  Result := ColorToRGB(FValue) shr 8;
end;
//------------------------------------------------------------------------------

function TMSColor.GetR: Byte;
begin
  Result := ColorToRGB(FValue);
end;
//------------------------------------------------------------------------------

function TMSColor.GetTRGBValue: MSUInt;
begin
  Result := ColorToRGB(FValue) + (FTransparency shl 24);
end;
//------------------------------------------------------------------------------

procedure TMSColor.SetTRGBValue(const Value: MSUInt);
var
  R, G, B, T: Byte;
begin

  T := 255 - ((Value shr 24) and $FF);
  R := ((Value shr 16) and $FF);
  G := ((Value shr 8) and $FF);
  B := (Value and $FF);

  FValue := RGB(R, G, B);
  FTransparency := T;

end;

//------------------------------------------------------------------------------

function TMSColor.TokenType: TMSTETokenType;
begin
  Result := tt_COLOR;
end;
//------------------------------------------------------------------------------

function TMSColor.ToString: string;
var
  rgb: Integer;
begin
  rgb := ColorToRGB(FValue);
  Result := Format('#%.2x%.2x%.2x%.2x',
    [FTransparency, GetRValue(rgb), GetGValue(rgb), GetBValue(rgb)]);

end;
{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSCouple }
//------------------------------------------------------------------------------

{$REGION 'TMSColor'}

procedure TMSCouple.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else begin
    FFirstMember.Assign(TMSCouple(AObject).FirstMember);
    FSecondMember.Assign(TMSCouple(AObject).SecondMember);
  end;
end;
//------------------------------------------------------------------------------

constructor TMSCouple.Create(FirstMember, SecondMember: TObject);
begin
  inherited Create;
  FreeOnDestroy := False;
  FFirstMember := FirstMember;
  FSecondMember := SecondMember;
end;
//------------------------------------------------------------------------------

destructor TMSCouple.Destroy;
begin
  if FreeOnDestroy then begin
    FreeAndNil(FFirstMember);
    FreeAndNil(FSecondMember);
  end;

  inherited;
end;
//------------------------------------------------------------------------------

procedure TMSCouple.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeObject(FFirstMember);
  TMSTEEncoder(Encoder).EncodeObject(FSecondMember);
end;
//------------------------------------------------------------------------------

function TMSCouple.TokenType: TMSTETokenType;
begin
  Result := tt_COUPLE;
end;
//------------------------------------------------------------------------------

function TMSCouple.ToString: string;
begin
  if Assigned(FFirstMember) then Result := FFirstMember.ToString;
  if Assigned(FSecondMember) then Result := Result + '/' + FSecondMember.ToString;
end;
{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSData }
//------------------------------------------------------------------------------

{$REGION 'TMSColor'}

procedure TMSData.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else
    FValue.LoadFromStream(TMSData(AObject).Value);
end;
//------------------------------------------------------------------------------

constructor TMSData.Create;
begin
  inherited Create;
  FValue := TMemoryStream.Create;
end;
//------------------------------------------------------------------------------

destructor TMSData.Destroy;
begin
  FValue.Free;
  inherited;
end;
//------------------------------------------------------------------------------

procedure TMSData.EncodeWithMSTEncoder(Encoder: TObject);
begin
  FValue.Position := 0;
  TMSTEEncoder(Encoder).EncodeStream64(FValue, False);
end;

//------------------------------------------------------------------------------

procedure TMSData.SetBase64Data(AData: string);
var
  AStream: TStringStream;
begin
  FValue.Clear;
  AStream := TStringStream.Create(AData);
  DecodeStream(AStream, FValue);
  AStream.Free;
end;
//------------------------------------------------------------------------------

procedure TMSData.SetHexData(AData: string);
var
  xB: Byte;
  i: Integer;
begin
  FValue.Clear;

  if Odd(Length(AData)) then AData := AData + '0';
  i := 1;
  repeat
    xB := StrToInt('$' + Copy(AData, i, 2));
    FValue.WriteBuffer(xB, 1);
    Inc(i, 2)
  until i >= Length(AData);

end;
//------------------------------------------------------------------------------

function TMSData.TokenType: TMSTETokenType;
begin
  Result := tt_BASE64_DATA;
end;
//------------------------------------------------------------------------------

function TMSData.ToString: string;
begin
  if FValue.Size = 0 then
    Result := 'TMSData = Empty'
  else
    BinToHex(FValue.Memory, PAnsiChar(Result), FValue.Size);
end;

{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSNumber }
//------------------------------------------------------------------------------

{$REGION 'TMSNumber'}

procedure TMSNumber.Assign(AObject: TObject);
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else
    CopyMemory(@FValue, @TMSNumber(AObject).FValue, SizeOf(TMSNumberInstance));

end;
//------------------------------------------------------------------------------

procedure TMSNumber.EncodeWithMSTEncoder(Encoder: TObject);
begin
  case FValue.NType of
    0: TMSTEEncoder(Encoder).EncodeChar(FValue.v0, False);
    1: TMSTEEncoder(Encoder).EncodeUnsignedChar(FValue.v1, False);
    2: TMSTEEncoder(Encoder).EncodeShort(FValue.v2, False);
    3: TMSTEEncoder(Encoder).EncodeUnsignedShort(FValue.v3, False);
    4: TMSTEEncoder(Encoder).EncodeInt(FValue.v4, False);
    5: TMSTEEncoder(Encoder).EncodeUnsignedInt(FValue.v5, False);
    6: TMSTEEncoder(Encoder).EncodeLongLong(FValue.v6, False);
    7: TMSTEEncoder(Encoder).EncodeUnsignedLongLong(FValue.v7, False);
    8: TMSTEEncoder(Encoder).EncodeFloat(FValue.v8, False);
    9: TMSTEEncoder(Encoder).EncodeDouble(FValue.v9, False);
  else
    MSRaise(Exception, 'Unknow Number Type');
  end;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsChar(const Value: MSChar);
begin
  FValue.NType := 0;
  FValue.v0 := Value;
end;

//------------------------------------------------------------------------------

function TMSNumber.GetAsChar: MSChar;
begin
  if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else Result := FValue.v0;
end;
//------------------------------------------------------------------------------

function TMSNumber.GetAsByte: MSByte;
begin
  if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else Result := FValue.v1;
end;
//------------------------------------------------------------------------------

function TMSNumber.GetAsShort: MSShort;
begin
  if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else Result := FValue.v2;
end;
//------------------------------------------------------------------------------

function TMSNumber.GetAsUShort: MSUShort;
begin
  if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else Result := FValue.v3;
end;

//------------------------------------------------------------------------------

function TMSNumber.GetAsInt: MSInt;
begin
  if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else Result := FValue.v4;
end;

//------------------------------------------------------------------------------

function TMSNumber.GetAsUInt: MSUInt;
begin
  if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else Result := FValue.v5;
end;
//------------------------------------------------------------------------------

function TMSNumber.GetAsLong: MSLong;
begin
  if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else Result := FValue.v6;
end;
//------------------------------------------------------------------------------

function TMSNumber.GetULong: MSULong;
begin
  if FValue.NType = 8 then Result := Trunc(FValue.v8)
  else if FValue.NType = 9 then Result := Trunc(FValue.v9)
  else Result := FValue.v7;
end;

//------------------------------------------------------------------------------

function TMSNumber.GetAsDouble: Double;
begin
  if FValue.NType = 8 then Result := FValue.v8
  else if FValue.NType = 9 then Result := FValue.v9
  else Result := FValue.v6;
end;
//------------------------------------------------------------------------------

function TMSNumber.GetAsFloat: Single;
begin
  if FValue.NType = 8 then Result := FValue.v8
  else if FValue.NType = 9 then Result := FValue.v9
  else Result := FValue.v6;
end;

//------------------------------------------------------------------------------

procedure TMSNumber.SetAsByte(const Value: MSByte);
begin
  FValue.NType := 1;
  FValue.v1 := Value;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsShort(const Value: MSShort);
begin
  FValue.NType := 2;
  FValue.v2 := Value;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsUShort(const Value: MSUShort);
begin
  FValue.NType := 3;
  FValue.v3 := Value;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsInt(const Value: MSInt);
begin
  FValue.NType := 4;
  FValue.v4 := Value;
end;

//------------------------------------------------------------------------------

procedure TMSNumber.SetAsUInt(const Value: MSUInt);
begin
  FValue.NType := 5;
  FValue.v5 := Value;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsLong(const Value: MSLong);
begin
  FValue.NType := 6;
  FValue.v6 := Value;
end;

//------------------------------------------------------------------------------

procedure TMSNumber.SetAsULong(const Value: MSULong);
begin
  FValue.NType := 7;
  FValue.v7 := Value;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsFloat(const Value: Single);
begin
  FValue.NType := 8;
  FValue.v8 := Value;
end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsDouble(const Value: Double);
begin
  FValue.NType := 9;
  FValue.v9 := Value;
end;

//------------------------------------------------------------------------------

function TMSNumber.TokenType: TMSTETokenType;
begin
  Result := tt_INTEGER_VALUE;
end;
//------------------------------------------------------------------------------

function TMSNumber.ToString: string;
begin
  case FValue.NType of
    0: result := IntToStr(FValue.v0);
    1: result := IntToStr(FValue.v1);
    2: result := IntToStr(FValue.v2);
    3: result := IntToStr(FValue.v3);
    4: result := IntToStr(FValue.v4);
    5: result := IntToStr(FValue.v5);
    6: result := IntToStr(FValue.v6);
    7: result := IntToStr(FValue.v7);
    8: result := FloatToStr(FValue.v8);
    9: Result := FloatToStr(FValue.v9);
  else result := '';
  end;

end;
{$ENDREGION}

//------------------------------------------------------------------------------
{ TMSNaturalArray }
//------------------------------------------------------------------------------

{$REGION 'TMSNaturalArray'}

procedure TMSNaturalArray.Assign(AObject: TObject);
var
  i: Integer;
begin
  if (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName])
  else begin
    SetLength(FValue, TMSNaturalArray(AObject).Count);
    for i := 0 to Count - 1 do
      SetValue(i, TMSNaturalArray(AObject)[i]);
  end;
end;
//------------------------------------------------------------------------------

constructor TMSNaturalArray.Create(ALen: Integer);
begin
  inherited Create;
  SetLength(FValue, ALen);
end;
//------------------------------------------------------------------------------

procedure TMSNaturalArray.EncodeWithMSTEncoder(Encoder: TObject);
var
  i: Integer;
begin
  TMSTEEncoder(Encoder).EncodeUnsignedLongLong(Count, False);
  for i := 0 to Count - 1 do
    TMSTEEncoder(Encoder).encodeUnsignedInt(FValue[i], False);
end;

//------------------------------------------------------------------------------

function TMSNaturalArray.GetCount: Integer;
begin
  Result := Length(FValue);
end;
//------------------------------------------------------------------------------

function TMSNaturalArray.GetValue(Index: Integer): MSULong;
begin
  if (Index < 0) or (Index >= Count) then
    MSRaise(ERangeError, 'Invalid index %d', [Index]);
  Result := FValue[Index];
end;
//------------------------------------------------------------------------------

procedure TMSNaturalArray.SetValue(Index: Integer; AValue: MSULong);
begin
  if (Index < 0) or (Index >= Count) then
    MSRaise(ERangeError, 'Invalid index %d', [Index]);
  FValue[Index] := AValue;
end;

//------------------------------------------------------------------------------

function TMSNaturalArray.TokenType: TMSTETokenType;
begin
  Result := tt_NATURAL_ARRAY;
end;

//------------------------------------------------------------------------------

function TMSNaturalArray.ToString: string;
var
  i: Integer;
  c: MSULong;
begin
  Result := '[';
  for i := 0 to Count - 1 do begin
    c := GetValue(i);
    Result := Result + ',' + IntToStr(c);
  end;

  if Count <> 0 then
    delete(Result, 2, 1);

  Result := Result + ']';
end;

{$ENDREGION}

//------------------------------------------------------------------------------
{ TObject }
//------------------------------------------------------------------------------

{$REGION 'TObject'}

procedure TObject.Assign(AObject: TObject);
begin
  MSRaise(Exception, '%s : Assign method must be overritten', [ClassName]);
end;

procedure TObject.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeObject(Self);
end;

function TObject.IsCollection: Boolean;
begin
  Result := False;
end;

function TObject.MSTEncodedString: string;
begin
  result := '';
end;

function TObject.MSTESnapshot(Encoder: TObject): TMSDictionary;
begin
  Result := nil;
end;

function TObject.singleEncodingCode: TMSTETokenType;
begin
  Result := tt_MUST_ENCODE;
end;

function TObject.TokenType: TMSTETokenType;
begin
  Result := tt_USER_CLASS;
end;

function TObject.ToString: string;
begin
  MSRaise(Exception, '%s : ToString method must be overritten', [ClassName]);
end;

{$ENDREGION}

//------------------------------------------------------------------------------
{ TObjectList }
//------------------------------------------------------------------------------

{$REGION 'TObjectList'}

procedure TObjectList.Assign(AObjectList: TObjectList);
var
  i: Integer;
  xSrc, xDest: TObject;
begin
  clear;
  OwnsObjects := AObjectList.OwnsObjects;

  if not OwnsObjects then
    inherited Assign(AObjectList) //TList.assign only copy pointers

  else begin
     //create and assign new obj
    for I := 0 to AObjectList.Count - 1 do begin
      xSrc := TObject(AObjectList.Items[i]);
      if Assigned(xSrc) then begin
        xDest := TObject(xSrc.ClassType.Create);
        xDest.Assign(xSrc);
      end
      else xDest := nil;
      Add(xDest);
    end;

  end;
end;
//------------------------------------------------------------------------------

procedure TObjectList.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeArray(self);
end;
//------------------------------------------------------------------------------

function TObjectList.IsCollection: Boolean;
begin
  Result := True;
end;
//------------------------------------------------------------------------------

function TObjectList.MSTEncodedString: string;
var
  encoder: TMSTEEncoder;
begin
  encoder := TMSTEEncoder.Create;
  Result := encoder.EncodeRootObject(Tobject(self));
  FreeAndNil(encoder);
end;
//------------------------------------------------------------------------------

function TObjectList.MSTESnapshot(Encoder: TObject): TMSDictionary;
begin
  Result := nil;
end;
//------------------------------------------------------------------------------

function TObjectList.SingleEncodingCode: TMSTETokenType;
begin
  Result := tt_MUST_ENCODE;
end;
//------------------------------------------------------------------------------

function TObjectList.TokenType: TMSTETokenType;
begin
  Result := tt_ARRAY;
end;
//------------------------------------------------------------------------------

function TObjectList.ToString: string;
var
  i: Integer;
  xObj: TObject;
  s, sobj: string;
begin

  s := '[';

  for I := 0 to Count - 1 do begin
    xObj := TObject(Items[i]);
    sObj := xObj.ToString;
    s := s + ',' + sObj;
  end;

  if Count <> 0 then system.delete(s, 2, 1);

  s := s + ']';

  result := s;
end;

{$ENDREGION}

//------------------------------------------------------------------------------

initialization

  __MSNull := TMSNull.Create;
  __MSTrue := TMSBool.Create(True);
  __MSFalse := TMSBool.Create(False);
  __MSEmptyString := TMSString.Create('');

  __theDistantPast := TMSDate.Create(MSLongMin);
  __theDistantFuture := TMSDate.Create(MSLongMax);

finalization
  FreeAndNil(__theDistantPast);
  FreeAndNil(__theDistantFuture);
  FreeAndNil(__MSEmptyString);
  FreeAndNil(__MSTrue);
  FreeAndNil(__MSFalse);
  FreeAndNil(__MSNull);

end.

