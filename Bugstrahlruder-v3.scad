/*****************************************************************/
/*                   BUGSTRAHLRUDER                              */
/*****************************************************************/

/****** PARAMETER ******/

//Wandstärke von Topf, Deckel, Rohr, ...
wand=1.6;

//Nutbreite = Durchmesser des Dichtrings
nut=3;

//Innenduchmesser des Querrohrs
rohrid=11;

//Länge des Querrohrs
laenge=70;

//Motor Achsdurchmesser
achse=2.0;

//Motordurchmesser
motord=24.5;

//Durchmesser Loch für Motor
motorloch=6.2;

/****** FESTE WERTE ******/

//Durchmesser des Schraublochs für M3 Schraube
schraube=3.2;
//Höhe Motorhalterung
motorh=20;
//Abstand
abstand=1;

/****** ABGELEITETE VARIABLEN ******/

//Aussenduchmesser des Querrohrs
rohrad=rohrid+2*wand;
//Aussenradius des Topfs
topfradius=achse+rohrad+wand;
//Aussenhöhe des Topfs
topfhoehe=wand+rohrad+3; //3=abstand boden + rotordeckel + deckel
rotorradius=topfradius-wand-abstand/2;
rotorhoehe=topfhoehe-wand-abstand;
$fn=100;

/****** DIE BAUTEILE ******/

bugstrahlruder_topf();
translate([0,-4*rohrad,0]) 
    bugstrahlruder_deckel();
translate([4*rohrad,0,0]) 
    bugstrahlruder_rotor(rotorradius, rotorhoehe, achse);


/*****************************************************************/
/* TOPF                                                          */
/*****************************************************************/
module bugstrahlruder_topf()
{
    //Topf
    difference()
    {
        union()
        {
            //Topfmassiv
            cylinder(h=topfhoehe,r=topfradius);
            //Querrohr
            translate([-(0.5*laenge),topfradius-rohrad/2-2*wand,topfhoehe/2])
                rotate(a=[0,90,0])
                    cylinder(h=laenge,d=rohrad);
            //Stütze Querrohr
            translate([-laenge/2,topfradius-rohrad/2-2.5*wand,0]) 
                cube([laenge,wand,topfhoehe/2]);
            //Befestigungsrand
            difference()
            {
                befestigungsrand(topfradius, topfhoehe, wand);
                befestigungsloecher(topfradius, topfhoehe, wand);
            }
        }
        //davon abziehen...
        //Topfinneres
        translate([0,0,wand])
            cylinder(h=topfhoehe-wand,r=topfradius-wand);
        //Querrohrinneres
        translate([-(0.5*laenge),topfradius-rohrad/2-2*wand,topfhoehe/2])
            rotate(a=[0,90,0])
                cylinder(h=laenge,r=rohrad/2-wand);
        //Dichtungsnut
        dichtungsnut();
        //Wellenaufnahme im Boden
        translate([0,0,wand/2]) cylinder(h=wand/2,d=achse+0.2);
    }
}

module befestigungsrand()
{
    hull() 
    {
        translate([0,0,topfhoehe-wand])
            cylinder(h=wand,r=topfradius+nut+schraube+2*wand);
        translate([0,0,topfhoehe-5*wand])
            cylinder(h=wand,r=topfradius);
     }
}

module befestigungsloecher()
{
    for (i = [0:2])
        rotate([0,0,120*i])
            union()
            {
                //Schraubenloch
                translate([0,topfradius+nut+schraube/2+wand,topfhoehe-3*wand])
                    cylinder(h=3*wand,r=schraube/2);
                //Ausschnitt für Mutter M3
                translate([0,topfradius+nut+schraube/2+wand,topfhoehe-5*wand])
                    cylinder(h=4*wand,r=5.5/2/cos(180/6)+0.05,$fn=6);
            }
}

module dichtungsnut()
{
    translate([0,0,topfhoehe-0.8*nut])
        difference()
        {
            cylinder(h=nut,r=topfradius+nut);
            cylinder(h=0.8*nut,r=topfradius);
        }
}


/*****************************************************************/
/* DECKEL                                                        */
/*****************************************************************/
module bugstrahlruder_deckel()
{
    difference()
    {
        union()
        {
            //Deckelscheibe
            cylinder(h=wand,r=topfradius+nut+schraube+2*wand);
            //Kegel zur Verstärkung
            translate([0,0,wand]) 
                cylinder(h=2*wand, r1=topfradius+nut+wand, r2=motord/2);
        }
        //davon abziehen:
        //Schraubenlöcher
        for (i = [0:2])
            rotate([0,0,120*i])
                translate([0,topfradius+nut+schraube/2+wand,0])
                    cylinder(h=wand,d=schraube);
        //Motordurchführung
        cylinder(h=wand,d=motorloch);
    }
    //Motorhalterung
    translate([0,0,wand]) 
        difference()
        {
            union()
            {
                //Motorhalter
                cylinder(h=motorh,d=motord+2*wand);
                //Schraubenhubbel
                 for (i = [0:2]) //3 Hubbel
                    rotate([0,0,120*i]) //jeweils 120°
                        translate([0,motord/2,wand+motorh/2]) //hoch auf hälfte
                            rotate([-90,0,0]) //Kegel flachlegen
                                cylinder(h=2*wand,d1=12,d2=5); //aussen 5mm, innen 12
               
            }
            //inneres
            cylinder(h=motorh,d=motord);
            //Löcher zur Motorbefestigung
            for (i = [0:2]) //3 Löcher
                rotate([0,0,120*i]) //jeweils 120°
                    translate([0,motord/2-wand,wand+motorh/2]) //hoch auf hälfte
                        rotate([-90,0,0]) //cylinder flachlegen
                            cylinder(h=3*wand,d=3); //3mm Loch für M3
        }
}


/*****************************************************************/
/* ROTOR                                                         */
/*****************************************************************/
module bugstrahlruder_rotor(rotorradius, rotorhoehe, achse)
{
    difference()
    {
        union()
        {
            //Rotorscheibe
            cylinder(h=wand,r=rotorradius);
            //Rotorflügel
            for (i = [0:2])
                rotate([0,0,120*i])
                    translate([-wand/2,0,0])
                        cube([wand,rotorradius,rotorhoehe]); 
            //Rotorzentrum
            cylinder(h=rotorhoehe,d=achse+2.5*wand);
        }
        //davon abziehen:
        //Achsloch
        cylinder(h=rotorhoehe,d=achse);
        //Loch für Madenschraube M2
        translate([0,0,3*wand]) //Höhe 2*wand über Rotorscheibe
            rotate([90,0,0]) //cylinder flachlegen
                cylinder(h=achse/2+1.5*wand,d=2); //2mm Loch für M2
    }
}


