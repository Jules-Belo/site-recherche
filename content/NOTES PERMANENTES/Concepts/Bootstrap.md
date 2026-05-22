---
type: concept
tags: [concept, méthodologie, statistiques, validation, rééchantillonnage]
sources: [Rein et al. (2010), Efron (1979)]
created: 2025-01-08
---
# Bootstrap

Le **bootstrap** constitue une méthode de rééchantillonnage statistique non paramétrique permettant d'estimer la distribution d'une statistique et d'établir des intervalles de confiance sans hypothèses distributionnelles contraignantes (Efron, 1979). Cette technique génère $B$ échantillons artificiels (typiquement $B \geq 10\,000$) en tirant aléatoirement avec remplacement des observations de l'échantillon original, puis recalcule la statistique d'intérêt sur chacun de ces pseudo-échantillons, construisant ainsi empiriquement sa distribution de probabilité. Dans le contexte de la validation de [[clustering hiérarchique]] pour l'analyse de patterns de mouvement, [[Rein et al. (2010)]] recommandent l'utilisation du test **approximately unbiased (AU)** implémentant un bootstrap multiscale : cette approche évalue la stabilité de chaque cluster en mesurant la probabilité que sa structure persiste sous rééchantillonnages répétés, fournissant des p-values ajustées pour l'inférence statistique formelle. Un cluster avec AU p-value $\geq 0.95$ signale une structure réelle hautement probable, tandis qu'une p-value $< 0.95$ suggère un regroupement potentiellement artefactuel nécessitant une interprétation prudente. L'application du bootstrap aux données de [[Trajectoire|trajectoires]] d'escalade permet ainsi de discriminer objectivement les classes de solutions motrices statistiquement robustes des partitions fortuites résultant du hasard d'échantillonnage, renforçant la validité scientifique des conclusions sur la [[variabilité fonctionnelle]] et la [[créativité motrice]] ([[Van Bergen et al. (2025)]]).

**Voir aussi** : [[clustering hiérarchique]] • [[Score de Hubert-Γ]] • [[dendrogramme]]
