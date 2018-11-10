/******* BUGSTRAHLRUDER **********/

//Wandstärke von Topf, Deckel, Rohr, ...
wand=1.6;
//Achsdurchmesser
achse=2;
//Durchmesser des Schraublochs für M3 Schraube
schraube=3.2;
//Nutbreite = Durchmesser des Dichtrings
nut=3; //1.5;

//Aussenduchmesser des Querrohrs
rohr=14;
//Länge des Querrohrs
laenge=70;


/* abgeleitete Variablen */

//Aussenradius des Topfs
topfradius=achse+rohr+wand;
//Aussenhöhe des Topfs
topfhoehe=wand+rohr+3; //3=abstand boden + rotordeckel + deckel
$fn=100;

bugstrahlruder_topf();
translate([0,-3.5*rohr,0]) bugstrahlruder_deckel();
translate([3.5*rohr,0,0]) bugstrahlruder_rotor();
//translate([0,0,wand+rohr+3]) rotate([0,180,0]) bugstrahlruder_rotor();


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
            translate([-(0.5*laenge),topfradius-rohr/2,topfhoehe/2])
                rotate(a=[0,90,0])
                    cylinder(h=laenge,r=rohr/2);
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
        translate([-(0.5*laenge),topfradius-rohr/2,topfhoehe/2])
            rotate(a=[0,90,0])
                cylinder(h=laenge,r=rohr/2-wand);
        //Dichtungsnut
        dichtungsnut();
        //Wellenaufnahme im Boden
        translate([0,0,wand-1]) cylinder(h=1,r=achse/2+0.1);
    }
}

module befestigungsrand()
{
    hull() 
    {
        translate([0,0,topfhoehe-wand])
            cylinder(h=wand,r=topfradius+nut+schraube+2*wand);
        translate([0,0,topfhoehe-3*wand])
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
                translate([0,topfradius+nut+schraube/2+wand,topfhoehe-3*wand])
                    cylinder(h=2*wand,r=5.5/2/cos(180/6)+0.05,$fn=6);
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


module bugstrahlruder_deckel()
{
    difference()
    {
        union()
        {
            //Deckelscheibe
            cylinder(h=wand,r=topfradius+nut+schraube+2*wand);
            //Wellenhalterung
            translate([0,0,wand])
                cylinder(h=15,r=3+wand,$fn=100);
        }
        //davon abziehen:
        //Schraubenlöcher
        for (i = [0:2])
            rotate([0,0,120*i])
                translate([0,topfradius+nut+schraube/2+wand,0])
                    cylinder(h=wand,r=schraube/2);
        //Wellendurchführung
        cylinder(h=15+wand,r=schraube/2);
    }
}


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
            cylinder(h=hoehe,r=achse/2+wand);
        }
        //davon abziehen:
        //Achsloch
        cylinder(h=hoehe,r=achse/2);
    }
}


