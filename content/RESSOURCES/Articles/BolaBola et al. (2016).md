---
type: article
title: "Application of Hidden Markov Model in Human Motion Recognition by Using Motion Capture Data"
authors: [BolaBola, Wang, Wu, Qin, Niu]
year: 2016
journal: Advances in Physical Ergonomics and Human Factors (Advances in Intelligent Systems and Computing 489)
doi: 10.1007/978-3-319-41694-6_3
tags: [motion-capture, hidden-markov-model, motion-recognition, trajectory-analysis, SVD, biomécanique-computationnelle]
status: ⚪ Contexte
---

# Application of Hidden Markov Model in Human Motion Recognition by Using Motion Capture Data

**Citation complète APA** : BolaBola, J. Z., Wang, Y., Wu, S., Qin, H., & Niu, J. (2016). Application of hidden Markov model in human motion recognition by using motion capture data. In R. Goonetilleke & W. Karwowski (Eds.), *Advances in Physical Ergonomics and Human Factors* (Advances in Intelligent Systems and Computing, Vol. 489, pp. 21–28). Springer International Publishing. https://doi.org/10.1007/978-3-319-41694-6_3

---

## Typologie de l'article

moc:: [[00-ARTICLES]]
citation:: BolaBola et al. (2016)
type_etude:: Expérimentale
approche:: Biomécanique | Computationnelle
mots_cles:: #motion-capture #hidden-markov-model #SVD #reconnaissance-de-mouvement #trajectoires-articulaires
pdf:: [[BolaBola et al. (2016).pdf]]
discipline:: Informatique appliquée, Biomécanique computationnelle, Ergonomie physique

---

## 📋 Résumé

BolaBola et al. (2016) proposent une méthode de reconnaissance automatique du mouvement humain combinant la décomposition en valeurs singulières (SVD) pour l'extraction de caractéristiques et le modèle de Markov caché (HMM) pour la classification probabiliste. À partir de données de capture de mouvement (format AMC) issues de la bibliothèque CMU, six types de locomotion sont traités — dont l'escalade — atteignant un taux de reconnaissance moyen de 66,67 % en test par lots. L'étude démontre la faisabilité d'une reconnaissance de mouvement fondée uniquement sur les trajectoires articulaires 3D, sans recours à des informations visuelles contextuelles.

---

## 🎯 Hypothèse(s)

**Hypothèse principale** : La combinaison SVD + HMM permet de segmenter et classifier avec fiabilité différents types de locomotion humaine à partir de données de trajectoires articulaires 3D en format AMC, sans recours à des données visuelles complémentaires.

---

## 🔬 Méthodologie

### Cadre Théorique

**Bases conceptuelles** :

- Modèles de Markov cachés (HMM) : reconnaissance probabiliste de séquences stochastiques (Rabiner, 1989)
- Décomposition en valeurs singulières (SVD) : réduction dimensionnelle par approximation aux moindres carrés (Kalman, 2002)
- Quantification vectorielle pour la classification de patrons moteurs

**Construits théoriques centraux** :

| Concept | Opérationnalisation proposée |
|---|---|
| Trajectoire articulaire | Matrice de déplacements 3D des 29 articulations du squelette AMC, standardisée en matrices 124 × 62 |
| Pattern de mouvement | Modèle HMM (λ = π, A, B) entraîné par l'algorithme de Baum-Welch sur les caractéristiques SVD extraites |
| Reconnaissance de mouvement | Comparaison probabiliste entre les vecteurs de caractéristiques d'un nouveau mouvement et la base de modèles HMM existants |

### Variables

**VI (Variables Indépendantes)** : Type de locomotion (6 catégories : escalade, saut en avant, saut, course, position assise, marche)

**VD (Variables Dépendantes)** : Taux de reconnaissance (%), correspondance entre le mouvement observé et le modèle HMM entraîné

### Design Expérimental

Design de classification supervisée appliqué à des données de capture de mouvement préenregistrées ; les modèles HMM sont entraînés sur un sous-ensemble de données puis testés en reconnaissance isolée (single amc) et en reconnaissance par lots (batch).

### Procédure

