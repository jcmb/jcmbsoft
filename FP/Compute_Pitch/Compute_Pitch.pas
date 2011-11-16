PROGRAM Compute_Pitch;
{$mode delphi}
USES
   Math,
   AWK_Unit,
   Extra_Strings,
   Compute_Pitch_Test,
   Math_GRK;


CONST
   Program_Name = 'Compute_Pitch';
   Program_Version = 1.1;


procedure Help;
begin
WriteLn(STDERR,'Usage: '+ Program_Name + ' <Computed_Heading_File> <Pitch File>');
WriteLn(STDERR,'');
WriteLn(STDERR,'Computes Pitch for points in a Computed Heading filename and the pitch point from the pitch file');
WriteLn(STDERR,'');
WriteLn(STDERR, Program_Name,' V', Program_Version:1:1);
WriteLn(STDERR,'Copyright: JCMBsoft, 2011. JCMBSoft.com');
WriteLn(STDERR,'');
halt (1);
end;

VAR
   Heading_File,
   Pitch_File : TextFile;
   Heading_Awk : TAwk;
   Pitch_Awk : TAwk;
   Pitch_Time,
   Heading_Time : DOUBLE;
   N_Heading,
   E_Heading,
   H_Heading,
   Heading_Distance,
   Heading : Double;
   Tilt,
   N_Pitch,
   E_Pitch,
   H_Pitch,
   Pitch_Distance : Double;
   Pitch_Match : BOOLEAN;



BEGIN
if paramstr(1)= 'TEST' then
   begin
   WriteLn('Running Tests');
   Test_Compute_Pitch;
   halt(2);
   END;

if paramcount <> 2 then
   begin
   Help;
   end;


AssignFile(Heading_File,Paramstr(1));
Reset(Heading_File);
Heading_Awk := TAwk.Create;
Heading_Awk.FS := ',';

AssignFile(Pitch_File,Paramstr(2));
Reset(Pitch_File);
Pitch_Awk := TAwk.Create;
Pitch_AWK.FS := ',';


Pitch_Time := -1;

WHILE Heading_Awk.Next_Record (Heading_File) DO
   BEGIN
   Heading_Time := Str2Double(Heading_Awk.Field(1));
   N_Heading  := Str2Double(Heading_Awk.Field(2));
   E_Heading  := Str2Double(Heading_Awk.Field(3));
   H_Heading  := Str2Double(Heading_Awk.Field(4));
   Heading_Distance  := Str2Double(Heading_Awk.Field(5));
   Heading    := Str2Double(Heading_Awk.Field(6));
   Pitch_Match := TRUE;
//   WriteLn('Heading: ', Heading_Time:0:2);

   WHILE Pitch_Match AND Pitch_AWK.Next_Record(Pitch_File)  DO //requires short circuit to work correctly
      BEGIN
      Pitch_Time := Str2Double(Pitch_Awk.Field(1));
      N_Pitch  := Str2Double(Pitch_Awk.Field(2));
      E_Pitch  := Str2Double(Pitch_Awk.Field(3));
      H_Pitch  := Str2Double(Pitch_Awk.Field(4));
      Pitch_Match := Pitch_Time < Heading_Time;
//      WriteLn('Pitch: ', Pitch_Time:0:2,' ', Pitch_Match);
      END;

//   WriteLn('Pitch: ', Pitch_Time:0:2,' ', Pitch_Match);

   IF Pitch_Time = Heading_Time THEN
      BEGIN
      Tilt := RadToDeg(Compute_Tilt_NE(N_Heading,E_Heading,H_Heading,N_Pitch,E_Pitch,H_Pitch));
      Pitch_Distance := Compute_Distance_NE(N_Heading,E_Heading,N_Pitch,E_Pitch);
      WriteLn(Pitch_Time:0:2,',',N_Heading:0:3,',',E_Heading:0:3,',',H_Heading:0:3,',',Heading_Distance:0:3,',', Heading:0:3, ',', N_Pitch:0:3,',',E_Pitch:0:3,',',H_Pitch:0:3,',', Tilt:0:3,',',Pitch_Distance:0:3,',',H_Heading-H_Pitch:0:3);
      END;
   END;
CloseFile(Heading_File);
CloseFile(Pitch_File);
END.
