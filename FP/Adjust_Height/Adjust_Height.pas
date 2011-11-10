PROGRAM Adjust_Height;
{$mode delphi}
USES
   Math,
   AWK_Unit,
   Extra_Strings,
   Math_GRK;

procedure Help;
begin
WriteLn(STDERR,'Adjust Height: <Height Adjustment> <Pt,N,E,H FileName>');
WriteLn(STDERR,'');
WriteLn(STDERR,'Adjusts the height in the file');
halt (1);
end;

VAR
   Input_File : TextFile;
   Awk : TAwk;
   Height_Adjustment : DOUBLE;

   Name : STRING;
   N_Current,
   E_Current,
   H_Current : Double;



BEGIN
if paramcount <> 2 then
   begin
   Help;
   end;

Height_Adjustment := Str2Double(paramstr(1));

if (String_Convert_Error <> 0) Or (Height_Adjustment = 0) then
   begin
   WriteLn(STDERR,'Error: Invalid height adjustment');
   Help;
   END;

AssignFile(Input_File,Paramstr(2));
Reset(Input_File);
Awk := TAwk.Create;
AWK.FS := ',';

WHILE Awk.Next_Record (Input_File) DO
   BEGIN
   Name := Awk.Field(1);
   N_Current    := Str2Double(Awk.Field(2));
   E_Current    := Str2Double(Awk.Field(3));
   H_Current    := Str2Double(Awk.Field(4));
   H_Current := H_Current+Height_Adjustment;
   WriteLn(Name,',',N_Current:0:3,',',E_Current:0:3,',',H_Current:0:3);
   END;
CloseFile(Input_File);
END.
