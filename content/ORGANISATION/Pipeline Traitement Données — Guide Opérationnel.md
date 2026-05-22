---
aliases:
  - Pipeline analyse vidéo
  - Guide traitement données
  - Procédure par participant
tags:
  - pipeline
  - méthodologie
  - traitement-données
  - clustering
  - SSPD
  - procédure
type: procédure
statut: actif
date_creation: 2026-03-23
date_modification: 2026-03-24
version: "2.0"
---
# Pipeline de traitement des données — Guide opérationnel

> [!abstract] Objectif
> Ce document décrit la chaîne complète de traitement des données, de la vidéo brute au dataset final pour R. Il constitue la **référence unique** pour la reproductibilité et la traçabilité de l'analyse.

> [!tip] Architecture logicielle
> | Outil | Usage | Dossier |
> |---|---|---|
> | **PyCharm** (Python) | Clustering SSPD, fatigue SmartBoard, variables temporelles | `~/PyCharmMiscProject/ANALYSE/` |
> | **R / RStudio** | Statistiques inférentielles, psychométrie, ggplot2, pvclust | `analyse_questionnaire/` |
> | **MATLAB** | Calibration caméra uniquement | — |
> | **Tracker** | Suivi semi-automatique de la LED | — |

> [!important] Décisions méthodologiques clés (version 2.0)
> - **Clustering par bloc indépendant** : BA et BB sont analysés séparément (problèmes physiquement différents)
> - **Score de créativité = moyenne** (et non somme) des originalités (Van Bergen et al., 2025)
> - **Pas de Z-score** : le contrebalancement du design rend les scores bruts comparables via l'ANOVA mixte 2×2
> - **Correction de distorsion post-tracking** : appliquée aux coordonnées (x, y), pas aux images vidéo

---

## Arborescence du projet

```
ANALYSE/
├── analyse_video/
│   ├── config.py                    ← Paramètres centralisés
│   ├── utils_trajectoire.py         ← Chargement, distorsion, normalisation
│   ├── utils_sspd.py                ← Métrique SSPD + multiprocessing
│   ├── utils_clustering.py          ← Ward, Hubert-Γ, seuil manuel
│   ├── utils_creativite.py          ← Scores Van Bergen et al. (2025)
│   ├── controle_qualite.py          ← Vérification positions start/end
│   ├── visualisations.py            ← Fonctions graphiques (intra-bloc + comparatifs)
│   ├── pipeline_clustering.py       ← Script principal (étapes 1→7, par bloc)
│   ├── analyse_temporelle.py        ← Variables comportementales (mode hybride)
│   ├── lire_calibration.py          ← Lecture des .mat MATLAB
│   ├── donnees/                     ← CSV trajectoires (par essai réussi)
│   │   └── recaps/                  ← Fichiers récapitulatifs (essais échoués)
│   └── resultats/
│       ├── graphiques/
│       │   ├── BA/                  ← Graphiques bloc A
│       │   └── BB/                  ← Graphiques bloc B
│       ├── trajectoires_normalisees/
│       └── analyses/
│           ├── BA/                  ← Analyses bloc A
│           └── BB/                  ← Analyses bloc B
├── analyse_smartboard/
│   ├── config_smartboard.py
│   └── analyse_smartboard.py        ← Script fatigue (CMV, τ, FC)
├── analyse_questionnaire/           ← R uniquement
│   ├── analyse_questionnaires.R
│   └── pvclust_validation.R
└── synthese/
    └── integration.py               ← Fusion → dataset_complet.csv
```

---

## PHASE 0 — Configuration unique

> [!warning] Ces étapes ne sont réalisées qu'une seule fois, avant le traitement du premier participant.

### 0.1 Environnement PyCharm

- [ ] Ouvrir `~/PyCharmMiscProject/ANALYSE/analyse_video/` comme projet PyCharm
- [ ] Configurer l'interpréteur Python (Anaconda `/opt/anaconda3/bin/python`)
- [ ] Vérifier les dépendances :
```bash
pip install numpy scipy pandas matplotlib tqdm h5py
```

### 0.2 Paramètres de calibration dans `config.py`

Valeurs extraites depuis MATLAB le 23/03/2026 (objectif x0.9 ultra-grand-angle) :

```python
# Paramètres intrinsèques — iPhone 15, 4K/60fps, x0.9
FOCAL_X = 3030.7742
FOCAL_Y = 3037.6276
CENTRE_X = 1913.0
CENTRE_Y = 1119.6
DIST_COEFFS = [0.022954, 0.125800, 0.004012, 0.004142, -0.768588]
```

