---
type: article
title: "Review and Perspective for Distance-Based Clustering of Vehicle Trajectories"
authors: [Philippe C. Besse, Brendan Guillouet, Jean-Michel Loubes, François Royer]
year: 2016
journal: IEEE Transactions on Intelligent Transportation Systems
doi: 10.1109/TITS.2016.2547641
tags: [clustering, trajectoires, distance, véhicules, GPS, SSPD]
status: 🟡 Complémentaire
---

# Review and Perspective for Distance-Based Clustering of Vehicle Trajectories

**Citation complète APA** : Besse, P. C., Guillouet, B., Loubes, J.-M., & Royer, F. (2016). Review and perspective for distance-based clustering of vehicle trajectories. *IEEE Transactions on Intelligent Transportation Systems*, 1-12. https://doi.org/10.1109/TITS.2016.2547641

---

## Typologie de l'article

moc:: [[02 - MOC Créativité et Escalade]] | [[03 - MOC Fatigue et Performance]]
citation:: Besse, P. C., Guillouet, B., Loubes, J.-M., & Royer, F. (2016). Review and perspective for distance-based clustering of vehicle trajectories. *IEEE Transactions on Intelligent Transportation Systems*, 1-12.
type_etude:: Méthodologique | Revue comparative
approche:: Informatique | Mathématique | Data science
mots_cles:: #clustering #trajectoires #distance #géolocalisation #véhicules #SSPD #métriques
pdf:: [[Besse et al. (2016).pdf]]
discipline:: Informatique, Sciences des données, Systèmes de transport intelligents

---

## 📋 Résumé

Cet article propose une revue systématique des distances utilisées pour comparer des trajectoires géolocalisées et introduit une nouvelle distance, la Symmetrized Segment-Path Distance (SSPD). Les auteurs évaluent les performances de différentes métriques de distance appliquées au clustering de trajectoires de véhicules via des méthodes de classification hiérarchique et de propagation d'affinité.

---

## 🎯 Hypothèse(s)

**Hypothèse principale** : Une distance basée sur la forme géométrique des trajectoires (shape-based) plutôt que sur leur indexation temporelle permet un meilleur regroupement des comportements de déplacement similaires.

**Hypothèses secondaires** :
- H1 : Les distances de type warping (DTW, LCSS, EDR, ERP) sont moins adaptées aux trajectoires de véhicules en raison de leur sensibilité au bruit et aux variations temporelles
- H2 : La nouvelle distance SSPD combine les avantages des distances de Hausdorff et OWD sans nécessiter de paramètres additionnels

---

## 🔬 Méthodologie

### Cadre Théorique

**Bases conceptuelles** :
- Théorie des distances métriques et dissimilarités (Deza et al., 2009)
- Analyse de séries temporelles spatiales
- Théorie des graphes pour réseaux routiers

**Construits théoriques centraux** :

| Concept                               | Opérationnalisation proposée                                                                              |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| **Trajectoire discrète**              | Séquence ordonnée de positions $T = ((p₁,t₁),...,(pₙ,tₙ)) où pₖ ∈ ℝ²$ représente une position GPS         |
| **Trajectoire linéaire par morceaux** | Représentation $T_pl = ((s₁),...,(sₙ₋₁))$ où $sₖ$ représente un segment entre deux positions consécutives |
| **Distance métrique**                 | Fonction $d: T×T → ℝ$ satisfaisant positivité, symétrie, identité et inégalité triangulaire               |
| **Exemplaire de cluster**             | Trajectoire $T^{ex}$ minimisant la somme des distances aux autres trajectoires du groupe                  |

### Variables

**VI (Variables Indépendantes)** : Type de distance utilisée (DTW, LCSS, EDR, ERP, Hausdorff, Fréchet, Discrete Fréchet, OWD, SSPD), méthode de clustering (HCA avec différents linkages, Affinity Propagation)

**VD (Variables Dépendantes)** : Critère Within-Like (WC), critère Between-Like (BC), temps de calcul, qualité des clusters obtenus

### Design Expérimental

Étude comparative évaluant 7 distances sur un jeu de données réel (2574 trajectoires de taxis à San Francisco) avec deux méthodes de clustering (HCA et AP). Analyse quantitative via critères BC/WC et validation visuelle des clusters.

### Procédure

