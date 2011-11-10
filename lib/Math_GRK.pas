unit Math_GRK;
{$MODE DELPHI}
{$R+}
{$O+}

interface

FUNCTION EQ_Double (CONST A, B : DOUBLE; CONST Digits: ShortInt) : BOOLEAN;
{ The LLH related stuff was nicked from Bryn Fosburghs, GGK_ENU}

PROCEDURE LLH_ECEF_XYZ ( CONST Lat, Long : Double; { Decimal Degrees}
                         CONST Height    : Double; { Meters}
                         VAR X, Y, Z : DOUBLE);


PROCEDURE LLH_ECEF_Delta ( CONST Rover_X, Rover_Y, Rover_Z,
                           Base_X, Base_Y, Base_Z : DOUBLE;
                           VAR Delta_X, Delta_Y, Delta_Z : DOUBLE);

PROCEDURE Tan_N_E_U    ( CONST Base_Lat, Base_Long : DOUBLE;
                         CONST DX, DY, DZ : DOUBLE;
                         VAR   Tan_N, Tan_E, Tan_U : DOUBLE);

PROCEDURE Sums_to_std_Dev ( CONST Sum, Sum_of_Sqrs : DOUBLE;
                            CONST N : WORD;
                              VAR Mean, Std_Dev    : DOUBLE);


{ The Following are based on information from http://williams.best.vwh.net/avform.htm }

FUNCTION Compute_Heading_LL ( CONST Lat1, Lon1, Lat2, Lon2 : DOUBLE) : DOUBLE;

FUNCTION Compute_Distance_LL ( CONST  Lat1, Lon1, Lat2, Lon2 : DOUBLE) : DOUBLE;

{Geoffrey Stuff}

FUNCTION Compute_Heading_NE ( CONST N1, E1, N2, E2 : DOUBLE) : DOUBLE;

FUNCTION Compute_Tilt_NE ( CONST N1, E1, H1, N2, E2, H2 : DOUBLE) : DOUBLE;

FUNCTION Compute_Distance_NE ( CONST N1, E1, N2, E2 : DOUBLE) : DOUBLE;

PROCEDURE VA_SD_To_HD_VD (CONST VA,SD : Double; VAR HD, VD : DOUBLE);

//VA is 0 at level.
// VD can be negative, HD is always possitive

PROCEDURE AZ_SD_To_dN_dE_dH (CONST AZ,VA,SD : Double; VAR dN, dE, dH : DOUBLE);

PROCEDURE Apply_AZ_SD (CONST N,E,H : Double; CONST AZ,VA,SD : Double; VAR N1, E1, H1 : DOUBLE);

implementation
USES
   MATH;


PROCEDURE Sums_to_std_Dev ( CONST Sum, Sum_of_Sqrs : DOUBLE;
                            CONST N : WORD;
                              VAR Mean, Std_Dev    : DOUBLE);
BEGIN
Mean := Sum/N;
Std_Dev := Sqrt(((N * Sum_Of_Sqrs) - SQR(Sum))/Sqr(n));
END;

//* WGS 84 Semi Major Axis */
CONST
   WGS_84_a = 6378137.0;
//* WGS 84 Inverse of Flattening */
   WGS_84_f1 = 298.257223563;

//* Compute Flattening and Eccentricity */
    WGS_84_f  = 1/WGS_84_f1;
    WGS_84_e2 = 2*WGS_84_f-WGS_84_f * WGS_84_f;

PROCEDURE LLH_ECEF_XYZ ( CONST Lat, Long : Double; { Decimal Degrees}
                         CONST Height    : Double; { Meters}
                         VAR X, Y, Z : Double);
VAR
   Lat_R,
   Long_R  : Double;
   NK      : Double;
   Sin_Lat_R,
   Cos_Lat_R : Double;
BEGIN
LAT_R  := DegToRad(Lat);
LONG_R := DegToRad(LONG);
Sin_Lat_R := sin(LAT_R);

NK := WGS_84_a/sqrt(1-WGS_84_e2*Sqr(sin_LAT_R));
Cos_Lat_R :=  Cos(Lat_R);
X:=(NK+Height)*cos_Lat_R*cos(LONG_R);
Y:=(NK+Height)*cos_Lat_R*sin(LONG_R);
Z:=(NK*(1-WGS_84_e2) + Height)*sin_LAT_R;
END;

PROCEDURE LLH_ECEF_Delta ( CONST Rover_X, Rover_Y, Rover_Z,
                           Base_X, Base_Y, Base_Z : DOUBLE;
                           VAR Delta_X, Delta_Y, Delta_Z : DOUBLE);

BEGIN
Delta_X := Rover_X - Base_X;
Delta_Y := Rover_Y - Base_Y;
Delta_Z := Rover_Z - Base_Z;
END;

PROCEDURE Tan_N_E_U    ( CONST Base_Lat, Base_Long : DOUBLE; { Dec Degrees}
                         CONST DX, DY, DZ : DOUBLE;
                         VAR   Tan_N, Tan_E, Tan_U : DOUBLE);
VAR
   Sin_Long_R,
   Sin_Lat_R,
   Cos_Lat_R,
   Cos_Long_R   : DOUBLE;

BEGIN
Sin_Lat_R := Sin(DegToRad(Base_Lat));
Sin_Long_R := Sin(DegToRad(Base_Long));

Cos_Lat_R := Cos(DegToRad(Base_Lat));
Cos_Long_R := Cos(DegToRad(Base_Long));

Tan_e := -Sin_Lat_R*dx + Cos_LONG_R*dy;
Tan_n := (-sin_LAT_R*cos_LONG_R*dx) - (sin_LAT_R*sin_LONG_R*dy) + (cos_LAT_R)*dz;
Tan_u := cos_LAT_R*cos_LONG_R*dx + cos_LAT_R * sin_LONG_R*dy + sin_LAT_R*dz;
END;

FUNCTION Compute_Heading_LL (CONST Lat1, Lon1, Lat2, Lon2 : DOUBLE) : DOUBLE;
BEGIN
Compute_Heading_LL:=arctan2(sin(lon1-lon2)*cos(lat2),cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lon1-lon2));           
END;