Les données AMC sont extraites de la bibliothèque CMU (48 séquences au total, 8 par catégorie de mouvement, 29 articulations, 120 fps). Elles sont converties en matrices 2D normalisées (124 × 62) par standardisation des frames. La SVD est ensuite appliquée pour extraire les vecteurs de caractéristiques minimaux et maximaux de chaque mouvement. Ces caractéristiques alimentent les HMM entraînés via l'algorithme de Baum-Welch. Deux tests de reconnaissance sont conduits : par lot (via transformée de Fourier rapide) et par séquence isolée.

**Participants** : N = non applicable (données de mouvement issus d'une base de données ouverte, sujets multiples)

**Mesures** : Taux de reconnaissance (%), structure des matrices de transition HMM

---

## 📊 Résultats Principaux

### Résultat clé 1

Le taux de reconnaissance moyen en test par lots atteint 66,67 %, avec 32 séquences correctement classifiées sur 48 pour chaque catégorie de mouvement.

**Implication** : La combinaison SVD-HMM fonctionne au-dessus du hasard mais reste perfectible, notamment pour les mouvements aux trajectoires complexes comme l'escalade.

### Résultat clé 2

Le test par lot (batch) identifie uniquement le mouvement de saut avec un taux de 80 %, les autres catégories demeurant non discriminées dans ce mode de reconnaissance.

**Implication** : La reconnaissance par lots est sensible au bruit des trajectoires distales (mains, pieds), ce qui dégrade la performance pour les mouvements impliquant une grande variabilité des extrémités — caractéristique particulièrement saillante en escalade.

### Résultat clé 3

La reconnaissance en mode isolé (single amc) obtient de meilleures performances que le mode batch car les frontières du mouvement sont plus nettes, permettant une localisation plus précise des points caractéristiques.

**Implication** : La segmentation préalable du mouvement constitue une étape critique pour améliorer la précision des algorithmes de reconnaissance, information méthodologique directement applicable à l'analyse de trajectoires en escalade.

---

## 🌟 Contribution Théorique

### Apports Majeurs

1. Validation de la chaîne SVD + HMM pour la reconnaissance de locomotion à partir de données articulaires brutes, sans informations visuelles contextuelles.
2. Identification du bruit des trajectoires distales (mains, orteils) comme source principale de dégradation des performances, justifiant des stratégies de filtrage ciblées.
3. Démonstration que 8 séquences d'entraînement par catégorie suffisent pour constituer un modèle HMM fonctionnel, ce qui ouvre la voie à des bases de données de taille réduite.

### Positionnement Théorique

L'article s'inscrit dans la continuité des travaux HMM appliqués à la reconnaissance d'actions humaines (vision-based ou skeletal-based) et étend leur application à des données AMC multi-sujets issues d'une bibliothèque ouverte, se distinguant des approches restreintes à un seul type de locomotion.

---

## ⚠️ Limites

### Identifiées par les auteurs

1. La vitesse des trajectoires n'est pas prise en compte dans le modèle, ce qui réduit la sensibilité aux variations temporelles du mouvement.
2. Le bruit généré par les trajectoires des mains et des orteils dégrade significativement les taux de reconnaissance, en particulier pour les mouvements complexes comme l'escalade.
3. La taille de la base d'entraînement (8 séquences par catégorie) est jugée insuffisante pour atteindre un niveau de généralisation robuste.

### Critiques additionnelles

1. L'escalade est traitée comme une catégorie homogène sans distinction des phases ou des types de mouvements (dalles, dévers, surplombs), ce qui limite la granularité de l'analyse pour une application en escalade sportive.
2. L'absence de validation croisée rigoureuse et le recours à une seule base de données (CMU) fragilisent la généralisabilité des résultats à des contextes écologiques réels.

---

## 🎯 Pertinence pour l'Étude

### Justification de l'inclusion

Cet article présente un cadre algorithmique de reconnaissance et de classification de trajectoires articulaires pertinent d'un point de vue méthodologique pour l'analyse vidéo des mouvements d'escalade. Il documente les défis inhérents au traitement de données de trajectoires complexes et bruyantes, problématique directement rencontrée dans l'analyse de marqueurs LED sur paroi d'escalade.

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité)** :
- Lien indirect : les algorithmes de reconnaissance de mouvement peuvent être mobilisés pour détecter des modifications de trajectoires induites par la fatigue, en comparant les patterns pré/post-fatigue.
- Mécanisme proposé : une modification des signatures HMM entre états de fatigue et de repos pourrait objectiver un changement dans les solutions motrices adoptées.

