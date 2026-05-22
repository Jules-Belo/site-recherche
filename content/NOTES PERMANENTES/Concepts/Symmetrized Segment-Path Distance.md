---
type: concept
tags: [concept, méthodologie, statistiques, distance, trajectoires]
sources: [Besse et al. (2016), Van Bergen et al. (2025)]
created: 2025-01-08
---
# Symmetrized Segment-Path Distance (SSPD)

La **Symmetrized Segment-Path Distance (SSPD)** constitue une métrique de dissimilarité géométrique permettant la comparaison quantitative de [[Trajectoire|trajectoires]] spatiales, développée par [[Besse et al. (2016)]] dans le contexte de l'analyse de données GPS véhiculaires. Cette distance se définit comme la moyenne symétrique des distances point-vers-trajectoire calculées dans les deux sens : $$D_{SSPD}(T^1, T^2) = \frac{D_{SPD}(T^1, T^2) + D_{SPD}(T^2, T^1)}{2}$$<center>où</center> $$D_{SPD}(T^1, T^2) = \frac{1}{n_1} \sum_{i=1}^{n_1} D_{pt}(p_i^1, T^2)$$représente la distance moyenne de chaque point $p_i$ de la trajectoire $T^1$ vers le segment le plus proche de la trajectoire $T^2$. Cette formulation garantit la propriété de symétrie ($D_{SSPD}(T^1, T^2) = D_{SSPD}(T^2, T^1)$) tout en évitant les limitations des distances de Hausdorff ou de Fréchet, particulièrement sensibles aux valeurs aberrantes. Dans le cadre de l'étude de [[Van Bergen et al. (2025)]] sur la [[créativité motrice]] en [[escalade de bloc olympique]], la SSPD a permis de calculer une matrice de distances $N×N$ entre les 212 trajectoires de hanche enregistrées, constituant ainsi l'input pour le [[clustering hiérarchique]] subséquent. L'avantage majeur de cette métrique réside dans son absence de paramètres additionnels à calibrer, contrairement aux alternatives nécessitant la spécification de grilles de précision (OWD) ou de seuils de tolérance (DTW), tout en maintenant une complexité computationnelle raisonnable en O(n²) adaptée aux jeux de données de taille moyenne rencontrés en biomécanique sportive.

**Voir aussi** : [[Trajectoire]] • [[clustering hiérarchique]] • [[Distance segment-chemin symétrique]]
