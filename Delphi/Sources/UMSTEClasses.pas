unit UMSTEClasses;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Contnrs, Graphics, UMSFoundation
  , UDictionary
  ;

const
  RecursiveToString = True;

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

  TMSTEObject = class;
  TMSArray = class;
  TMSDictionary = class;

  TMSTEElement = class(TObject)
  private
    FTokenType: TMSTETokenType;
    FObject: TMSTEObject;
  public
    constructor Create(AObject: TMSTEObject);
    destructor Destroy; override;
    property TokenType: TMSTETokenType read FTokenType write FTokenType;
    property MSTEObject: TMSTEObject read FObject write FObject;
  end;

  TMSTEObjectList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TMSTEObject;
    procedure SetItem(Index: Integer; AObject: TMSTEObject);
  public
    function Add(AObject: TMSTEObject): Integer; reintroduce;
    destructor Destroy; override;
    property Items[Index: Integer]: TMSTEObject read GetItem write SetItem; default;
  end;

  TMSTEObject = class(TObject)
  public
    constructor Create;
    function ToString: string; virtual;
    procedure Assign(AObject: TMSTEObject); virtual;
    function TokenType: TMSTETokenType; virtual;
    function SingleEncodingCode: TMSTETokenType; virtual;
    procedure EncodeWithMSTEncoder(Encoder: TObject); virtual;
    function MSTESnapshot(AEncoder: TObject): TMSDictionary; virtual;
  end;

  TMSNull = class(TMSTEObject)
  private
    function GetValue: TObject;
  public
    procedure Assign(AObject: TMSTEObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    function ToString: string; override;
    property Value: TObject read GetValue;
  end;

  TMSBool = class(TMSTEObject)
  private
    FValue: Boolean;
  public
    constructor Create(AValue: Boolean);
    procedure Assign(AObject: TMSTEObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    function ToString: string; override;
    property Value: Boolean read FValue write FValue;
  end;

  TMSString = class(TMSTEObject)
  private
    FValue: string;
  public
    constructor Create(AString: string = '');
    procedure Assign(AObject: TMSTEObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;
    property Value: string read FValue write FValue;
  end;

  TMSDate = class(TMSTEObject)
  private
    FValue: TDateTime;
  public
    constructor Create(AValue: TDateTime = 0); overload;
    procedure Assign(AObject: TMSTEObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;
    property Value: TDateTime read FValue write FValue;
  end;

  TMSDictionary = class(TMSTEObject)
  private
    FValue: TDictionary;
    function GetCount: Integer;
  public
    constructor Create(OwnObject: Boolean = False); reintroduce;
    destructor Destroy; override;
    procedure Assign(AObject: TMSTEObject); override;
    function ToString: string; override;

    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;

    procedure AddValue(Key: string; Value: TMSTEObject);
    function GetValue(Key: string): TMSTEObject;

    property Count: Integer read GetCount;
    property Value: TDictionary read FValue;
  end;

  TMSArray = class(TMSTEObject)
  private
    FValue: TObjectList; // array of TMSTEObject; //A Remplacer par un TObjectList ...
    function GetItem(Index: Integer): TMSTEObject;
//    procedure SetItem(Index: Integer; const Value: TMSTEObject);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(AObject: TMSTEObject); override;

    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    function Add(AObject: TMSTEObject): Integer;

    property Value[Index: Integer]: TMSTEObject read GetItem; default;
    property Count: Integer read GetCount;
  end;

  TMSNaturalArray = class(TMSTEObject)
  private
    FValue: array of MSULong;
    function GetCount: Integer;
  public
    constructor Create(ALen: Integer);
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    procedure Assign(AObject: TMSTEObject); override;

    procedure SetValue(AIndex: Integer; AValue: MSULong);
    function ValueAtIndex(AIndex: Integer): MSULong;
    property Count: Integer read GetCount;

  end;

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

  TMSNumber = class(TMSTEObject)
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
  public

    procedure Assign(AObject: TMSTEObject); override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;

    function TokenType: TMSTETokenType; override;
    function ToString: string; override;
    property Char: MSChar read FValue.v0 write SetAsChar;
    property Byte: MSByte read FValue.v1 write SetAsByte;
    property Short: MSShort read FValue.v2 write SetAsShort;
    property UShort: MSUShort read FValue.v3 write SetAsUShort;
    property Int: MSInt read FValue.v4 write SetAsInt;
    property UInt: MSUInt read FValue.v5 write SetAsUInt;
    property Long: MSLong read FValue.v6 write SetAsLong;
    property ULong: MSULong read FValue.v7 write SetAsULong;
    property Float: Single read FValue.v8 write SetAsFloat;
    property Double: Double read FValue.v9 write SetAsDouble;
  end;

  TMSColor = class(TMSTEObject)
  private
    FValue: TColor;
    FTransparent: Byte;
    function GetTRGBValue: MSUInt;
    procedure SetTRGBValue(const Value: MSUInt);
  public
    procedure Assign(AObject: TMSTEObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;
    property ColorValue: TColor read FValue write FValue;
    property TransparentValue: Byte read FTransparent write FTransparent;
    property TRGBValue: MSUInt read GetTRGBValue write SetTRGBValue;
  end;

  TMSCouple = class(TMSTEObject)
  private
    FFirstMember: TMSTEObject;
    FSecondMember: TMSTEObject;
  public
    procedure Assign(AObject: TMSTEObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;
    property FirstMember: TMSTEObject read FFirstMember write FFirstMember;
    property SecondMember: TMSTEObject read FSecondMember write FSecondMember;
  end;

  TMSData = class(TMSTEObject)
  private
    FValue: TMemoryStream;
  public
    procedure Assign(AObject: TMSTEObject); override;
    constructor Create;
    destructor Destroy; override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;
    procedure SetBase64Data(AData: string);
    procedure SetHexData(AData: string);
    property Value: TMemoryStream read FValue;
  end;

//  TComponentHelper = class helper for TComponent
//    public
//  function GetEnumerator: TComponentEnumerator;
//end;

//function DeQuote(Input: string): string;

var
  __MSNull: TMSNull;
  __MSTrue: TMSBool;
  __MSFalse: TMSBool;
  __MSEmptyString: TMSString;
  __theDistantPast: TMSDate;
  __theDistantFuture: TMSDate;

implementation
uses StrUtils, DateUtils, UMSTEEncoder;

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

//function DeQuote(Input: string): string;
//begin
//  Result := Input;
//  if StartsText('"', Result) then Delete(Result, 1, 1);
//  if EndsText('"', Result) then Delete(Result, Length(Result), 1);
//end;
//------------------------------------------------------------------------------

procedure Decode64(S: string; AStream: TStream);
var
  i: Integer;
  a: Integer;
  x: Integer;
  b: Integer;
begin
  a := 0;
  b := 0;
  if (Length(S) mod 4) <> 0 then
    raise Exception.Create('Base64: Incorrect string format');

  for i := 1 to Length(s) do begin
    x := Pos(s[i], codes64) - 1;
    if x >= 0 then begin
      b := b * 64 + x;
      a := a + 6;
      if a >= 8 then begin
        a := a - 8;
        x := b shr a;
        b := b mod (1 shl a);
        x := x mod 256;
        AStream.WriteBuffer(byte(x), 1);
      end;
    end
    else
      Break;
  end;
end;
//------------------------------------------------------------------------------
{ TNull }
//------------------------------------------------------------------------------

procedure TMSNull.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
end;
//------------------------------------------------------------------------------

function TMSNull.GetValue: TObject;
begin
  Result := nil;
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
//------------------------------------------------------------------------------
{ TMSBool }
//------------------------------------------------------------------------------

procedure TMSBool.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  FValue := TMSBool(AObject).Value;
end;
//------------------------------------------------------------------------------

constructor TMSBool.Create(AValue: Boolean);
begin
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

//------------------------------------------------------------------------------
{ TMSDictionary }

procedure TMSDictionary.AddValue(Key: string; Value: TMSTEObject);
begin
  FValue.AddValue(Key, Value);
end;

//------------------------------------------------------------------------------

procedure TMSDictionary.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  //Todo ....
//  FValue := TMSDate(AObject).Value;

end;
//------------------------------------------------------------------------------

constructor TMSDictionary.Create(OwnObject: Boolean = False);
begin
  inherited create;
  FValue := TDictionary.Create(OwnObject);
end;
//------------------------------------------------------------------------------

destructor TMSDictionary.Destroy;
begin
  FreeAndNil(FValue);
  inherited;
end;
//------------------------------------------------------------------------------

procedure TMSDictionary.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeDictionary(Self);
end;

//------------------------------------------------------------------------------

function TMSDictionary.GetCount: Integer;
begin
  Result := FValue.Count;
end;
//------------------------------------------------------------------------------

function TMSDictionary.GetValue(Key: string): TMSTEObject;
begin
  Result := FValue.GetValue(Key) as TMSTEObject;
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
  xObj: TMSTEObject;
begin

  //erreur sur les références cycliques
//  Exit;

  sl := FValue.GetElementsKeys;

  s := #13#10'{'#13#10;

  for I := 0 to sl.Count - 1 do begin
    sKey := sl[i];
    xObj := GetValue(sKey);
    if (not RecursiveToString) and ((xObj is TMSDictionary) or (xObj is TMSArray)) then begin
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

//------------------------------------------------------------------------------

{ TMSArray }

function TMSArray.Add(AObject: TMSTEObject): Integer;
begin
  Result := FValue.Add(AObject);
end;
//------------------------------------------------------------------------------

procedure TMSArray.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  //Todo ....
end;
//------------------------------------------------------------------------------

constructor TMSArray.Create;
begin
  inherited;
  FValue := TObjectList.Create(False);
end;
//------------------------------------------------------------------------------

destructor TMSArray.Destroy;
begin
  FValue.Free;
  inherited;
end;
//------------------------------------------------------------------------------

procedure TMSArray.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeArray(Self);
end;

//------------------------------------------------------------------------------

function TMSArray.GetCount: Integer;
begin
  Result := FValue.Count;
end;
//------------------------------------------------------------------------------

function TMSArray.GetItem(Index: Integer): TMSTEObject;
begin
  Result := FValue[Index] as TMSTEObject;
end;

//------------------------------------------------------------------------------

function TMSArray.TokenType: TMSTETokenType;
begin
  Result := tt_ARRAY;
end;
//------------------------------------------------------------------------------

function TMSArray.ToString: string;
var
  i: Integer;
  xObj: TMSTEObject;
  s, sobj: string;
begin

  s := #13#10'['#13#10;
  for I := 0 to FValue.Count - 1 do begin
    xObj := Value[i];
    sObj := xObj.ToString;
    s := s + sObj + #13#10;
  end;
  s := s + ']';

  result := s;
end;

//------------------------------------------------------------------------------
{ TMSTEObject }
//------------------------------------------------------------------------------

procedure TMSTEObject.Assign(AObject: TMSTEObject);
begin

end;
//------------------------------------------------------------------------------

constructor TMSTEObject.Create;
begin
  inherited;
end;
//------------------------------------------------------------------------------

procedure TMSTEObject.EncodeWithMSTEncoder(Encoder: TObject);
begin
  MSRaise(Exception, 'EncodeWithMSTEncoder method not implemented %s', [ClassName]);
end;
//------------------------------------------------------------------------------

function TMSTEObject.MSTESnapshot(AEncoder: TObject): TMSDictionary;
begin
  Result := nil;
  MSRaise(Exception, 'MSTESnapshot must be overrided for user class');
end;
//------------------------------------------------------------------------------

function TMSTEObject.SingleEncodingCode: TMSTETokenType;
begin
  Result := tt_MUST_ENCODE;
end;
//------------------------------------------------------------------------------

function TMSTEObject.TokenType: TMSTETokenType;
begin
  result := tt_USER_CLASS;
end;
//------------------------------------------------------------------------------

function TMSTEObject.ToString: string;
begin
  Result := ClassName;
end;

//------------------------------------------------------------------------------
{ TMSString }
//------------------------------------------------------------------------------

procedure TMSString.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  FValue := TMSString(AObject).Value;
end;
//------------------------------------------------------------------------------

constructor TMSString.Create(AString: string = '');
begin
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
//------------------------------------------------------------------------------
{ TMSDate }

procedure TMSDate.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  FValue := TMSDate(AObject).Value;
end;
//------------------------------------------------------------------------------

constructor TMSDate.Create(AValue: TDateTime);
begin
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
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

{ TMSColor }

procedure TMSColor.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  FValue := TMSColor(AObject).ColorValue;
  FTransparent := TMSColor(AObject).TransparentValue;
end;
//------------------------------------------------------------------------------

procedure TMSColor.EncodeWithMSTEncoder(Encoder: TObject);
begin

  TMSTEEncoder(Encoder).EncodeUnsignedInt(TRGBValue, False);
end;
//------------------------------------------------------------------------------

function TMSColor.GetTRGBValue: MSUInt;
begin
  Result := ColorToRGB(FValue) + (FTransparent shl 24);
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
  FTransparent := T;

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
    [FTransparent, GetRValue(rgb), GetGValue(rgb), GetBValue(rgb)]);

end;
//------------------------------------------------------------------------------

{ TMSCouple }

procedure TMSCouple.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
  FFirstMember := TMSCouple(AObject).FirstMember;
  FSecondMember := TMSCouple(AObject).SecondMember;
end;
//------------------------------------------------------------------------------

procedure TMSCouple.EncodeWithMSTEncoder(Encoder: TObject);
begin
//todo

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

//------------------------------------------------------------------------------
{ TMSData }

procedure TMSData.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//TODO ...
end;
//------------------------------------------------------------------------------

constructor TMSData.Create;
begin
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
//todo

end;

//------------------------------------------------------------------------------

procedure TMSData.SetBase64Data(AData: string);
begin
  FValue.Clear;
  Decode64(AData, FValue);
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
//------------------------------------------------------------------------------

{ TMSNumber }

procedure TMSNumber.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);

  CopyMemory(@FValue, @TMSNumber(AObject).FValue, SizeOf(TMSNumberInstance));

end;
//------------------------------------------------------------------------------

procedure TMSNumber.EncodeWithMSTEncoder(Encoder: TObject);
begin
//TODO
//coinc ....

end;
//------------------------------------------------------------------------------

procedure TMSNumber.SetAsChar(const Value: MSChar);
begin
  FValue.NType := 0;
  FValue.v0 := Value;
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
//------------------------------------------------------------------------------

{ TMSNaturalArray }
//------------------------------------------------------------------------------

procedure TMSNaturalArray.Assign(AObject: TMSTEObject);
begin
  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//todo
end;
//------------------------------------------------------------------------------

constructor TMSNaturalArray.Create(ALen: Integer);
begin
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

procedure TMSNaturalArray.SetValue(AIndex: Integer; AValue: MSULong);
begin
  if AIndex < Length(FValue) then
    FValue[AIndex] := AValue;
end;

function TMSNaturalArray.TokenType: TMSTETokenType;
begin
  Result := tt_NATURAL_ARRAY;
end;

//------------------------------------------------------------------------------

function TMSNaturalArray.ValueAtIndex(AIndex: Integer): MSULong;
begin
  if AIndex < Length(FValue) then
    Result := FValue[AIndex]
  else
  begin
    result := 0;
    MSRaise(ERangeError, 'Invalid index %s', [AIndex]);
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
{ TMSTEObjectList }
//------------------------------------------------------------------------------

function TMSTEObjectList.Add(AObject: TMSTEObject): Integer;
var
  xElm: TMSTEElement;
begin
  xElm := TMSTEElement.Create(AObject);
  Result := inherited Add(xElm);
end;
//------------------------------------------------------------------------------

destructor TMSTEObjectList.Destroy;
begin

  inherited;
end;
//------------------------------------------------------------------------------

function TMSTEObjectList.GetItem(Index: Integer): TMSTEObject;
var
  xElm: TMSTEElement;
begin
  xElm := inherited GetItem(Index) as TMSTEElement;
  Result := xElm.MSTEObject;
end;
//------------------------------------------------------------------------------

procedure TMSTEObjectList.SetItem(Index: Integer; AObject: TMSTEObject);
begin
  inherited SetItem(Index, AObject);
end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
{ TMSTEElement }
//------------------------------------------------------------------------------

constructor TMSTEElement.Create(AObject: TMSTEObject);
begin
  inherited create;
  FObject := AObject;
  if assigned(AObject) then
    FTokenType := AObject.TokenType //useless
  else
    beep;
end;
//------------------------------------------------------------------------------

destructor TMSTEElement.Destroy;
begin
  if Assigned(FObject) then
    FreeAndNil(FObject);
  inherited;
end;
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

