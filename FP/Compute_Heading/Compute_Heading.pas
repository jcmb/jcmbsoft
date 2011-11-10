PROGRAM Compute_Heading;
{$mode delphi}
USES
   Math,
   AWK_Unit,
   Extra_Strings,
   Compute_Heading_Test,
   Math_GRK;

procedure Help;
begin
WriteLn(STDERR,'Compute_Heading: <Pt,N,E,H  FileName>');
WriteLn(STDERR,'');
WriteLn(STDERR,'Compute_Heading for points in a file');
halt (1);
end;

VAR
   Input_File : TextFile;
   Awk : TAwk;
   Previous_Name,
   Name : STRING;
   N_Current,
   E_Current,
   H_Current : Double;
   N_Previous,
   E_Previous,
   H_Previous : Double;
   Distance,
   Heading,
   Heading_Previous,
   Heading_Delta : Double;
   Direction_Change,
   First : BOOLEAN;


BEGIN
if paramcount <> 1 then
   begin
   Help;
   end;

if paramstr(1)= 'TEST' then
   begin
   WriteLn('Running Tests');
   Test_Compute_Heading;
   halt(2);
   END;

AssignFile(Input_File,Paramstr(1));
Reset(Input_File);
Awk := TAwk.Create;
AWK.FS := ',';
First := TRUE;
N_Previous   := 0;
E_Previous   := 0;
H_Previous   := 0;
Heading_Previous := -1;

WHILE Awk.Next_Record (Input_File) DO
   BEGIN
   Name := Awk.Field(1);
   N_Current    := Str2Double(Awk.Field(2));
   E_Current    := Str2Double(Awk.Field(3));
   H_Current    := Str2Double(Awk.Field(4));
   IF NOT First THEN
      BEGIN
      Distance := Compute_Distance_NE(N_Current,E_Current,N_Previous,E_Previous);
      IF Distance > 3 THEN
         BEGIN
         Heading  := RadToDeg(Compute_Heading_NE(N_Current,E_Current,N_Previous,E_Previous));
         IF Heading_Previous = -1 THEN
            BEGIN
            Heading_Delta := 0;
            END
         ELSE
            BEGIN
            Heading_Delta := Heading-Heading_Previous;
            IF Heading_Delta < 0 THEN
               BEGIN
               Heading_Delta := Heading_Delta + 360;
               END;
            END;
         Direction_Change := (Heading_Delta > 90) and (Heading_Delta < 270);
         WriteLn(Name,',',N_Current:0:3,',',E_Current:0:3,',',H_Current:0:3,',',Distance:0:3,',',Heading:0:3, ',', Direction_Change);
         Previous_Name := Name;
         N_Previous   := N_Current;
         E_Previous   := E_Current;
         H_Previous   := H_Current;
         Heading_Previous := Heading;
         END
      ELSE
         BEGIN
{
         WriteLn('Skipping Point: ', Name, ' Last Valid Point ', Previous_Name,' ',Distance:0:3);
         WriteLn(' N: ', N_Current:0:3,'  E:', E_Current:0:3);
         WriteLn(' N: ', N_Previous:0:3,'  E:', E_Previous:0:3);
}
         END;
      END
   ELSE
      BEGIN
      Previous_Name := Name;
      N_Previous   := N_Current;
      E_Previous   := E_Current;
      H_Previous   := H_Current;
      First := FALSE;
      END;
   END;
CloseFile(Input_File);
END.
