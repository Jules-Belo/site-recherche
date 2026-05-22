---
type: article
title: "Background subtraction techniques: a review"
authors: [Massimo Piccardi]
year: 2004
journal: IEEE International Conference on Systems, Man and Cybernetics
doi: Non spécifié
tags: [vision_par_ordinateur, détection_mouvement, revue_systématique, background_subtraction]
status: ⚪ Contexte
---

# Background subtraction techniques: a review

**Citation complète APA** : Piccardi, M. (2004). Background subtraction techniques: a review. In *2004 IEEE International Conference on Systems, Man and Cybernetics* (pp. 3099-3104). IEEE.

---

## Typologie de l'article

moc:: [[00-ARTICLES]]
citation:: Piccardi, M. (2004). Background subtraction techniques: a review. In 2004 IEEE International Conference on Systems, Man and Cybernetics (pp. 3099-3104). IEEE.
type_etude:: Revue systématique
approche:: Vision par ordinateur, Analyse comparative
mots_cles:: #background_subtraction #computer_vision #object_detection #parametric_models #non_parametric_models
pdf:: [[Piccardi (2004).pdf]]
discipline:: Informatique, Vision par ordinateur

---

## 📋 Résumé

Cette revue systématique compare les principales méthodes de soustraction d'arrière-plan pour détecter des objets en mouvement dans des vidéos de caméras statiques. L'auteur propose une catégorisation originale basée sur trois critères : vitesse de traitement, besoins mémoire et précision. Sept méthodes sont analysées, allant d'approches simples (moyenne Gaussienne) à des approches sophistiquées (eigenbackgrounds, KDE).

---

## 🎯 Objectif de la Revue

**Objectif principal** : Fournir une comparaison systématique des méthodes de soustraction d'arrière-plan pour guider les concepteurs dans le choix de la méthode la plus appropriée pour une application donnée.

**Problématique adressée** : La multiplicité des méthodes existantes crée de la confusion chez les experts et novices concernant leurs bénéfices et limitations respectifs.

---

## 🔬 Méthodologie de Revue

### Critères de Comparaison

L'auteur utilise trois dimensions d'analyse :

| Critère | Description | Importance |
|---------|-------------|------------|
| **Vitesse** | Complexité temporelle par pixel | Critique pour applications temps réel |
| **Mémoire** | Besoins en stockage par pixel | Contrainte pour dispositifs embarqués |
| **Précision** | Capacité à modéliser distributions multimodales | Détermine la qualité de détection |

### Méthodes Revues

1. **Running Gaussian Average** (Wren et al., 1997)
2. **Temporal Median Filter** (Lo & Velastin, 2001; Cucchiara et al., 2003)
3. **Mixture of Gaussians** (Stauffer & Grimson, 1999)
4. **Kernel Density Estimation - KDE** (Elgammal et al., 2000)
5. **Sequential KD Approximation - SKDA** (Han et al., 2004)
6. **Cooccurrence of Image Variations** (Seki et al., 2003)
7. **Eigenbackgrounds** (Oliver et al., 2000)

---

## 📊 Résultats Principaux

### Synthèse Comparative

| Méthode | Complexité Temps | Complexité Mémoire | Précision |
|---------|------------------|-------------------|-----------|
| **Running Gaussian** | O(1) | O(1) | L (Limitée) |
| **Median Filter** | O(ns) | O(ns) | L/M |
| **Mixture of Gaussians** | O(m) | O(m) | M/H |
| **KDE** | O(n) | O(n) | H (Haute) |
| **SKDA** | O(m+1) | O(m) | M/H |
| **Cooccurrence** | O(8*(n+L²+L)/N²) | O(nK/N²) | M |
| **Eigenbackgrounds** | O(M) | O(M) + O(n) training | M |

*Légende : L=Low, M=Medium, H=High; n=nombre d'échantillons (≈100), m=nombre de distributions (3-5), M=nombre d'eigenvectors*

### Résultat clé 1 : Trade-off vitesse-précision

Les méthodes simples (Running Gaussian, Median) offrent une vitesse maximale O(1)-O(ns) mais une précision limitée aux distributions unimodales. Elles conviennent aux contraintes temps-réel strictes avec scènes stables.

**Implication** : Pour applications à faibles ressources, ces méthodes restent pertinentes malgré leurs limites.

### Résultat clé 2 : Supériorité des approches multimodales