Les auteurs ont extrait 2574 trajectoires de taxis partant de la gare Caltrain vers le centre-ville de San Francisco à partir de données GPS publiques. Pour chaque paire de distance/méthode de clustering, ils ont calculé les matrices de distance, appliqué l'algorithme de clustering, puis évalué la qualité via les critères Between-Like et Within-Like. Le package Python "trajectory_distance" a été développé pour implémenter toutes les distances en Python et Cython.

**Participants** : N = 2574 trajectoires de taxis (3 à 39 positions GPS par trajectoire, médiane ~10)

**Mesures** : Temps de calcul, matrices de distance, critères BC/WC, analyse visuelle des partitions

---

## 📊 Résultats Principaux

### Résultat clé 1 : Supériorité des distances shape-based

Les distances basées sur la forme géométrique (Hausdorff, Fréchet, SSPD, OWD) obtiennent des performances significativement supérieures aux distances warping-based (DTW, LCSS, EDR, ERP) pour le clustering de trajectoires véhicules. LCSS obtient les plus mauvais résultats avec un critère WC très élevé.

**Implication** : Les méthodes temporelles ne sont pas adaptées aux données GPS véhicules en raison du bruit inhérent et des variations d'échantillonnage temporel.

### Résultat clé 2 : Performance de la distance SSPD

La nouvelle distance SSPD approche les performances de OWD grid (meilleure distance) sans nécessiter de paramètre de précision de grille. SSPD est une symétrie calculée en $O(n²)$ : $D_SSPD(T¹,T²) = [D_SPD(T¹,T²) + D_SPD(T²,T¹)]/2.$

**Implication** : SSPD offre un bon compromis entre qualité de clustering et simplicité d'utilisation, sans paramétrage spécifique à chaque jeu de données.

### Résultat clé 3 : Efficacité computationnelle

Les distances DTW, LCSS et Discrete Fréchet sont les plus rapides (0.60-0.66s pour 100 trajectoires). Fréchet est la plus lente (268s) en O(n² log n²). SSPD (2.46s) est ~3 fois plus lente que DTW mais 100 fois plus rapide que Fréchet.

**Implication** : SSPD offre un bon équilibre entre temps de calcul et qualité de clustering pour des applications pratiques.

### Résultat clé 4 : Méthode de clustering optimale

HCA-Ward obtient les meilleurs résultats parmi toutes les méthodes HCA testées. Affinity Propagation donne également de bons résultats mais nécessite un nombre minimum de clusters élevé (21-54 selon la distance) et est moins contrôlable.

**Implication** : HCA-Ward avec 10-20 clusters représente la meilleure approche pour partitionner les comportements de déplacement.

### Résultat clé 5 : Sensibilité au paramétrage

OWD grid montre une forte dépendance au paramètre de précision : précision 5 donne des résultats médiocres, précision 7 améliore légèrement précision 6 mais avec un temps de calcul 7× supérieur (52.96s vs 7.44s).

**Implication** : Les distances nécessitant des paramètres additionnels sont moins généralisables d'un contexte à l'autre.

---

## 🌟 Contribution Théorique

### Apports Majeurs

1. **Revue systématique des distances** : Première synthèse comparative exhaustive des métriques de distance pour trajectoires, catégorisées en warping-based vs shape-based
2. **Nouvelle métrique SSPD** : Introduction d'une distance symétrique sans paramètres, combinant avantages de Hausdorff (robustesse au bruit) et OWD (comparaison globale)
3. **Critères d'évaluation adaptés** : Proposition des critères Between-Like et Within-Like pour évaluer la qualité de clustering en l'absence de moyenne calculable

### Positionnement Théorique

L'article se situe à l'intersection de la théorie des distances métriques et de l'analyse de données spatiotemporelles. Il étend les travaux antérieurs sur les distances warping (Berndt et al., 1994; Vlachos et al., 2002) et shape-based (Lin et al., 2005) en démontrant empiriquement que ces dernières sont mieux adaptées aux trajectoires GPS véhicules. La contribution est méthodologique : SSPD n'introduit pas de nouveau paradigme théorique mais optimise les propriétés existantes.

---

## ⚠️ Limites

### Identifiées par les auteurs

