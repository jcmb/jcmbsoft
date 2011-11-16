UNIT Compute_Heading_Test;

interface

PROCEDURE Test_Compute_Heading;

IMPLEMENTATION

USES
   Math,
   Math_GRK;

{$ASSERTIONS ON}

PROCEDURE Test_Compute_Heading;
VAR
   HD,VD,
   dE,dN,dH : DOUBLE;
BEGIN
Assert(Eq_Double(Compute_Heading_LL(0.592539,2.066470,0.709186,1.287762),1.15003394,-8),'Compute_Heading_LL Failed, 1 ');

Assert(Eq_Double(Compute_Distance_LL(0.592539,2.066470,0.709186,1.287762), 0.62358492,-8),'Compute Distance_LL,1' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,10,0)), 0, 8 ), 'Compute Heading Failed, 1' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,10,10)), 45.0,-8),'Compute Heading Failed, 2' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,0,10)), 90.0,-8),'Compute Heading Failed, 3' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,-10,10)), 135.0,-8),'Compute Heading Failed, 4' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,-10,0)), 180.0,-8),'Compute Heading Failed, 5' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,-10,-10)), 225.0,-8),'Compute Heading Failed, 6' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,0,-10)), 270.0,-8),'Compute Heading Failed, 7' );
Assert(Eq_Double(radtodeg(Compute_Heading_NE(0,0,10,-10)), 315.0,-8),'Compute Heading Failed, 8' );

Assert(Eq_Double(Compute_Distance_NE(0,0,10,0), 10.0,-8),'Compute Distance Failed 1' );
Assert(Eq_Double(Compute_Distance_NE(0,0,10,10), 14.14213562,-8),'Compute Distance Failed 2' );
Assert(Eq_Double(Compute_Distance_NE(0,0,0,10), 10.0,-8) ,'Compute Distance Failed 3' );
Assert(Eq_Double(Compute_Distance_NE(0,0,-10,10), 14.14213562,-8) ,'Compute Distance Failed 4' );
Assert(Eq_Double(Compute_Distance_NE(0,0,-10,0), 10.0,-8) ,'Compute Distance Failed 5' );
Assert(Eq_Double(Compute_Distance_NE(0,0,-10,-10), 14.14213562,-8),'Compute Distance Failed 6' );
Assert(Eq_Double(Compute_Distance_NE(0,0,0,-10),10.0,-8) ,'Compute Distance Failed 7' );
Assert(Eq_Double(Compute_Distance_NE(0,0,10,-10),14.14213562,-8),'Compute Distance Failed 8' );

Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,0,10)), 90.0,-8),'Compute_Tilt_NE Failed 1' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,0,-10)), -90.0,-8),'Compute_Tilt_NE Failed 2' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,0)), 0.0,-8),'Compute_Tilt_NE Failed 3' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,10)), 45.0,-8),'Compute_Tilt_NE Failed 4' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,-10)), -45.0,-8),'Compute_Tilt_NE Failed 5' );

Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,9.84807753,0,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.1' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,6.96364240,6.96364240,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.2' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,6.96364240,-6.96364240,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.3' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,9.84807753,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.4' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,-6.96364240,6.96364240,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.5' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,-9.84807753,0,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.6' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,-6.96364240,-6.96364240,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.7' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,9.84807753,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.8' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,-9.84807753,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.9' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,6.96364240,-6.96364240,1.73648178)),10,-6),'Compute_Tilt_NE Failed 5.10' );


Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,10)),45.0,-6),'Compute_Tilt_NE Failed 5.11' );
//writeln('2: ' , radtodeg(Compute_Tilt_NE(0,0,0,0,10,-10)):8:8);
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,-10)),-45.0,-6),'Compute_Tilt_NE Failed 5.12' );
Assert(Eq_Double(Compute_Tilt_NE(0,0,0,0,0.17452406,9.99847695),degtorad(89),-6),'Compute_Tilt_NE Failed 5.13' );
Assert(Eq_Double(Compute_Tilt_NE(0,0,0,0,0.17452406,-9.99847695),degtorad(-89),-6),'Compute_Tilt_NE Failed 5.14' );

Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,-10)),-45.0,-6),'Compute_Tilt_NE Failed 5.15' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,0,10)),90.0,-6),'Compute_Tilt_NE Failed 5.16' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,0,-10)),-90.0,-6),'Compute_Tilt_NE Failed 5.17' );
Assert(Eq_Double(radtodeg(Compute_Tilt_NE(0,0,0,0,10,0)),0,-6),'Compute_Tilt_NE Failed 5.18' );