> [!tip] Participant exception (objectif x1)
> Un seul participant a été filmé en x1. Pour celui-ci, basculer temporairement les paramètres dans `config.py` :
> ```python
> FOCAL_X = 3247.1995
> FOCAL_Y = 3254.0736
> CENTRE_X = 1983.1
> CENTRE_Y = 1117.7
> DIST_COEFFS = [0.240028, -1.423559, 0.004045, 0.005073, 2.452362]
> ```

### 0.3 Facteur de conversion pixels → mètres

- [ ] Ouvrir dans Tracker une vidéo montrant les 3 marqueurs de calibration spatiale (espacés de 1 m sur le mur)
- [ ] Relever les coordonnées pixel de chaque marqueur
- [ ] Calculer : `PIXELS_PAR_METRE = distance_pixels_entre_deux_marqueurs / 1.0`
- [ ] Moyenner sur les 3 paires possibles pour plus de précision
- [ ] Reporter la valeur dans `config.py`

### 0.4 Validation sur un participant pilote

- [ ] Traiter un participant complet (ex. P02) selon la procédure ci-dessous
- [ ] Lancer `pipeline_clustering.py` et vérifier l'absence d'erreurs
- [ ] Vérifier le format de sortie Tracker (séparateur, colonnes, décimale)
- [ ] Lancer le diagnostic de distorsion :
```python
from utils_trajectoire import visualiser_correction_distorsion, diagnostic_correction_distorsion
visualiser_correction_distorsion("donnees/E01_P02_BA_NF.csv")
diagnostic_correction_distorsion("donnees/E01_P02_BA_NF.csv")
```

---

## PHASE 1 — Procédure par participant

> [!important] Procédure standardisée
> Cette section décrit les étapes **exactes** à réaliser pour chaque participant, dans l'ordre. Chaque participant génère des données pour 2 blocs × 2 conditions.

### Étape 1 — Visionnage et identification des essais

**Entrée** : Vidéo brute 10 min (iPhone 15, 4K/60fps)
**Durée estimée** : ~15 min par bloc

1. Ouvrir la vidéo du bloc dans Tracker
2. Visionner la vidéo en entier et **noter sur papier** :
   - Le numéro séquentiel de chaque essai (réussi ET échoué)
   - Pour chaque essai : réussite (oui/non)
   - Pour les échecs : durée approximative (à la seconde)
   - Tout événement particulier (occultation LED, interruption, micro-mouvement sans essai)

> [!warning] Rappel des critères de segmentation
> - **Début d'essai** : dernière frame en position statique de départ (4 appuis imposés), avant le premier mouvement volontaire vers une prise non-initiale
> - **Fin d'essai (réussi)** : première frame de stabilisation de la LED sur la prise finale
> - **Fin d'essai (échoué)** : dernière frame avec au moins un appui sur le mur
> - **Pas un essai** : micro-mouvement exploratoire sans quitter les prises de départ
> 
> Cf. [[Fiche de codage — Segmentation des trajectoires]]

### Étape 2 — Tracking des essais réussis dans Tracker

**Entrée** : Vidéo brute + notes de l'étape 1
**Sortie** : 1 fichier CSV par essai réussi
**Durée estimée** : ~3-5 min par essai

Pour **chaque essai réussi** identifié à l'étape 1 :

1. Positionner l'axe tel que :
![[Capture d’écran 2026-03-24 à 17.28.26.png|400]]
2. Positionner le curseur Tracker au **frame de début**
3. Sélectionner la LED comme cible du tracking semi-automatique
4. Lancer le suivi jusqu'au **frame de fin**
5. Corriger manuellement les **décrochages** éventuels (frame par frame)
6. **Exporter** le CSV avec :
   - Première colonne : **temps en secondes** (pas en frames)
   - Colonnes suivantes : x, y en pixels
   - Séparateur : point-virgule (`;`)
   - Décimale : virgule (`,`)

> [!danger] Convention de nommage obligatoire
> ```
> E[nn]_P[nn]_B[X]_[COND].csv
> ```
> Exemple : `E03_P12_BA_NF.csv` = Essai 03, Participant 12, Bloc A, Non-Fatigué
> 
> - `nn` : numéro séquentiel (01, 02, ...) incluant réussites ET échecs dans l'ordre chronologique
> - `B[X]` : BA ou BB
> - `COND` : F (fatigué) ou NF (non-fatigué)