1. Choix du nombre de clusters basé sur observation empirique (plateau du critère WC) plutôt que sur un critère statistique formel
2. Validation uniquement visuelle de la cohérence géographique des clusters formés
3. Package Python développé mais nécessitant optimisation pour très grands jeux de données

### Critiques additionnelles

1. **Généralisation limitée** : Évaluation sur un seul jeu de données (taxis San Francisco) avec un cas d'usage spécifique (même origine). Validation nécessaire sur d'autres contextes (zones rurales, différentes densités routières, autres types de véhicules)
2. **Absence de ground truth** : Aucune validation externe des clusters obtenus (pas de comparaison avec des catégories comportementales connues ou des chemins optimaux théoriques)
3. **Biais méthodologique** : Les critères BC/WC utilisent un exemplaire calculé avec la même distance que celle évaluée, créant potentiellement un biais circulaire favorisant certaines distances
4. **Dimension temporelle ignorée** : Le choix délibéré d'ignorer l'indexation temporelle élimine des informations potentiellement utiles (vitesse, accélération, patterns temporels)

---

## 🎯 Pertinence pour l'Étude

### Justification de l'inclusion

Cet article est inclus dans le corpus car il propose une méthodologie de clustering de trajectoires spatiales basée sur des métriques de distance. Bien que développé pour des trajectoires véhicules GPS, le framework théorique (comparaison shape-based vs warping, définition formelle des distances, critères d'évaluation) peut informer l'analyse de trajectoires de mouvements en escalade.

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité)** :
- *Lien indirect* : Si la créativité motrice se manifeste par une variabilité accrue des trajectoires gestuelles, les métriques de distance shape-based pourraient capturer cette diversification. Une analyse pré/post-fatigue des distances moyennes entre trajectoires pourrait quantifier l'augmentation de variabilité.
- *Mécanisme proposé* : Augmentation de la distance intra-cluster (critère WC) sous fatigue si celle-ci induit une exploration gestuelle plus large.

**H2 (Profil psycho → Créativité)** :
- *Lien indirect* : Les profils psychologiques différents pourraient se traduire par des "styles" de mouvements distincts en escalade. Le clustering de trajectoires gestuelles pourrait révéler des patterns comportementaux associés à différents profils.
- *Contribution conceptuelle* : Framework méthodologique pour identifier objectivement des catégories de comportements moteurs à partir de données de mouvement continues.

### Applications méthodologiques

| Sections | Applications |
|----------|-------------|
| **Mesures utilisables** | Adaptation de SSPD aux trajectoires 3D (position main/bassin pendant escalade), calcul de distances entre séquences gestuelles filmées |
| **Design inspirant** | Approche comparative de plusieurs métriques avant sélection finale, validation via clustering hiérarchique avec visualisation des résultats |
| **Pièges à éviter** | Ne pas ignorer systématiquement la dimension temporelle (vitesse/accélération peuvent être pertinents en escalade), nécessité de valider clusters obtenus par expertise externe |

---

## 🔗 Liens Conceptuels

### Articles similaires
- [[Orth et al. (2017)]] : Variabilité fonctionnelle (conceptualisation théorique) vs mesure quantitative de variabilité via distances entre trajectoires
- [[Künzell et al. (2020)]] : Créativité motrice opérationnalisée - potentiel d'utiliser clustering de trajectoires pour identifier patterns créatifs

### Contradictions avec
- Approches temporelles classiques : l'article démontre que les distances warping (DTW, LCSS) performent moins bien que les shape-based pour données GPS, questionnant l'utilité systématique de la dimension temporelle

### Complète/Approfondit
- Littérature sur variabilité motrice : fournit outils quantitatifs pour mesurer variabilité inter- et intra-individuelle de trajectoires gestuelles
- Méthodes d'analyse vidéo en sport : offre alternative computationnelle aux analyses qualitatives expertes

### Lien avec mes Hypothèses

**H1** : Permet quantification objective de l'augmentation de variabilité gestuelle sous fatigue via calcul de distances moyennes entre répétitions.

**H2** : Framework pour identifier clusters comportementaux (profils gestuels) associés à différents profils psychologiques.

**Lien théorique** : Distance comme opérationnalisation de dissimilarité, variabilité comme diversité mesurable, clustering comme identification de patterns comportementaux.

