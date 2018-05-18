module bugstrahlruder_topf(rohrdurchmesser, breite)
{
    topfradius=achse+rohrdurchmesser+wand;
    topfhoehe=wand+rohrdurchmesser+3; //3=abstand boden + rotordeckel + deckel
    
    //Topf
    difference()
    {
        union()
        {
            //Topfmassiv
            cylinder(h=topfhoehe,r=topfradius,$fn=100);
            //Querrohr
            translate([-(0.5*breite),topfradius-rohrdurchmesser/2,topfhoehe/2])
                rotate(a=[0,90,0])
                    cylinder(h=breite,r=rohrdurchmesser/2,$fn=100);
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
            cylinder(h=topfhoehe-wand,r=topfradius-wand,$fn=100);
        //Querrohrinneres
        translate([-(0.5*breite),topfradius-rohrdurchmesser/2,topfhoehe/2])
            rotate(a=[0,90,0])
                cylinder(h=breite,r=rohrdurchmesser/2-wand,$fn=100);
        //Dichtungsnut
        dichtungsnut(topfradius, topfhoehe);
    }
}

module befestigungsrand(topfradius, topfhoehe, wand)
{
    hull() 
    {
        translate([0,0,topfhoehe-wand])
            cylinder(h=wand,r=topfradius+nut+schraube+wand,$fn=100);
        translate([0,0,topfhoehe-3*wand])
            cylinder(h=wand,r=topfradius,$fn=100);
     }
}

module befestigungsloecher(topfradius, topfhoehe, wand)
{
    for (i = [0:2])
        rotate([0,0,120*i])
            union()
            {
                //Schraubenloch
                translate([0,topfradius+nut+schraube/2+wand/2,topfhoehe-3*wand])
                    cylinder(h=3*wand,r=schraube/2,$fn=100);
                //Ausschnitt für Mutter M3
                translate([0,topfradius+nut+schraube/2+wand/2,topfhoehe-3*wand])
                    cylinder(h=2*wand,r=5.5/2/cos(180/6)+0.05,$fn=6);
            }
}

module dichtungsnut(topfradius, topfhoehe)
{
    translate([0,0,topfhoehe-0.8*nut])
        difference()
        {
            cylinder(h=nut,r=topfradius+nut/2,$fn=100);
            cylinder(h=0.8*nut,r=topfradius-nut/2,$fn=100);
        }
}


module bugstrahlruder_deckel(rohrdurchmesser)
{
    topfradius=achse+rohrdurchmesser+wand;
    topfhoehe=wand+rohrdurchmesser+3; //3=abstand boden + rotordeckel + deckel
    
    difference()
    {
        union()
        {
            //Deckelscheibe
            cylinder(h=wand,r=topfradius+nut+schraube+wand,$fn=100);
            //Wellenhalterung
            translate([0,0,wand])
                cylinder(h=15,r=3+wand,$fn=100);
        }
        //davon abziehen:
        //Schraubenlöcher
        for (i = [0:2])
            rotate([0,0,120*i])
                translate([0,topfradius+nut+schraube/2+wand/2,0])
                    cylinder(h=wand,r=schraube/2,$fn=100);
        //Wellendurchführung
        cylinder(h=15+wand,r=schraube/2,$fn=100);
    }
}


module bugstrahlruder_rotor(rohrdurchmesser)
{
    topfradius=achse+rohrdurchmesser+wand;
    topfhoehe=wand+rohrdurchmesser+3; //3=abstand boden + rotordeckel + deckel
    radius=achse+rohrdurchmesser-0.5;
    hoehe=rohrdurchmesser+3-1; //topfhoehe - wand - 1mm Spalt
    
    difference()
    {
        union()
        {
            //Rotorscheibe
            cylinder(h=wand,r=radius,$fn=100);
            //Rotorflügel
            for (i = [0:2])
                rotate([0,0,120*i])
                    translate([-wand/2,0,0])
                        cube([wand,radius,hoehe]); 
            //Rotorzentrum
            cylinder(h=hoehe,r=achse/2+wand,$fn=100);
        }
        //davon abziehen:
        //Achsloch
        cylinder(h=hoehe,r=achse/2,$fn=100);
    }
}


//Wandstärke von Topf, Deckel, Rohr, ...
wand=2;
//Achsdurchmesser
achse=2;
//Durchmesser des Schraublochs für M3 Schraube
schraube=3.2;
//Nutbreite = Durchmesser des Dichtrings
nut=1.5;

//Aussenduchmesser des Querrohrs
rohr=20;
//Länge des Querrohrs
laenge=70;

//bugstrahlruder_topf(15,50);
bugstrahlruder_topf(rohr,laenge);
translate([0,-3*rohr,0]) bugstrahlruder_deckel(rohr);
translate([3*rohr,0,0]) bugstrahlruder_rotor(rohr);
//translate([0,0,wand+rohr+3]) rotate([0,180,0]) bugstrahlruder_rotor(rohr);
