unit UMSTEEncoder;

interface

uses
  Windows, Messages, SysUtils, Classes, Contnrs, UMSFoundation, UMSTEClasses;

const
  MSTEncoderLastVersion = 100;

type

  TMSTEEncoder = class(TObject)
  private
    FClasses: TStringList;
    FKeys: TStringList;
    FEncodedObjects: TObjectList;
    FSnapshots: TObjectList;
    FBuffer: TStringStream;

    FTokenCount: Integer;

    procedure _encodeTokenSeparator;
    procedure _encodeTokenType(tokenType: TMSTETokenType); overload;
    procedure _encodeTokenType(tokenType: Byte); overload;
    procedure _encodeUnsignedLongLong(AStream: TStringStream; l: MSULong);
    procedure _EncodeString(AStream: TStringStream; s: string);
  public
    constructor Create;
    destructor Destroy; override;
    function EncodeRootObject(AObject: TObject): string;

    procedure EncodeObject(AObject: TObject); overload;
    procedure EncodeObject(AObject: TObject; WeakRef: Boolean); overload;

    procedure EncodeBool(b: Boolean; withTokenType: Boolean);
    procedure EncodeString(s: string; withTokenType: Boolean);
    procedure EncodeUnsignedChar(c: MSByte; withTokenType: boolean);
    procedure EncodeChar(c: MSChar; withTokenType: boolean);
    procedure EncodeUnsignedShort(s: MSUShort; withTokenType: boolean);
    procedure EncodeShort(s: MSShort; withTokenType: boolean);
    procedure EncodeUnsignedInt(i: MSUInt; withTokenType: Boolean);
    procedure EncodeInt(i: MSInt; withTokenType: boolean);
    procedure EncodeUnsignedLongLong(l: MSULong; withTokenType: boolean);
    procedure EncodeLongLong(l: MSLong; withTokenType: boolean);
    procedure EncodeFloat(f: Float; withTokenType: boolean);
    procedure EncodeDouble(d: Double; withTokenType: boolean);

    procedure EncodeArray(AnArray: TObjectList);
    procedure EncodeDictionary(ADictionary: TMSDictionary; isSnapshot: Boolean = False);

    procedure EncodeStream64(AStream: TStream; withTokenType: boolean);

  end;

implementation
uses Dialogs, EncdDecd;

{ TMSTEEncoder }
//------------------------------------------------------------------------------

constructor TMSTEEncoder.Create;
begin
  FEncodedObjects := TObjectList.Create(False);
  FSnapshots := TObjectList.Create(True);
  FClasses := TStringList.Create;
  FKeys := TStringList.Create;

  FBuffer := TStringStream.Create('');

  FTokenCount := 0;
end;
//------------------------------------------------------------------------------

destructor TMSTEEncoder.Destroy;
begin
  FSnapshots.Free;
  FEncodedObjects.Free;

  FClasses.Free;
  FKeys.Free;
  FBuffer.Free;

  inherited;
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder._encodeTokenSeparator;
begin
  Inc(FTokenCount);
  FBuffer.WriteString(',');
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder._encodeTokenType(tokenType: TMSTETokenType);
begin
  FBuffer.WriteString(IntToStr(Ord(tokenType)));
end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder._encodeTokenType(tokenType: Byte);
begin
  FBuffer.WriteString(IntToStr(tokenType));
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder._EncodeUnsignedLongLong(AStream: TStringStream; l: MSULong);
begin
  AStream.WriteString(Format('%u', [l]));
end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeObject(AObject: TObject);
begin
  EncodeObject(AObject, False);
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeObject(AObject: TObject; WeakRef: Boolean);
var
  singleToken, tokenType: TMSTETokenType;
  objectReference, classIndex: Integer;
  snapshot: TMSDictionary;

