---
type: article
title: "Cluster Analysis of Movement Patterns in Multiarticular Actions: A Tutorial"
authors: [Robert Rein, Chris Button, Keith Davids, Jeffery Summers]
year: 2010
journal: Motor Control
doi: 10.1123/mcj.14.2.211
tags: [cluster_analysis, movement_patterns, methodology, multiarticular_actions, coordination]
status: 🔴 Fondateur
---

# Cluster Analysis of Movement Patterns in Multiarticular Actions: A Tutorial

**Citation complète APA** : Rein, R., Button, C., Davids, K., & Summers, J. (2010). Cluster analysis of movement patterns in multiarticular actions: A tutorial. *Motor Control*, *14*(2), 211-239. https://doi.org/10.1123/mcj.14.2.211

---

## Typologie de l'article

moc:: [[00 - ARTICLES]] | [[02 - MOC Créativité et Escalade]] | [[03 - MOC Fatigue et Performance]]
citation:: Rein, R., Button, C., Davids, K., & Summers, J. (2010). Cluster analysis of movement patterns in multiarticular actions: A tutorial. *Motor Control*, *14*(2), 211-239.
type_etude:: Méthodologique | Tutoriel avec cas d'études expérimentales
approche:: Biomécanique | Statistique | Analyse de patterns moteurs
mots_cles:: #cluster_analysis #movement_patterns #coordination #kinematics #validation_methods #hierarchical_clustering #multiarticular_actions
pdf:: [[Rein et al. (2010).pdf]]
discipline:: Sciences du mouvement, Biomécanique, Analyse statistique du mouvement

---

## 📋 Résumé

Cet article propose une méthode d'analyse technique pour extraire l'information sur les patterns de mouvement dans les études de contrôle moteur, basée sur l'analyse en clusters de la cinématique du mouvement. Trois expériences sont présentées pour exemplifier et valider cette méthode technique appliquée aux actions multiarticulaires complexes.

---

## 🎯 Hypothèse(s)

**Nature de l'article** : Article méthodologique tutoriel sans hypothèses formelles testées, mais avec trois cas d'études de validation.

**Objectifs** :
- O1 : Proposer un cadre général pour l'application de l'analyse en clusters aux données de coordination motrice
- O2 : Démontrer la capacité de l'analyse en clusters à identifier et quantifier les patterns dans les actions multiarticulaires
- O3 : Valider la méthode à travers trois expériences utilisant des connaissances a priori comme référence

---

## 🔬 Méthodologie

### Cadre Théorique

**Bases conceptuelles** :
L'analyse en clusters est historiquement développée pour identifier des patterns dans des jeux de données à haute dimension. L'article s'appuie sur les travaux antérieurs appliquant cette méthode à divers mouvements sportifs (marche, natation, saut en longueur, handball, golf, soccer).

**Construits théoriques centraux** :

| Concept                      | Opérationnalisation proposée                                                                                           |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Pattern de mouvement**     | Série temporelle des angles articulaires ou forces, normalisées et organisées en matrices (objets × variables × temps) |
| **Similarité/dissimilarité** | Distance euclidienne entre matrices de patterns de mouvement (norme de Frobenius de la matrice de différence)          |
| **Cluster**                  | Groupement hiérarchique d'objets (essais) basé sur leurs distances mutuelles                                           |
| **Validation de cluster**    | Combinaison de tests (Hubert-Γ, approximately unbiased test) pour vérifier la qualité et la stabilité du regroupement  |

### Variables

Le cadre méthodologique proposé comprend :

**Variables d'entrée** : 
- Séries temporelles d'angles articulaires ou de forces
- Normalisées temporellement (même nombre de frames)
- Organisées en matrice (M variables × N points temporels × essais)

**Variables de sortie** :
- Dendrogramme hiérarchique
- Nombre optimal de clusters
- P-values de validation (bootstrap)
- Scores de Hubert-Γ

### Design Expérimental

Trois expériences de validation sont présentées :

