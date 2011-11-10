unit Extra_Strings;

interface
{$IFDEF MSDOS}
USES
   Delphi;
{$ENDIF}

{$MODE Delphi}

VAR
   String_Convert_Error : INTEGER;

FUNCTION  Trim_Left    ( S : STRING) : STRING;

FUNCTION  Trim_Right   ( S : STRING) : STRING;

FUNCTION  Trim_Zeros   ( S : STRING) : STRING;

FUNCTION  Strip_Blanks ( Const S : STRING) : STRING;

FUNCTION  Pad_Right    ( Const S : STRING; Min_Size : WORD) : STRING;

FUNCTION  Pad_Left     ( Const S : STRING; Min_Size : WORD) : STRING;

FUNCTION  Null_Pad     ( Const S : STRING; Max_Size : WORD) : STRING;

FUNCTION  Spaces       ( N : WORD) : STRING;

FUNCTION  Remove_Quotes ( S : STRING) : STRING;


FUNCTION  Str2Hex      ( CONST S : ShortSTRING) : STRING;
{ Takes a string of any byte value and converts these to a string of hex digits
with a space between each one }

FUNCTION  Str2Bits      ( CONST S : STRING) : STRING;
{ Takes a string of any byte value and converts these to a string of binary digits
with a space between each byte }


PROCEDURE Hex2Bin       ( CONST S : STRING; VAR Bin_String : STRING; Var Err : WORD);
{ Takes a stream of space sepearated hex bytes and converts these to a string
  Error is set to 0 if everyhing worked well. Otherwise it is set to the byte of the
  invalid character. This takes a hex string and makes a string of BYTE value from the hex}

FUNCTION Byte2Bits ( B : BYTE) : STRING;
 { Takes a byte and returns the 0 and 1 for the bytes, LSB is the right most
   item in the string}

FUNCTION Cardinal2Bits ( C : CARDINAL) : STRING;
 { Takes a Cardinal and returns the 0 and 1 for the bytes, LSB is the right most
   item in the string}


FUNCTION  Byte2Hex     ( CONST B : BYTE) : STRING;

FUNCTION  Clean_String  ( S : STRING) : STRING; {Removes unprintable items from the string, replaces them with .}

FUNCTION  Remove_Nulls_String  ( S : STRING) : STRING; {Removes Nulls from the string}

FUNCTION  Clean_String_Hex_Format  ( S : STRING) : STRING;

FUNCTION  Delete_Unprintables ( S : STRING) : STRING;

FUNCTION  Clean_String_Hex_Unprintables  ( S : STRING) : STRING; {Removes unprintable items from the string}

FUNCTION  Remove_Trailing_CR_LF (CONST CR_LF_Term_String : STRING) : STRING;

{$IFDEF MSDOS}
FUNCTION  UpperCase ( S : STRING) : STRING; {Used to be StrUpper}

FUNCTION  LowerCase ( S : STRING) : STRING; {Used to be StrUpper}
{$ENDIF}

FUNCTION  Byte2Str ( CONST B : BYTE ) : String;

FUNCTION  Word2Str ( CONST W : WORD ) : String;

FUNCTION  Integer2Str ( CONST I : INTEGER) : String;

{$IFNDEF MSDOS}
FUNCTION  Smallint2Str ( CONST S : SmallInt) : String;
{$ENDIF}

FUNCTION  Longint2Str ( CONST L : LONGINT) : String;

FUNCTION  Cardinal2Str ( CONST C : Cardinal) : String;

FUNCTION  Int642Str ( CONST I : Int64) : String;

{$IFDEF VER210}
FUNCTION  UInt642Str ( CONST U : UInt64) : String;
{$ENDIF}

FUNCTION  Boolean2Str  ( CONST B : BOOLEAN) : STRING;

FUNCTION  Extended2Str ( CONST E : Extended; CONST DPs : BYTE) : String;

FUNCTION  Real2Str     ( CONST R : Real;     CONST DPs : BYTE) : String;

FUNCTION  Single2Str   ( CONST S : Single;   CONST DPs : BYTE) : String;

FUNCTION  Double2Str   ( CONST D : Double;   CONST DPs : BYTE) : String;

FUNCTION  DecDegrees2Str(D : DOUBLE) : STRING;

FUNCTION  Str2Longint ( CONST S : STRING ) : Longint;

{$IFNDEF MSDOS}
FUNCTION  Str2SmallInt ( CONST S : STRING ) : Smallint;
{$ENDIF}

FUNCTION  HexStr2Byte ( CONST S : STRING ) : Byte;

FUNCTION Str2Byte ( CONST S : STRING ) : Byte;

FUNCTION Str2Real ( CONST S : STRING ) : Real;

FUNCTION Str2Single ( CONST S : STRING ) : Single;

FUNCTION Str2Double ( CONST S : STRING ) : Double;

FUNCTION AngleStr2Double ( S : STRING ) : Double; {Returns Dec degrees}

FUNCTION Str2COMP ( CONST S : STRING ) : COMP;