6. Placer le fichier dans `analyse_video/donnees/`

### Étape 3 — Fichier récapitulatif (essais échoués)

**Entrée** : Notes de l'étape 1
**Sortie** : `recap_P[nn].csv` dans `analyse_video/donnees/recaps/`
**Durée estimée** : ~5 min par participant

Créer le fichier CSV avec **uniquement les essais échoués** :

```csv
participant;bloc;condition;essai_num;reussite;duree_s;commentaire
P12;BA;NF;2;0;12;chute prise 5
P12;BA;NF;3;0;8;lâcher volontaire
P12;BB;F;5;0;15;
```

> [!tip] Les essais réussis n'ont PAS besoin de figurer dans ce fichier
> Leurs durées sont calculées automatiquement depuis les CSV de trajectoires par `analyse_temporelle.py`.

> [!note] Si aucun essai échoué
> Ne pas créer de fichier récapitulatif. Le script `analyse_temporelle.py` fonctionne sans, en calculant les variables temporelles à partir des seuls essais réussis (avec un avertissement).

### Étape 4 — Vérification

Avant de passer au participant suivant, vérifier :

- [ ] Tous les essais réussis ont un CSV dans `donnees/`
- [ ] La convention de nommage est respectée (E, P, B, COND)
- [ ] Le numéro d'essai est séquentiel (réussites + échecs dans l'ordre chronologique)
- [ ] Le récapitulatif des échecs est renseigné (si applicable)
- [ ] Un essai pilote a été ouvert dans Python pour vérifier le format :
```python
import pandas as pd
df = pd.read_csv("donnees/E01_P12_BA_NF.csv", sep=';', decimal=',')
print(df.head())  # Vérifier : 3 colonnes (t, x, y), valeurs numériques
```

---

## PHASE 2 — Traitement collectif (après tous les participants)

### Étape 5 — Pipeline de clustering (par bloc indépendant)

**Entrée** : Tous les CSV trajectoires dans `donnees/`
**Sortie** : `scores_creativite.csv`, graphiques par bloc, matrices SSPD
**Durée estimée** : 1-2h (deux matrices SSPD, une par bloc)

```bash
cd ~/PyCharmMiscProject/ANALYSE/analyse_video
python pipeline_clustering.py
```

> [!important] Clustering par bloc indépendant
> Les blocs BA et BB sont des problèmes d'escalade physiquement différents. Le clustering est exécuté **séparément sur chaque bloc** pour que la SSPD compare des solutions motrices au sein d'un même problème. La comparabilité inter-blocs est assurée par le **contrebalancement** du design et traitée dans R par l'ANOVA mixte 2×2.

Le pipeline exécute séquentiellement :

| Étape | Action | Sortie clé |
|---|---|---|
| 1 | Chargement → distorsion → normalisation (tous fichiers) | `trajectoires_normalisees/` |
| — | *Séparation par bloc (BA / BB)* | |
| 2 | Matrice SSPD par bloc (multiprocessing) | `BA/matrice_distances.csv` |
| 3 | Clustering Ward + seuil manuel (×2 blocs) | `BA/clusters.csv` + dendrogramme |
| 4 | Validation Hubert-Γ par bloc | `BA/validation_indices.csv` |
| 5 | Scores créativité — **moyenne** des originalités | `BA/scores_creativite.csv` |
| 6 | Fusion des scores bruts des deux blocs | `scores_creativite.csv` |
| 7 | Visualisations comparatives F vs NF | Graphiques 13, 14, 15 |

> [!warning] Étapes interactives
> L'étape 3 demande un seuil manuel **pour chaque bloc** (deux saisies). Inspecter `resultats/graphiques/BA/04_diagnostic.png` puis `BB/04_diagnostic.png` avant de choisir.

**Graphiques par bloc** (dans `resultats/graphiques/BA/` et `.../BB/`) :

| # | Graphique |
|---|---|
| 03 | Dendrogramme |
| 04 | Diagnostic seuil (nb clusters + taille max) |
| 05 | Trajectoires colorées par cluster |
| 06 | Cohésion / séparation |
| 07 | Distribution F/NF par cluster |
| 08 | Heatmap participants × clusters (Figure 5 Van Bergen) |
| 11 | Validation Hubert-Γ |
| 12 | Trajectoires F vs NF (3 panneaux : NF, F, superposition) |