**Expérience 1** : Techniques de tir au basketball (4 joueurs professionnels)
- 3 techniques : lancers francs (4.6m), tirs à 3 points (6.5m), tirs en crochet (4m)
- Solution attendue : 3 clusters

**Expérience 2** : Tâche cyclique de supination-pronation des poignets (1 participant)
- Fréquence de mouvement augmentant de 1 Hz à 2.5 Hz par paliers de 0.25 Hz
- Solution attendue : transition antiphase → en phase

**Expérience 3** : Tirs en crochet au basketball avec contrainte de distance (2 joueurs professionnels)
- Distances : 2m à 9m
- Contrainte structurelle : plafond bas (4.5m) limitant la trajectoire de balle
- Solution attendue : 2 clusters (courte vs longue distance)

### Procédure

**Étapes générales de la méthode proposée** :

1. **Prétraitement des données**
   - Choix des variables d'entrée (angles articulaires, forces)
   - Normalisation temporelle (points de coupe fiables)
   - Standardisation si nécessaire (éviter z-scores naïfs)

2. **Calcul des distances**
   - Distance euclidienne (généralisation du NoRMS)
   - Matrice de distance D (symétrique, N×N essais)

3. **Analyse en clusters**
   - Algorithme hiérarchique agglomératif
   - Méthode recommandée : average linkage ou Ward
   - Production du dendrogramme

4. **Validation**
   - Hubert-Γ statistic (compacité des clusters)
   - Approximately unbiased test (stabilité par bootstrap multiscale)
   - 10,000-20,000 itérations de bootstrap

---

## 📊 Résultats Principaux

### Résultat clé 1 : Validation sur techniques de basketball distinctes (Exp. 1)

L'analyse en clusters a clairement distingué les trois techniques de tir pour tous les participants. Pour 3 participants, les lancers francs et tirs à 3 points formaient des sous-clusters similaires, distincts des tirs en crochet. Le participant 4 utilisait une technique de "jump-hook" similaire au tir en suspension, expliquant un regroupement différent.

**Implication** : L'analyse en clusters identifie efficacement les différences entre techniques motrices distinctes avec validation statistique (p < 0.05).

### Résultat clé 2 : Sensibilité à la normalisation des données (Exp. 1, participant 2)

Avec données angulaires brutes : solution à 3 clusters. Avec normalisation z-score : solution à 4 clusters différente. La normalisation a réduit les différences de bras droit entre techniques, amplifiant l'importance d'autres segments moins variables.

**Implication** : Le choix du schéma de normalisation impacte significativement les résultats ; la normalisation doit être justifiée théoriquement selon la question de recherche.

### Résultat clé 3 : Équivalence avec l'analyse de phase relative (Exp. 2)

L'analyse en clusters a produit une solution à 3 clusters correspondant exactement aux patterns identifiés par l'analyse conventionnelle de phase relative discrète (DRP) : patterns antiphase stables, transition, patterns en phase stables.

**Implication** : L'analyse en clusters peut substituer ou compléter les méthodes d'analyse conventionnelles pour les mouvements cycliques.

### Résultat clé 4 : Identification de différences inter-individuelles (Exp. 3)

- Participant 1 : 2 clusters nets (courte vs longue distance, Hubert-Γ max à 2)
- Participant 2 : 6 clusters graduels (adaptation progressive, Hubert-Γ et p-values plus faibles)

**Implication** : La méthode est assez sensible pour révéler des stratégies individuelles distinctes (transition nette vs adaptation graduelle).

### Résultat clé 5 : Importance de la validation statistique

Les tests de validation (Hubert-Γ, AU test) ont systématiquement confirmé ou affiné le nombre optimal de clusters, évitant l'acceptation naïve de regroupements artefactuels.

**Implication** : La validation est obligatoire pour éviter les interprétations erronées des résultats de clustering.

---

## 🌟 Contribution Théorique

### Apports Majeurs