FUNCTION Str2Extended ( CONST S : STRING ) : Extended;

FUNCTION Str2Cardinal ( CONST S : STRING ) : Cardinal;

FUNCTION Str2Integer ( CONST S : STRING )  : Integer;

FUNCTION Str2Word ( CONST S : STRING )  : Word;

FUNCTION Str2Int64 ( CONST S : STRING )  : Int64;

FUNCTION Reverse_String ( S : STRING ) : STRING;

FUNCTION Spaces_To_Underscores (  S : STRING) : STRING;

FUNCTION Remove_Commas ( S : STRING ) : STRING;

FUNCTION First_Cap ( S : STRING) : STRING;

FUNCTION Valid_Number ( CONST S : STRING) : BOOLEAN;

FUNCTION Process_Leica_Code (CONST Code : STRING) : STRING;

FUNCTION Process_Hex_Code (CONST Code : STRING) : STRING;

FUNCTION Add_Back_Slash (CONST Directory_Name : STRING) : STRING;

FUNCTION ExtractJustFileName  (CONST Path : STRING) : STRING;

FUNCTION ExtractJustFileExt   (CONST Path : STRING) : STRING;

FUNCTION Display_File_Name ( CONST File_Name : STRING; CONST Width : WORD) : STRING;
 { Takes a filename and changes it so it will display in Width Characters}
 { It will show at least Width character of the file name
 If width is more than the filename then the drive information is displaied
 Any remaining characters are used to display the directory path starting from
 the last directory

 Width needs be be something sane, > 7 at least, but really > 12}


{
FUNCTION ForceExtension ( Path : TFileName; Ext : ExtStr) : TFileName;
USE ChangeFileExt instead.
}


implementation
{$IFNDEF MSDOS}
USES
   SysUtils;
{$ENDIF}

FUNCTION First_Cap ( S : STRING) : STRING;
VAR
   I : INTEGER;
   Had_Space : BOOLEAN;
   S_Str : STRING;
BEGIN
Had_Space := TRUE;
{$IFDEF MSDOS}
S := LowerCase(S);
{$ELSE}
S := AnsiLowerCase(Strip_Blanks(S));
{$ENDIF}
FOR I := 1 TO Length(S) DO
   BEGIN
   IF S[I] = ' ' THEN
      BEGIN
      Had_Space := TRUE;
      END
   ELSE
      BEGIN
      IF Had_Space THEN
         BEGIN
         {$IFDEF MSDOS}
         S[I] := UpCase(S[I]

         );
         {$ELSE}
         S_Str := S[I];
         S_Str :=AnsiUpperCase(S_Str);
         S[I] := S_Str[1];
         {$ENDIF}
         Had_Space := FALSE;
         END;
      END;
   END;
First_Cap := S;
END;

FUNCTION Remove_Commas ( S : STRING ) : STRING;
VAR
   W : WORD;
BEGIN
W := 1;
WHILE W <= Length(S) DO
   BEGIN
   IF S[W] =',' THEN
      BEGIN
      Delete(S,W,1);
      END
   ELSE
      BEGIN
      INC(W);
      END;
   END;
Remove_Commas := S;
END;

FUNCTION Reverse_String ( S : STRING ) : STRING;
VAR
   B : WORD;
   Len_S : WORD;
   Temp_Char : CHAR;
   Swap_Location : WORD;
BEGIN {yeah I know Recursion of it would be fun,
      but 128 * 255/2 Char strings is alot of stack }
Len_S := Length(S);
FOR B := 1 TO (Len_S DIV 2) DO
   BEGIN
   Temp_Char := S[B];
   Swap_Location := Succ(Len_S-B);
   S[B] := S[Swap_Location];
   S[Swap_Location] := Temp_Char;
   END;
Reverse_String := S;
END;

FUNCTION Spaces ( N : WORD) : STRING;
VAR
   Temp : STRING;
   B    : WORD;
BEGIN
{$IFDEF MSDOS}
Temp[0] := CHR(N);
{$ELSE}
SetLength (Temp, N);
{$ENDIF}
FOR B := 1 TO N DO
   BEGIN
   Temp[B] := ' ';
   END;
Spaces := Temp;
END;

FUNCTION  Pad_Right ( Const S : STRING; Min_Size : WORD) : STRING;

BEGIN

IF Length (S) < Min_Size THEN
   BEGIN
   Pad_Right := S + Spaces (Min_Size-Length(S));
   END
ELSE
   BEGIN
   Pad_Right := S;
   END;
END;

FUNCTION  Pad_Left ( Const S : STRING; Min_Size : WORD) : STRING;

BEGIN
IF Length (S) < Min_Size THEN
   BEGIN
   Pad_Left := Spaces (Min_Size-Length(S)) + S;
   END
ELSE
   BEGIN
   Pad_Left := S;
   END;
END;

FUNCTION  Null_Pad ( Const S : STRING; Max_Size : WORD) : STRING;
BEGIN
IF Length(S) >= Max_Size THEN
   BEGIN
   Result := Copy(S,1,Max_Size);
   END
