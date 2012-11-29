unit UTest;

interface

//UMSTEClasses must be first

uses
  UMSTEClasses, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UMSFoundation, UMSTEDecoder, UMSTEEncoder, UDictionary;

type

  TMSPerson = class(TObject)
  public
    Name: string;
    firstName: string;
    sex: Boolean;

    function MSTESnapshot(Encoder: TObject): TMSDictionary; override;
  end;

  TMSSon = class;

  TMSParent = class(TMSPerson)
    son: TMSSon;
    function MSTESnapshot(Encoder: TObject): TMSDictionary; override;
  end;

  TMSSon = class(TMSPerson)
    Mother: TMSParent;
    Father: TMSParent;
    function MSTESnapshot(Encoder: TObject): TMSDictionary; override;
  end;

implementation

{ TMSPerson }

function TMSPerson.MSTESnapshot(Encoder: TObject): TMSDictionary;
var
  xDic: TMSDictionary;

  msCplName, msCplFirstName, msCplSex: TMSCouple;
  msName, msFirstName: TMSString;
  msSex: TMSNumber;

begin

  msName := TMSString.Create(name);
  msCplName := TMSCouple.Create(msName, nil);
  msCplName.FreeOnDestroy := True;

  msFirstName := TMSString.Create(firstName);
  msCplFirstName := TMSCouple.Create(msFirstName, nil);
  msCplFirstName.FreeOnDestroy := True;

  msSex := TMSNumber.Create;
  msSex.Byte := Integer(sex);
  msCplSex := TMSCouple.Create(msSex, nil);
  msCplSex.FreeOnDestroy := True;

  xDic := TMSDictionary.Create(True);
  xDic.AddValue('firstName', msCplFirstName);
  xDic.AddValue('name', msCplName);
  xDic.AddValue('sex', msCplsex);
  Result := xDic;

end;

{ TMSParent }

function TMSParent.MSTESnapshot(Encoder: TObject): TMSDictionary;
var
  xDic: TMSDictionary;
  msCplSon: TMSCouple;
begin
  xDic := inherited MSTESnapshot(Encoder);

  msCplSon := TMSCouple.Create(son, __MSTrue);
  xDic.AddValue('son', msCplSon);

  Result := xDic;

end;

{ TMSSon }

function TMSSon.MSTESnapshot(Encoder: TObject): TMSDictionary;
var
  xDic: TMSDictionary;
  msCplFather, msCplMother: TMSCouple;
begin
  xDic := inherited MSTESnapshot(Encoder);

  msCplFather := TMSCouple.Create(Father, nil);
  msCplMother := TMSCouple.Create(Mother, nil);

  xDic.AddValue('father', msCplFather);
  xDic.AddValue('mother', msCplMother);

  Result := xDic;

end;

end.