1. **Cadre méthodologique standardisé** : Premier tutoriel complet proposant un framework général pour l'analyse en clusters appliquée aux données de contrôle moteur, avec étapes détaillées de prétraitement, clustering et validation.

2. **Démonstration de polyvalence** : L'article démontre l'applicabilité de la méthode à des modèles de mouvement très différents (actions discrètes multiarticulaires, mouvements cycliques bilatéraux, adaptations à des contraintes scalaires).

3. **Intégration d'outils de validation robustes** : Introduction dans le domaine du contrôle moteur de méthodes de validation sophistiquées (approximately unbiased test avec bootstrap multiscale, Hubert-Γ statistic) issues de la bio-informatique.

### Positionnement Théorique

L'article se positionne en **complémentarité** avec les approches existantes (PCA, UCM). Les auteurs proposent l'analyse en clusters comme première étape d'une chaîne d'analyse multi-outils : clustering → séparation des patterns → application de PCA ou UCM sur chaque pattern séparément. Cette approche multiniveau permet d'éviter les biais dus à l'agrégation de patterns hétérogènes (ex : problème de linéarisation du Jacobien dans UCM avec patterns très différents).

---

## ⚠️ Limites

### Identifiées par les auteurs

1. **Sensibilité aux points de coupe** : Les erreurs dans le choix des points de début/fin de mouvement pour la normalisation temporelle peuvent introduire des différences artefactuelles (erreurs d'offset et de pente multipliées).

2. **Dépendance à la normalisation** : Le choix du schéma de normalisation (brut, z-score, range) introduit un biais de pondération des variables qui peut altérer les résultats.

3. **Nature non réversible de l'algorithme** : Les algorithmes hiérarchiques agglomératifs ne peuvent défaire les regroupements des étapes précédentes, pouvant conduire à des solutions sous-optimales.

### Critiques additionnelles

1. **Arbitraire dans le choix des variables d'entrée** : L'article mentionne que le choix doit être guidé par la théorie, mais ne fournit pas de critères objectifs pour la sélection.

2. **Généralisation limitée des expériences de validation** : Toutes les expériences utilisent des mouvements de sport (basketball, tâches motrices de laboratoire) avec des participants experts, limitant la généralisation à d'autres populations ou contextes.

3. **Absence de comparaison systématique avec d'autres méthodes** : Bien que mentionnant PCA et UCM, l'article ne compare pas systématiquement les résultats obtenus par ces différentes approches sur les mêmes données.

4. **Complexité d'interprétation pour le praticien** : La méthode requiert des compétences statistiques avancées, limitant potentiellement son adoption par les praticiens du terrain.

---

## 🎯 Pertinence pour l'Étude

### Justification de l'inclusion

Cet article est **fondateur** pour le corpus car il fournit un cadre méthodologique complet pour analyser les patterns de mouvement complexes en escalade. L'analyse en clusters pourrait permettre d'identifier et quantifier objectivement les différents styles de grimpe ou stratégies créatives adoptées par les grimpeurs sous différentes conditions de fatigue ou selon leurs profils psychologiques.

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité)** :
- L'analyse en clusters permet d'identifier si la fatigue induit des transitions entre patterns de mouvement distincts (comme dans l'Exp. 3) ou des adaptations graduelles (comme pour le participant 2).
- Mécanisme proposé : Si la fatigue provoque une perte de flexibilité motrice, on devrait observer une réduction du nombre de clusters utilisés et une augmentation de la dissimilarité intra-cluster (variabilité moins fonctionnelle).

**H2 (Profil psycho → Créativité)** :
- La méthode peut révéler des différences inter-individuelles dans les répertoires moteurs (nombre de patterns disponibles) en fonction des traits psychologiques.
- Contribution conceptuelle : Les grimpeurs plus ouverts à l'expérience ou plus tolérants à l'ambiguïté pourraient disposer d'un répertoire plus large de patterns (plus de clusters), reflétant une variabilité fonctionnelle.

### Applications méthodologiques

| Sections | Applications |
|----------|--------------|
| **Mesures utilisables** | - Angles articulaires des membres inférieurs et supérieurs lors de séquences d'escalade<br>- Séries temporelles de forces appliquées sur prises<br>- Validation par Hubert-Γ et AU test (10,000+ bootstrap) |
| **Design inspirant** | - Approche par scaling (distance à la prise suivante, difficulté croissante)<br>- Design intra-sujet avec connaissance a priori pour validation<br>- Combinaison analyse quantitative (clusters) + qualitative (inspection des patterns) |
| **Pièges à éviter** | - Éviter normalisation z-score naïve sans justification théorique<br>- S'assurer de la fiabilité des points de coupe pour normalisation temporelle<br>- Ne JAMAIS interpréter sans validation statistique<br>- Vérifier que les essais ne diffèrent pas > 30% en durée avant normalisation |

---

## 🔗 Liens Conceptuels

### Articles similaires
- [[Schöllhorn et al. (2002)]] : Application de l'analyse en clusters aux patterns de marche (base méthodologique)
- [[Ball and Best (2007)]] : Cluster analysis dans le golf avec stratégies de validation multiples
- [[Chow et al. (2008)]] : Analyse de patterns moteurs complexes en soccer kicking avec données longitudinales

### Complète/Approfondit
- [[Newell (1986)]] : Modèle de contraintes - le clustering permet d'identifier les solutions émergentes sous différentes contraintes
- [[Davids et al. (2003)]] : Variabilité fonctionnelle - les clusters peuvent représenter des solutions stables dans le paysage de coordination
- [[Kelso (1995)]] : Dynamique des patterns - l'analyse en clusters peut compléter l'analyse de phase relative pour identifier les transitions

### Contradictions avec
- *Aucune contradiction majeure identifiée* : l'article se positionne explicitement en complémentarité avec les approches existantes

### Lien avec mes Hypothèses

**H1** : La méthode permettrait de tester si la fatigue induit des changements qualitatifs (changement de cluster) vs quantitatifs (variation intra-cluster) dans les patterns moteurs créatifs.

**H2** : L'analyse en clusters pourrait révéler que les profils psychologiques influencent la taille du répertoire moteur (nombre de clusters) plutôt que la qualité intrinsèque de chaque pattern.

**Lien théorique** : [[variabilité fonctionnelle]], [[Flexibilité motrice]], [[Contraintes sur l'action]], [[Affordances]]

**Gap comblé** : Fournit un outil objectif pour quantifier la diversité des réponses motrices créatives, au-delà des mesures de performance brutes.

---

## 💡 Concepts Clés

### Définitions Opérationnelles

| Concept | Définition de l'article |
|---------|-------------------------|
| **Cluster analysis (analyse en clusters)** | Technique d'exploration de données qui groupe itérativement des objets en clusters de taille croissante basés sur leurs similarités mutuelles, produisant un dendrogramme hiérarchique |
| **Dendrogram (dendrogramme)** | Arbre hiérarchique résultant de l'analyse en clusters, où la hauteur de fusion entre clusters indique leur degré de dissimilarité |
| **Distance matrix (matrice de distance)** | Matrice symétrique N×N contenant les distances euclidiennes entre toutes les paires d'essais (dij = distance entre essai i et j) |
| **Frobenius norm** | Norme matricielle calculant la racine carrée de la somme des carrés de toutes les différences point-à-point entre deux matrices de patterns de mouvement |
| **Time normalization (normalisation temporelle)** | Procédure standardisant tous les essais au même nombre de frames (typiquement 50-100), assumant que le CNS spécifie le même état postural à chaque tranche temporelle |
| **Hubert-Γ statistic** | Mesure de validation interne testant la compacité des clusters en mesurant la concordance entre la matrice de distances et la matrice de groupement |
| **Approximately Unbiased (AU) test** | Test de validation par bootstrap multiscale estimant la stabilité des clusters et fournissant des p-values pour l'inférence statistique |
| **Average linkage method** | Algorithme de clustering calculant la dissimilarité entre deux clusters comme la moyenne de toutes les distances pairwise entre leurs membres (robuste aux outliers) |

### Citations Majeures

> **Sur la nécessité de la validation** :
> *"One common criticism of cluster analysis methods concerns the fact that a cluster analysis algorithm always groups objects into clusters even when no real underlying structure might exist in the dataset."* (p. 213)

> **Sur l'erreur de normalisation temporelle** :
> *"Cutting points must be used which can be reliably identified in all observed trials otherwise spurious differences will be introduced which will affect all subsequent analysis."* (p. 222)

> **Sur la complémentarité avec d'autres méthodes** :
> *"Cluster analysis provides different information from both methods [PCA and UCM] discussed here and it analyses different aspects of movement control data."* (p. 218)

> **Sur l'importance du choix des variables** :
> *"The choice of input variables should be driven by theoretical knowledge since the inclusion of unrelated variables might have a negative impact on the quality of the analysis."* (p. 213)

> **Sur l'utilisation combinée avec UCM** :
> *"Using the cluster analysis approach though, the experimenter could separate the trials into different groups and calculate the UCM within each group. Thus, such an approach would provide the best of 'both worlds'."* (p. 218)

---

## Notes pour Rédaction

### Pour l'Introduction

1. **Défi méthodologique en contrôle moteur** : L'augmentation de la complexité des données cinématiques (systèmes multi-caméras, full-body markers) nécessite des techniques d'analyse sophistiquées capables de gérer la haute dimensionnalité tout en identifiant des patterns significatifs.

2. **Limitation des approches traditionnelles** : Les méthodes conventionnelles (PCA, analyses de phase) présupposent souvent l'homogénéité des patterns ou requièrent des connaissances a priori sur les événements critiques du mouvement.

3. **Potentiel de l'analyse en clusters** : Cette technique permet l'exploration data-driven de la structure des patterns moteurs sans hypothèses fortes sur le nombre ou la nature des solutions coordinatives adoptées.

### Pour la Discussion

1. **Interprétation de la diversité des clusters** : Un nombre élevé de clusters ne signifie pas nécessairement une meilleure adaptation ou créativité - l'interprétation fonctionnelle nécessite l'examen qualitatif des patterns (angle-angle plots, analyse UCM subséquente).

2. **Implications pour la créativité motrice** : Les résultats de l'Exp. 3 suggèrent que face à des contraintes, certains individus adoptent des transitions nettes entre stratégies (participant 1) tandis que d'autres adaptent graduellement une stratégie de base (participant 2) - ces différences pourraient refléter des styles cognitifs distincts.

3. **Nécessité d'une approche multi-méthodes** : L'article plaide pour une analyse séquentielle (clustering → séparation des patterns → analyse détaillée intra-cluster) plutôt qu'une opposition entre techniques analytiques.

### Limites à mentionner

1. **Sensibilité aux décisions de prétraitement** : La méthode requiert des choix méthodologiques critiques (variables d'entrée, schéma de normalisation, points de coupe) qui peuvent substantiellement influencer les résultats - ces décisions doivent être explicitement justifiées théoriquement.

2. **Validité écologique limitée** : Les expériences de validation utilisent principalement des tâches de laboratoire ou des gestes sportifs standardisés - l'application à des actions écologiques complexes comme l'escalade nécessite une adaptation et une validation supplémentaires.

3. **Inférence causale limitée** : L'analyse en clusters révèle l'existence de patterns distincts mais ne permet pas directement d'inférer les mécanismes de contrôle sous-jacents ou les facteurs causaux expliquant l'adoption de tel ou tel pattern.

---

## 📎 Fichiers Associés

- PDF : [[Rein_et_al___2010_.pdf]]
- Notes d'extraction : *Aucun fichier extraction trouvé*
- Synthèse thématique : [[00-CONCEPT]]

---

**Date de création** : 2026-01-06
**Dernière modification** : 2026-01-06
**Statut d'analyse** : ✅ Complète