ELSE
   BEGIN
   Result := S;
   While Length(Result) < Max_Size DO
      BEGIN
      Result := Result + #0;
      END;
   END;
END;



FUNCTION Trim_Left ( S : STRING ) : STRING;
BEGIN
WHILE LENGTH ( S ) > 0 DO
   BEGIN
   IF S[1] = ' ' THEN
      BEGIN
      Delete (S,1,1);
      END
   ELSE
      BEGIN
      Break;
      END;
   END;
Trim_Left := S;
END;

FUNCTION Trim_Right ( S : STRING ) : STRING;
BEGIN
WHILE LENGTH ( S ) > 0 DO
   BEGIN
   IF S[Length(S)] = ' ' THEN
      BEGIN
      Delete (S, Length(S),1);
      END
   ELSE
      BEGIN
      Break;
      END;
   END;
Trim_Right := S;
END;

FUNCTION Trim_Zeros ( S : STRING ) : STRING;
BEGIN
WHILE LENGTH ( S ) > 0 DO
   BEGIN
   IF S[Length(S)] = #0 THEN
      BEGIN
      Delete (S, Length(S),1);
      END
   ELSE
      BEGIN
      Break;
      END;
   END;
Trim_Zeros := S;
END;

FUNCTION Strip_Blanks ( Const S : STRING ) : STRING;
BEGIN
Strip_Blanks := Trim_Right(Trim_Left(S));
END;


FUNCTION  Byte2Hex     ( CONST B : BYTE) : STRING;
CONST
     Number2Hex : String [16] = '0123456789ABCDEF';

VAR
   High_Nibble : BYTE;
   Low_Nibble  : BYTE;
BEGIN
High_Nibble := B SHR 4;
Low_Nibble  := B AND $0F;

Byte2Hex := Number2Hex[Succ(High_Nibble)] + Number2Hex[Succ(Low_Nibble)]
END;

FUNCTION Byte2Bits ( B : BYTE) : STRING;
VAR
   Bit : BYTE;
   J   : INTEGER;
   S   : STRING;
BEGIN
Bit := 1;
IF (B AND Bit) = 0 THEN
   BEGIN
   S := '0';
   END
ELSE
   BEGIN
   S := '1';
   END;

FOR J := 1 TO 7 DO
   BEGIN
   Bit := 1 SHL j;
   IF (B AND Bit) = 0 THEN
      BEGIN
      S := '0' + S;
      END
   ELSE
      BEGIN
      S := '1' + S;
      END;
   END;
Byte2Bits := S;
END;

FUNCTION Cardinal2Bits ( C : CARDINAL) : STRING;
 { Takes a Cardinal and returns the 0 and 1 for the bytes, LSB is the right most
   item in the string}
BEGIN
Result := '';
Result := Result + Byte2Bits((C SHR 24) AND $FF);
Result := Result + Byte2Bits((C SHR 16) AND $FF);
Result := Result + Byte2Bits((C SHR 8) AND $FF);
Result := Result + Byte2Bits(C AND $FF);
END;

FUNCTION Str2Hex (CONST S : ShortSTRING) : STRING;
VAR
   I : INTEGER;
   Result_Str  : STRING;
BEGIN
Result_Str := '';
FOR I := 1 TO Length (S) DO
   BEGIN
   Result_Str := Result_Str + Byte2hex(ord(S[I])) + ' ';
   END;
Str2Hex := Strip_Blanks(Result_Str);
END;

FUNCTION  Str2Bits      ( CONST S : STRING) : STRING;
{ Takes a string of any byte value and converts these to a string of binary digits
with a space between each byte }
VAR
   I : INTEGER;
   Result_Str  : STRING;
BEGIN
Result_Str := '';
FOR I := 1 TO Length (S) DO
   BEGIN
   Result_Str := Result_Str + Byte2Bits(ord(S[I])) + ' ';
   END;
Str2Bits := Strip_Blanks(Result_Str);
END;



PROCEDURE Hex2Bin       ( CONST S : STRING; VAR Bin_String : STRING; Var ERR : WORD);
VAR
   B          : WORD;
   Val_Code   : INTEGER;
   Val_Number : BYTE;
BEGIN
B := 1;
Err := 255; {Just in case, set to 0 at the end}
Bin_String := '';

WHILE B <= Length (S) DO
   BEGIN
   IF S[B] <> ' ' THEN
      BEGIN
      IF B < Length (S) THEN
         BEGIN
         IF S[B+1] <> ' ' THEN
            BEGIN
            {Have 2 Hex Digits}
            Val('$'+Copy(S,B,2),Val_Number,Val_Code);
            IF val_code <> 0 THEN
               BEGIN
               Err := B;
               Exit;
               END
            ELSE
               BEGIN
               Bin_String := Bin_String + Chr(Val_number);
               B := B + 2;
               END; { Valid VAL }
            END
         ELSE
            BEGIN
            {Have 1 Hex Digits}
            Val('$'+Copy(S,B,1),Val_Number,Val_Code);
            IF val_code <> 0 THEN
               BEGIN
               Err := B;
               Exit;
               END
            ELSE
               BEGIN
               Bin_String := Bin_String + Chr(Val_number);
               Inc(B);
               END;
            END
         END
      ELSE
         BEGIN
         {Have 1 Hex Digit, which is the last on the line}
         Val('$'+Copy(S,B,1),Val_Number,Val_Code);
         IF val_code <> 0 THEN
            BEGIN
            Err := B;
            Exit;
            END
         ELSE
            BEGIN
            Bin_String := Bin_String + chr(Val_number);
            Inc(B);
            END;
         END
      END
   ELSE
      BEGIN
      {Space}
      Inc(B);
      END;
   END;
