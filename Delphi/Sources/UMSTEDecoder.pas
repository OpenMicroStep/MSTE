{$M+}
unit UMSTEDecoder;

interface
uses
  Windows, Messages, SysUtils, Classes, Contnrs, UMSFoundation, UMSTEClasses;

type

  TMSTError = (
    mrInvalidStartChar,
    mrInvalidTokenCount,
    mrInvalidCRC,
    mrUnknownError,
    mrNone);

const

  Errors: array[TMSTError] of string = (
    'mrInvalidStartChar',
    'mrInvalidTokenCount',
    'mrInvalidCRC',
    'mrError',
    'mrOk');

  Separator: set of char = ['[', ']', ','];

type

  TParseState = (psStart, psVersion, psTokensCount, psCRC, psClasses, psKeys,
    psRootObject);

  TMSTEDecodingState = (
    ds_ARRAY_START = 0,
    ds_VERSION_START = 1,
    ds_VERSION_HEADER = 2,
    ds_VERSION_VALUE = 3,
    ds_VERSION_END = 4,
    ds_VERSION_NEXT_TOKEN = 5,
    ds_TOKEN_NUMBER_VALUE = 6,
    ds_TOKEN_NUMBER_NEXT_TOKEN = 7,
    ds_CRC_START = 8,
    ds_CRC_HEADER = 9,
    ds_CRC_VALUE = 10,
    ds_CRC_END = 11,
    ds_CRC_NEXT_TOKEN = 12,
    ds_CLASSES_NUMBER_VALUE = 13,
    ds_CLASSES_NUMBER_NEXT_TOKEN = 14,
    ds_CLASS_NAME = 15,
    ds_CLASS_NEXT_TOKEN = 16,
    ds_KEYS_NUMBER_VALUE = 17,
    ds_KEYS_NUMBER_NEXT_TOKEN = 18,
    ds_KEY_NAME = 19,
    ds_KEY_NEXT_TOKEN = 20,
    ds_ROOT_OBJECT = 21,
    ds_ARRAY_END = 22,
    ds_GLOBAL_END = 23
    );

  TMSTEStringDecodingState = (
    sds_START = 0,
    sds_STRING = 1,
    sds_STRING_ESCAPED_CAR = 2,
    sds_STRING_STOP = 3);

  TMSTEDecoder = class(TObject)

  private
    FClasses: TStringList;
    FKeys: TStringList;

    FObjects: TMSTEObjectList;

    FVersion: string;
    FTokensCount, FClassesCount, FKeysCount: Integer;
    FCRC: DWORD;

    FRootObject: TMSTEObject;

    procedure _AddObject(AObject: TMSTEObject);

    function _CalculateCrc(AStream: TMemoryStream): Cardinal;

    procedure JumpToNextToken(ptr: PPChar; endPointer: PChar; var tokenCount: integer);

    function DecodeObject(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSTEObject;
    function DecodeString(ptr: PPChar; endPointer: PChar; operation: string): WideString;

    function DecodeArray(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSArray;
    function DecodeNaturalArray(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSNaturalArray;

    function DecodeDictionary(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSDictionary;
    function DecodeDate(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSDate;
    function DecodeColor(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSColor;
    function DecodeCouple(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSCouple;
    function DecodeBufferBase64String(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSData;

    function _DecodeUnsignedChar(ptr: PPChar; endPointer: PChar; operation: string): MSByte;
    function _DecodeChar(ptr: PPChar; endPointer: PChar; operation: string): MSChar;
    function _DecodeUnsignedShort(ptr: PPChar; endPointer: PChar; operation: string): MSUShort;
    function _DecodeShort(ptr: PPChar; endPointer: PChar; operation: string): MSShort;
    function _DecodeUnsignedInt(ptr: PPChar; endPointer: PChar; operation: string): MSUInt;
    function _DecodeInt(ptr: PPChar; endPointer: PChar; operation: string): MSInt;
    function _DecodeUnsignedLong(ptr: PPChar; endPointer: PChar; operation: string): MSULong;
    function _DecodeLong(ptr: PPChar; endPointer: PChar; operation: string): MSLong;
    function _DecodeFloat(ptr: PPChar; endPointer: PChar; operation: string): Single;
    function _DecodeDouble(ptr: PPChar; endPointer: PChar; operation: string): Double;

//    function DecodeUnsignedLong(ptr: PPChar; endPointer: PChar; operation: string): UInt64;
//    function DecodeLong(ptr: PPChar; endPointer: PChar; operation: string): Int64;
//    function DecodeUnsignedShort(ptr: PPChar; endPointer: PChar; operation: string): Byte;
//    function DecodeUnsignedInt(ptr: PPChar; endPointer: PChar; operation: string): UINT;

    function DecodeNumber(ptr: PPChar; endPointer: PChar; operation: string; tokenType: TMSTETokenType): TMSNumber;
    function _FindNumber(ptr: PPChar; endPointer: PChar; operation1, operation2: string): string;
    function _FindDoubleNumber(ptr: PPChar; endPointer: PChar; operation1, operation2: string): string;

  public

    constructor Create;
    destructor Destroy; override;
    procedure Debug;
    function Decode(AStream: TMemoryStream; VerifyCRC: Boolean): TMSTEObject;
    property Root: TMSTEObject read FRootObject;

    property Version: string read FVersion;
    property TokensCount: Integer read FTokensCount;
    property Crc: DWORD read FCRC;
    property Classes: TStringList read FClasses;
    property Keys: TStringList read FKeys;

  end;

  TExecFn = function: TMSTEObject of object;

const
  sLOGFILE = 'MSTE.Log';
var
  sDBG: string;

implementation
uses StrUtils, DateUtils, Controls, dialogs, CRC32;

function aWriteLog(LogString: string): Integer;
var
  f: TextFile;
begin
{$IOCHECKS OFF}
  AssignFile(f, sLOGFILE);
  if FileExists(sLOGFILE) then
    Append(f)
  else
    Rewrite(f);
  Writeln(f, DateTimeToStr(now) + LogString);
  CloseFile(f);
  result := GetLastError();
{$IOCHECKS ON}
end;

procedure LogDico(ADico: TMSDictionary);
begin
  aWriteLog(format('-- %p -- %d', [addr(ADico), ADico.Value.Count]));
  aWriteLog(ADico.ToString);
end;

{ TMSTEDecoder }
//------------------------------------------------------------------------------

constructor TMSTEDecoder.Create;
begin
  inherited;
//  FObjects := TObjectList.Create;
  FObjects := TMSTEObjectList.Create;

  FClasses := TStringList.Create;
  FKeys := TStringList.Create;
end;
//------------------------------------------------------------------------------

destructor TMSTEDecoder.Destroy;
begin
  FObjects.Free;
  FClasses.Free;
  FKeys.Free;
  inherited;
end;

//------------------------------------------------------------------------------

function TMSTEDecoder._FindDoubleNumber(ptr: PPChar; endPointer: PChar; operation1, operation2: string): string;
var
  s: PChar;
  xLen: Integer;
begin
  s := Ptr^;
  xLen := 0;
  while s[xLen] in ['.', '-', '+', '0'..'9'] do Inc(xLen);

  if (xLen > (endPointer - s)) then MSRaise(Exception, '%s - %s (exceed buffer end)', [operation1, operation2]);
  if (xLen > 0) then Inc(ptr^, xLen)
  else MSRaise(Exception, '%s - %s(no termination)', [operation1, operation2]);

  Result := Copy(s, 1, xLen);

end;
//------------------------------------------------------------------------------

function TMSTEDecoder._FindNumber(ptr: PPChar; endPointer: PChar; operation1, operation2: string): string;
var
  s: PChar;
  xLen: Integer;
begin
  s := Ptr^;
  xLen := 0;
  while s[xLen] in ['-', '+', '0'..'9'] do Inc(xLen);

  if (xLen > (endPointer - s)) then MSRaise(Exception, '%s - %s (exceed buffer end)', [operation1, operation2]);
  if (xLen > 0) then Inc(ptr^, xLen)
  else MSRaise(Exception, '%s - %s(no termination)', [operation1, operation2]);

  Result := Copy(s, 1, xLen);

end;

//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeDate(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSDate;
var
  s: PChar;
  seconds: Int64;
  xDate: TDateTime;
begin
  s := Ptr^;
  seconds := _DecodeLong(@s, endPointer, 'DecodeObject');
  xDate := UnixToDateTime(seconds);
  Result := TMSDate.Create(xDate);
//  TMSDate(Result).Value := xDate;
  ptr^ := s;
end;
//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeDictionary(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSDictionary;

var
  s: PChar;
  i, count: Integer;
  xDic: TMSDictionary;

  xObj: TMSTEObject;

  xKeyRef: Integer;
  sKey: string;

begin
  s := Ptr^;
  xDic := nil;

  count := _DecodeUnsignedLong(@s, endPointer, operation);

  if count > 0 then begin
    xDic := TMSDictionary.Create;//(True);
    _AddObject(xDic);

    for i := 0 to count - 1 do begin
      JumpToNextToken(@s, endPointer, tokenCount);

      xKeyRef := _DecodeUnsignedInt(@s, endPointer, operation);

      if xKeyRef >= FKeys.Count then MSRaise(Exception, 'DecodeArray - invalid key reference!');
      sKey := FKeys[xKeyRef];

      JumpToNextToken(@s, endPointer, tokenCount);
      xObj := DecodeObject(@s, endPointer, operation, tokenCount);

      if not Assigned(xObj) then begin
        xObj := TMSNull.Create;
        _AddObject(xObj);
      end;

      xDic.AddValue(sKey, xObj);

    end;
  end;

  Result := xDic;
  ptr^ := s;

end;

//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeArray(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSArray;
var
  s: PChar;
  i, count: Integer;
  xArray: TMSArray;
  xObj: TMSTEObject;
begin
  s := Ptr^;
  xArray := nil;

  count := _DecodeUnsignedLong(@s, endPointer, operation);

  if count > 0 then begin
    xArray := TMSArray.Create;
    _AddObject(xArray);
    for i := 0 to count - 1 do begin
      JumpToNextToken(@s, endPointer, tokenCount);
      xObj := DecodeObject(@s, endPointer, operation, tokenCount);
      if not Assigned(xObj) then begin
        xObj := TMSNull.Create;
        _AddObject(xObj);
      end;
      xArray.Add(xObj);
    end;
  end;

  Result := xArray;
  ptr^ := s;

end;
//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeBufferBase64String(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSData;
var
  s: PChar;
  xData: TMSData;
  ws: WideString;
begin
  s := Ptr^;

  //A tester .....
  xData := TMSData.Create;
  ws := DecodeString(@s, endPointer, operation);
  xData.SetBase64Data(ws);
  Result := xData;

  ptr^ := s;
end;

//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeColor(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSColor;
var
  s: PChar;
  xColor: TMSColor;
  trgbValue: MSUInt;
begin
  s := Ptr^;
  trgbValue := _DecodeUnsignedInt(@s, endPointer, operation);

  xColor := TMSColor.Create;
  xColor.TRGBValue := trgbValue;
  Result := xColor;

  ptr^ := s;
end;
//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeCouple(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSCouple;
var
  s: PChar;
  xCouple: TMSCouple;

begin
  s := Ptr^;
  xCouple := TMSCouple.Create;
  _AddObject(xCouple);
  xCouple.FirstMember := DecodeObject(@s, endPointer, operation, tokenCount);
  JumpToNextToken(@s, endPointer, tokenCount);
  xCouple.SecondMember := DecodeObject(@s, endPointer, operation, tokenCount);
  Result := xCouple;
  ptr^ := s;
end;

//------------------------------------------------------------------------------

procedure TMSTEDecoder._AddObject(AObject: TMSTEObject);
begin
  FObjects.Add(AObject);
end;
//------------------------------------------------------------------------------

procedure TMSTEDecoder.Debug;
var
  s: string;
begin

  s := '';

  showmessage(
    FRootObject.ToString
    );

end;

//------------------------------------------------------------------------------

procedure TMSTEDecoder.JumpToNextToken(ptr: PPChar; endPointer: PChar; var tokenCount: integer);
var
  s: PChar;
  separatorFound, nextFound: Boolean;
begin
  s := Ptr^;

  separatorFound := False;
  nextFound := False;

  while (not separatorFound and ((endPointer - s) > 0)) do begin
    if s^ = ' ' then Inc(s)
    else if s^ = ',' then begin Inc(s); separatorFound := True; Inc(tokenCount); end
    else MSRaise(Exception, 'Decode - Bad format (unexpected character before token separator: %s)', [s^]);
  end;
  if (not separatorFound) then MSRaise(Exception, 'Decode - Bad format(no token separator)');

  while (not nextFound) and ((endPointer - s) > 0) do begin
    if s^ = ' ' then Inc(s);
    nextFound := s^ <> ' ';
  end;
  if (not separatorFound) then MSRaise(Exception, 'MSTDecodeRetainedObject - Bad format(no next token)');

  ptr^ := s;

end;

//-----------------------------------------------------------------------------------

function TMSTEDecoder.DecodeString(ptr: PPChar; endPointer: PChar; operation: string): WideString;
var
  state: TMSTEStringDecodingState;
  endStringFound: Boolean;
  s: PChar;
  character: Char;
  res: WideString;

  hex: string;

begin
  res := '';
  endStringFound := False;
  state := sds_START;
  s := Ptr^;

  while ((s < endPointer) and (not endStringFound)) do begin
    character := s^;

    case state of
      sds_START: begin
          if CompareCharAsWide(character, '"') then begin Inc(s); Inc(state); Continue; end;
          MSRaise(Exception, 'MSTDecodeString - %s(wrong starting character: %c)', [operation, character]);
        end;
      sds_STRING: begin
          if CompareCharAsWide(character, '\') then begin inc(s); state := sds_STRING_ESCAPED_CAR; continue; end;
          if CompareCharAsWide(character, '"') then begin inc(s); state := sds_STRING_STOP; endStringFound := True; continue; end;

          res := res + WideChar(character);
          inc(s); //pass to next character

        end;
      sds_STRING_ESCAPED_CAR: begin
          if CompareCharAsWide(character, 'r') then begin res := res + #$000D; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, 'n') then begin res := res + #$000A; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, 't') then begin res := res + #$0009; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, '\') then begin res := res + #$005C; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, '/') then begin res := res + #$002F; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, 'b') then begin res := res + #$0008; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, 'f') then begin res := res + #$0012; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, '"') then begin res := res + #$0022; inc(s); state := sds_STRING; end
          else if CompareCharAsWide(character, 'u') then begin

            if ((endPointer - s) < 5) then MSRaise(Exception, 'DecodeString - %@ (too short UTF16 character expected)', [operation]);

            if (not CharIsHexa(s[1])) or (not CharIsHexa(s[2])) or
              (not CharIsHexa(s[3])) or (not CharIsHexa(s[4])) then
              MSRaise(Exception, 'DecodeString - %@ (bad hexadecimal character for UTF16)', [operation]); ;

            hex := '';
            inc(s); //pass the u char
            Hex := Copy(s, 1, 4);
            res := res + WideChar(StrToInt('$' + Hex));
            inc(s, 4); //pass the 4 hex digit
            state := sds_STRING;

          end
          else
            MSRaise(Exception, 'MSTDecodeString - %s (unexpected escaped character : %s)', [operation, character]);

        end;
      sds_STRING_STOP: ;
    else
      MSRaise(Exception, 'DecodeString - %s (unknown state)', [operation]);
    end;

  end;

  ptr^ := s;
  Result := res;

end;

//-----------------------------------------------------------------------------------

function TMSTEDecoder.Decode(AStream: TMemoryStream; VerifyCRC: Boolean): TMSTEObject;
var
  ps: PChar;
  pend: PChar;
  state: TMSTEDecodingState;
  className, key: string;
  crc: string;
  crcPtr: PChar;
  crcCalc: Cardinal;
  tokenCount: integer;
begin
  FRootObject := nil;
  FClassesCount := 0;
  FKeysCount := 0;
  FTokensCount := 0;
  FCRC := 0;

  tokenCount := 0;
  crcPtr := nil;
  crc := '';

  if AStream.Size > 26 then begin //minimum header size : ["MSTE0101",3,"CRC00000000" ...]
    ps := AStream.Memory;
    pend := ps + AStream.Size;
    state := ds_ARRAY_START;

    while ((ps < (pend + 1))) do begin
      case state of
        ds_ARRAY_START: begin
            if ps^ = ' ' then begin Inc(ps); continue; end;
            if ps^ = '[' then begin Inc(ps); Inc(State); continue; end;
            MSRaise(Exception, 'Decode - Bad header format(array start)');
          end;
        ds_VERSION_START:
          begin
            if ps^ = ' ' then begin Inc(ps); continue; end;
            if ps^ = '"' then begin Inc(ps); Inc(State); continue; end;
            MSRaise(Exception, 'Decode - Bad header format(start)');
          end;
        ds_VERSION_HEADER: begin
            FVersion := Copy(ps, 1, 4);
            if (((pend - ps) < 4) or (ps[0] <> 'M') or (ps[1] <> 'S') or (ps[2] <> 'T') or (ps[3] <> 'E')) then begin
              MSRaise(Exception, 'Decode - Bad header format (MSTE marker)');
            end;
            Inc(ps, 4);
            Inc(state);
          end;
        ds_VERSION_VALUE: begin
            FVersion := FVersion + Copy(ps, 1, 4);
            if (((pend - ps) < 4) or (not CharIsDigit(ps[0])) or (not CharIsDigit(ps[1])) or
              (not CharIsDigit(ps[2])) or (not CharIsDigit(ps[3]))) then begin
              MSRaise(Exception, 'Decode - Bad header version');
            end;
            Inc(ps, 4);
            Inc(state);
          end;
        ds_VERSION_END: begin
            if ps^ <> '"' then MSRaise(Exception, 'MSTDecodeRetainedObject - Bad header format (version end)');
            Inc(ps);
            Inc(State);
          end;

        ds_VERSION_NEXT_TOKEN,
          ds_TOKEN_NUMBER_NEXT_TOKEN,
          ds_CRC_NEXT_TOKEN,
          ds_CLASSES_NUMBER_NEXT_TOKEN,
          ds_CLASS_NEXT_TOKEN,
          ds_KEYS_NUMBER_NEXT_TOKEN,
          ds_KEY_NEXT_TOKEN: begin
            JumpToNextToken(@ps, pend, tokenCount);
            case state of

              ds_VERSION_NEXT_TOKEN,
                ds_TOKEN_NUMBER_NEXT_TOKEN,
                ds_CRC_NEXT_TOKEN: begin
                  Inc(state);
                end;

              ds_CLASSES_NUMBER_NEXT_TOKEN: begin
                  if (FClassesCount <> 0) then state := ds_CLASS_NAME else state := ds_KEYS_NUMBER_VALUE;
                end;

              ds_CLASS_NEXT_TOKEN: begin
                  if (FClassesCount > FClasses.Count) then state := ds_CLASS_NAME else state := ds_KEYS_NUMBER_VALUE;
                end;

              ds_KEYS_NUMBER_NEXT_TOKEN: begin
                  if (FKeysCount <> 0) then state := ds_KEY_NAME else state := ds_ROOT_OBJECT;
                end;

              ds_KEY_NEXT_TOKEN: begin
                  if (FKeysCount > FKeys.Count) then state := ds_KEY_NAME else state := ds_ROOT_OBJECT;
                end;
            else
              MSRaise(Exception, 'Decode - state unchanged!!!!');
            end

          end;

        ds_TOKEN_NUMBER_VALUE: begin
            FTokensCount := _DecodeUnsignedLong(@ps, pend, 'token number');
//            ShowMessage(Format('%u', [tokenNumber]));
            Inc(state);
          end;

        ds_CRC_START: begin
            if (ps^ = '"') then begin inc(ps); Inc(state); continue; end;
            MSRaise(Exception, 'Decode - Bad header format(CRC start)');
          end;

        ds_CRC_HEADER: begin
            if (((pend - ps) < 3) or (ps[0] <> 'C') or (ps[1] <> 'R') or (ps[2] <> 'C')) then //CRC
              MSRaise(Exception, 'Decode - Bad header format (CRC marker)');
            Inc(ps, 3);
            Inc(state);
          end;

        ds_CRC_VALUE: begin
            if ((pend - ps) < 8) then MSRaise(Exception, 'Decode - Bad header format (CRC value)');
            crcPtr := ps;
            crc := Copy(ps, 1, 8);
            FCRC := StrToInt('$' + crc);
            Inc(ps, 8);
            Inc(state);
          end;

        ds_CRC_END: begin
            if (ps^ = '"') then begin inc(ps); Inc(state); continue; end;
            MSRaise(Exception, 'Decode - Bad header format(CRC end)');
          end;

        ds_CLASSES_NUMBER_VALUE: begin
            FClassesCount := _DecodeUnsignedLong(@ps, pend, 'classes number');
            if (FClassesCount <> 0) then begin
              //FClasses := TStringList.Create;
            end;
            Inc(state);
          end;
        ds_CLASS_NAME: begin
            className := DecodeString(@ps, pend, 'class name');
            FClasses.Add(className);
            //class myClass = NSClassFromString(className);
            //if (myClass)NSMapInsertKnownAbsent(decodedClasses, (const void * )lastClassId + +, (const void * )myClass);
            //else MSRaise(Exception, 'Decode - unknown class : %s', [className]);
            Inc(state);
          end;

        ds_KEYS_NUMBER_VALUE: begin
            FKeysCount := _DecodeUnsignedLong(@ps, pend, 'keys number');
            if (FKeysCount <> 0) then begin
              //FKeys := TStringList.Create;
            end;
            Inc(state);
          end;

        ds_KEY_NAME: begin
            key := DecodeString(@ps, pend, 'key name');
            FKeys.Add(key);
            Inc(state);
          end;

        ds_ROOT_OBJECT: begin

            try
              FRootObject := DecodeObject(@ps, pend, 'root object', tokenCount);
              Inc(state);
            except
              on E: Exception do begin
                raise e;
              end;
            end;
          end;

        ds_ARRAY_END: begin
            if ps^ = ' ' then begin Inc(ps); continue; end;
            if ps^ = ']' then begin Inc(ps); Inc(State); continue; end;
            MSRaise(Exception, 'Decode - Bad format (array end)');
          end;

        ds_GLOBAL_END: begin
            if ps^ = ' ' then begin Inc(ps); continue; end;
            if (ps = pend) then begin
              if (verifyCRC) then begin
                FillChar(crcPtr[0], 8, '0');
                crcCalc := _CalculateCrc(AStream);
                if (FCRC <> crcCalc) then MSRaise(Exception, 'Decode - CRC Verification failed');
              end;

              Inc(tokenCount);
              if (FTokensCount <> tokenCount) then
                MSRaise(Exception, 'Decode - Wrong token number : %d (expected : %d)', [tokenCount, FTokensCount]);

              Inc(ps);
              Continue;
            end;
            MSRaise(Exception, 'Decode - Bad format(character after array end)');
          end;
      else begin
          //never go here
          MSRaise(Exception, 'Decode - unknown state');
        end;

      end; //case
    end; //while
  end; //AStream.Size

  Result := FRootObject;

end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeNaturalArray(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSNaturalArray;
var
  s: PChar;
  i, count: Integer;
  xArray: TMSNaturalArray;
  natural: MSULong;
begin

  s := Ptr^;
  xArray := nil;

  count := _DecodeUnsignedLong(@s, endPointer, operation);

  if count > 0 then begin
    xArray := TMSNaturalArray.Create(count);
    _AddObject(xArray);
    for i := 0 to count - 1 do begin
      JumpToNextToken(@s, endPointer, tokenCount);
      natural := _DecodeUnsignedLong(@s, endPointer, operation);
      xArray.SetValue(i, natural);
    end;
  end;

  Result := xArray;
  ptr^ := s;

end;
//------------------------------------------------------------------------------

function TMSTEDecoder.DecodeNumber(ptr: PPChar; endPointer: PChar; operation: string; tokenType: TMSTETokenType): TMSNumber;
var
  res: TMSNumber;
begin

  res := TMSNumber.Create;

  case tokenType of

    tt_REAL_VALUE, tt_DOUBLE: res.Double := _DecodeDouble(ptr, endPointer, operation);
    tt_FLOAT: res.Float := _DecodeFloat(ptr, endPointer, operation);

    tt_CHAR: res.Char := _DecodeChar(ptr, endPointer, operation);
    tt_UNSIGNED_CHAR: res.Byte := _DecodeUnsignedChar(ptr, endPointer, operation);

    tt_SHORT: res.Short := _DecodeShort(ptr, endPointer, operation);
    tt_UNSIGNED_SHORT: res.UShort := _DecodeUnsignedShort(ptr, endPointer, operation);

    tt_INT32: res.Int := _DecodeInt(ptr, endPointer, operation);
    tt_UNSIGNED_INT32: res.Uint := _DecodeUnsignedInt(ptr, endPointer, operation);

    tt_INTEGER_VALUE, tt_INT64: res.Long := _DecodeLong(ptr, endPointer, operation);
    tt_UNSIGNED_INT64: res.ULong := _DecodeUnsignedLong(ptr, endPointer, operation);

  else begin
      FreeAndNil(res);
      MSRaise(Exception, 'DecodeNumber - unknown tokenType: %d', [ord(tokenType)]);
    end;

  end;

//sais pas comment tester ca
//  MSRaise(Exception, 'DecodeNumber - unable to decode number with tokenType = %d', [ord(tokenType)]);

  Result := Res;

end;
//------------------------------------------------------------------------------

function TMSTEDecoder._DecodeDouble(ptr: PPChar; endPointer: PChar; operation: string): Double;
var
  str: string;
  ods: Char;
  r: Extended;
begin
  ods := DecimalSeparator;
  DecimalSeparator := '.';

  Result := 0;
  str := _FindDoubleNumber(ptr, endPointer, '_DecodeDouble', operation);

  if TextToFloat(PChar(str), r, fvExtended) then
    Result := r
  else
    MSRaise(Exception, '_DecodeDouble - unable to decode number (Double)');

  DecimalSeparator := ods;

end;
//------------------------------------------------------------------------------

function TMSTEDecoder._DecodeFloat(ptr: PPChar; endPointer: PChar; operation: string): Single;
var
  str: string;
  ods: Char;
  r: Extended;
begin
  ods := DecimalSeparator;
  DecimalSeparator := '.';

  Result := 0;
  str := _FindDoubleNumber(ptr, endPointer, '_DecodeFloat', operation);

  if TextToFloat(PChar(str), r, fvExtended) then
    Result := r
  else
    MSRaise(Exception, '_DecodeFloat - unable to decode number (Float)');

  DecimalSeparator := ods;
end;

//------------------------------------------------------------------------------

function TMSTEDecoder._DecodeUnsignedLong(ptr: PPChar; endPointer: PChar; operation: string): MSULong;
var
  str: string;
begin
  str := _FindNumber(ptr, endPointer, '_DecodeUnsignedLong', operation);
  Result := StrToUInt64(Str);
end;
//------------------------------------------------------------------------------

function TMSTEDecoder._DecodeChar(ptr: PPChar; endPointer: PChar; operation: string): MSChar;
var
  str: string;
  res: Integer;
begin
  Str := _FindNumber(ptr, endPointer, '_DecodeChar', operation);
  res := StrToInt(Str);
  if (res < MSCharMin) or (Res > MSCharMax) then MSRaise(Exception, '_DecodeChar - out of range(%d)', [res]);
  Result := Res;
end;
//------------------------------------------------------------------------------

function TMSTEDecoder._DecodeInt(ptr: PPChar; endPointer: PChar; operation: string): MSInt;
var
  str: string;
  res: Int64;
begin
  Str := _FindNumber(ptr, endPointer, '_DecodeInt', operation);
  res := StrToInt64(Str);
  if (res < MSIntMin) or (Res > MSIntMax) then MSRaise(Exception, '_DecodeInt - out of range(%d)', [res]);
  Result := Res;
end;
//-----------------------------------------------------------------------------------

function TMSTEDecoder._DecodeLong(ptr: PPChar; endPointer: PChar; operation: string): MSLong;
var
  str: string;
begin
  str := _FindNumber(Ptr, endPointer, '_DecodeLong', operation);
  Result := StrToInt64(Str);
end;
//-----------------------------------------------------------------------------------

function TMSTEDecoder._DecodeShort(ptr: PPChar; endPointer: PChar; operation: string): MSShort;
var
  str: string;
  res: Int64;
begin
  Str := _FindNumber(ptr, endPointer, '_DecodeShort', operation);
  res := StrToInt64(Str);
  if (res < MSShortMin) or (Res > MSShortMax) then MSRaise(Exception, '_DecodeShort - out of range(%d)', [res]);
  Result := Res;
end;

//-----------------------------------------------------------------------------------

function TMSTEDecoder._DecodeUnsignedChar(ptr: PPChar; endPointer: PChar; operation: string): MSByte;
var
  str: string;
  res: UInt64;
begin
  Str := _FindNumber(ptr, endPointer, '_DecodeUnsignedChar', operation);
  res := StrToUInt64(Str);
  if Res > MSByteMax then MSRaise(Exception, '_DecodeUnsignedChar - out of range(%d)', [res]);
  Result := Res;
end;
//-----------------------------------------------------------------------------------

function TMSTEDecoder._DecodeUnsignedInt(ptr: PPChar; endPointer: PChar; operation: string): MSUInt;
var
  str: string;
  res: UInt64;
begin
  Str := _FindNumber(ptr, endPointer, '_DecodeUnsignedInt', operation);
  res := StrToUInt64(Str);
  if Res > MSUIntMax then MSRaise(Exception, '_DecodeUnsignedInt - out of range(%d)', [res]);
  Result := Res;
end;
//-----------------------------------------------------------------------------------

function TMSTEDecoder._DecodeUnsignedShort(ptr: PPChar; endPointer: PChar; operation: string): MSUShort;
var
  str: string;
  res: UInt64;
begin
  Str := _FindNumber(ptr, endPointer, '_DecodeUnsignedShort', operation);
  res := StrToUInt64(Str);
  if Res > MSUShortMax then MSRaise(Exception, 'DecodeUnsignedShort - out of range(%d)', [res]);
  Result := Res;
end;
//-----------------------------------------------------------------------------------

function TMSTEDecoder.DecodeObject(ptr: PPChar; endPointer: PChar; operation: string; var tokenCount: integer): TMSTEObject;
var
  s: PChar;
  tokenType: Byte;
  Ref: Int64;
begin
  Result := nil;
  s := Ptr^;

  tokenType := _DecodeUnsignedShort(@s, endPointer, 'token type');

  case TMSTETokenType(tokenType) of
//0
    tt_Null: begin
        Result := __MSNull;
      end;
//1
    tt_TRUE: begin
        Result := __MSTrue;
      end;
//2
    tt_FALSE: begin
        Result := __MSFalse;
      end;
//10 -> 19
//3 -> 4
    tt_CHAR,
      tt_UNSIGNED_CHAR,
      tt_SHORT,
      tt_UNSIGNED_SHORT,
      tt_INT32,
      tt_UNSIGNED_INT32,
      tt_INT64,
      tt_UNSIGNED_INT64,
      tt_FLOAT,
      tt_DOUBLE,
      tt_INTEGER_VALUE,
      tt_REAL_VALUE:
      begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeNumber(@s, endPointer, 'DecodeObject', TMSTETokenType(tokenType));

        if TMSTETokenType(tokenType) in [tt_INTEGER_VALUE, tt_REAL_VALUE] then
          _AddObject(Result);
      end;
//5
    tt_STRING: begin
        Result := TMSString.Create;
        JumpToNextToken(@s, endPointer, tokenCount);
        TMSString(Result).Value := DecodeString(@s, endPointer, 'DecodeObject');
        _AddObject(Result);
      end;
//6
    tt_DATE: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeDate(@s, endPointer, 'DecodeObject', tokenCount);
        _AddObject(Result);
      end;
//7
    tt_COLOR: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeColor(@s, endPointer, 'DecodeObject', tokenCount);
        _AddObject(Result);
      end;

//8
    tt_DICTIONARY: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeDictionary(@s, endPointer, 'DecodeObject', tokenCount);
      end;
//9 , 27
    tt_STRONG_REFERENCED_OBJECT, tt_WEAK_REFERENCED_OBJECT: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Ref := _DecodeLong(@s, endPointer, 'DecodeObject');
        if Ref >= FObjects.Count then
          MSRaise(Exception, 'DecodeArray - invalid object reference!');

        Result := FObjects.Items[Ref];
      end;

//20
    tt_ARRAY: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeArray(@s, endPointer, 'DecodeObject', tokenCount);
      end;

//21
    tt_NATURAL_ARRAY: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeNaturalArray(@s, endPointer, 'DecodeObject', tokenCount);
      end;

//22
    tt_COUPLE: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeCouple(@s, endPointer, 'DecodeObject', tokenCount);
      end;

//    tt_BASE64_DATA = 23,
    tt_BASE64_DATA: begin
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeBufferBase64String(@s, endPointer, 'DecodeObject', tokenCount);
        _AddObject(Result);
      end;

//    tt_DISTANT_PAST = 24,
    tt_DISTANT_PAST: begin
        result := __theDistantPast;
      end;
//    tt_DISTANT_FUTURE = 25,
    tt_DISTANT_FUTURE: begin
        result := __theDistantFuture;
      end;

//26
    tt_EMPTY_STRING: begin
        Result := __MSEmptyString;
      end

  else begin
      if tokenType >= 50 then begin //ord(tt_USER_CLASS)
        JumpToNextToken(@s, endPointer, tokenCount);
        Result := DecodeDictionary(@s, endPointer, 'DecodeObject', tokenCount);
      end else
        MSRaise(Exception, 'Unknow TokenType :%d', [ord(tokenType)]);
    end;

  end;

  ptr^ := s;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

function TMSTEDecoder._CalculateCrc(AStream: TMemoryStream): Cardinal;
var
  xCrc: Cardinal;
begin
  AStream.SaveToFile('CRC.TXT');
  MSCRC32(AStream.Memory, AStream.Size, xCrc);
  Result := xCrc;
end;

//------------------------------------------------------------------------------
end.

