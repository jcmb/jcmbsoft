UNIT AWK_Unit;
INTERFACE
{$IFDEF MSDOS}
USES
   Delphi; {For AnsiString}
{$ENDIF}

{$MODE DELPHI}
TYPE

   FS_String_Type = STRING[10];

{$IFDEF MSDOS}
   TAWK = OBJECT
{$ELSE}
   TAWK = CLASS (TObject)
{$ENDIF}

   PRIVATE
      Val_FS             : FS_String_Type;

      Current_Line       : AnsiSTRING;
      Number_Of_Fields   : BYTE;
      Number_Of_Records  : CARDINAL;
      Multi_Line_Records : BOOLEAN;

   FUNCTION  Read_Val_RS  : STRING;
   PROCEDURE Write_Val_RS   ( CONST S : STRING);

   PROCEDURE Setup_Awk_Line ( CONST Line : AnsiString);


   PUBLIC
   FUNCTION  Next_Record ( VAR F : TEXTFILE) : BOOLEAN;
             { True if not EOF}
   PROCEDURE New_Awk_Line (CONST Line : STRING);
   FUNCTION  Field (CONST Field_Number : WORD) : STRING;
   PROCEDURE Replace_Field ( CONST Field_Number : BYTE;  New_Value : STRING);
   CONSTRUCTOR Create;
{   DESTRUCTOR  Free; OVERRIDE;}
   PROCEDURE Set_FS (New_Val : FS_String_Type);

{$IFDEF MSDOS}
   FUNCTION NR : CARDINAL;
   FUNCTION NF : BYTE;
   FUNCTION FS : FS_String_Type;
{$ELSE}
   PROPERTY NR : CARDINAL
            READ Number_Of_Records;
   PROPERTY NF : BYTE
            READ Number_Of_Fields;
   PROPERTY FS : FS_String_Type
            READ Val_FS
            WRITE Val_FS;

   PROPERTY RS : STRING
            READ Read_Val_RS
            WRITE Write_Val_RS;
{$ENDIF}
   END;

IMPLEMENTATION
USES
   Extra_Strings;


PROCEDURE Tawk.Setup_Awk_Line( CONST Line : AnsiSTRING);
VAR
   Pos_Value : CARDINAL;
BEGIN
Inc(Number_Of_Records);
Current_Line := Line;
Number_Of_Fields := 1;
IF Length(Val_FS) <> 0 THEN
   BEGIN
   Pos_Value := Pos(Val_FS, Current_Line);
   WHILE Pos_Value <> 0 DO
      BEGIN
      Inc(Number_Of_Fields);
      Delete(Current_Line, 1, Pos_Value);
      Pos_Value := Pos(Val_FS, Current_Line);
      END;
   Current_Line := Line;
   END
ELSE
   BEGIN
   Current_Line := Strip_Blanks(Line);
   Pos_Value := Pos(' ', Current_Line);
   WHILE Pos_Value <> 0 DO
      BEGIN
      Inc(Number_Of_Fields);
      Delete(Current_Line, 1, Pos_Value);
      Current_Line := Trim_Left (Current_Line);
      Pos_Value := Pos(' ', Current_Line);
      END;
   Current_Line := Line;
   END;
END;

PROCEDURE Tawk.New_Awk_Line( CONST Line : STRING);
BEGIN
Setup_Awk_Line(Line);
END;

FUNCTION Tawk.Field ( CONST Field_Number : WORD) : STRING;
VAR
   Temp_Str  : AnsiSTRING;
   Field_Str : AnsiSTRING;
   B         : CARDINAL;
   Pos_Value : CARDINAL;
BEGIN
IF Field_Number = 0 THEN
   BEGIN
   Field := Current_Line;
   END
ELSE
   BEGIN
   IF Length(Val_FS) <> 0 THEN
      BEGIN
      Temp_Str := Current_Line;
      END
   ELSE
      BEGIN
      Temp_Str := Strip_Blanks(Current_Line);
      END;



   FOR B := 1 TO Pred (Field_Number) DO
      BEGIN
      IF Length(Val_FS) <> 0 THEN
         BEGIN
         Pos_Value := Pos(Val_FS, Temp_Str);
         IF Pos_Value <> 0 THEN
            BEGIN
            Delete(Temp_Str, 1, Pos_Value);
            END;
         END
      ELSE
         BEGIN
         Pos_Value := Pos(' ', Temp_Str);
         IF Pos_Value <> 0 THEN
            BEGIN
            Delete(Temp_Str, 1, Pos_Value);
            Temp_Str := Trim_Left (Temp_Str);
            END;
         END;
      END;

   { Here we have the trailing part of the string that may have other
   fields after it}
   IF Val_FS <> '' THEN
      BEGIN
      Pos_Value := Pos(Val_FS, Temp_Str);
      IF Pos_Value <> 0 THEN
         BEGIN
         Field_Str := Copy (Temp_Str, 1, Pred(Pos_Value));
         END
      ELSE
         BEGIN
         Field_Str := Temp_Str;
         END;
      END
   ELSE
      BEGIN
      Pos_Value := Pos(' ', Temp_Str);
      IF Pos_Value <> 0 THEN
         BEGIN
         Field_Str := Copy(Temp_Str, 1, Pred(Pos_Value));
         Temp_Str  := Trim_Left (Temp_Str);
         END
      ELSE
         BEGIN
         Field_Str := Strip_blanks(Temp_Str);
         END;
      END;
   Field := Field_Str;
   END; {Need a field, not Field 0}
