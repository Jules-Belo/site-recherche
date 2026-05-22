---
type: concept
tags: [concept, méthodologie, statistiques, validation, clustering]
sources: [Rein et al. (2010), Van Bergen et al. (2025)]
created: 2025-01-08
---
# Score de Hubert-Γ

Le **score de Hubert-Γ** (gamma) constitue une statistique de validation interne mesurant la concordance entre une matrice de distances observées entre objets et leur partition en clusters obtenue par [[clustering hiérarchique]] (Huber & Arabie, 1985). Formellement, le coefficient s'exprime par : $$\Gamma = \frac{1}{M} \sum_{i<j} (D_{ij} - \bar{D})(C_{ij} - \bar{C})$$où $D$ représente la matrice de distances originales, $C$ la matrice de co-appartenance aux clusters ($C_{ij} = 1$ si $i$ et $j$ appartiennent au même cluster, $0$ sinon), $\bar{D}$ et $\bar{C}$ leurs moyennes respectives, et $M = \frac{n(n-1)}{2}$ le nombre total de paires d'objets ([[Rein et al. (2010)]]). Un coefficient $\Gamma$ élevé indique que les objets proches selon la métrique de distance se retrouvent effectivement regroupés dans les mêmes clusters, tandis que les objets distants sont assignés à des clusters distincts, témoignant ainsi d'une structure de partition cohérente avec la matrice de dissimilarités empiriques. La procédure d'optimisation consiste à tracer $\Gamma$ en fonction du nombre de clusters $k$ : un maximum local ou global signale le nombre optimal de groupes maximisant la compacité intra-cluster et la séparation inter-cluster (Milligan & Cooper, 1985). Cette approche objective permet de dépasser l'inspection visuelle subjective du [[dendrogramme]] en fournissant un critère quantitatif de qualité de partition, particulièrement utile lors de l'analyse de patterns de mouvement complexes où la structure sous-jacente n'est pas connue a priori ([[Van Bergen et al. (2025)]]).

**Voir aussi** : [[clustering hiérarchique]] • [[dendrogramme]] • [[Bootstrap]]
