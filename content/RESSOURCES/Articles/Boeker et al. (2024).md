---
type: article
title: "Predictive Modelling of Muscle Fatigue in Climbing"
authors: [Boeker, Swarbrick, Côté-Allard, Riegler, Halvorsen, Hammer]
year: 2024
journal: "MMSports '24: Proceedings of the 7th ACM International Workshop on Multimedia Content Analysis in Sports"
doi: 10.1145/3689061.3689066
tags: [fatigue-musculaire, EMG, escalade, trajectoire, machine-learning, modélisation-prédictive, FDS]
status: 🟠 Important
---

# Predictive Modelling of Muscle Fatigue in Climbing

**Citation complète APA** : Boeker, M., Swarbrick, D., Côté-Allard, U., Riegler, M. A., Halvorsen, P., & Hammer, H. L. (2024). Predictive modelling of muscle fatigue in climbing. In *Proceedings of the 7th ACM International Workshop on Multimedia Content Analysis in Sports (MMSports '24)*. ACM. https://doi.org/10.1145/3689061.3689066

---

## Typologie de l'article

moc:: [[02 - MOC Créativité et Escalade]] | [[03 - MOC Fatigue et Performance]]
citation:: Boeker et al. (2024)
type_etude:: Expérimentale
approche:: Physiologique, Biomécanique
mots_cles:: #fatigue-musculaire #EMG #escalade #trajectoire-vidéo #machine-learning #FDS #modélisation
pdf:: [[Boeker et al. (2024).pdf]]
discipline:: Sciences du sport, Informatique appliquée, Biomécanique

---

## 📋 Résumé

Boeker et al. (2024) proposent une approche multi-modale pour surveiller et prédire la fatigue musculaire en escalade, combinant électromyographie (EMG) du muscle fléchisseur digitorum superficialis (FDS) et trajectoires vidéo du centre de gravité chez 20 grimpeurs. L'étude compare des modèles autorégressifs (AR) classiques à des méthodes d'apprentissage automatique (MLP, Gradient Boosting, LSTM, Random Forest) pour prédire la fatigue jusqu'à 5 secondes dans le futur. Les modèles non-linéaires (MLP, GB) surpassent les modèles linéaires, mais ces derniers offrent l'avantage d'une implémentation en temps réel sur dispositifs portables.

---

## 🎯 Hypothèse(s)

**Hypothèse principale** : Il est possible de prédire la fatigue musculaire d'un grimpeur en temps réel en intégrant les données d'activité myoélectrique (EMG) et les informations de trajectoire spatiale sur la voie.

**Hypothèses secondaires** :
- H1 : L'intégration de la fatigue musculaire attendue en fonction de la distance grimpée améliore la performance prédictive du modèle AR.
- H2 : Les modèles non-linéaires (réseaux de neurones, méthodes d'ensemble) surpassent les modèles linéaires pour modéliser des patterns d'activation musculaire complexes en escalade.

---

## 🔬 Méthodologie

### Cadre Théorique

**Bases conceptuelles** :
- Fatigue musculaire comme réduction temporaire de la capacité à produire de la force (Enoka & Duchateau, 2008)
- Mesure de la fatigue par la fréquence médiane (MF) du signal EMG de surface (Cifrek et al., 2009)
- Importance du FDS et des fléchisseurs du coude dans la performance en escalade (Deyhle et al., 2015)

**Construits théoriques centraux** :
| Concept | Opérationnalisation proposée |
|---|---|
| Fatigue musculaire | Diminution de la fréquence médiane du signal EMG de surface enregistré sur le FDS |
| Trajectoire du grimpeur | Centre de gravité (COG) annoté manuellement frame-par-frame, transformé par homographie en coordonnées 2D |
| Fatigue attendue | Modèle catégoriel de la MF espérée en fonction des intervalles de distance grimpée en y |

### Variables

**VI (Variables Indépendantes)** : Observations passées de la MF (variables endogènes), position spatiale (x, y) sur la voie, accélération du bras droit (IMU), distance grimpée en y (modèle AR étendu)
**VD (Variables Dépendantes)** : Fréquence médiane future du signal EMG (indicateur de fatigue musculaire), horizon de prédiction : 250 ms (court terme) et 5 secondes (long terme)

### Design Expérimental

Design intra-sujet à mesures répétées : chaque participant effectue la même voie deux fois (escalade en tête et moulinette), dans un ordre randomisé pour contrôler les effets de fatigue cumulée et de mémorisation de la voie.

### Procédure

Les 20 grimpeurs ont réalisé un échauffement standardisé de 5 minutes avant chaque tentative. Le capteur BioPoint™ (ECG, EDA, PPG, IMU, EMG) était positionné sur le FDS de l'avant-bras droit à 3/4 de la distance coude-poignet. L'ascension était enregistrée en vidéo, et le COG annoté manuellement via une interface graphique dédiée pour chaque frame. Le signal EMG était prétraité par filtre notch (50 Hz) et filtre passe-bande (20-450 Hz), puis la MF calculée par transformée de Fourier à court terme sur fenêtres glissantes. La validation croisée leave-one-out (LOOCV) sur 40 ascensions garantissait une évaluation robuste malgré la taille réduite de l'échantillon.

**Participants** : N = 20 grimpeurs récréatifs (12 hommes, 8 femmes), âge moyen 31 ± 7,8 ans, jusqu'à 4 ans d'expérience, ~1h/semaine d'escalade
**Mesures** : EMG surface (FDS, 2000 Hz), IMU 6 axes (50 Hz), trajectoire vidéo (30 fps), métriques d'erreur : MSE, RMSE, MAE

---

## 📊 Résultats Principaux

### Résultat clé 1 : Progression linéaire de la fatigue

La fréquence médiane du signal EMG présente une diminution linéaire systématique avec l'altitude grimpée, observable chez l'ensemble des participants. Cette progression est suffisamment stable pour être modélisée et prédite, constituant la justification empirique centrale de l'étude.

**Implication** : La fatigue musculaire en escalade suit une dynamique temporelle prévisible, ce qui légitime le développement de modèles prédictifs pour l'optimisation des stratégies de gestion de l'effort.

### Résultat clé 2 : Supériorité des modèles non-linéaires

Pour les prédictions à court terme, MLP (RMSE = 15,09 ± 27,94%) et GB (RMSE = 15,09 ± 29,02%) surpassent significativement le modèle AR standard (RMSE = 16,24 ± 28,11%). Cet avantage se maintient pour les prédictions à long terme (MLP : RMSE = 17,63 ; AR : RMSE = 19,75).

**Implication** : Les patterns d'activation musculaire en escalade sont trop irréguliers et non-linéaires pour être capturés par des modèles autorégressifs simples, reflétant la complexité des interactions entre style d'escalade, morphologie individuelle et contraintes de la voie.

### Résultat clé 3 : Apport de la fatigue attendue au modèle AR

L'intégration de la fatigue attendue selon la distance grimpée améliore le modèle AR standard (AR Exp. Fat. : RMSE court terme = 16,05 vs AR : 16,24), tout en réduisant la variance des prédictions (écart-type stabilisé).

**Implication** : L'information spatiale (position sur la voie) porte une part de variance explicative de la fatigue, indépendante de l'historique du signal EMG seul. Cela suggère que la voie elle-même contraint la dynamique de fatigue.

### Résultat clé 4 : Contre-performance du LSTM

Malgré ses capacités théoriques pour les données séquentielles, le LSTM présente les moins bonnes performances (RMSE court terme = 17,44), probablement en raison de la taille insuffisante du jeu de données (40 sessions).

**Implication** : La complexité du modèle doit être mise en regard de la taille des données disponibles — enjeu directement transférable à tout protocole expérimental en escalade avec échantillon modeste.

---

## 🌟 Contribution Théorique

### Apports Majeurs

1. Première mesure EMG en temps réel durant l'escalade combinée à la trajectoire du grimpeur : approche véritablement multi-modale et écologiquement valide.
2. Modélisation de la fatigue comme fonction de la position sur la voie : démontre que la contrainte spatiale (la voie) module directement la dynamique physiologique du grimpeur.
3. Cadre comparatif systématique entre modèles linéaires et non-linéaires adapté aux contraintes du terrain sportif (taille d'échantillon, applicabilité en temps réel).

### Positionnement Théorique

L'article s'inscrit dans une approche écologique de la performance en escalade en montrant que la fatigue ne peut pas être dissociée du contexte spatial de la voie. Il prolonge les travaux physiologiques classiques sur le FDS (Watts et al., 2008 ; Vigouroux & Quaine, 2006) en les inscrivant dans une dynamique temporelle continue plutôt qu'en comparaisons avant/après effort.

---

## ⚠️ Limites

### Identifiées par les auteurs

1. Taille d'échantillon réduite (40 sessions, une seule voie) limitant la généralisabilité des modèles.
2. Mesure restreinte au bras droit (FDS), ne reflétant pas la fatigue musculaire globale du grimpeur.
3. Annotation manuelle des trajectoires vidéo, chronophage et potentiellement biaisée par l'annotateur.

### Critiques additionnelles

1. L'absence de distinction lead vs moulinette dans l'entraînement des modèles efface une source de variabilité potentiellement pertinente pour comprendre l'influence du contexte psychologique sur la fatigue physiologique.
2. La fréquence médiane de l'EMG est un indicateur de fatigue musculaire périphérique mais ne rend pas compte des dimensions centrales de la fatigue, ni des ajustements moteurs compensatoires pouvant refléter une forme de créativité motrice sous contrainte.

---

## 🎯 Pertinence pour l'Étude

### Justification de l'inclusion

Cet article fournit une base méthodologique et empirique robuste pour opérationnaliser la fatigue musculaire en contexte écologique d'escalade. La combinaison EMG + trajectoire vidéo constitue un modèle de recueil de données multi-modal directement pertinent pour mon protocole de recherche sur l'influence de la fatigue sur la créativité motrice.

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité motrice)** :
- La démonstration d'une progression linéaire de la fatigue musculaire au fil de l'ascension fournit une base empirique pour inférer les niveaux de fatigue auxquels sont soumis mes participants à différents moments de la voie.
- Le lien établi entre position spatiale et niveau de fatigue attendu confirme que la conception de la voie (contrainte matérielle) module la fatigue — variable médiatrice potentielle dans la relation fatigue → créativité.

**H2 (Profil psychologique → Créativité motrice)** :
- L'étude ne traite pas directement les profils psychologiques, mais le fait que lead et moulinette produisent des dynamiques de fatigue comparables (hypothèse des auteurs) ouvre la question des différences individuelles non-physiologiques dans la gestion de la fatigue, terrain sur lequel les orientations motivationnelles (promotion/prévention) pourraient opérer.

### Applications méthodologiques

| Sections | Applications |
|---|---|
| Mesures utilisables | Fréquence médiane de l'EMG comme indicateur continu de fatigue ; annotation de trajectoire par centre de gravité avec transformation homographique |
| Design inspirant | Protocole de randomisation lead/moulinette pour contrôler les effets d'ordre ; LOOCV adapté aux petits échantillons |
| Pièges à éviter | Ne pas limiter la mesure à un seul bras ; ne pas assimiler fatigue périphérique et fatigue centrale ; anticiper la complexité de l'annotation manuelle |

---

## 🔗 Liens Conceptuels

### Articles similaires
- [[Van Bergen et al. (2022)]] : Analyse trajectoire et comportement moteur en escalade
- [[Giles et al.]] : Physiologie de la performance en escalade

### Complète/Approfondit
- [[03 - MOC Fatigue et Performance]] : Opérationnalisation de la fatigue musculaire en contexte écologique

### Lien avec mes Hypothèses
H1 : Fournit une opérationnalisation continue de la fatigue (MF de l'EMG) et valide sa progression au fil de l'ascension
H2 : Soulève indirectement la question des différences individuelles dans la réponse physiologique à la fatigue
Lien théorique : approche contraintes-led (voie comme contrainte modulant la fatigue), écologie de la performance
Gap comblé : manque de mesure dynamique et continue de la fatigue en escalade ; méthode d'extraction de trajectoire applicable

---

## 💡 Concepts Clés

### Définitions Opérationnelles

| Concept | Définition de l'article |
|---|---|
| Fatigue musculaire | Réduction temporaire de la capacité à produire de la force, mesurée par la diminution de la fréquence médiane du signal EMG de surface au fil du temps |
| Fréquence médiane (MF) | Paramètre spectral du signal EMG calculé par transformée de Fourier à court terme sur fenêtres glissantes ; sa diminution progressive indexe l'accumulation de fatigue musculaire |
| Centre de gravité (COG) | Point d'application de la résultante des forces de pesanteur du corps du grimpeur, annoté frame-par-frame pour reconstruire la trajectoire sur la voie |
| Fatigue attendue | Valeur espérée de la MF conditionnée à l'intervalle de distance grimpée en y, intégrée comme variable exogène dans le modèle AR étendu |

### Citations Majeures

> **Définition de la fatigue musculaire** :
> *"Muscle fatigue is a local and complex phenomenon that involves a temporary reduction in the ability to carry out physical activities."* (p. 8)

> **Importance de la mesure en temps réel** :
> *"A comprehensive, temporal analysis of muscle fatigue in climbing is lacking in the existing literature."* (p. 8)

> **Valeur applicative des modèles linéaires** :
> *"Linear models, despite their lower prediction accuracy, offer advantages in terms of computational simplicity and real-time application."* (p. 14)

---

## Notes pour Rédaction

### Pour l'Introduction

- Justifier la mesure de la fatigue par EMG en escalade en s'appuyant sur Boeker et al. (2024) : premier enregistrement continu combinant EMG et trajectoire durant une ascension complète.
- Souligner le gap identifié par les auteurs : absence d'analyse temporelle holistique de la fatigue musculaire en escalade, que mon étude entend prolonger en intégrant la dimension motrice et créative.
- La progression linéaire de la fatigue avec l'altitude grimpée peut servir de justification pour mes conditions expérimentales (manipulation de la fatigue par la voie).

### Pour la Discussion

- Comparer mes résultats sur la variabilité des trajectoires avec la cartographie fatigue-position proposée par Boeker et al. : si la fatigue est spatialement distribuée sur la voie, les variations motrices (créativité) pourraient être concentrées dans les zones de fatigue maximale.
- Discuter les limites de la mesure EMG du FDS seul si mon étude utilise des indicateurs comportementaux (trajectoires) comme proxy de la fatigue, en citant la complémentarité des approches.

### Limites à mentionner

- L'absence de dimension psychologique et comportementale dans Boeker et al. justifie l'élargissement du cadre d'analyse à la créativité motrice et aux profils motivationnels, objet de mon étude.

---

## 📎 Fichiers Associés

- PDF : [[Boeker_et_al___2024_.pdf]]
- Notes d'extraction : /
- Synthèse thématique : [[03 - MOC Fatigue et Performance]]

---

**Date de création** : 2026-02-19
**Dernière modification** : 2026-02-19
**Statut d'analyse** : ✅ Complète
