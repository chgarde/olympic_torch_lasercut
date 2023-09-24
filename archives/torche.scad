ep=3;
nb=15;
h=480;
kerf=0.1;
logo_ep=5;

// bagues: [numéro, hauteur, diamètre int, diamètre ext]
bagues_spec=[
    [0,h/2-10,8,16],
    [1,160,16,24],
    [2,100,26,34]
];

module pales(ep){
    rotate([0,5,0]){
    translate([0,-h/2,0]){
        for (i=[0:nb]){
            rotate([0,i*(360/nb),0]) translate([9,0,0]) linear_extrude(height = ep, center = true) import(file = "torche_contour.dxf");
        }
    }
}
}

module pales_cutter(ep){
    difference(){
        children();
        pales(ep-kerf);    
    }
}

module bague(r,ep){
   rotate([-90,0,0]) cylinder(h=ep,r=r,center=true);
}

module mirrorer(v){
    children();
    mirror(v) children();
}


module bagues(ep,seulementInterieur){
    mirrorer([0,1,0]){
        for (s=bagues_spec){
            translate([0,s[1],0]) bague(s[2],ep);
        }
    if (seulementInterieur==false){
        for (s=bagues_spec){
            translate([0,s[1],0]) bague(s[3],ep);
        }
        }
    }
}

module bagues_cutter(ep){
    difference(){
        children();
        bagues(ep-kerf,seulementInterieur=true);    
    }
}


module trouBoite(){
    difference(){
        children();
    for (i=[1:4]){
        translate([0,0,i*10]) boite();
    }
}
}
module trouLogo(){
    difference(){
        children();
    for (i=[1:10]){
        translate([0,0,i*(logo_ep-1)]) logo();
    }
}
    }
module boite(){
    translate([0,-30,-10]) cube([40,120,30],center=true);    
}

module logo(){
    translate([0,65,20]) cube([50,50,logo_ep],center=true);
}


module torche(ep){
    bagues_cutter(ep){
        pales(ep);
    }
}

module torche_cutter(ep){
    difference(){
        children();
        bagues_cutter(ep+kerf){ pales(ep-kerf);}
    }
}

module torche2(){
    trouLogo() trouBoite() torche(ep);
}

// ce module permet d'applatir les coupes en angle afin de récupérer uniquement la plus petite dimension.
module flatteninter(){
    children();
//    intersection(){
//        translate([0,0,ep/2-0.2]) children();
//        translate([0,0,-ep/2+0.2]) children();
//    }
}

module torche2D(){     
    for (i=[0:nb/2-1]){
        //for (i=[0:1]){
         projection(true) translate([(i+1)*120,0,0]) flatteninter() rotate([0,i*(360/nb),0]) torche2();
        }
}


module bagues2D(){
    mirror([1,0,0]){
    for (s=bagues_spec){
        translate([s[0]*50,0,0]){
         projection(true) color("green") rotate([90,0,0]) translate([0,-s[1],0]) torche_cutter(ep) bagues(ep,seulementInterieur=false);
        }
    }
}
}

module plan2D(){
    torche2D();       
    bagues2D();
}

module plan3D(){
    torche2(ep);
    color("green") bagues(ep,seulementInterieur=false);
    color("blue") boite();
    color("red") logo();
}

//plan2D();
plan3D();
