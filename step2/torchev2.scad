a=0; // decalage d'angle.
ep=3.3; // epaisseur du bois
nb=12; // nb de pales
h=480; // hauteur totale
kerf=0.1; // kerf du laser
logo_ep=5; // epaisseur de la plaque logo

profile_file="../step1/out/torche_contour.dxf";
logo_file="../step1/out/Logo_JO_d'été_-_Paris_2024.dxf";

// bagues: [numéro, hauteur, diamètre int, diamètre ext]
bagues_spec=[
    [0,h/2-10,16,20],
    [1,160,16,24],
    [2,100,26,34]
];

module pales(ep){

    translate([0,-h/2,0]){
        for (i=[0:nb]){
            rotate([0,a+i*(360/nb),0]) translate([9,0,0]) linear_extrude(height = ep, center = true) import(file = profile_file);
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
    
        rotate([-90,0,0]) difference(){
            cylinder(h=ep,r=r,center=true);
            cylinder(h=ep+4,r=3,center=true);
        }
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
        for (i=[0:4]){
            translate([0,0,i*10]) hull() boite();
        }
    }
}
module trouLogo(){
    difference(){
        children();
        union(){
        for (i=[1:10]){
            translate([0,0,i*(logo_ep-1)]) logo_plaque();
        }
        translate([0,30,50]) rotate([90,0,0]) cube([50,50,20],center=true);
        }
    }
}


module boite(){
    translate([0,-30,-10])
    difference(){
        cube([50,120,30],center=true);    
            translate([0,0,3]) cube([50-6,120-6,30],center=true);    
    }
}

module logo_plaque(){
    translate([0,65,20]) {
        color("white") cube([50,54,logo_ep],center=true);
        color("red") translate([-23,-27,3]) linear_extrude(1) import(logo_file);
    }

}

module logo_plaque2D(){
    square(50,54);
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
         projection(true) translate([(i+1)*100,0,0]) flatteninter() rotate([0,i*(360/nb)-a,0]) torche2();
        }
}


module bagues2D(){
    mirror([1,0,0]){
    for (s=bagues_spec){
        translate([s[0]*70,0,0]){
         projection(true) color("green") rotate([90,0,0]) translate([0,-s[1],0]) torche_cutter(ep) bagues(ep,seulementInterieur=false);
        }
    }
}
}

module plan2D(){
    torche2D();       
    bagues2D();
    translate([-100,-100,0])logo_plaque2D();
}

module plan3D(){
    torche2();
    color("green") bagues(ep,seulementInterieur=false);
    color("blue") boite();
    logo_plaque();
}


// vue 3D
//difference(){
//plan3D();

// vue 2D bagues + pales
plan2D();

// video
//rotate([0,$t*360,0]) plan3D();
//translate([0,200,0]) cube([100,400,100],center=true);
//}