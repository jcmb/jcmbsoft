PROGRAM Compute_Pitch_And_Heading;
{$mode delphi}
USES
   Math,
   AWK_Unit,
   Extra_Strings,
   Compute_Pitch_And_Heading_Test,
   Math_GRK;

procedure Help;
begin
WriteLn(STDERR,'Compute_Pitch_And_Heading: <Left_Antenna_FileName> <Right_Antenna File>');
WriteLn(STDERR,'');
WriteLn(STDERR,'Computes Pitch and heading for two points, the pitch and heading is computed from the Left Antenna');
halt (1);
end;

VAR
   Left_File,
   Right_File : TextFile;
   Left_Awk : TAwk;
   Right_Awk : TAwk;
   Right_Time,
   Left_Time : DOUBLE;
   N_Left,
   E_Left,
   H_Left : Double;
   N_Right,
   E_Right,
   H_Right,
   Heading,
   Tilt,
   Distance : Double;
   Right_Match : BOOLEAN;



BEGIN
if paramstr(1)= 'TEST' then
   begin
   WriteLn('Running Tests');
   Test_Compute_Pitch_And_Heading;
   halt(2);
   END;

if paramcount <> 2 then
   begin
   Help;
   end;


AssignFile(Left_File,Paramstr(1));
Reset(Left_File);
Left_Awk := TAwk.Create;
Left_Awk.FS := ',';

AssignFile(Right_File,Paramstr(2));
Reset(Right_File);
Right_Awk := TAwk.Create;
Right_AWK.FS := ',';


Right_Time := -1;

WHILE Left_Awk.Next_Record (Left_File) DO
   BEGIN
   Left_Time := Str2Double(Left_Awk.Field(1));
   N_Left  := Str2Double(Left_Awk.Field(2));
   E_Left  := Str2Double(Left_Awk.Field(3));
   H_Left  := Str2Double(Left_Awk.Field(4));
   Right_Match := TRUE;

//   WriteLn('Left: ', Left_Time:0:2,' ',Left_AWK.NF);

   WHILE Right_Match AND Right_AWK.Next_Record(Right_File)  DO
      BEGIN
      Right_Time := Str2Double(Right_Awk.Field(1));
      N_Right  := Str2Double(Right_Awk.Field(2));
      E_Right  := Str2Double(Right_Awk.Field(3));
      H_Right  := Str2Double(Right_Awk.Field(4));
      Right_Match := Right_Time < Left_Time;

//      WriteLn('Right: ', Right_Time:0:2,' ', Right_Match,' ',Right_AWK.NF);
      END;

   IF Right_Time = Left_Time THEN
      BEGIN
      Tilt     := RadToDeg(Compute_Tilt_NE(N_Left,E_Left,H_Left,N_Right,E_Right,H_Right));
      Heading  := RadToDeg(Compute_Heading_NE(N_Left,E_Left,N_Right,E_Right));
      Distance := Compute_Distance_NE(N_Left,E_Left,N_Right,E_Right);
      WriteLn(Left_Time:0:2,',',N_Left:0:3,',',E_Left:0:3,',',H_Left:0:3,',', N_Right:0:3,',',E_Right:0:3,',',H_Right:0:3,',',Distance:0:3,',',Heading:0:3,',', Tilt:0:3);
      END;
   END;
CloseFile(Left_File);
CloseFile(Right_File);
END.
