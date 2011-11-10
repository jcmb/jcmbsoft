PROGRAM Adjust_Height;
{$mode delphi}
USES
   Math,
   AWK_Unit,
   Extra_Strings,
   Math_GRK;

procedure Help;
begin
WriteLn(STDERR,'Adjust For Pitch: <Height> <Pt,N,E,H FileName>');
WriteLn(STDERR,'');
WriteLn(STDERR,'Adjusts the NEH file for the pitch of the antenna, with the co-ordinates being adjusted based on the height of the antenna');
halt (1);
end;

VAR
   Input_File : TextFile;
   Awk : TAwk;
   Height : DOUBLE;

   Name : STRING;
   N_Left,
   E_Left,
   H_Left : Double;
   N_right,
   E_right,
   H_right : Double;
   N_Left_Adjusted,
   E_Left_Adjusted,
   H_Left_Adjusted : Double;
   N_right_Adjusted,
   E_right_Adjusted,
   H_right_Adjusted : Double;
   Distance,
   Heading,
   Tilt : Double;





BEGIN
if paramcount <> 2 then
   begin
   Help;
   end;

Height := Str2Double(paramstr(1));

if (String_Convert_Error <> 0) Or (Height = 0) then
   begin
   WriteLn(STDERR,'Error: Invalid height');
   Help;
   END;

AssignFile(Input_File,Paramstr(2));
Reset(Input_File);
Awk := TAwk.Create;
AWK.FS := ',';

WHILE Awk.Next_Record (Input_File) DO
   BEGIN
   Name := Awk.Field(1);
   N_Left  := Str2Double(Awk.Field(2));
   E_Left  := Str2Double(Awk.Field(3));
   H_Left  := Str2Double(Awk.Field(4));
   N_right := Str2Double(Awk.Field(5));
   E_right := Str2Double(Awk.Field(6));
   H_right := Str2Double(Awk.Field(7));
   Distance := Str2Double(Awk.Field(8));
   Heading  := Str2Double(Awk.Field(9));
   Tilt     := Str2Double(Awk.Field(10));
   Apply_AZ_SD (N_Left,E_Left,H_Left,DegTorad(Heading+90),DegTorad(90+Tilt),Height,N_Left_Adjusted,E_Left_Adjusted,H_Left_Adjusted);
   Apply_AZ_SD (N_Right,E_Right,H_Right,DegTorad(Heading+90),DegTorad(90+Tilt),Height,N_Right_Adjusted,E_Right_Adjusted,H_Right_Adjusted);
   H_Left_Adjusted := H_Left_Adjusted - Height;
   H_Right_Adjusted := H_Right_Adjusted - Height;
   WriteLn(Name,',',N_Left_Adjusted:0:3,',',E_Left_Adjusted:0:3,',',H_Left_Adjusted:0:3,',',N_Right_Adjusted:0:3,',',E_Right_Adjusted:0:3,',',H_Right_Adjusted:0:3);
   END;
CloseFile(Input_File);
END.