**H2 (Profil psycho → Créativité)** :
- Lien très indirect : l'approche de classification de trajectoires pourrait, à terme, discriminer des profils moteurs associés à différentes orientations régulatrices si des variations systématiques de mouvement sont détectées.
- Contribution conceptuelle limitée à H2.

### Applications méthodologiques

| Sections | Applications |
|---|---|
| **Mesures utilisables** | Extraction de caractéristiques SVD pour réduire la dimensionnalité des trajectoires articulaires ; modélisation séquentielle des phases de mouvement |
| **Design inspirant** | Approche de classification multi-catégories applicable à la distinction de solutions motrices créatives vs. conventionnelles en escalade |
| **Pièges à éviter** | Ne pas ignorer la vitesse des trajectoires ; prévoir un filtrage des trajectoires distales bruyantes (mains/pieds en escalade) avant l'application d'algorithmes de reconnaissance |

---

## 🔗 Liens Conceptuels

### Articles similaires
- [[Van Bergen et al. (2022)]] : Analyse quantitative des trajectoires en escalade (approche complémentaire)

### Complète/Approfondit
- [[Orth et al. (2017)]] : La variabilité des solutions motrices que ces algorithmes cherchent à classifier trouve son fondement théorique dans les dynamiques écologiques

### Lien avec mes Hypothèses

H1 : Outil potentiel pour objectiver les modifications de trajectoires induites par la fatigue via comparaison de modèles HMM pré/post-fatigue

H2 : Pertinence limitée ; contribue davantage à l'instrumentation qu'à la théorie

Lien théorique : Biomécanique computationnelle → Analyse quantitative du mouvement → Mesure de la variabilité motrice

Gap comblé : Fournit des outils algorithmiques pour traiter le défi technique d'extraction de trajectoires en conditions d'escalade réelle

---

## 💡 Concepts Clés

### Définitions Opérationnelles

| Concept | Définition de l'article |
|---|---|
| Hidden Markov Model (HMM) | Modèle stochastique probabiliste composé d'états cachés (λ = π, A, B), entraîné par l'algorithme de Baum-Welch pour classifier des séquences de mouvements à partir de leurs caractéristiques extraites |
| Singular Value Decomposition (SVD) | Algorithme de factorisation matricielle décomposant la matrice de trajectoires A = USV⊤ pour extraire les valeurs minimales et maximales comme caractéristiques représentatives du mouvement |
| Trajectoire articulaire | Déplacement 3D des 29 articulations squelettiques indexées, converti en matrice 2D standardisée pour traitement algorithmique |

### Citations Majeures

> **Principe de reconnaissance HMM** :
> *"HMM has the ability to learn standardize motion pattern, in the way that it round up easily to avoid zero probability and identify sequential stochastic states where the likelihood of a state predicate the previous state."* (p. 25)

> **Limite du bruit articulaire** :
> *"In spite of the noisiness of the hand and toe trajectories, the recognition level was pretty higher than expected."* (p. 21)

---

## Notes pour Rédaction

### Pour l'Introduction

- Contextualiser le défi de l'analyse quantitative des trajectoires en escalade, domaine où les outils de capture de mouvement restent sous-exploités comparativement à d'autres sports.
- Pointer la complexité inhérente à la classification de mouvements polyarticulaires et la nécessité de méthodes robustes au bruit pour l'escalade.

### Pour la Discussion

- Si des modifications de trajectoires sont observées entre conditions (fatigue/non-fatigue), les outils de classification probabiliste offrent une piste pour objectiver ces différences au-delà des simples métriques de variabilité.
- La difficulté signalée par BolaBola et al. à discriminer les mouvements d'escalade des autres locomotions renforce l'idée que l'escalade constitue une activité motrice singulière méritant des outils d'analyse spécifiques.

### Limites à mentionner

- L'article traite l'escalade comme catégorie homogène, ce qui ne reflète pas la diversité des solutions motrices observées sur voie : cette limite justifie une approche d'analyse individuelle des trajectoires plutôt qu'une classification globale par catégorie.

---

## 📎 Fichiers Associés

- PDF : [[BolaBola_et_al___2016_.pdf]]
- Notes d'extraction : non disponible
- Synthèse thématique : [[00-ARTICLES]]

---

**Date de création** : 2026-02-19
**Dernière modification** : 2026-02-19
**Statut d'analyse** : ✅ Complète
