unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //   UMSTEClasses must be after Contnrssociete
  Contnrs, UMSTEClasses,
  Dialogs, StdCtrls, UMSFoundation, UMSTEDecoder, UMSTEEncoder, UDictionary, UTest
  ;

type
  TForm9 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Memo2: TMemo;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    xDecoder: TMSTEDecoder;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.Button1Click(Sender: TObject);
var
  bCrc: Boolean;
  ms: TMemoryStream;
  s: string;
  root: TObject;

begin

  s := ' ["MSTE0101",59,"CRC2CFCF8AC",1,"Person",6,"name","firstName","birthday","maried-to","father","mother",20,3,50,4,0,5,'
    + '"Durand",1,5,"Yves",2,6,-1222131600,3,50,4,0,9,2,1,5,"Claire",2,6,-1185667200,3,9,1,9,5,50,5,0,9,2,1,5,'
    + '"Lou",2,6,-426214800,4,9,1,5,9,5]';

  s := ' ["MSTE0101",59,"CRCC41DBEF3",1,"Person",6,"name","firstName","birthday","maried-to","father","mother",'
    + '20,3,50,4,0,5,"Durand",1,5,"Yves",2,6,-1222131600,3,51,4, 0,9,2,1,5,"Claire",2,6,-1185667200,'
    + '3,27,1,9,5,50,5,0,9,2,1,5,"Lou",2,6,-426214800,4,9,1,5,9,5]';

  s := '["MSTE0101",60,"CRC81B787F3",2,"MSParent","MSSon",6,"firstName","sex","name","son","father","mother",20,3,50,4,0,5,'
    + '"Jean",1,3,0,2,5,"DUPOND",3,53,5,0,5,"Marc",1,9,3,2,9,4,4,9,1,5,50,4,0,5,"Ginette",1,3,1,2,5,"DURAND",3,27,5,9,7,9,5]';

  Memo1.Text := s;

  StrToFloat('136,10');

  bCrc := True; // false;

  s := StringReplace(s, #13#10, '', [rfReplaceAll]);
  xDecoder := TMSTEDecoder.Create;
  ms := TMemoryStream.Create;
  ms.LoadFromFile('MSTE.TXT');
//  ms.Write(s[1], Length(s));
  ms.Seek(0, soFromBeginning);
  root := xDecoder.Decode(ms, bCrc);

//  xDecoder.Debug;

  ms.Free;
  Memo2.Clear;

  Memo2.Lines.Add('Décodage:');
  Memo2.Lines.Add('version = ' + xDecoder.Version);
  if bCrc then begin
    Memo2.Lines.Add('crc = ' + IntToHex(xDecoder.Crc, 8) + ' OK');
  end else
    Memo2.Lines.Add('NO CRC CHECK');

  Memo2.Lines.Add('Token count = ' + IntToStr(xDecoder.TokensCount));
  Memo2.Lines.Add('Classes count = ' + IntToStr(xDecoder.Classes.Count));
  Memo2.Lines.Add('Keys count = ' + IntToStr(xDecoder.Keys.Count));

  Memo2.Lines.Add('classes = ' + Trim(xDecoder.Classes.DelimitedText));
  Memo2.Lines.Add('keys = ' + Trim(xDecoder.Keys.DelimitedText));

  Memo2.Lines.Add('--------------------------------------------------------');
  Memo2.Lines.Add('Classe du root = ' + root.ClassName);
  Memo2.Lines.Add('--------------------------------------------------------');

  Memo2.Lines.Add(Format('%d', [ord(UMSTEClasses.TObjectList(Root).TokenType)]));
  Memo2.Lines.Add(Format('%d', [ord(UMSTEClasses.TObject(Root).TokenType)]));
  Memo2.Lines.Add(Format('%d', [ord(root.TokenType)]));

  Memo2.Lines.Add(
    root.ToString
    );

  Memo2.Lines.Add('--------------------------------------------------------');

//  a := root as TMSArray;
//  d2 := a[2] as TMSDictionary;
//
//  Memo2.Lines.Add(format('%s', [d2.GetValue('firstName').ToString]));
//  d1 := d2.GetValue('mother') as TMSDictionary;
//  Memo2.Lines.Add(format('Mother : %s', [d1.GetValue('firstName').ToString]));
//  d0 := d2.GetValue('father') as TMSDictionary;
//  Memo2.Lines.Add(format('Father : %s', [d0.GetValue('firstName').ToString]));
  xDecoder.Free;

end;

procedure TForm9.FormCreate(Sender: TObject);
begin
//  Button1.Click;
//  Button2.Click;
  Button3.Click;
end;

procedure TForm9.Button2Click(Sender: TObject);
var
  pere: TMSParent;
  mere: TMSParent;
  fils: TMSSon;
  famille: TObjectList;

  s: string;

begin

  pere := TMSParent.Create;
  pere.Name := 'Dupond';
  pere.firstName := 'Jean';
  pere.sex := False;

  mere := TMSParent.Create;
  mere.Name := 'Dupond';
  mere.firstName := 'Ginette';
  mere.sex := True;

  fils := TMSSon.Create;
  fils.Father := pere;
  fils.Mother := mere;
  fils.firstName := 'Marc';
  fils.Name := pere.Name;
  fils.sex := False;

  famille := TObjectList.Create(True);
  famille.Add(pere);
  famille.Add(mere);
  famille.Add(fils);

  pere.son := fils;
  mere.son := fils;

  s := famille.MSTEncodedString;
  Memo2.Text := s;

  famille.Free;
  Memo2.Lines.Add(
    '["MSTE0101",60,"CRC564495FB",2,"MSParent2","MSSon2",6,"firstName",'
    + '"sex","name","son","father","mother",20,3,50,4,0,5,"Jean",1,3,0,2,5,'
    + '"DUPOND",3,52,5,0,5,"Marc",1,9,3,2,9,4,4,9,1,5,50,4,0,5,"Ginette",1,3,1,2,5,"DURAND",3,9,5,9,7,9,5]'
    );

end;

procedure TForm9.Button3Click(Sender: TObject);
var
  i: Integer;
  s1, s2: TMSString;
  n1, n2: TMSNumber;
  c1, c2: TMSColor;
  na1, na2: TMSNaturalArray;

  o1, o2: TObjectList;
  d1, d2: TMSDictionary;
begin

  Memo2.Lines.Add('TMSDictionary');
  d1 := TMSDictionary.Create(True);
  for I := 0 to 10 do begin
    s1 := TMSString.Create(IntToStr(i));
    d1.AddValue('Key' + IntToHex(i, 1), s1);
  end;
  Memo2.Lines.Add(d1.ToString);

  d2 := TMSDictionary.Create(True);
  d2.Assign(d1);
  Memo2.Lines.Add(d2.ToString);
  d2.Free;
  d1.Free;

  Exit;

  Memo2.Lines.Add('TObjectList');
  o1 := TObjectList.Create;
  for I := 0 to 10 do begin
    s1 := TMSString.Create(IntToStr(i));
    o1.Add(s1)
  end;

  Memo2.Lines.Add(o1.ToString);

  o2 := TObjectList.Create;
  o2.Assign(o1);
  Memo2.Lines.Add(o2.ToString);
  o2.free;
  o1.Free;
  Exit;

  Memo2.Lines.Add('TMSNaturalArray');
  na1 := TMSNaturalArray.Create(5);
  for i := 1 to 5 do na1[i - 1] := i;
  Memo2.Lines.Add(na1.ToString);

  na2 := TMSNaturalArray.Create(0);
  na2.Assign(na1);
  Memo2.Lines.Add(na2.ToString);

  na1.free;
  na2.free;
  Exit;

  Memo2.Lines.Add('TMSString');
  s1 := TMSString.Create('String1');
  s2 := TMSString.Create('String2');
  s2.Assign(s1);
  Memo2.Lines.Add(s1.Value);
  Memo2.Lines.Add(s2.Value);
  s1.Free;
  s2.Free;

  exit;
  Memo2.Lines.Add('TMSNumber');
  n1 := TMSNumber.Create;
  n1.Int := 100;
  n1.Float := 100.10;
  n1.Double := 100.10;

  n2 := TMSNumber.Create;
  n2.Assign(n1);

  Memo2.Lines.Add(IntToStr(n2.Int));
  Memo2.Lines.Add(FloatToStr(n2.Float));
  Memo2.Lines.Add(FloatToStr(n2.Double));

  n1.Free;
  n2.Free;

  exit;
  Memo2.Lines.Add('TMSColor');
  c1 := TMSColor.Create(clLime, 0);
  Memo2.Lines.Add(IntToStr(c1.r));
  Memo2.Lines.Add(IntToStr(c1.g));
  Memo2.Lines.Add(IntToStr(c1.b));
  c1.Free;

end;

end.