HD:=-1;
VD:=-1;

VA_SD_To_HD_VD (degtorad(90),10, HD, VD);
Assert(Eq_Double(HD, 0.0,-8),' VA_SD_To_HD_VD Failed 1.1' );
Assert(Eq_Double(VD, 10.0,-8),' VA_SD_To_HD_VD Failed 1.2' );

VA_SD_To_HD_VD (degtorad(0),10, HD, VD);
Assert(Eq_Double(HD,10.0,-8),' VA_SD_To_HD_VD Failed 2.1' );
Assert(Eq_Double(VD,0.0,-8),' VA_SD_To_HD_VD Failed 2.2' );

VA_SD_To_HD_VD (degtorad(180),10, HD, VD);
Assert(Eq_Double(HD,10.0,-8),' VA_SD_To_HD_VD Failed 3.1' );
Assert(Eq_Double(VD,0.0,-8),' VA_SD_To_HD_VD Failed 3.2' );

VA_SD_To_HD_VD (degtorad(80),10, HD, VD);
Assert(Eq_Double(HD,1.73648178,-8),' VA_SD_To_HD_VD Failed 4.1' );
Assert(Eq_Double(VD,9.84807753,-8),' VA_SD_To_HD_VD Failed 4.2' );

VA_SD_To_HD_VD (degtorad(80),10, HD, VD);
Assert(Eq_Double(HD,1.73648178,-8),' VA_SD_To_HD_VD Failed 5.1' );
Assert(Eq_Double(VD,9.84807753,-8),' VA_SD_To_HD_VD Failed 5.2' );

VA_SD_To_HD_VD (degtorad(100),10, HD, VD);
Assert(Eq_Double(HD,1.73648178,-8),' VA_SD_To_HD_VD Failed 6.1' );
Assert(Eq_Double(VD,9.84807753,-8),' VA_SD_To_HD_VD Failed 6.2' );

VA_SD_To_HD_VD (degtorad(10),10, HD, VD);
Assert(Eq_Double(HD,9.84807753,-8),' VA_SD_To_HD_VD Failed 7.1' );
Assert(Eq_Double(VD,1.73648178,-8),' VA_SD_To_HD_VD Failed 7.2' );

VA_SD_To_HD_VD (degtorad(170),10, HD, VD);
Assert(Eq_Double(HD,9.84807753,-8),' VA_SD_To_HD_VD Failed 8.1' );
Assert(Eq_Double(VD,1.73648178,-8),' VA_SD_To_HD_VD Failed 8.2' );

VA_SD_To_HD_VD (degtorad(-10),10, HD, VD);
Assert(Eq_Double(HD,9.84807753,-8),' VA_SD_To_HD_VD Failed 9.1' );
Assert(Eq_Double(VD,-1.73648178,-8),' VA_SD_To_HD_VD Failed 9.2' );

VA_SD_To_HD_VD (degtorad(350),10, HD, VD);
Assert(Eq_Double(HD,9.84807753,-8),' VA_SD_To_HD_VD Failed 10.1' );
Assert(Eq_Double(VD,-1.73648178,-8),' VA_SD_To_HD_VD Failed 10.2' );

VA_SD_To_HD_VD (degtorad(45),10, HD, VD);
Assert(Eq_Double(HD,7.07106781,-8),' VA_SD_To_HD_VD Failed 11.1' );
Assert(Eq_Double(VD,7.07106781,-8),' VA_SD_To_HD_VD Failed 11.2' );