END;

(*
FUNCTION Tawk.NR : LONGINT;
BEGIN
NR := Number_Of_Records;
END;

FUNCTION Tawk.NF : BYTE;
BEGIN
NF := Number_Of_Fields;
END;
*)

PROCEDURE Tawk.Replace_Field ( CONST Field_Number : BYTE;  New_Value : STRING);
VAR
   Temp_String : STRING;
   B : BYTE;
BEGIN
IF Field_Number <> 0 THEN
   BEGIN
   Temp_String := '';
   FOR B := 1 TO Pred (Field_Number) DO
      BEGIN
      Temp_String := Temp_String + Self.Field(B) + Val_FS
      END;

   Temp_String := Temp_String + New_Value;

   FOR B := Succ (Field_Number) TO Number_Of_Fields DO
      BEGIN
      Temp_String := Temp_String + Val_FS + Self.Field(B);
      END;

   IF Pos(Val_FS,New_Value) <> 0 THEN
      BEGIN {Have added a extra field, recompute things}
      Self.New_Awk_Line(Temp_String); {This is a copy of what happens with Feild 0}
                                 { Didn't want to recurse ask I don't really need to}
      Dec(Number_of_Records); { Since This is is inced in New Line}
      END
   ELSE
      BEGIN
      Current_Line := Temp_String;
      END;
   END
ELSE
   BEGIN
   Self.New_Awk_Line(New_Value); { This is copied above}
   Dec(Number_of_Records); { Since This is is inced in New Line}
   END;
END;


CONSTRUCTOR Tawk.Create;
BEGIN
{$IFNDEF MSDOS}
INHERITED Create;
{$ENDIF}

Number_Of_Fields  := 0;
Number_Of_Records := 0;
VAL_FS :='';
END;

(*
DESTRUCTOR  Tawk.Free;
BEGIN
Inherited Free;
END;
*)
FUNCTION  Tawk.Read_Val_RS  : STRING;
BEGIN
IF Multi_Line_Records THEN
   BEGIN
   Read_Val_RS := '';
   END
ELSE
   BEGIN
   Read_Val_RS := #13;
   END;
END;

PROCEDURE Tawk.Write_Val_RS ( CONST S : STRING);
BEGIN
Multi_Line_Records := S = '';
END;

FUNCTION  Tawk.Next_Record ( VAR F : TEXTfile) : BOOLEAN;
          { True if not EOF}
VAR
   Temp,
   AnsiS : AnsiString;
   Found_Empty : BOOLEAN;
BEGIN
IF EOF ( F ) THEN
   BEGIN
   Next_Record := FALSE;
   Exit;
   END;

Next_Record := TRUE;
IF NOT Multi_Line_Records THEN
   BEGIN
   ReadLn(F, AnsiS);
   New_Awk_Line(AnsiS);
   END
ELSE
   BEGIN
   Found_Empty := FALSE;
   AnsiS := '';
   WHILE (NOT EOF(F)) AND (NOT Found_Empty) DO
      BEGIN
      Readln(F,Temp);
      IF AnsiS = '' THEN
         BEGIN
         Found_Empty := True;
         END
      ELSE
         BEGIN
         AnsiS := AnsiS + Temp;
         END;
      END;
   New_Awk_Line(AnsiS);
   END;
END;
{$IFDEF MSDOS}
FUNCTION Tawk.NR : CARDINAL;
BEGIN
NR := Number_Of_Records;
END;

FUNCTION Tawk.NF : BYTE;
BEGIN
NF := Number_Of_Fields;
END;

FUNCTION Tawk.FS : FS_String_Type;
BEGIN
FS := Val_FS;
END;
{$ENDIF}

PROCEDURE Tawk.Set_FS (New_Val : FS_String_Type);
BEGIN
Val_FS := New_Val;
END;


END.
