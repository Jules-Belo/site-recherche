---
type: concept
tags: [concept, méthodologie, statistiques, clustering, analyse-données]
sources: [Rein et al. (2010), Van Bergen et al. (2025)]
created: 2025-01-08
---
# Méthode Ward

La **méthode Ward** constitue un algorithme de [[clustering hiérarchique]] agglomératif basé sur le principe de minimisation de la variance, développé par Ward (1963) et largement recommandé pour l'analyse de patterns de mouvement en biomécanique (Rein et al., 2010). À chaque étape de l'agrégation, cet algorithme fusionne les deux clusters $C_i$ et $C_j$ qui minimisent l'augmentation de la variance totale intra-cluster, quantifiée par le critère : $$\Delta(C_i, C_j) = \frac{n_i n_j}{n_i + n_j} ||m_i - m_j||^2$$où $n_i$ représente le nombre d'objets dans le cluster $i$, et $m_i$ son centroïde. Cette approche présente l'avantage théorique de produire des clusters compacts et relativement équilibrés en taille, contrairement aux méthodes de linkage simple ou complet sensibles aux chaînages ou aux outliers (Everitt et al., 2001). La robustesse de Ward a été empiriquement validée dans de multiples études comparatives démontrant sa supériorité pour l'identification de patterns coordinatifs distincts (Breckenridge, 2000; Milligan, 1981). Dans le contexte de l'analyse de la [[Créativité motrice]] en escalade, [[Van Bergen et al. (2025)]] ont appliqué la méthode Ward aux matrices de [[Symmetrized Segment-Path Distance|SSPD]] calculées entre trajectoires de hanche, permettant l'identification de classes de solutions motrices statistiquement distinctes et la quantification subséquente de la [[variabilité fonctionnelle]] et de l'[[originalité]] des réponses individuelles.

**Voir aussi** : [[clustering hiérarchique]] • [[dendrogramme]] • [[Score de Hubert-Γ]]
