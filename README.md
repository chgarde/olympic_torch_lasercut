# Torche olympique 2024 à réaliser en découpe laser
# Fête de la science 2023 / Lou Fabiloub / Christophe Garde

## Introduction
Il s'agit ici de préparer une torche olympique en découpe laser dans laquelle on viendra insérer un montage électronique simulant la flamme.

## Etapes

### Etape 1 : Vectorisation
Récupération de l'image en format jpg.
Détourage via gimp en utilisant le ciseau magique, puis "selection to path" > export path > svg.
reprise sous inkscape pour obtenir torche_contour.dxf
On en profite pour exporter le logo svg en dxf aussi en cochant toutes les options. (ROBO-MASTER, LOWPOLY, Flatten Bez, Base Unit=mm)

### Etape 2 : Dessin en 3D et préparation découpe.
Réalisé sous openscad.
Une partie de la complexité est la prise en compte du kerf (largeur du faisceau laser) qu'il faut parfois retirer, parfois ajouter.
Il est important que l'épaisseur soit paramétrable car on ne la connait en général qu'une fois que l'on a la planche de bois sous la main !

### Etape 3 : Réalisation d'une vidéo
Openscad permet de réaliser une vidéo et d'enregistrer toutes les images de celle-ci.
Il suffit ensuite de les rassembler avec ffmpeg :
pour un mp4 :
```ffmpeg -framerate 30 -pattern_type glob -i '*.png'   -c:v libx264 -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" out.mp4```

pour un gif
```ffmpeg -pattern_type glob -i '*.png'  -vsync 2 -safe 0 -loop 0 -y out.gif```


### Etape 4 : Projection en 2D et Planification de la découpe
Assemblage des différents éléments dans inkscape pour faire tenir sur des plaques 500x300mm