Mixture of Gaussians et KDE modélisent efficacement les distributions multimodales (ex: feuilles d'arbres oscillant devant un bâtiment). KDE atteint la meilleure précision mais au coût mémoire le plus élevé (buffer de 100 frames).

**Implication** : Scènes dynamiques complexes nécessitent des modèles probabilistes sophistiqués.

### Résultat clé 3 : SKDA comme compromis optimal

Sequential KD Approximation approxime KDE avec une erreur quadratique moyenne de 10⁻⁴, tout en réduisant la complexité mémoire d'un ordre de grandeur (m modes vs n échantillons).

**Implication** : SKDA combine avantages du KDE (précision) et du Mixture of Gaussians (efficacité).

### Résultat clé 4 : Corrélation spatiale améliore la robustesse

Méthodes exploitant la corrélation spatiale (Cooccurrence, Eigenbackgrounds, spatial KDE) réduisent les artefacts (ghosts, deadlocks) en cohérence avec le voisinage.

**Implication** : L'indépendance pixel-par-pixel est une limitation majeure des approches basiques.

---

## 🌟 Contribution Théorique

### Apports Majeurs

1. **Catégorisation systématique** : Première taxonomie structurée selon vitesse/mémoire/précision, permettant une sélection principiée.
2. **Analyse comparative rigoureuse** : Complexités algorithmiques explicites (Big O notation) pour chaque méthode.
3. **Identification des limitations** : Clarification des compromis inhérents (ex: précision vs vitesse, mémoire vs temps).

### Positionnement Théorique

L'article synthétise l'évolution des approches : de modèles paramétriques simples (Gaussienne unique) vers des modèles non-paramétriques (KDE) capturant des distributions arbitraires. Il met en évidence le passage d'approches pixellaires indépendantes à des méthodes exploitant la corrélation spatiale.

---

## ⚠️ Limites

### Identifiées par l'auteur

1. **Exclusions dues à l'espace** : Revue non exhaustive, certaines méthodes pertinentes omises.
2. **Absence de benchmark standardisé** : Pas de comparaison empirique sur jeu de données commun.

### Critiques additionnelles

1. **Manque de données quantitatives** : Précision évaluée qualitativement (L/M/H) sans métriques objectives (taux faux positifs/négatifs).
2. **Contexte applicatif limité** : Focus sur caméras statiques uniquement, n'aborde pas les caméras mobiles.
3. **Actualité** : Revue de 2004, deep learning non couvert (inexistant à l'époque).

---

## 🎯 Pertinence pour l'Étude

### Justification de l'inclusion

**ATTENTION** : Cet article ne semble pas pertinent pour un corpus sur fatigue musculaire/créativité/psychologie en escalade. Il s'agit d'une revue technique en vision par ordinateur pour la détection d'objets en mouvement.

**Pertinence potentielle (hypothèse)** : 
Si l'étude prévoit une analyse vidéo automatisée des grimpeurs (détection de mouvements, tracking), cette revue pourrait informer le choix d'algorithmes de prétraitement. Cependant, aucun lien direct avec les hypothèses H1 (fatigue→créativité) ou H2 (profil psycho→créativité) n'est établi.

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité)** :
- Aucun lien direct. Pourrait théoriquement servir à automatiser la détection de mouvements créatifs en escalade via analyse vidéo.

**H2 (Profil psycho → Créativité)** :
- Aucun lien identifiable.

### Applications méthodologiques

| Section | Applications |
|---------|--------------|
| **Mesures utilisables** | Aucune (domaine non pertinent) |
| **Design inspirant** | Approche comparative systématique transposable à d'autres revues |
| **Pièges à éviter** | Évaluations qualitatives sans métriques quantitatives |

---

## 🔗 Liens Conceptuels

### Articles similaires
- Aucun dans le corpus actuel (domaine différent)

### Contradictions avec
- Non applicable

### Complète/Approfondit
- Non applicable au corpus escalade/créativité

### Lien avec mes Hypothèses
**H1** : Aucun lien
**H2** : Aucun lien
**Lien théorique** : Méthodologie de revue systématique transposable
**Gap comblé** : Aucun gap du corpus M2 adressé

---

## 💡 Concepts Clés

### Définitions Opérationnelles

| Concept                     | Définition de l'article                                                                                                                                                             |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Background Subtraction**  | Détection d'objets en mouvement par différence entre frame courante et modèle d'arrière-plan de référence, mis à jour pour s'adapter aux variations d'illumination et de géométrie. |
| **Selective Update**        | Mécanisme d'actualisation du modèle excluant les valeurs classifiées comme foreground pour éviter la "pollution" par des objets transitoires.                                       |
| **Multimodal Distribution** | Distribution probabiliste avec plusieurs modes (pics), nécessaire quand différents objets d'arrière-plan alternent à une même position (ex: feuilles/branches/bâtiment).            |
| **Spatial Correlation**     | Exploitation de la cohérence entre pixels voisins pour améliorer la robustesse (filtres morphologiques, évaluation multi-pixels).                                                   |

### Citations Majeures

> **Problématique de la revue** :
> *"Both the expert and the newcomer to this area can be confused about the benefits and limitations of each method."* (p. 3099)

> **Trade-off fondamental** :
> *"The approaches reviewed in this paper range from simple approaches, aiming to maximise speed and limiting the memory requirements, to more sophisticated approaches, aiming to achieve the highest possible accuracy under any possible circumstances."* (p. 3099)

> **Limitation des modèles unimodaux** :
> *"Over time, different background objects are likely to appear at a same (i,j) pixel location... In these cases, a single-valued background is not an adequate model."* (p. 3100)

---

## 📝 Notes pour Rédaction

### Pour l'Introduction

- **Si analyse vidéo prévue** : Mentionner que le choix d'algorithmes de détection de mouvement doit considérer le trade-off vitesse/précision (Piccardi, 2004).
- **Approche méthodologique** : La revue systématique peut servir de modèle pour structurer la revue de littérature (critères explicites, comparaison tabulaire).

### Pour la Discussion

- Non applicable au corpus escalade/créativité/fatigue.

### Limites à mentionner

- Si utilisation d'algorithmes de vision : Reconnaissance que les méthodes pré-deep learning (2004) ont été dépassées par les approches neuronales modernes.

---

## 📎 Fichiers Associés

- PDF : [[Piccardi (2004).pdf]]
- Notes d'extraction : Non disponible
- Synthèse thématique : [[00-ARTICLES]]

---

**Date de création** : 2025-01-20
**Dernière modification** : 2025-01-20
**Statut d'analyse** : ✅ Complète (avec réserve sur pertinence thématique)

---

## 🎯 Pertinence pour l'Étude (MISE À JOUR)

### Justification de l'inclusion

**Article méthodologique clé** : Cette revue est essentielle pour le pipeline d'analyse vidéo de l'étude. La soustraction d'arrière-plan est l'**étape de prétraitement critique** qui :

1. **Isole la silhouette du grimpeur** du mur d'escalade statique
2. **Élimine le bruit visuel** (texture du mur, prises, éclairage)
3. **Facilite le tracking** en réduisant drastiquement la complexité de détection
4. **Améliore la précision** de l'extraction de trajectoires motrices

### Chaîne de traitement vidéo

```
Vidéo brute → Background Subtraction → Silhouette grimpeur → Tracking → Trajectoires → Analyse créativité
```

Sans étape 2, le tracking serait noyé par les variations de texture du mur et des prises, générant des faux positifs massifs.

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité)** :
- **Lien direct** : La soustraction d'arrière-plan permet l'extraction automatique des trajectoires motrices pour quantifier la variabilité (proxy créativité) en condition fatigue vs repos.
- **Application** : Isolation du grimpeur pour mesurer précisément les déplacements, changements de direction, pauses (indicateurs de créativité motrice).

**H2 (Profil psycho → Créativité)** :
- **Lien direct** : Permet l'analyse objective des patterns moteurs selon profils (promotion/prévention).
- **Application** : Comptage automatisé de solutions distinctes par participant après nettoyage de l'arrière-plan.

### Applications méthodologiques concrètes

| Section | Applications pour escalade |
|---------|---------------------------|
| **Méthode recommandée** | **SKDA** ou **Mixture of Gaussians** (compromis optimal précision/vitesse) |
| **Justification** | Mur d'escalade = scène multimodale (prises colorées, variations d'éclairage) nécessitant approche sophistiquée |
| **Éviter** | Running Gaussian (insuffisant pour texture complexe du mur) |
| **Amélioration** | Intégrer corrélation spatiale (évite artefacts aux contours du grimpeur) |
| **Pipeline** | Background subtraction → Morphological operations → Skeleton extraction → Tracking |

### Contribution méthodologique

Cet article fournit la base théorique pour **justifier le choix algorithmique** dans la section Méthodologie du mémoire, en documentant le trade-off vitesse/précision pour l'analyse temps-réel ou différé.

---
