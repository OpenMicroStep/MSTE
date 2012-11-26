unit UMSTEClasses;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Contnrs, Graphics, UMSFoundation
  , UDictionary
  ;

const
//  RecursiveToString = True;
  RecursiveToString = False;

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

  TMSDictionary = class;

  TObject = class(System.TObject)
  public
    procedure Assign(AObject: TObject); dynamic;
    function IsCollection: Boolean; dynamic;
    function TokenType: TMSTETokenType; dynamic; //must be overriden by subclasse to be encoded
    function ToString: string; dynamic;
    function MSTESnapshot: TMSDictionary; dynamic; //must be overriden by subclasse to be encoded as a dictionary
    function MSTEncodedString: string; dynamic; //returns a buffer containing the object encoded with MSTE protocol
    function SingleEncodingCode: TMSTETokenType; dynamic; // defaults returns MSTE_TOKEN_MUST_ENCODE
    procedure EncodeWithMSTEncoder(Encoder: TObject); dynamic;
  end;

  TObjectList = class(Contnrs.TObjectList)
  public
    procedure Assign(AObject: TObject); dynamic;
    function IsCollection: Boolean; dynamic;
    function TokenType: TMSTETokenType; dynamic; //dynamic;
    function ToString: string; dynamic;
    function MSTESnapshot: TMSDictionary; dynamic; //must be overriden by subclasse to be encoded as a dictionary
    function MSTEncodedString: string; dynamic; //returns a buffer containing the object encoded with MSTE protocol
    function SingleEncodingCode: TMSTETokenType; dynamic; // defaults returns MSTE_TOKEN_MUST_ENCODE
    procedure EncodeWithMSTEncoder(Encoder: TObject); dynamic;

  end;

  TMSNull = class(TObject)
  private
    function GetValue: TObject;
  public
//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    function ToString: string; override;

    property Value: TObject read GetValue;
  end;

  TMSBool = class(TObject)
  private
    FValue: Boolean;
  public
    constructor Create(AValue: Boolean);

//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    function ToString: string; override;

    property Value: Boolean read FValue write FValue;
  end;

  TMSString = class(TObject)
  private
    FValue: string;
  public
    constructor Create(AString: string = '');

//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property Value: string read FValue write FValue;
  end;

  TMSDate = class(TObject)
  private
    FValue: TDateTime;
  public
    constructor Create(AValue: TDateTime = 0);

//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    function SingleEncodingCode: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property Value: TDateTime read FValue write FValue;
  end;

  TMSDictionary = class(TObject)
  private
    FValue: TDictionary;
    function GetCount: Integer;
  public
    constructor Create(OwnObject: Boolean = False);
    destructor Destroy; override;

    function IsCollection: Boolean; override;
    procedure AddValue(Key: string; Value: TObject);
    function GetValue(Key: string): TObject;

    property Count: Integer read GetCount;
    property Value: TDictionary read FValue;

//    procedure Assign(AObject: TObject); override;
    function ToString: string; override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
  end;

//  TMSArray = class(TObject)
//  private
//    FValue: TObjectList;
//    function GetCount: Integer;
//    function GetItem(Index: Integer): TObject;
//  public
//    constructor Create;
//    destructor Destroy; override;
//
//    function Add(AObject: TObject): Integer;
//
//    function ToString: string; override;
//    function TokenType: TMSTETokenType; override;
//    property Value[Index: Integer]: TObject read GetItem; default;
//    property Count: Integer read GetCount;
//
//  end;

  TMSNaturalArray = class(TObject)
  private
    FValue: array of MSULong;
    function GetCount: Integer;
  public
    constructor Create(ALen: Integer);

    procedure SetValue(AIndex: Integer; AValue: MSULong);
    function ValueAtIndex(AIndex: Integer): MSULong;
    property Count: Integer read GetCount;

//    procedure Assign(AObject: TObject); override;
    function ToString: string; override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
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
  public

//    procedure Assign(AObject: TObject); override;
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

  TMSColor = class(TObject)
  private
    FValue: TColor;
    FTransparent: Byte;
    function GetTRGBValue: MSUInt;
    procedure SetTRGBValue(const Value: MSUInt);
  public
//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property ColorValue: TColor read FValue write FValue;
    property TransparentValue: Byte read FTransparent write FTransparent;
    property TRGBValue: MSUInt read GetTRGBValue write SetTRGBValue;
  end;

  TMSCouple = class(TObject)
  private
    FFirstMember: TObject;
    FSecondMember: TObject;
  public
//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    property FirstMember: TObject read FFirstMember write FFirstMember;
    property SecondMember: TObject read FSecondMember write FSecondMember;
  end;

  TMSData = class(TObject)
  private
    FValue: TMemoryStream;
  public
    constructor Create;
    destructor Destroy; override;

