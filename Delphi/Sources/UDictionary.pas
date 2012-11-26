unit UDictionary;

interface

uses Classes, Windows, SysUtils, Math, Contnrs;

const
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

  TDictionary = class(TObject)
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
  public
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

implementation

//------------------------------------------------------------------------------
{ Create a new hash map }

constructor TDictionary.Create(OwnObject: Boolean = False);
begin
  Create(11, OwnObject);
end;
//------------------------------------------------------------------------------

constructor TDictionary.Create(Capacity: Integer; OwnObject: Boolean = False);
begin
  FCount := 0;
  FCapacity := 0;
  FDepth := 0;
  FOwnObject := OwnObject;
  SetCapacity(Capacity);
end;
//------------------------------------------------------------------------------

function TDictionary.GetElements: TList;
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

function TDictionary.GetElementsKeys: TStringList;
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

procedure TDictionary.SetCapacity(NewCapacity: Integer);
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

destructor TDictionary.Destroy;
begin
  Clear;
  inherited Destroy
end;
//------------------------------------------------------------------------------

procedure TDictionary.FreeElementValue(Element: PElement);
begin
  if FOwnObject and (Element.Value <> nil) then begin
    TObject(Element.Value).Free;
    Element.Value := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TDictionary.FreeElement(Element: PElement);
begin
  FreeElementValue(Element);
  FreeMem(Element.Key);
  FreeMem(Element);
  Dec(FCount);
end;

//------------------------------------------------------------------------------
{ Calculate the hash value of a string }

function TDictionary.Hash(Akey: string): Cardinal;
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

//------------------------------------------------------------------------------

function TDictionary.SetValue(Key: string; Value: TObject): Boolean;
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

procedure TDictionary.AddValue(Key: string; Value: TObject);
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

procedure TDictionary.PutElement(Index: Cardinal; Element: PElement);
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

function TDictionary.Remove(Key: string): Boolean;
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

function TDictionary.GetValue(key: string): TObject;
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

procedure TDictionary.Grow;
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
{ Clear all the values from the hash map }

procedure TDictionary.Clear;
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

end.