begin

  singleToken := AObject.SingleEncodingCode;

  if singleToken <> tt_MUST_ENCODE then begin
    _encodeTokenSeparator;
    _encodeTokenType(singleToken);
  end else begin
    objectReference := FEncodedObjects.IndexOf(AObject);
    if (objectReference <> -1) then begin
     //this is an already encoded object
      _encodeTokenSeparator;
      if WeakRef then _encodeTokenType(tt_WEAK_REFERENCED_OBJECT) else _encodeTokenType(tt_STRONG_REFERENCED_OBJECT);
      EncodeUnsignedInt(objectReference, False); //  : (objectReference - 1)withTokenType: NO];
    end else begin
      tokenType := aObject.TokenType;
      if tokenType = tt_USER_CLASS then begin

        snapshot := aObject.MSTESnapshot(Self);

        if (not Assigned(snapshot)) then MSRaise(Exception, 'encodeObject: Specific user classes must implement MSTESnapshot to be encoded as a dictionary!');

        classIndex := FClasses.IndexOf(AObject.ClassName);
        if classIndex = -1 then classIndex := FClasses.Add(AObject.ClassName);

        FEncodedObjects.Add(AObject);

        _encodeTokenSeparator;

        if WeakRef then
          _encodeTokenType(MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_USER_OBJECT + (2 * classIndex) - 1)
        else
          _encodeTokenType(MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_USER_OBJECT + 2 * classIndex);

        EncodeDictionary(snapshot, True);

        FreeAndNil(snapshot);

      end else if tokenType < tt_USER_CLASS then begin

        FEncodedObjects.Add(AObject);

        _encodeTokenSeparator;
        _encodeTokenType(AObject.TokenType);
        aObject.encodeWithMSTEncoder(self);

      end else
        MSRaise(Exception, 'encodeObject: cannot encode an object with token type %u!', [ord(tokenType)]);

    end;
  end;

end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeBool(b: Boolean; withTokenType: Boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    if (b) then _encodeTokenType(tt_TRUE) else _encodeTokenType(tt_FALSE);
  end;
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeStream64(AStream: TStream; withTokenType: boolean);
begin
//Atester

  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_BASE64_DATA);
  end;
  _encodeTokenSeparator;

  FBuffer.WriteString('"');
  EncodeStream(AStream, FBuffer);

  FBuffer.WriteString('"');

end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeChar(c: MSChar; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_CHAR);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%d', [c]));
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeUnsignedChar(c: MSByte; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_UNSIGNED_CHAR);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%u', [c]));
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeShort(s: MSShort; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_SHORT);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%d', [s]));

end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeUnsignedShort(s: MSUShort; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_UNSIGNED_SHORT);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%u', [s]));

end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeInt(i: MSInt; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_INT32);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%d', [i]));
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeUnsignedInt(i: MSUInt; withTokenType: Boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_UNSIGNED_INT32);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%u', [i]));
end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeLongLong(l: MSLong; withTokenType: boolean);
begin

  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_INT64);
  end;
  _encodeTokenSeparator;

  FBuffer.WriteString(Format('%d', [l]));
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeUnsignedLongLong(l: MSULong; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_UNSIGNED_INT64);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%u', [l]));
end;

//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeDouble(d: Double; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_DOUBLE);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%.15f', [d]));

end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeFloat(f: Float; withTokenType: boolean);
begin
  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_FLOAT);
  end;
  _encodeTokenSeparator;
  FBuffer.WriteString(Format('%f', [f]));
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder._EncodeString(AStream: TStringStream; s: string);
var
  i: Integer;
  c: char;
  b: array[0..3] of MSByte;