//    procedure Assign(AObject: TObject); override;
    function TokenType: TMSTETokenType; override;
    procedure EncodeWithMSTEncoder(Encoder: TObject); override;
    function ToString: string; override;

    procedure SetBase64Data(AData: string);
    procedure SetHexData(AData: string);
    property Value: TMemoryStream read FValue;
  end;

//  TObjectMSTEHelper = class helper for TObject
//    public
//  procedure Assign(AObject: TObject);
//function TokenType: TMSTETokenType; //must be overriden by subclasse to be encoded
//function ToString: string;
//function MSTESnapshot: TMSDictionary; //must be overriden by subclasse to be encoded as a dictionary
//function MSTEncodedString: string; //returns a buffer containing the object encoded with MSTE protocol
//function singleEncodingCode: TMSTETokenType; // defaults returns MSTE_TOKEN_MUST_ENCODE
//procedure EncodeWithMSTEncoder(Encoder: TObject);
//end;

//TObjectListMSTEHelper = class helper for TObjectList
//  public
//  procedure Assign(AObject: TObject);
//function TokenType: TMSTETokenType;
//procedure EncodeWithMSTEncoder(Encoder: TObject);
//function ToString: string;
//end;

var
  __MSNull: TMSNull;
  __MSTrue: TMSBool;
  __MSFalse: TMSBool;
  __MSEmptyString: TMSString;
  __theDistantPast: TMSDate;
  __theDistantFuture: TMSDate;

implementation
uses Dialogs, StrUtils, DateUtils, UMSTEEncoder;

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

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
{ TObjectMSTEHelper }
//------------------------------------------------------------------------------

//procedure TObjectMSTEHelper.Assign(AObject: TObject);
//begin
//  MSRaise(Exception, '%s : Assign procedure undefined', [AObject.ClassName]);
//end;

//------------------------------------------------------------------------------

//function TObjectMSTEHelper.TokenType: TMSTETokenType;
//begin
//  //WARNING
//  //FOR USE WHEN CALLED WITH A TObject CAST ON VCL BASE OBJECT
//  if (Self is TObjectList) then Result := tt_ARRAY
//  else Result := tt_USER_CLASS;
//end;

//------------------------------------------------------------------------------

//function TObjectMSTEHelper.ToString: string;
//begin
//
//  if (Self is TObjectList) then
//    Result := (Self as TObjectList).ToString
//  else
//    Result := Self.ClassName;
//end;

//------------------------------------------------------------------------------

//function TObjectMSTEHelper.MSTESnapshot: TMSDictionary; //must be overriden by subclasse to be encoded as a dictionary
//begin
//  MSRaise(Exception, '%s : MSTESnapshot not implemented', [Self.ClassName]);
//  Result := nil;
//end;

//------------------------------------------------------------------------------
//
//function TObjectMSTEHelper.MSTEncodedString: string; //returns a buffer containing the object encoded with MSTE protocol
//var
//  encoder: TMSTEEncoder;
//  ret: string;
//begin
//  encoder := TMSTEEncoder.Create;
//  ret := encoder.EncodeRootObject(Self);
//  FreeAndNil(encoder);
//  Result := ret;
//end;
//
////------------------------------------------------------------------------------
//
//function TObjectMSTEHelper.singleEncodingCode: TMSTETokenType; // defaults returns MSTE_TOKEN_MUST_ENCODE
//begin
//  Result := tt_MUST_ENCODE;
//end;

//------------------------------------------------------------------------------

//procedure TObjectMSTEHelper.EncodeWithMSTEncoder(Encoder: TObject);
//begin
//  MSRaise(Exception, '%s : EncodeWithMSTEncoder not implemented', [Self.ClassName]);
//end;
//------------------------------------------------------------------------------
{ TObjectListMSTEHelper }
//------------------------------------------------------------------------------

//procedure TObjectListMSTEHelper.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
////TODO ...
//end;
//
////------------------------------------------------------------------------------
//
//function TObjectListMSTEHelper.TokenType: TMSTETokenType;
//begin
//  Result := tt_ARRAY;
//end;
//
////------------------------------------------------------------------------------
//
//procedure TObjectListMSTEHelper.EncodeWithMSTEncoder(Encoder: TObject);
//begin
//  TMSTEEncoder(Encoder).EncodeArray(Self);
//end;

//------------------------------------------------------------------------------

//function TObjectListMSTEHelper.ToString: string;
//var
//  i: Integer;
//  xObj: TObject;
//  s, sobj: string;
//begin
//
//  s := #13#10'['#13#10;
//  for I := 0 to Count - 1 do begin
//    xObj := Items[i];
//    sObj := xObj.ToString;
//    s := s + sObj + #13#10;
//  end;
//  s := s + ']';
//
//  result := s;
//end;

//------------------------------------------------------------------------------
{ TMSNull }
//------------------------------------------------------------------------------

//procedure TMSNull.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//end;
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

