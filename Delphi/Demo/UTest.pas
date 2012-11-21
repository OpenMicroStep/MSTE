unit UTest;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UMSFoundation, UMSTEDecoder, UMSTEEncoder, UMSTEClasses, UDictionary;

type
  TTest2 = class;

  TTest = class(TMSTEObject)
  public
    IntVal: Integer;
    DateVal: TDate;
    StrVal: string;
    TestVal: TTest2;
    constructor Create;
    destructor Destroy; override;

    function InitWithDictionary(ADictionary: TMSDictionary): Boolean;
    function MSTESnapshot(AEncoder: TObject): TMSDictionary; override;

  end;

  TTest2 = class(TMSTEObject)
  public

    IntVal: Integer;
    DateVal: TDate;
    StrVal: string;

    constructor Create;
    destructor Destroy; override;

    function InitWithDictionary(ADictionary: TMSDictionary): Boolean;
    function MSTESnapshot(AEncoder: TObject): TMSDictionary; override;
  end;

implementation

{ TTest }
//------------------------------------------------------------------------------

constructor TTest.Create;
begin
  TestVal := TTest2.Create;
  IntVal := 155;
  DateVal := Now;
  StrVal := 'Test1'

end;
//------------------------------------------------------------------------------

destructor TTest.Destroy;
begin
  TestVal.Free;
  inherited;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

function TTest.InitWithDictionary(ADictionary: TMSDictionary): Boolean;
//var
//  xObj: TObject;
//  xDic: TDictionary;
begin
//  Result := True;
//  xDic := ADictionary.Value;
//
//  xObj := xDic.GetValue('Int');
//  if xObj is TMSNumber then begin
//    IntVal := TMSNumber(xObj);
//  end;
//
//  xObj := xDic.GetValue('Date');
//  if xObj is TMSDate then begin
//    DateVal := TMSDate(xObj);
//  end;
//
//  xObj := xDic.GetValue('Str');
//  if xObj is TMSString then begin
//    StrVal := TMSString(xObj);
//  end;
//
//  xObj := xDic.GetValue('test');
//  if xObj is TMSDictionary then begin
//    TestVal.InitWithDictionary(TMSDictionary(xObj));
//  end;

end;

//------------------------------------------------------------------------------

function TTest.MSTESnapshot(AEncoder: TObject): TMSDictionary;
var
  Snapshot: TMSDictionary;
  n: TMSNumber;
  d: TMSDate;
  s: TMSString;
begin
  Snapshot := TMSDictionary.Create();

  n := TMSNumber.Create;
  n.Int := IntVal;

  d := TMSDate.Create(DateVal);
  s := TMSString.Create(StrVal);

  Snapshot.AddValue('Int', n);
  Snapshot.AddValue('Date', d);
  Snapshot.AddValue('Str', s);

  Snapshot.AddValue('test', TestVal.MSTESnapshot(AEncoder));

  Result := Snapshot;

end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
{ TTest2 }
//------------------------------------------------------------------------------

constructor TTest2.Create;
begin
  IntVal := 100;
  DateVal := Now;
  StrVal := 'Test2';

end;

destructor TTest2.Destroy;
begin
  inherited;
end;

function TTest2.InitWithDictionary(ADictionary: TMSDictionary): Boolean;
//var
//  xObj: TMSTEObject;
begin
//  Result := True;
//
//  xObj := ADictionary.GetValue('Int');
//  IntVal.Assign(xObj);
//
//  xObj := ADictionary.GetValue('Date');
//  DateVal.Assign(xObj);
//
//  xObj := ADictionary.GetValue('Str');
//  StrVal.Assign(xObj);

end;
//------------------------------------------------------------------------------

function TTest2.MSTESnapshot(AEncoder: TObject): TMSDictionary;
//var
//  Snapshot: TMSDictionary;
begin
//  Snapshot := TMSTEEncoder(AEncoder).getSnapshotDictionary;
//
//  Snapshot.AddValue('Int', IntVal);
//  Snapshot.AddValue('Date', DateVal);
//  Snapshot.AddValue('Str', StrVal);
//
//  Result := Snapshot;

end;
//------------------------------------------------------------------------------
end.

