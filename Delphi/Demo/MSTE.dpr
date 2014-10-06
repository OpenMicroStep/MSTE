program MSTE;

uses
  ExceptionLog,
  Forms,
  UMain in 'UMain.pas' {Form9},
  UTest in 'UTest.pas',
  crc32 in '..\Sources\crc32.pas',
  UMSFoundation in '..\Sources\UMSFoundation.pas',
  UMSTEClasses in '..\Sources\UMSTEClasses.pas',
  UMSTEDecoder in '..\Sources\UMSTEDecoder.pas',
  UMSTEEncoder in '..\Sources\UMSTEEncoder.pas',
  UDictionary in '..\Sources\UDictionary.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.