//procedure TMSBool.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//  FValue := TMSBool(AObject).Value;
//end;
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

//------------------------------------------------------------------------------
{ TMSDictionary }

procedure TMSDictionary.AddValue(Key: string; Value: TObject);
begin
  FValue.AddValue(Key, Value);
end;

//------------------------------------------------------------------------------

constructor TMSDictionary.Create(OwnObject: Boolean = False);
begin
  inherited Create;
  FValue := TDictionary.Create(OwnObject);
end;
//------------------------------------------------------------------------------

destructor TMSDictionary.Destroy;
begin
  FreeAndNil(FValue);
  inherited;
end;

//------------------------------------------------------------------------------

function TMSDictionary.GetCount: Integer;
begin
  Result := FValue.Count;
end;
//------------------------------------------------------------------------------

function TMSDictionary.GetValue(Key: string): TObject;
begin
  Result := TObject(FValue.GetValue(Key));
end;
//------------------------------------------------------------------------------

function TMSDictionary.IsCollection: Boolean;
begin
  Result := True;
end;

//------------------------------------------------------------------------------

//procedure TMSDictionary.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//  //Todo ....
////  FValue := TMSDate(AObject).Value;
//end;
//------------------------------------------------------------------------------

function TMSDictionary.ToString: string;
var
  sl: TStringList;
  i: integer;
  s, sKey, sObj: string;
  xObj: TObject;
begin

  sl := FValue.GetElementsKeys;

  s := #13#10'{'#13#10;

  for I := 0 to sl.Count - 1 do begin
    sKey := sl[i];
    xObj := GetValue(sKey);
    if xObj.IsCollection then begin
//    if (not RecursiveToString) and ((xObj is TMSDictionary)) then begin
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

function TMSDictionary.TokenType: TMSTETokenType;
begin
  Result := tt_DICTIONARY;
end;

//------------------------------------------------------------------------------

procedure TMSDictionary.EncodeWithMSTEncoder(Encoder: TObject);
begin
  TMSTEEncoder(Encoder).EncodeDictionary(Self);
end;

//------------------------------------------------------------------------------
{ TMSString }
//------------------------------------------------------------------------------

//procedure TMSString.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//  FValue := TMSString(AObject).Value;
//end;
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
//------------------------------------------------------------------------------
{ TMSDate }

//procedure TMSDate.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//  FValue := TMSDate(AObject).Value;
//end;
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
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

{ TMSColor }

//procedure TMSColor.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//  FValue := TMSColor(AObject).ColorValue;
//  FTransparent := TMSColor(AObject).TransparentValue;
//end;
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

//procedure TMSCouple.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//  FFirstMember := TMSCouple(AObject).FirstMember;
//  FSecondMember := TMSCouple(AObject).SecondMember;
//end;
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

//procedure TMSData.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
////TODO ...
//end;
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

//procedure TMSNumber.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
//
//  CopyMemory(@FValue, @TMSNumber(AObject).FValue, SizeOf(TMSNumberInstance));
//
//end;
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

//procedure TMSNaturalArray.Assign(AObject: TObject);
//begin
//  if not (AObject.ClassType <> ClassType) then MSRaise(Exception, '%s : wrong source class  for assignment, expected %s', [AObject.ClassName, ClassName]);
////todo
//end;
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

function TMSNaturalArray.ToString: string;
begin
//TODO
  Result := 'TMSNaturalArray.ToString : A IMPEMENTER';
end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
{ TObject }
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//procedure TObject.Assign(AObject: TObject);
//begin
//
//end;

procedure TObject.Assign(AObject: TObject);
begin

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

function TObject.MSTESnapshot: TMSDictionary;
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

end;

//------------------------------------------------------------------------------

//function TMSArray.ToString: string;
//var
//  i: Integer;
//  xObj: TObject;
//  s, sobj: string;
//begin
//
//  s := #13#10'['#13#10;
//  for I := 0 to FValue.Count - 1 do begin
//    xObj := Value[i];
//    sObj := xObj.ToString;
//    s := s + sObj + #13#10;
//  end;
//  s := s + ']';
//
//  result := s;
//end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
{ TObjectList }

procedure TObjectList.Assign(AObject: TObject);
begin

end;

procedure TObjectList.EncodeWithMSTEncoder(Encoder: TObject);
begin

end;
//------------------------------------------------------------------------------

function TObjectList.IsCollection: Boolean;
begin
  Result := True;
end;
//------------------------------------------------------------------------------

function TObjectList.MSTEncodedString: string;
begin

end;
//------------------------------------------------------------------------------

function TObjectList.MSTESnapshot: TMSDictionary;
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

  s := #13#10'['#13#10;
  for I := 0 to Count - 1 do begin
    xObj := TObject(Items[i]);
    sObj := xObj.ToString;
    s := s + sObj + #13#10;
  end;
  s := s + ']';

  result := s;
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