**Graphiques comparatifs** (dans `resultats/graphiques/`) :

| # | Graphique |
|---|---|
| 13 | Boxplot créativité F vs NF (un panneau par bloc) |
| 14 | Paired plot — évolution individuelle F → NF |
| 15 | Barplot variabilité F vs NF (moyenne ± std par bloc) |

### Étape 6 — Validation bootstrap pvclust (R)

**Entrée** : `BA/matrice_distances.csv` et `BB/matrice_distances.csv`
**Sortie** : `AU_pvalues.csv`, `AU_scores_resume.csv` (par bloc)

```r
# Dans RStudio — pvclust_validation.R
# Exécuter séparément pour chaque bloc
# Closure sspd_dist avec matrice SSPD précomputed
# parallel = FALSE obligatoire
# 10 000 itérations, AU ≥ 0.95
```

### Étape 7 — Variables temporelles

**Entrée** : CSV trajectoires + récapitulatifs
**Sortie** : `variables_temporelles.csv`, `detail_essais.csv`

```bash
python analyse_temporelle.py
```

> [!note] Mode hybride
> Le script extrait automatiquement les durées des essais réussis depuis les CSV, et les combine avec les essais échoués des fichiers récapitulatifs.

### Étape 8 — Analyse fatigue SmartBoard

**Entrée** : Fichiers SmartBoard bruts
**Sortie** : `synthese_fatigue.csv`

```bash
cd ~/PyCharmMiscProject/ANALYSE/analyse_smartboard
python analyse_smartboard.py
```

> [!important] Terminologie
> **CMV** (Contraction Maximale Volontaire) en français, **MVC** en anglais. Jamais FMV.
> Le premier pic du fichier CMV = suspension passive (poids du corps), pas la CMV.

### Étape 9 — Analyse questionnaires (R)

**Entrée** : Export LimeSurvey
**Sortie** : `scores_psycho.csv` (QORS, ECCI-i-FR, BFI-Fr)

Exécuter le script R d'analyse questionnaires (V3, 7 sections).

### Étape 10 — Intégration finale

**Entrée** : `scores_creativite.csv` + `variables_temporelles.csv` + `synthese_fatigue.csv` + `scores_psycho.csv`
**Sortie** : `dataset_complet.csv`

```bash
cd ~/PyCharmMiscProject/ANALYSE/synthese
python integration.py
```

Ce script fusionne les 4 CSV sur le code participant (P01–P28) et produit le dataset directement importable dans R.

### Étape 11 — Analyses statistiques (R)

**Entrée** : `dataset_complet.csv`
**Sortie** : Résultats des tests, figures ggplot2