VA_SD_To_HD_VD (degtorad(-45),10, HD, VD);
Assert(Eq_Double(HD,7.07106781,-8),' VA_SD_To_HD_VD Failed 12.1' );
Assert(Eq_Double(VD,-7.07106781,-8),' VA_SD_To_HD_VD Failed 12.2' );

VA_SD_To_HD_VD (degtorad(-135),10, HD, VD);
Assert(Eq_Double(HD,7.07106781,-8),' VA_SD_To_HD_VD Failed 13.1' );
Assert(Eq_Double(VD,-7.07106781,-8),' VA_SD_To_HD_VD Failed 13.2' );

VA_SD_To_HD_VD (degtorad(135),10, HD, VD);
Assert(Eq_Double(HD,7.07106781,-8),' VA_SD_To_HD_VD Failed 14.1' );
Assert(Eq_Double(VD,7.07106781,-8),' VA_SD_To_HD_VD Failed 14.2' );

dN := -1;
dE := -1;
dH := -1;
   
AZ_SD_To_dN_dE_dH(degtorad(0),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,10,-8),' AZ_SD_To_dN_dE_dH Failed 1.1.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.1.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.1.3' );

AZ_SD_To_dN_dE_dH(degtorad(45),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.2.1' );
Assert(Eq_Double(dE,7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.2.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.2.3' );

AZ_SD_To_dN_dE_dH(degtorad(90),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,00,-8),' AZ_SD_To_dN_dE_dH Failed 1.3.1' );
Assert(Eq_Double(dE,10,-8),' AZ_SD_To_dN_dE_dH Failed 1.3.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.3.3' );


AZ_SD_To_dN_dE_dH(degtorad(135),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,-7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.4.1' );
Assert(Eq_Double(dE,7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.4.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.4.3' );

AZ_SD_To_dN_dE_dH(degtorad(180),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,-10,-8),' AZ_SD_To_dN_dE_dH Failed 1.5.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.5.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.5.3' );

AZ_SD_To_dN_dE_dH(degtorad(225),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,-7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.6.1' );
Assert(Eq_Double(dE,-7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.6.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.6.3' );

AZ_SD_To_dN_dE_dH(degtorad(270),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.7.1' );
Assert(Eq_Double(dE,-10,-8),' AZ_SD_To_dN_dE_dH Failed 1.7.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.7.3' );

AZ_SD_To_dN_dE_dH(degtorad(315),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.8.1' );
Assert(Eq_Double(dE,-7.07106781,-8),' AZ_SD_To_dN_dE_dH Failed 1.8.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 1.8.3' );

AZ_SD_To_dN_dE_dH(degtorad(0),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 2.1.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 2.1.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.1.3' );

AZ_SD_To_dN_dE_dH(degtorad(45),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.2.1' );
Assert(Eq_Double(dE,1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.2.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.2.3' );

AZ_SD_To_dN_dE_dH(degtorad(90),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,00,-8),' AZ_SD_To_dN_dE_dH Failed 2.3.1' );
Assert(Eq_Double(dE,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 2.3.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.3.3' );

AZ_SD_To_dN_dE_dH(degtorad(135),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,-1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.4.1' );
Assert(Eq_Double(dE,1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.4.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.4.3' );

AZ_SD_To_dN_dE_dH(degtorad(180),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,-1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 2.5.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 2.5.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.5.3' );

AZ_SD_To_dN_dE_dH(degtorad(225),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,-1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.6.1' );
Assert(Eq_Double(dE,-1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.6.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.6.3' );

AZ_SD_To_dN_dE_dH(degtorad(270),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,0,-8),' AZ_SD_To_dN_dE_dH Failed 2.7.1' );
Assert(Eq_Double(dE,-1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 2.7.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.7.3' );

AZ_SD_To_dN_dE_dH(degtorad(315),degtorad(80),10,dN,dE,dH);
Assert(Eq_Double(dN,1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.8.1' );
Assert(Eq_Double(dE,-1.22787804,-8),' AZ_SD_To_dN_dE_dH Failed 2.8.2' );
Assert(Eq_Double(dH,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 2.8.3' );

AZ_SD_To_dN_dE_dH(degtorad(0),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 3.1.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 3.1.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.1.3' );

AZ_SD_To_dN_dE_dH(degtorad(45),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.2.1' );
Assert(Eq_Double(dE,6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.2.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.2.3' );

AZ_SD_To_dN_dE_dH(degtorad(90),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,00,-8),' AZ_SD_To_dN_dE_dH Failed 3.3.1' );
Assert(Eq_Double(dE,9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 3.3.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.3.3' );

AZ_SD_To_dN_dE_dH(degtorad(135),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,-6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.4.1' );
Assert(Eq_Double(dE,6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.4.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.4.3' );

AZ_SD_To_dN_dE_dH(degtorad(180),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,-9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 3.5.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 3.5.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.5.3' );

AZ_SD_To_dN_dE_dH(degtorad(225),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,-6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.6.1' );
Assert(Eq_Double(dE,-6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.6.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.6.3' );

AZ_SD_To_dN_dE_dH(degtorad(270),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,0,-8),' AZ_SD_To_dN_dE_dH Failed 3.7.1' );
Assert(Eq_Double(dE,-9.84807753,-8),' AZ_SD_To_dN_dE_dH Failed 3.7.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.7.3' );

AZ_SD_To_dN_dE_dH(degtorad(315),degtorad(10),10,dN,dE,dH);
Assert(Eq_Double(dN,6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.8.1' );
Assert(Eq_Double(dE,-6.96364240,-8),' AZ_SD_To_dN_dE_dH Failed 3.8.2' );
Assert(Eq_Double(dH,1.73648178,-8),' AZ_SD_To_dN_dE_dH Failed 3.8.3' );

AZ_SD_To_dN_dE_dH(degtorad(90),degtorad(0),10,dN,dE,dH);
Assert(Eq_Double(dN,0,-8),' AZ_SD_To_dN_dE_dH Failed 4.1.1' );
Assert(Eq_Double(dE,10,-8),' AZ_SD_To_dN_dE_dH Failed 4.1.2' );
Assert(Eq_Double(dH,0,-8),' AZ_SD_To_dN_dE_dH Failed 4.1.3' );

AZ_SD_To_dN_dE_dH(degtorad(90),degtorad(1),10,dN,dE,dH);
Assert(Eq_Double(dN,00,-8),' AZ_SD_To_dN_dE_dH Failed 4.2.1' );
Assert(Eq_Double(dE,9.99847695,-8),' AZ_SD_To_dN_dE_dH Failed 4.2.2' );
Assert(Eq_Double(dH,0.17452406,-8),' AZ_SD_To_dN_dE_dH Failed 4.2.3' );

AZ_SD_To_dN_dE_dH(degtorad(0),degtorad(1),10,dN,dE,dH);
Assert(Eq_Double(dN,9.99847695,-8),' AZ_SD_To_dN_dE_dH Failed 4.3.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 4.3.2' );
Assert(Eq_Double(dH,0.17452406,-8),' AZ_SD_To_dN_dE_dH Failed 4.3.3' );

AZ_SD_To_dN_dE_dH(degtorad(90),degtorad(-1),10,dN,dE,dH);
Assert(Eq_Double(dN,00,-8),' AZ_SD_To_dN_dE_dH Failed 4.4.1' );
Assert(Eq_Double(dE,9.99847695,-8),' AZ_SD_To_dN_dE_dH Failed 4.4.2' );
Assert(Eq_Double(dH,-0.17452406,-8),' AZ_SD_To_dN_dE_dH Failed 4.4.3' );

AZ_SD_To_dN_dE_dH(degtorad(0),degtorad(-1),10,dN,dE,dH);
Assert(Eq_Double(dN,9.99847695,-8),' AZ_SD_To_dN_dE_dH Failed 4.5.1' );
Assert(Eq_Double(dE,0,-8),' AZ_SD_To_dN_dE_dH Failed 4.5.2' );
Assert(Eq_Double(dH,-0.17452406,-8),' AZ_SD_To_dN_dE_dH Failed 4.5.3' );


END;

END.