begin
  AStream.WriteString('"');

  for i := 1 to Length(s) do begin
    c := s[i];
    case c of
      #8: AStream.WriteString('\b');
      #9: AStream.WriteString('\t');
      #10: AStream.WriteString('\n');
      #12: AStream.WriteString('\f');
      #13: AStream.WriteString('\r');
      #34: AStream.WriteString('\"');
      #47: AStream.WriteString('\/');
      #92: AStream.WriteString('\\');

    else
      if ((c < #32) or (c > #127)) then begin
        b[0] := (ord(c) and $0F000) shr 12;
        b[1] := (ord(c) and $0F00) shr 8;
        b[2] := (ord(c) and $00F0) shr 4;
        b[3] := (ord(c) and $000F);

        FBuffer.WriteString('\u');
        FBuffer.WriteString(IntToHex(b[0], 1));
        FBuffer.WriteString(IntToHex(b[1], 1));
        FBuffer.WriteString(IntToHex(b[2], 1));
        FBuffer.WriteString(IntToHex(b[3], 1));
      end else
        AStream.WriteString(c);
    end;
  end;

  AStream.WriteString('"');
end;
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeString(s: string; withTokenType: Boolean);
begin

  if s = '' then MSRaise(Exception, 'encodeString:withTokenType: no string to encode!');

  if withTokenType then begin
    _encodeTokenSeparator;
    _encodeTokenType(tt_STRING);
  end;

  _encodeTokenSeparator;
  _EncodeString(FBuffer, s);
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TMSTEEncoder.EncodeArray(AnArray: TObjectList);
var
  i: Integer;
begin
  encodeUnsignedLongLong(anArray.count, False);
  for i := 0 to anArray.Count - 1 do
    EncodeObject(TObject(AnArray[i]));

end;
//------------------------------------------------------------------------------
//weakref ...

procedure TMSTEEncoder.EncodeDictionary(ADictionary: TMSDictionary; isSnapshot: Boolean);
var
  xKeys: TStringList;
  xTmpKeys: TStringList;
  i, keyReference: Integer;
  xObj: TObject;
  xCpl: TMSCouple;
  xList: TObjectList;
  sKey: string;
  isWeak: Boolean;
begin

  xList := TObjectList.Create(False);
  xKeys := TStringList.Create;

  xTmpKeys := ADictionary.Value.GetElementsKeys;

  if isSnapshot then begin
    for i := 0 to xTmpKeys.Count - 1 do begin
      sKey := xTmpKeys[i];
      xCpl := ADictionary.GetValue(sKey) as TMSCouple;
      if xCpl.SingleEncodingCode <> tt_NULL then begin
        xKeys.Add(sKey);
        xList.Add(xCpl);
      end;
    end;

  end else begin
    for i := 0 to xTmpKeys.Count - 1 do begin
      sKey := xTmpKeys[i];
      xObj := ADictionary.GetValue(sKey);
      if xObj.SingleEncodingCode <> tt_NULL then begin
        xKeys.Add(sKey);
        xList.Add(xObj);
      end;
    end;

  end;

  xTmpKeys.Free;

  EncodeUnsignedLongLong(xKeys.Count, False);

  for i := 0 to xKeys.Count - 1 do begin
    sKey := xKeys[i];
    keyReference := FKeys.IndexOf(sKey);
    if keyReference = -1 then keyReference := FKeys.Add(sKey);
    EncodeUnsignedLongLong(keyReference, False);

    if isSnapshot then begin
      xCpl := xList[i] as TMSCouple;
      isWeak := Assigned(xCpl.SecondMember);
      encodeObject(xCpl.FirstMember, isWeak);
    end else
      EncodeObject(TObject(xList[i]));
  end;

  xKeys.Free;
  xList.Free;
end;

//------------------------------------------------------------------------------

function TMSTEEncoder.EncodeRootObject(AObject: TObject): string;
var
  xBuf: TStringStream;
  i: Integer;
begin
  FEncodedObjects.Clear;
  FClasses.Clear;
  FKeys.Clear;

  EncodeObject(AObject);

  xBuf := TStringStream.Create('');

  //Header
  xBuf.WriteString('["MSTE0101",');
  _encodeUnsignedLongLong(xBuf, 5 + FTokenCount + FKeys.Count + FClasses.Count);
  xBuf.WriteString(',"CRC00000000",');

  //Classes list
  _encodeUnsignedLongLong(xBuf, FClasses.Count);
  for i := 0 to FClasses.Count - 1 do begin
    xBuf.WriteString(',');
    _EncodeString(xBuf, FClasses[i]);
  end;

    //Keys list
  xBuf.WriteString(',');
  _encodeUnsignedLongLong(xBuf, FKeys.Count);
  for i := 0 to FKeys.Count - 1 do begin
    xBuf.WriteString(',');
    _EncodeString(xBuf, FKeys[i]);
  end;

  xBuf.WriteString(FBuffer.DataString);
  xBuf.WriteString(']');

  FBuffer.Size := 0;
  Result := xBuf.DataString;

  xBuf.Free;

end;

end.

