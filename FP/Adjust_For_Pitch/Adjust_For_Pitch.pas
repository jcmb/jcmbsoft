PROGRAM Adjust_Height;
{$mode delphi}
USES
   Math,
   AWK_Unit,
   Extra_Strings,
   Math_GRK;

CONST
   Program_Name = 'Adjust_For_Pitch';
   Program_Version = 1.1;


procedure Help;
begin
WriteLn(STDERR, 'Usage: '+ Program_Name + ' <Heading FileName> <Height> [Heading Adjustment]');
WriteLn(STDERR,'');
WriteLn(STDERR,'Adjusts the NEH co-ordinates in the file for the pitch of the antenna, with the co-ordinates');
WriteLn(STDERR,'being adjusted based on the height of the antenna that is entered.');
WriteLn(STDERR,'');
WriteLn(STDERR,'The Pitch is computed between the two points and the co-ordinates are adjusted along the heading');
WriteLn(STDERR,'between the two points. Which is normally what is wanted.');
WriteLn(STDERR,'This can be changed by adding the optional heading adjustment parameter.');
WriteLn(STDERR,'');

WriteLn(STDERR,'Note that the height value is not subtracted from the Height Values in the file.');
WriteLn(STDERR,'Use Adjust_Height for that');
WriteLn(STDERR,'');
WriteLn(STDERR, Program_Name,' V', Program_Version:1:1);
WriteLn(STDERR,'Copyright: JCMBsoft, 2011. JCMBSoft.com');
WriteLn(STDERR,'');

halt (1);
end;

VAR
   Input_File : TextFile;
   Awk : TAwk;
   Height : DOUBLE;

   Name : STRING;
   Heading_Adjust : Double;
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
   Heading,
   Tilt : Double;





BEGIN
if NOT (paramcount in [2,3]) then
   begin
   Help;
   end;

Height := Str2Double(paramstr(2));

if (String_Convert_Error <> 0) Or (Height = 0) then
   begin
   WriteLn(STDERR,'Error: Invalid height');
   Help;
   END;

AssignFile(Input_File,Paramstr(1));

Heading_Adjust := 0;

IF Paramstr(3) <> '' THEN
   BEGIN
   Heading_Adjust := Str2Double(paramstr(3));

	 if (String_Convert_Error <> 0)  then
	 begin
   	 WriteLn(STDERR,'Error: Invalid heading adjustment');
   	 Help;
   	END;
   END;


Reset(Input_File);
Awk := TAwk.Create;
AWK.FS := ',';

E_Left_Adjusted := 0;
N_Left_Adjusted := 0;
H_Left_Adjusted := 0;
E_right_Adjusted := 0;
N_right_Adjusted := 0;
H_right_Adjusted := 0;

WHILE Awk.Next_Record (Input_File) DO
   BEGIN
   Name := Awk.Field(1);
   N_Left  := Str2Double(Awk.Field(2));
   E_Left  := Str2Double(Awk.Field(3));
   H_Left  := Str2Double(Awk.Field(4));
//   Distance := Str2Double(Awk.Field(5));
   Heading  := Str2Double(Awk.Field(6));
   N_right := Str2Double(Awk.Field(7));
   E_right := Str2Double(Awk.Field(8));
   H_right := Str2Double(Awk.Field(9));
   Tilt     := Str2Double(Awk.Field(10));
   Apply_AZ_SD (N_Left,E_Left,H_Left,DegTorad(Heading+Heading_Adjust),DegTorad(90+Tilt),Height,N_Left_Adjusted,E_Left_Adjusted,H_Left_Adjusted);
   Apply_AZ_SD (N_Right,E_Right,H_Right,DegTorad(Heading+Heading_Adjust),DegTorad(90+Tilt),Height,N_Right_Adjusted,E_Right_Adjusted,H_Right_Adjusted);
   H_Left_Adjusted := H_Left_Adjusted - Height;
   H_Right_Adjusted := H_Right_Adjusted - Height;
   WriteLn(Name,',',N_Left_Adjusted:0:3,',',E_Left_Adjusted:0:3,',',H_Left_Adjusted:0:3,',',N_Right_Adjusted:0:3,',',E_Right_Adjusted:0:3,',',H_Right_Adjusted:0:3);
   END;
CloseFile(Input_File);
END.