Err := 0;
END; {Procedure Str2Bin}

FUNCTION Remove_Trailing_CR_LF (CONST CR_LF_Term_String : STRING) : STRING;
BEGIN
Remove_Trailing_CR_LF := CR_LF_Term_String;
IF Length(CR_LF_Term_String) >=2 THEN
   BEGIN {Can't cause any problems with silly strings}
   IF CR_LF_Term_String[Length(CR_LF_Term_String)] = CHR(10) THEN
      BEGIN
      IF CR_LF_Term_String[Length(CR_LF_Term_String)-1] = CHR(13) THEN
         BEGIN
         Remove_Trailing_CR_LF := Copy(CR_LF_Term_String,1,Length(CR_LF_Term_String)-2)
         END;
      END;
   END;
END;


FUNCTION UpperCase ( S : STRING) : STRING;
VAR
   B : WORD;
BEGIN
FOR B := 1 TO LENGTH (S) DO
   BEGIN
   S[B] := UpCase(S[B]);
    END;
UpperCase := S;
END;

FUNCTION LowerCase ( S : STRING) : STRING;
VAR
   B : WORD;
BEGIN
FOR B := 1 TO LENGTH (S) DO
   BEGIN
   IF S[B] IN ['A'..'Z'] THEN
      BEGIN
      S[B] := CHR(ORD(S[B]) + (ORD('a') - ORD('A')));
      END;
   END;
LowerCase := S;
END;

FUNCTION Cardinal2Str ( CONST C : Cardinal) : String;
VAR
   S : ShortSTRING;
BEGIN
Str(C,S);
Cardinal2Str := S;
END;

FUNCTION  Int642Str ( CONST I : Int64) : String;
VAR
   S : STRING;
BEGIN
Str(I,S);
Int642Str := S;
END;

{$IFDEF VER210}
FUNCTION  UInt642Str ( CONST U : UInt64) : String;
VAR
   S : STRING;
BEGIN
Str(U,S);
UInt642Str := S;
END;
{$ENDIF}



FUNCTION Extended2Str ( CONST E : Extended; CONST DPs : BYTE) : String;
VAR
   S : STRING;
BEGIN
Str(E:0:DPs,S);
Extended2Str := S;
END;

FUNCTION Real2Str ( CONST R : REAL; CONST DPs : BYTE) : String;
BEGIN
Real2Str := Extended2Str(R,DPs);
END;

FUNCTION Single2Str ( CONST S : Single; CONST DPs : BYTE) : String;
BEGIN
Single2Str := Extended2Str(S,DPs);
END;


FUNCTION Double2Str ( CONST D : Double; CONST DPs : BYTE) : String;
BEGIN
Double2Str := Extended2Str(D,DPs);
END;




FUNCTION Longint2Str ( CONST L : LONGINT ) : String;
VAR
   S : STRING;
BEGIN
Str(L,S);
Longint2Str := S;
END;

{$IFNDEF MSDOS}
FUNCTION Smallint2Str ( CONST S : SMALLINT ) : String;
VAR
   St : STRING;
BEGIN
Str(S,St);
Smallint2Str := St;
END;
{$ENDIF}


FUNCTION Integer2Str ( CONST I : Integer ) : String;
BEGIN
Integer2Str := Longint2Str(I);
END;

FUNCTION Word2Str ( CONST W : WORD ) : String;
BEGIN
Word2Str := Longint2Str(W);
END;

FUNCTION Byte2Str ( CONST B : BYTE ) : String;
BEGIN
Byte2Str := Longint2Str(B);
END;

FUNCTION Str2Longint ( CONST S : STRING ) : Longint;
VAR
   Code   : INTEGER;
   Res    : Longint;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Longint := Res;
   END
ELSE
   BEGIN
   Str2Longint := 0;
   END;
String_Convert_Error := Code;
END;

{$IFNDEF MSDOS}
FUNCTION Str2Smallint ( CONST S : STRING ) : Smallint;
VAR
   Code   : INTEGER;
   Res    : Smallint;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Smallint := Res;
   END
ELSE
   BEGIN
   Str2Smallint := 0;
   END;
String_Convert_Error := Code;
END;
{$ENDIF}


FUNCTION Str2Real ( CONST S : STRING ) : Real;
VAR
   Code   : INTEGER;
   Res    : Real;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Real := Res;
   END
ELSE
   BEGIN
   Str2Real := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Single ( CONST S : STRING ) : Single;
VAR
   Code   : INTEGER;
   Res    : Single;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Single := Res;
   END
ELSE
   BEGIN
   Str2Single := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Double ( CONST S : STRING ) : Double;
VAR
   Code   : INTEGER;
   Res    : Double;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Double := Res;
   END
ELSE
   BEGIN
   Str2Double := 0;
   END;
String_Convert_Error := Code;
END;


FUNCTION Str2Comp ( CONST S : STRING ) : Comp;
VAR
   Code   : INTEGER;
   Res    : Comp;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Comp := Res;
   END
ELSE
   BEGIN
   Str2Comp := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Extended ( CONST S : STRING ) : Extended;
VAR
   Code   : INTEGER;
   Res    : Extended;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Extended := Res;
   END
ELSE
   BEGIN
   Str2Extended := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Cardinal ( CONST S : STRING ) : Cardinal;
VAR
   Code   : INTEGER;
   Res    : Cardinal;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Cardinal := Res;
   END
ELSE
   BEGIN
   Str2Cardinal := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION HexStr2Byte ( CONST S : STRING ) : Byte;
VAR
   Code   : INTEGER;
   Res    : Byte;

BEGIN
VAL('$'+S,Res,Code);
IF Code = 0 THEN
   BEGIN
   HexStr2Byte := Res;
   END
ELSE
   BEGIN
   HexStr2Byte := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Byte ( CONST S : STRING ) : Byte;
VAR
   Code   : INTEGER;
   Res    : Byte;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Byte := Res;
   END
ELSE
   BEGIN
   Str2Byte := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Integer ( CONST S : STRING ) : Integer;
VAR
   Code   : INTEGER;
   Res    : Integer;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Integer := Res;
   END
ELSE
   BEGIN
   Str2Integer := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Word ( CONST S : STRING ) : Word;
VAR
   Code   : INTEGER;
   Res    : WORD;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Word := Res;
   END
ELSE
   BEGIN
   Str2Word := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION Str2Int64 ( CONST S : STRING ) : Int64;
VAR
   Code   : INTEGER;
   Res    : Int64;

BEGIN
VAL(S,Res,Code);
IF Code = 0 THEN
   BEGIN
   Str2Int64 := Res;
   END
ELSE
   BEGIN
   Str2Int64 := 0;
   END;
String_Convert_Error := Code;
END;

FUNCTION  Valid_Number ( CONST S : STRING ) : BOOLEAN;
VAR
   Code   : INTEGER;
   R,
   Res    : Extended;

BEGIN
{$HINTS OFF}
Code := 0;
Res := 0;
VAL(S,Res,Code);
R := Res;
Res := R; //Stop the compiler complaining
IF Code = 0 THEN
   BEGIN
   Valid_Number := TRUE;
   END
ELSE
   BEGIN
   Valid_Number := FALSE;
   END;
END;


FUNCTION Spaces_To_Underscores (  S : STRING) : STRING;
VAR
   B    : WORD;
BEGIN
FOR B := 1 TO Length(S) DO
   BEGIN
   IF S[B] = ' ' THEN
      BEGIN
      S[B] := '_';
      END;
   END;
Spaces_To_Underscores:= S;
END;

FUNCTION Remove_Quotes ( S : STRING) : STRING;
BEGIN
Remove_Quotes := S;

IF Length(S) < 2 THEN
   BEGIN
   Exit;
   END;

IF S[Length(S)] IN ['''','"','`'] THEN
   BEGIN
   IF S[1] IN ['''','"','`'] THEN
      BEGIN
      Delete(S,Length(S),1);
      Delete(S,1,1);
      Remove_Quotes := S;
      END;
   END;
END;

FUNCTION AngleStr2Double ( S : STRING ) : Double; {Returns Dec degrees}
VAR
   Degrees,
   Minutes : WORD;
   Seconds : DOUBLE;
   DP_Pos  : BYTE;
   Quad    : WORD;
   Add_Degrees : BOOLEAN; {For some quadarants we should subtract the angle}

BEGIN
{AngleStr2Double := 0;}
Minutes := 0;
Seconds := 0.0;
Quad    := 0;
Add_Degrees := TRUE;

S := UpperCase(S);

IF (Pos('N',S) <> 0) OR
   (Pos('S',S) <> 0) OR
   (Pos('E',S) <> 0) OR
   (Pos('W',S) <> 0) THEN
   BEGIN
   IF (Pos('N',S) <> 0) AND
      (Pos('E',S) <> 0) THEN
      BEGIN
      Quad := 0;
      END;
   IF (Pos('N',S) <> 0) AND
      (Pos('W',S) <> 0) THEN
      BEGIN
      Quad := 360;
      Add_Degrees := FALSE;
      END;

   IF (Pos('S',S) <> 0) AND
      (Pos('E',S) <> 0) THEN
      BEGIN
      Quad := 180;
      Add_Degrees := FALSE;
      END;

   IF (Pos('S',S) <> 0) AND
      (Pos('W',S) <> 0) THEN
      BEGIN
      Quad := 180;
      END;

   {These single quadrants are for lats and longs}

   IF Pos('N',S) <> 0 THEN
      BEGIN
      Delete(S,POS('N',S),1);
      Quad := 0;
      END;

   IF Pos('S',S) <> 0 THEN
      BEGIN
      Delete(S,POS('S',S),1);
      Quad := 0;
      Add_Degrees := FALSE;
      END;

   IF Pos('E',S) <> 0 THEN
      BEGIN
      Delete(S,POS('E',S),1);
      Quad := 0;
      END;

   IF Pos('W',S) <> 0 THEN
      BEGIN
      Delete(S,POS('W',S),1);
      Quad := 0;
      Add_Degrees := FALSE;
      END;
   END;

DP_POS := Pos('.',S);

IF DP_POS = 0 THEN
   BEGIN
   Degrees := Str2Word(S);
   END
ELSE
   BEGIN
   Degrees := Str2Word(COPY(S,1,Pred(DP_POS)));
   Delete(S,1,DP_POS);
   S := S + '0000'; {So we always have the MMSS part no mater what}
   Minutes := Str2Word(COPY(S,1,2));
   Delete(S,1,2);
   S := '0.' + S ; {So that we get a decimal for the SSSSSSSS part}
   Seconds := Str2Double(S);
   Seconds := Seconds * 100; {Convert to SS.SSSSSSS}
   END;


IF Add_Degrees THEN
   BEGIN
   AngleStr2Double := Quad + Degrees + (Minutes / 60 ) + ((Seconds / 60) / 60);
   END
ELSE
   BEGIN
   AngleStr2Double := Quad - (Degrees + (Minutes / 60 ) + ((Seconds / 60) / 60));
   END;
END;

FUNCTION DecDegrees2Str(D : DOUBLE) : STRING;
VAR
   Decimal : DOUBLE;
   Minutes,
   Seconds,
   Degrees : WORD;
   Min_Str,
   Sec_Str,
   Deg_Str : STRING;
   Negative : BOOLEAN;
BEGIN
DecDegrees2Str := '';
Negative := D < 0;
D := Abs(D);
Degrees := Trunc(D);
Decimal := Frac(D);
Decimal := Decimal * 60; { Convert to Minutes}
Minutes := Trunc(Decimal);
Decimal := Frac(Decimal);
Decimal := Decimal * 600;
Seconds := Round(Decimal);

IF Seconds >= 600 THEN
   BEGIN
   Seconds := 0;
   Inc(Minutes);
   END;

IF Minutes >= 60 THEN
   BEGIN
   Minutes := 0;
   Inc(Degrees);
   END;

Degrees := Degrees Mod 360;
Deg_Str := Word2Str(Degrees);
Min_Str := Word2Str(Minutes);
Sec_Str := Word2Str(Seconds);

IF Length (Min_Str) = 1 THEN
   BEGIN
   Min_Str := '0' + Min_Str;
   END;

IF Length (Sec_Str) = 1 THEN
   BEGIN
   Sec_Str := '0' + Sec_Str;
   END;

IF Length (Sec_Str) = 2 THEN
   BEGIN
   Sec_Str := '0' + Sec_Str;
   END;

Result := Deg_Str + '.' + Min_Str + Sec_Str;
IF Negative THEN
   BEGIN
   Result := '-'+ Result;
   END;
END;

FUNCTION Delete_Unprintables ( S : STRING) : STRING;
VAR
   W : WORD;
BEGIN
Result := '';
FOR W := 1 TO Length(S) DO
   BEGIN
   IF Ord(S[W]) >= 32 THEN
      BEGIN
      Result := Result + S[W];
      END;
   END;
END;

FUNCTION  Clean_String  ( S : STRING) : STRING; {Removes unprintable items from the string}
VAR
   W : WORD;
BEGIN
FOR W := 1 TO Length(S) DO
   BEGIN
   IF Ord(S[W]) < 32 THEN
      BEGIN
      S[W] := '.';
      END;
   END;

Clean_String := S;
END;

FUNCTION  Remove_Nulls_String  ( S : STRING) : STRING; {Removes Nulls from the string}
VAR
   W : WORD;
BEGIN
FOR W := Length(S) DownTO 1 DO
   BEGIN
   IF Ord(S[W]) = 0 THEN
      BEGIN
      Delete(S,W,1);
      END;
   END;

Remove_Nulls_String := S;
END;

FUNCTION  Clean_String_Hex_Unprintables  ( S : STRING) : STRING; {Removes unprintable items from the string}
VAR
   W : WORD;
BEGIN
Result := '';
FOR W := 1 TO Length(S) DO
   BEGIN
   IF Ord(S[W]) < 32 THEN
      BEGIN
      CASE Ord(S[W]) OF
      2  : Result := Result + '<STX>';
      3  : Result := Result + '<ETX>';
      5  : Result := Result + '<ENQ>';
      6  : Result := Result + '<ACK>';
      10 : Result := Result + '<LF>';
      13 : Result := Result + '<CR>';
      21  : Result := Result + '<NAK>';
      Else
         Result := Result + '<' + Byte2Hex(ord(s[W]))+'>';
         END
      END
   ELSE
      BEGIN
      Result := Result + S[W];
      END
   END;
END;


FUNCTION  Clean_String_Hex_Format  ( S : STRING) : STRING; {Removes unprintable items from the string,
                                                 replaces them whit . Formatting is so that it can line up with a STR2HEX output}
VAR
   W : WORD;
BEGIN
Result := '';
FOR W := 1 TO Length(S) DO
   BEGIN
   IF Ord(S[W]) < 32 THEN
      BEGIN
      CASE Ord(S[W]) OF
      2  : Result := Result + 'STX';
      3  : Result := Result + 'ETX';
      5  : Result := Result + 'ENQ';
      6  : Result := Result + 'ACK';
      10 : Result := Result + 'LF ';
      13 : Result := Result + 'CR ';
      21  : Result := Result + 'NAK';
      Else
         Result := Result + ' . ';
         END
      END
   ELSE
      BEGIN
      Result := Result + ' ' + S[W]+ ' ';
      END
   END;
END;


FUNCTION  Boolean2Str  ( CONST B : BOOLEAN) : STRING;
BEGIN
IF B THEN
   BEGIN
   Boolean2Str := 'True';
   END
ELSE
   BEGIN
   Boolean2Str := 'False';
   END;
END;

FUNCTION Process_Leica_Code (CONST Code : STRING) : STRING;
VAR
   Space_Pos : INTEGER;
   Non_Number   : BOOLEAN;
   String_Index : INTEGER;
BEGIN
IF Length(Code) = 0 THEN
   BEGIN
   Process_Leica_Code := '';
   Exit;
   END;

Process_Leica_Code := code;
Space_Pos := POS(' ',Code);
IF Space_Pos <> 0 THEN
   BEGIN
   Non_Number := FALSE;
   IF Code[1] = ' ' THEN {Deal with the case of a code starting with a space}
      BEGIN
      Non_Number := TRUE;
      END
   ELSE
      BEGIN
      FOR String_Index := 1 TO Pred(Space_Pos) DO
         BEGIN
         Non_Number := Non_Number OR (NOT (code[String_Index] IN ['0'..'9']));
         END;
      END;
   IF NOT Non_Number THEN
      BEGIN {Here we have a code that starts with a number and then has a space, most likely
             with other data after the space that we don't want}
      Process_Leica_Code := Copy(Code,1,Pred(Space_Pos));
      END;
   END
ELSE
   BEGIN
   Process_Leica_Code := Code; {No space pass it though unchanged}
   END;
END;

FUNCTION Process_Hex_Code (CONST Code : STRING) : STRING;
VAR
   Space_Pos : INTEGER;
   Non_Number   : BOOLEAN;
   String_Index : INTEGER;
BEGIN
IF Length(Code) = 0 THEN
   BEGIN
   Process_Hex_Code := '';
   Exit;
   END;

Process_Hex_Code := code;
Space_Pos := POS(' ',Code);
IF Space_Pos <> 0 THEN
   BEGIN
   Non_Number := FALSE;
   IF Code[1] = ' ' THEN {Deal with the case of a code starting with a space}
      BEGIN
      Non_Number := TRUE;
      END
   ELSE
      BEGIN
      FOR String_Index := 1 TO Pred(Space_Pos) DO
         BEGIN
         Non_Number := Non_Number OR (NOT (code[String_Index] IN ['0'..'9','A'..'F','a'..'f']));
         END;
      END;

   IF NOT Non_Number THEN
      BEGIN {Here we have a code that starts with a number and then has a space, most likely
             with other data after the space that we don't want}
      Process_Hex_Code := Copy(Code,1,Pred(Space_Pos));
      END;
   END
ELSE
   BEGIN
   Process_Hex_Code := Code; {No space pass it though unchanged}
   END;
END;

FUNCTION Display_File_Name ( CONST File_Name : STRING; CONST Width : WORD) : STRING;
 { Takes a filename and changes it so it will display in Width Characters}
 { It will show at least Width character of the file name
 If width is more than the filename then the drive information is displaied
 Any remaining characters are used to display the directory path starting from
 the last directory
 Width needs be be something sane, > 7 at least, but really > 12}

VAR
   S,
   Current_Prefix,
   FName,
   FPath : TFileName;
   P,
   Chars_Left : INTEGER;

BEGIN
IF Length (File_Name) <= Width THEN
   BEGIN
   Display_File_Name := File_Name;
   Exit;
   END;

FName := ExtractFileName(File_Name);
Fpath := ExtractFilePath (File_Name);
IF Length(FPath) = 0 THEN
   BEGIN
   IF Length (FName) > (Width) THEN
             { The -3 is to allow use to always put ... at the end}
      BEGIN
      Display_File_Name := Copy(FName,1,Width-3) + '...';
      Exit;
      END
   ELSE
      BEGIN
      Display_File_Name := FName;
      Exit;
      END;
   END
ELSE
   BEGIN
   IF Length (FName) >= (Width -4) THEN
             { The -4 is to allow use to always put ...\ at the front}
      BEGIN
      IF Length(FName) > 3 THEN
         BEGIN
         Display_File_Name := '...\' + Copy(FName,1,Width-7) + '...';
         Exit;
         END
      ELSE
         BEGIN
         Display_File_Name := '...\' + Fname;
         Exit;
         END;
      END;
   END;

{ Here we have a file path that is too long but the filename is smaller than
the width}

Chars_Left:= Width;
Current_Prefix := '';
Chars_Left := Chars_Left - Length(FName) -1; { To allow for the \ before the fname}

IF FPath[1] = '\' THEN
   BEGIN {Either have a \directory\, \filename or \\server\}
   IF Length (FPath) = 1 THEN
      BEGIN {\ Filename} {This shouldn't ever happen}
      Display_File_Name := FPath + FName;
      Exit;
      END;

   IF FPath[2] = '\' THEN
      BEGIN { We have server name}
      S := '\\';
      Delete(Fpath,1,2);
      Dec(Chars_Left,2);
      P := Pos('\',Fpath);
      IF P = 0 THEN
         BEGIN
         IF Chars_Left > Length(FPath) THEN
            BEGIN
            S := S + FPath; { This can't happen}
            END
         ELSE
            BEGIN
            IF Chars_Left >= 3 THEN
               BEGIN
               S := S + '...';
               END
            ELSE
               BEGIN
               S := '...';
               END;
            END;
         Display_File_Name := S + '\' + FName;
         EXIT;
         END
      ELSE
         BEGIN
         IF P > Chars_Left THEN { Server name is to long}
            BEGIN
            Display_File_Name := S + '...\' + FName;
            EXIT;
            END
         ELSE
            BEGIN
            Current_Prefix := S + Copy(FPath,1,P);
            Delete(Fpath,1,P);
            Dec(Chars_Left,P);
            END;
         END;
      END;
   END
ELSE
   BEGIN { We have a \Directory at the start}
   P := Pos('\',Fpath);
   IF P = 0 THEN
      BEGIN
      IF Chars_Left > Length(FPath) THEN
         BEGIN
         S := FPath; { This can't happen}
         END
      ELSE
         BEGIN
         IF Chars_Left >= 3 THEN
            BEGIN
            S := '...';
            END
         ELSE
            BEGIN { This shouldn't happen}
            S := '...';
            END;
         END;
      Display_File_Name := S + '\' + FName;
      EXIT;
      END
   ELSE
      BEGIN
      IF P > Chars_Left THEN { directory name is to long}
         BEGIN
         Display_File_Name := '\...\' + FName;
         EXIT;
         END
      ELSE
         BEGIN
         Current_Prefix := Copy(FPath,1,P);
         Delete(Fpath,1,P);
         Dec(Chars_Left,P);
         END;
      END;
   END;

{Here we may have a prefix, we do have some directorys they do not
 start with a \ but they may have more than one directory}

P := Pos('\',Fpath);
WHILE (P <> 0) AND (P <= (Chars_Left-3)) DO
   BEGIN
   Current_Prefix := Current_Prefix + Copy(FPath,1,P);
   Chars_Left := Chars_Left - P;
   Delete(Fpath,1,p);
   P := Pos('\',Fpath);
   END;

IF (P <> 0) THEN
   BEGIN
   Current_Prefix := Current_Prefix + '...'
   END;

Display_File_Name := Current_Prefix + '\' + FName;
END;

FUNCTION ExtractJustFileName  (CONST Path : STRING) : STRING;
VAR
   Temp_Str : STRING;
   Temp_Pos : Cardinal;
BEGIN
Temp_Str := ExtractFileName(Path);
Temp_Pos := Pos(ExtractFileExt(Temp_Str),Temp_Str);
IF Temp_Pos <> 0 THEN
   BEGIN
   Delete(Temp_Str,Pos(ExtractFileExt(Temp_Str),Temp_Str),255);
   END;
ExtractJustFileName := Temp_Str;
END;

FUNCTION ExtractJustFileExt  (CONST Path : STRING) : STRING;
VAR
   Temp_Str : STRING;
BEGIN
Temp_Str := ExtractFileExt(Path);

IF Temp_Str <> '' THEN
   BEGIN
   Delete(Temp_Str,1,1); { remove the . at the start}
   END;
ExtractJustFileExt := Temp_Str;
END;

FUNCTION Add_Back_Slash (CONST Directory_Name : STRING) : STRING;
{Here because it understands about path styles}
BEGIN
Add_Back_Slash := Directory_Name;

IF Directory_Name = '' THEN
   BEGIN
   EXIT;
   END;

IF Directory_Name[Length(Directory_Name)] IN ['\','/'] THEN
   BEGIN
   EXIT;
   END;

IF Directory_Name[Length(Directory_Name)] = ':' THEN
   BEGIN
   EXIT;
   END;

Add_Back_Slash := Directory_Name + '\';
END;

end.



