FUNCTION Compute_Distance_LL (CONST Lat1, Lon1, Lat2, Lon2 : DOUBLE) : DOUBLE;
BEGIN
Compute_Distance_LL:=2*arcsin(sqrt((sin((lat1-lat2)/2))**2 + 
                 cos(lat1)*cos(lat2)*(sin((lon1-lon2)/2))**2))
END;


FUNCTION Compute_Heading_NE ( CONST N1, E1, N2, E2 : DOUBLE) : DOUBLE;
var
  dx,dy:double;
begin
  dx := E2 - E1;
  dy := N2 - N1;

  if (dx > 0) then  result := (Pi*0.5) - ArcTan(dy/dx)   else
  if (dx < 0) then  result := (Pi*1.5) - ArcTan(dy/dx)   else
  if (dy > 0) then  result := 0                          else
  if (dy < 0) then  result := Pi                         else
                    result := 0; // the 2 points are equal
end;

FUNCTION Compute_Distance_NE ( CONST N1, E1, N2, E2 : DOUBLE) : DOUBLE;
begin
Compute_Distance_NE:=sqrt(sqr(N1-N2)+sqr(E1-E2));
end;

FUNCTION Compute_Tilt_NE ( CONST N1, E1, H1, N2, E2, H2 : DOUBLE) : DOUBLE;
VAR
   Distance : Double;
   Delta_Height : Double;
BEGIN
Distance := Compute_Distance_NE (N1, E1, N2, E2);
Delta_Height := H2-H1;
IF Distance = 0 THEN
   BEGIN   
   IF Delta_Height < 0 THEN
      BEGIN
      Compute_Tilt_NE := -Pi * 0.5;
      END
	ELSE
      BEGIN
      Compute_Tilt_NE := Pi * 0.5;
      END
    END
ELSE
   BEGIN
//   writeln('tilt_NE: ',Delta_Height:8:8,' ',Distance:8:8, ' ', arcTan(Delta_Height/Distance):8:8 , ' ' , radtodeg(arcTan2(Delta_Height,Distance)):8:8);
   Compute_Tilt_NE := arcTan2(Delta_Height,Distance);
   END;
END;

PROCEDURE VA_SD_To_HD_VD (CONST VA,SD : Double; VAR HD, VD : DOUBLE);
BEGIN
hd:=abs(sd*cos(vA));
vd:=sd*sin(vA);
//WriteLn('Va: ',radtoDeg(VA):0:3,' Hd: ',hd:0:3,' VD: ',vd:0:3)
END;

PROCEDURE AZ_SD_To_dN_dE_dH (CONST AZ,VA,SD : Double; VAR dN, dE, dH : DOUBLE);
VAR
   HD : Double;
BEGIN
VA_SD_To_HD_VD(VA,SD,HD,dH);
dN := cos (Az) * HD;
dE := sin (Az) * HD;
END;

PROCEDURE Apply_AZ_SD (CONST N,E,H : Double; CONST AZ,VA,SD : Double; VAR N1, E1, H1 : DOUBLE);
VAR 
	dN, dE, dH : DOUBLE;
BEGIN
AZ_SD_To_dN_dE_dH(AZ,VA,SD,dN,dE,dH);
N1 := N+dN;
E1 := e+dE;
H1 := h+dH;
END;

FUNCTION EQ_Double (CONST A, B : DOUBLE; CONST Digits: ShortInt) : BOOLEAN;
BEGIN
//WriteLn(abs(A-B):8:8,' ',Digits, ' ', 10.0**Digits);
Result := Abs(A-B)<10.0**Digits;
IF NOT Result THEN
   BEGIN
   WriteLn(a:8:8,' ',b:8:8);
   END;
END;

end.
