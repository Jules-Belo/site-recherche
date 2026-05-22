
### step 1 : vidéo originale

Images utilisées : 101 
Résolution : 2160 × 3840 pixels 
Focale fx, fy : 3332.15, 3345.11 pixels 
Centre optique : (1069.04, 1977.59) pixels 
k1, k2, k3 : +0.252346, -1.312187, +2.171855 p1, p2 : +0.006195, -0.002279 
Erreur reprojection : 0.245 pixels 
Déplacement max : 87.7 pixels
### step 1 : vidéo corrigée

images utilisées : 104 
Résolution : 2160 × 3840 pixels 
Focale fx, fy : 3336.35, 3348.06 pixels 
Centre optique : (1059.51, 2014.69) pixels 
k1, k2, k3 : -0.004700, +0.032474, -0.063817 p1, p2 : +0.002896, -0.001010 
Erreur reprojection : 0.250 pixels 
Déplacement max : 2.5 pixels


## Ce que montrent ces deux calibrations

| Paramètre           | Vidéo originale | Vidéo corrigée | Interprétation            |
| ------------------- | --------------- | -------------- | ------------------------- |
| k1                  | +0.252346       | **-0.004700**  | Distorsion quasi-nulle ✅  |
| Déplacement max     | 87.7 px         | **2.5 px**     | Réduction de 97% ✅        |
| Erreur reprojection | 0.245 px        | 0.250 px       | Qualité identique ✅       |
| Focale fx           | 3332.15         | 3336.35        | Stable (Δ = 4 px, 0.1%) ✅ |
|                     |                 |                |                           |