- **Analyse principale** : ANOVA mixte 2×2 (Condition F/NF × Profil Promotion/Prévention, mesures répétées sur Condition) — teste simultanément H1 (effet fatigue), H2 (effet profil) et leur interaction
- **Simplification H1** : t-test apparié (ou Wilcoxon) sur les scores de créativité F vs NF (si seul l'effet fatigue est testé)
- **Complémentaire** : Corrélations exploratoires, Cronbach's α, Shapiro-Wilk, régression multiple

> [!note] Comparabilité inter-blocs
> Le contrebalancement garantit que les scores **bruts** sont directement comparables entre conditions. Pas besoin de Z-score — l'ANOVA gère la variance due au bloc via le design contrebalancé. Un modèle linéaire mixte (lmer) peut être utilisé en analyse de sensibilité.

---

## Suivi d'avancement

### Checklist par participant

> [!tip] Utilisation
> Copier ce bloc pour chaque participant dans une note dédiée au suivi, ou utiliser le tableau Dataview ci-dessous.

```markdown
### P[nn]
- [ ] Étape 1 — Visionnage et identification des essais (Bloc A + Bloc B)
- [ ] Étape 2 — Tracking essais réussis Bloc A
- [ ] Étape 2 — Tracking essais réussis Bloc B
- [ ] Étape 3 — Récapitulatif essais échoués
- [ ] Étape 4 — Vérification format et nommage
- [ ] Données SmartBoard extraites
- [ ] Questionnaires complétés (LimeSurvey)
```

### Suivi global (Dataview)

> [!note] Pour que les requêtes Dataview ci-dessous fonctionnent
> Créer une note par participant dans un dossier `ORGANISATION/Participants/` avec le frontmatter suivant :
> ```yaml
> ---
> participant: P01
> tags: [participant, traitement-données]
> tracking_bloc_A: false
> tracking_bloc_B: false
> recap_echoues: false
> verification: false
> smartboard: false
> questionnaire: false
> statut: en-attente
> n_essais_reussis_A: 0
> n_essais_reussis_B: 0
> date_passation: 
> date_traitement: 
> commentaire: ""
> ---
> ```

#### Vue d'ensemble de l'avancement

```dataview
TABLE WITHOUT ID
  participant AS "ID",
  tracking_bloc_A AS "Bloc A",
  tracking_bloc_B AS "Bloc B",
  recap_echoues AS "Récap",
  verification AS "Vérifié",
  smartboard AS "SmartBoard",
  questionnaire AS "Questionnaire",
  statut AS "Statut"
FROM "ORGANISATION/Participants"
WHERE contains(tags, "participant")
SORT participant ASC
```

#### Participants restant à traiter

```dataview
LIST
FROM "ORGANISATION/Participants"
WHERE contains(tags, "participant") AND statut != "terminé"
SORT participant ASC
```

#### Statistiques d'avancement

```dataview
TABLE WITHOUT ID
  length(rows) AS "Total",
  length(filter(rows, (r) => r.statut = "terminé")) AS "Terminés",
  length(filter(rows, (r) => r.statut = "en-cours")) AS "En cours",
  length(filter(rows, (r) => r.statut = "en-attente")) AS "En attente"
FROM "ORGANISATION/Participants"
WHERE contains(tags, "participant")
GROUP BY true
```

#### Volume de données par participant

```dataview
TABLE WITHOUT ID
  participant AS "ID",
  n_essais_reussis_A AS "Réussis A",
  n_essais_reussis_B AS "Réussis B",
  (n_essais_reussis_A + n_essais_reussis_B) AS "Total réussis",
  date_passation AS "Passation",
  date_traitement AS "Traitement"
FROM "ORGANISATION/Participants"
WHERE contains(tags, "participant")
SORT participant ASC
```

---

## Aide-mémoire rapide

### Commandes Python essentielles

| Action | Commande |
|---|---|
| Pipeline complet | `python pipeline_clustering.py` |
| Variables temporelles | `python analyse_temporelle.py` |
| Lire calibration MATLAB | `python lire_calibration.py` |
| Diagnostic distorsion | `from utils_trajectoire import diagnostic_correction_distorsion` |
| Intégration finale | `cd ../synthese && python integration.py` |

### Convention de nommage des fichiers

| Fichier | Format | Exemple |
|---|---|---|
| Trajectoire réussie | `E[nn]_P[nn]_B[X]_[COND].csv` | `E03_P12_BA_NF.csv` |
| Récapitulatif | `recap_P[nn].csv` | `recap_P12.csv` |

### Paramètres clés à retenir

| Paramètre | Valeur | Justification |
|---|---|---|
| Clustering | Par bloc indépendant (BA, BB) | Problèmes physiquement différents |
| Score créativité | **Moyenne** des originalités | Van Bergen et al. (2025), isole originalité du volume |
| N_POINTS | 200 | Détail spatial (vs 100 chez Rein et al.) |
| Lissage Savitzky-Golay | fenêtre=11, ordre=3 | Adapté au clustering SSPD |
| Linkage | Ward | Standard pour ce type d'analyse |
| Seuil | Manuel, un par bloc (Van Bergen) | Inspection diagnostique |
| Bootstrap pvclust | 10 000 itérations, par bloc | AU ≥ 0.95, parallel=FALSE |
| Fatigue validée | ≥ 30% perte de force | Seuil CMV pré/post |
| Comparabilité blocs | Contrebalancement + ANOVA | Pas de Z-score nécessaire |
| Distorsion | Correction post-tracking | Sur coordonnées (x, y), pas sur images |

---

## Références méthodologiques

- [[Rein et al. (2010)]] — Pipeline de clustering, normalisation, Hubert-Γ
- [[Van Bergen et al. (2025)]] — Divergent doing task, scores de créativité (moyenne), seuil manuel
- [[Besse et al. (2016)]] — Métrique SSPD
- [[Medernach et al. (2025)]] — Créativité en escalade, validation inter-codeur
- Zhang, Z. (2000) — Calibration caméra, correction de distorsion
- [[Orth et al. (2017)]] — Construit fonctionnalité + originalité
