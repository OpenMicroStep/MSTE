unit UMSFoundation;

interface

uses Windows, Messages, SysUtils, Classes, Contnrs, Math;

const

  MSCharMin = -128;
  MSCharMax = 127;
  MSByteMax = 255;
  MSShortMin = -32768;
  MSShortMax = 32767;
  MSUShortMax = 65535;
  MSIntMax = 2147483647;
  MSIntMin = (-MSIntMax - 1);
  MSUIntMax = MAXDWORD;
  MSLongMax = 9223372036854775807;
  MSLongMin = (-MSLongMax - 1);
  MSULongMax = 18446744073709551615;
  MSDecimalMax = MaxExtended;
  MSDecimalMin = MinExtended;


type

  MSByte = Byte;
  MSChar = ShortInt;
  MSUShort = Word;
  MSShort = SmallInt;
  MSUInt = LongWord;
  MSInt = LongInt;
  MSULong = UInt64;
  MSLong = Int64;
  float = single;
  MSDecimal = Extended;

procedure MSRaise(AExceptClass: ExceptClass; AText: string); overload;
procedure MSRaise(AExceptClass: ExceptClass; AText: string; AParam: array of const); overload;
function CharIsDigit(C: Char): Boolean;
function CharIsHexa(C: Char): Boolean;

function StrToUInt64Def(const S: string; Default: UInt64): UInt64;
function StrToUInt64(const S: string): UInt64;

function WideStringToString(const ws: WideString; codePage: Word = CP_UTF8): AnsiString;
function StringToWideString(const s: AnsiString; codePage: Word): WideString;

function CompareCharAsWide(C1, C2: Char): Boolean;


implementation

{$R-}

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
  else begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], -1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], -1, @Result[1], l - 1, nil, nil);
  end;
end; { WideStringToString }
//------------------------------------------------------------------------------

function StringToWideString(const s: AnsiString; codePage: Word): WideString;
var
  l: integer;
begin
  if s = '' then
    Result := ''
  else begin
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PChar(@s[1]), -1, nil, 0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PChar(@s[1]),
        -1, PWideChar(@Result[1]), l - 1);
  end;
end; { StringToWideString }

function CompareCharAsWide(C1, C2: Char): Boolean;
begin
  Result := widechar(c1) = widechar(c2)
end;
//------------------------------------------------------------------------------

function StrToUInt64(const S: string): UInt64;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then raise EConvertError.Create('Convert error');
end;
//------------------------------------------------------------------------------

function StrToUInt64Def(const S: string; Default: UInt64): UInt64;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then Result := Default;
end;
//------------------------------------------------------------------------------

function CharIsDigit(C: Char): Boolean;
begin
  Result := not ((C < '0') or (C > '9'));
end;

//------------------------------------------------------------------------------

function CharIsHexa(C: Char): Boolean;
begin
  c := UpCase(C);
  Result := ((C >= '0') and (C <= '9')) or ((C >= 'A') and (C <= 'F'))
end;
//------------------------------------------------------------------------------

procedure MSRaise(AExceptClass: ExceptClass; AText: string);
begin
  MSRaise(AExceptClass, AText, []);
end;
//------------------------------------------------------------------------------

procedure MSRaise(AExceptClass: ExceptClass; AText: string; AParam: array of const);
begin
  raise AExceptClass.CreateFmt(AText, AParam);
end;

end.

