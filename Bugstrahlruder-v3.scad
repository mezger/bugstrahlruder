/******* BUGSTRAHLRUDER **********/

//Wandstärke von Topf, Deckel, Rohr, ...
wand=1.6;
//Durchmesser des Schraublochs für M3 Schraube
schraube=3.2;
//Nutbreite = Durchmesser des Dichtrings
nut=3; //1.5;

//Aussenduchmesser des Querrohrs
rohr=14;
//Länge des Querrohrs
laenge=70;

//Achsdurchmesser
achse=1.8;
//Motordurchmesser
motord=24.5;
//Höhe Motorhalterung
motorh=20;
//Durchmesser Loch für Motor
motorloch=6.2;

/* abgeleitete Variablen */

//Aussenradius des Topfs
topfradius=achse+rohr+wand;
//Aussenhöhe des Topfs
topfhoehe=wand+rohr+3; //3=abstand boden + rotordeckel + deckel
$fn=100;

bugstrahlruder_topf();
translate([0,-4*rohr,0]) 
    bugstrahlruder_deckel();
translate([4*rohr,0,0]) 
    bugstrahlruder_rotor();

//translate([0,0,wand+rohr+3]) rotate([0,180,0]) bugstrahlruder_rotor();

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
            translate([-(0.5*laenge),topfradius-rohr/2-2*wand,topfhoehe/2])
                rotate(a=[0,90,0])
                    cylinder(h=laenge,d=rohr);
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
        translate([-(0.5*laenge),topfradius-rohr/2-2*wand,topfhoehe/2])
            rotate(a=[0,90,0])
                cylinder(h=laenge,r=rohr/2-wand);
        //Dichtungsnut
        dichtungsnut();
        //Wellenaufnahme im Boden
        //translate([0,0,wand-1]) cylinder(h=1,r=achse/2+0.1);
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
            //Wellenhalterung
            //translate([0,0,wand])
                //cylinder(h=15,r=3+wand,$fn=100);
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
module bugstrahlruder_rotor()
{
    radius=achse+rohr-0.5;
    hoehe=rohr+3-1; //topfhoehe - wand - 1mm Spalt
    
    difference()
    {
        union()
        {
            //Rotorscheibe
            cylinder(h=wand,r=radius);
            //Rotorflügel
            for (i = [0:2])
                rotate([0,0,120*i])
                    translate([-wand/2,0,0])
                        cube([wand,radius,hoehe]); 
            //Rotorzentrum
            cylinder(h=hoehe,r=achse/2+1.5*wand);
        }
        //davon abziehen:
        //Achsloch
        cylinder(h=hoehe,r=achse/2);
        //Loch für Madenschraube M2
        translate([0,0,3*wand]) //Höhe 2*wand über Rotorscheibe
            rotate([90,0,0]) //cylinder flachlegen
                cylinder(h=achse/2+1.5*wand,d=2); //2mm Loch für M2
    }
}