**Gap comblé** : Absence d'outils quantitatifs standardisés pour mesurer variabilité de trajectoires complexes en sciences du mouvement.

---

## 💡 Concepts Clés

### Définitions Opérationnelles

| Concept | Définition de l'article |
|---------|-------------------------|
| **Trajectoire discrète** | Séquence ordonnée T = ((p₁,t₁),...,(pₙ,tₙ)) où pₖ ∈ ℝ² représente une position géolocalisée et tₖ le timestamp associé |
| **Distance métrique** | Fonction d: T×T → ℝ satisfaisant quatre propriétés : d(T¹,T²) ≥ 0, d(T¹,T²) = d(T²,T¹), d(T¹,T¹) = 0, d(T¹,T²) = 0 ⟹ T¹ = T², et inégalité triangulaire d(T¹,T³) ≤ d(T¹,T²) + d(T²,T³) |
| **Symétrie** | Distance satisfaisant positivité, symétrie et identité mais pas nécessairement inégalité triangulaire |
| **SSPD (Symmetrized Segment-Path Distance)** | Distance calculant la moyenne des distances point-vers-trajectoire dans les deux sens : D_SSPD(T¹,T²) = [D_SPD(T¹,T²) + D_SPD(T²,T¹)]/2 où D_SPD(T¹,T²) = (1/n₁) Σᵢ Dₚₜ(pᵢ¹, T²) |
| **Between-Like Criterion (BC)** | Mesure de dispersion inter-clusters : BC = Σₖ D(T^ex_T, T^ex_Cₖ) où T^ex représente l'exemplaire (trajectoire médiane) |
| **Within-Like Criterion (WC)** | Mesure de compacité intra-cluster : WC = Σₖ (1/\|Cₖ\|) ΣTᵢ∈Cₖ D(T^ex_Cₖ, Tᵢ) |

### Citations Majeures

> **Propriétés souhaitées d'une distance pour trajectoires** :
> *"The desired distance should have the following properties: it compares trajectories as a whole, the compared trajectories can be of different lengths, the time indexing can be very different from one trajectory to another, the trajectories can have similar shapes but can be physically far from each other and vice versa, extra parameters should not be required."* (p. 3)

> **Supériorité des distances shape-based** :
> *"These results confirm that shape-based distances are better adapted than warping-based distances for our objectives."* (p. 10)

> **Avantage de SSPD** :
> *"The new distance SSDP is the distance which best approaches the results found with OWD grid, regardless of the number of cluster. But unlike with OWD grid, we do not need to look for the optimal precision parameter."* (p. 10)

---

## Notes pour Rédaction

### Pour l'Introduction

- Mentionner que les méthodes de clustering de trajectoires ont été développées dans divers domaines (transport, écologie animale, sport) avant d'être appliquées à l'escalade
- Introduire distinction fondamentale warping-based vs shape-based distances comme cadre théorique pour choix méthodologique
- Citer Besse et al. (2016) comme référence établissant que les distances géométriques sont plus robustes au bruit que les distances temporelles pour données de mouvement

### Pour la Discussion

- Si nos résultats montrent augmentation de variabilité gestuelle sous fatigue : discuter en lien avec augmentation du critère Within-Like (dispersion intra-cluster accrue)
- Si clustering de trajectoires gestuelles révèle patterns comportementaux : comparer approche quantitative (Besse et al.) vs analyse qualitative experte traditionnelle en escalade
- Discuter limites liées à l'absence de dimension temporelle (vitesse, accélération) qui pourrait être pertinente en escalade contrairement aux trajectoires véhicules

### Limites à mentionner

- Besse et al. développent méthode pour trajectoires 2D GPS alors que mouvements escalade sont 3D avec contraintes biomécaniques spécifiques
- Validation uniquement sur données véhicules (comportements contraints par réseau routier) vs mouvements humains avec degrés de liberté supérieurs
- Choix du nombre de clusters reste subjectif (observation plateau critère WC) - nécessité de développer critère statistique formel pour notre contexte

---

## 📎 Fichiers Associés

- PDF : [[Besse et al. (2016).pdf]]
- Notes d'extraction : *Non disponible*
- Synthèse thématique : [[02 - MOC Créativité et Escalade]]

---

**Date de création** : 2025-01-06
**Dernière modification** : 2025-01-06
**Statut d'analyse** : ✅ Complète