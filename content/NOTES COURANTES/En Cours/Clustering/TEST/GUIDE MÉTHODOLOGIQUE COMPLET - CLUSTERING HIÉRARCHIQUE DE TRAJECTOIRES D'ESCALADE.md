
# GUIDE MÉTHODOLOGIQUE COMPLET : CLUSTERING HIÉRARCHIQUE DE TRAJECTOIRES D'ESCALADE

## Application à l'étude des effets de la fatigue sur la créativité motrice

**Document de référence pour l'analyse quantitative des trajectoires motrices en escalade de bloc**

_Auteur : Guide méthodologique basé sur Besse et al. (2016), Rein et al. (2010), et Van Bergen et al. (2025)_  
_Date : Janvier 2026_

---

## TABLE DES MATIÈRES

1. [Introduction conceptuelle](#1-introduction-conceptuelle)
2. [Fondements mathématiques](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#2-fondements-math%C3%A9matiques)
3. [Prétraitement des données](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#3-pr%C3%A9traitement-des-donn%C3%A9es)
4. [Calcul des distances SSPD](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#4-calcul-des-distances-sspd)
5. [Clustering hiérarchique](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#5-clustering-hi%C3%A9rarchique)
6. [Validation des clusters](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#6-validation-des-clusters)
7. [Calcul des scores de créativité](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#7-calcul-des-scores-de-cr%C3%A9ativit%C3%A9)
8. [Pipeline complet d'analyse](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#8-pipeline-complet-danalyse)
9. [Erreurs fréquentes et solutions](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#9-erreurs-fr%C3%A9quentes-et-solutions)
10. [Références et ressources](https://claude.ai/chat/23d372b8-30ac-4580-89d0-478054b91551#10-r%C3%A9f%C3%A9rences-et-ressources)

---

## 1. INTRODUCTION CONCEPTUELLE

### 1.1 Qu'est-ce que le clustering de trajectoires ?

Le clustering (ou analyse en grappes) constitue une famille de techniques statistiques visant à regrouper des objets similaires en ensembles homogènes appelés clusters ou groupes (Everitt et al., 2001). Dans le contexte de l'analyse du mouvement en escalade, ces "objets" sont des **trajectoires motrices** - plus spécifiquement, les déplacements du centre de masse corporel (approximé par la position de la hanche L4-L5) durant l'ascension d'un bloc.

L'objectif fondamental du clustering de trajectoires consiste à identifier des **patterns moteurs distincts** au sein d'un ensemble d'essais d'escalade. Contrairement aux analyses traditionnelles qui comparent des variables discrètes (temps de réalisation, nombre de prises utilisées), le clustering de trajectoires capture la **structure temporelle et spatiale complète** du mouvement (Rein et al., 2010).

### 1.2 Pourquoi utiliser le clustering pour étudier la créativité motrice ?

La créativité motrice en escalade se manifeste par la capacité des grimpeurs à générer des **solutions motrices variées et originales** pour résoudre un même problème spatial (atteindre la prise de sommet). Cette variabilité fonctionnelle représente l'essence même de l'adaptabilité motrice et constitue un marqueur de l'expertise en escalade (Seifert et al., 2014; Orth et al., 2017).

Le clustering de trajectoires offre un cadre méthodologique rigoureux pour quantifier cette créativité en :

1. **Identifiant objectivement** les différentes stratégies motrices utilisées (combien de solutions distinctes ?)
2. **Quantifiant la variabilité fonctionnelle** de chaque grimpeur (diversité du répertoire moteur)
3. **Mesurant l'originalité** des solutions adoptées (rareté statistique des patterns)

Van Bergen et al. (2025) ont démontré que cette approche permet de distinguer les grimpeurs experts des avancés sur la base de leur variabilité fonctionnelle. Notre protocole étend cette logique en examinant comment la **fatigue musculaire** modifie ces patterns de créativité.

### 1.3 Vue d'ensemble de la méthode

Le pipeline d'analyse suit une séquence logique en 6 phases principales :

```
PHASE 1 : Conception du protocole
          ↓ (Définition des points de coupe, contrôle des durées)
PHASE 2 : Extraction des trajectoires (Kinovea)
          ↓ (Coordonnées x,y de la LED à 60 Hz)
PHASE 3 : Prétraitement
          ↓ (Normalisation temporelle à 100 frames)
PHASE 4 : Calcul des distances (SSPD de Besse et al., 2016)
          ↓ (Matrice de dissimilarité N×N)
PHASE 5 : Clustering hiérarchique (Méthode Ward)
          ↓ (Dendrogramme et détermination du nombre de clusters)
PHASE 6 : Validation et interprétation
          ↓ (AU test, Hubert-Γ, scores de créativité)
```

Chacune de ces phases sera détaillée dans les sections suivantes avec les fondements mathématiques, les codes d'implémentation, et les considérations pratiques spécifiques à votre étude.

---

## 2. FONDEMENTS MATHÉMATIQUES

### 2.1 Représentation des trajectoires

#### 2.1.1 Trajectoire comme série temporelle bivariée

Une trajectoire d'escalade peut être formellement définie comme une fonction continue du temps qui décrit la position du centre de masse corporel dans l'espace bidimensionnel (Besse et al., 2016).

**Définition 1** : Une trajectoire discrète $T$ est une séquence ordonnée de points dans $\mathbb{R}^2$ :

$$T = {(p_1, t_1), (p_2, t_2), ..., (p_n, t_n)}$$

où $p_i = (x_i, y_i) \in \mathbb{R}^2$ représente la position spatiale au temps $t_i \in \mathbb{R}$.

Dans notre contexte expérimental :

- $x_i$ : coordonnée horizontale de la hanche (mètres)
- $y_i$ : coordonnée verticale de la hanche (mètres)
- $t_i$ : instant temporel correspondant (secondes)
- $n$ : nombre de points de la trajectoire (variable selon la durée de l'essai)

**Représentation piecewise linéaire** : Entre deux observations successives, la trajectoire est approximée par un segment de droite reliant $p_i$ et $p_{i+1}$ (Besse et al., 2016). Cette représentation linéaire par morceaux constitue une approximation raisonnable étant donné la fréquence d'échantillonnage de 60 Hz.

#### 2.1.2 Représentation matricielle normalisée

Après normalisation temporelle (détaillée section 3.2), chaque trajectoire est représentée comme une matrice $M \in \mathbb{R}^{2 \times 100}$ :

$$M = \begin{bmatrix} x_1 & x_2 & \cdots & x_{100} \ y_1 & y_2 & \cdots & y_{100} \end{bmatrix}$$

Cette représentation standardisée permet la comparaison directe entre trajectoires de durées initiales différentes.

### 2.2 Mesures de dissimilarité

#### 2.2.1 Distance euclidienne simple (inadéquate)

La distance euclidienne standard entre deux vecteurs de coordonnées :

$$d_{Eucl}(T^1, T^2) = \sqrt{\sum_{i=1}^{100} (x_i^1 - x_i^2)^2 + (y_i^1 - y_i^2)^2}$$

est **inadéquate** pour comparer des trajectoires car elle effectue une comparaison point-à-point rigide basée uniquement sur l'index temporel. Deux trajectoires spatialement identiques mais décalées temporellement auraient une distance élevée.

#### 2.2.2 Distance Segment-Path (SPD)

Besse et al. (2016) proposent une métrique basée sur la distance minimale entre chaque point d'une trajectoire et l'ensemble des segments de l'autre trajectoire.

**Définition 2** (Distance point-to-segment) : La distance d'un point $p$ à un segment $s = [p_a, p_b]$ est définie comme :

$$D_{ps}(p, s) = \begin{cases} |p - p_{proj}|_2 & \text{si } p_{proj} \in s \ \min(|p - p_a|_2, |p - p_b|_2) & \text{sinon} \end{cases}$$

où $p_{proj}$ est la projection orthogonale de $p$ sur la droite portant $s$, et $|\cdot|_2$ dénote la norme euclidienne.

**Définition 3** (Distance Segment-Path unidirectionnelle) : La SPD de $T^1$ vers $T^2$ est la moyenne des distances point-to-trajectory pour tous les points de $T^1$ :

$$D_{SPD}(T^1, T^2) = \frac{1}{n_1} \sum_{i=1}^{n_1} D_{pt}(p_i^1, T^2)$$

où $D_{pt}(p_i^1, T^2) = \min_{j \in [1, n_2-1]} D_{ps}(p_i^1, s_j^2)$ est la distance minimale du point $p_i^1$ à n'importe quel segment de $T^2$.

**Propriétés importantes** :

- SPD est **non-symétrique** : généralement $D_{SPD}(T^1, T^2) \neq D_{SPD}(T^2, T^1)$
- SPD = 0 si et seulement si tous les points de $T^1$ appartiennent à $T^2_{pl}$ (représentation piecewise linéaire)

#### 2.2.3 Distance Segment-Path Symétrisée (SSPD)

Pour obtenir une mesure symétrique requise par les algorithmes de clustering, Besse et al. (2016) définissent la SSPD comme la moyenne arithmétique des distances unidirectionnelles :

$$\boxed{D_{SSPD}(T^1, T^2) = \frac{D_{SPD}(T^1, T^2) + D_{SPD}(T^2, T^1)}{2}}$$

**Théorème 1** (Besse et al., 2016) : $D_{SSPD}$ est une **symmetric** sur l'espace des trajectoires, c'est-à-dire qu'elle satisfait :

1. $D_{SSPD}(T^1, T^2) \geq 0$ (non-négativité)
2. $D_{SSPD}(T^1, T^2) = D_{SSPD}(T^2, T^1)$ (symétrie)
3. $D_{SSPD}(T^1, T^1) = 0$ (identité)
4. $D_{SSPD}(T^1, T^2) = 0 \Rightarrow T^1 = T^2$ (séparation)

**Note** : SSPD n'est pas une métrique au sens strict car elle ne satisfait pas l'inégalité triangulaire. Néanmoins, elle constitue une mesure de dissimilarité valide pour le clustering hiérarchique (Besse et al., 2016).

**Interprétation géométrique** : La SSPD mesure la similarité de **forme spatiale** entre deux trajectoires, indépendamment de leur indexation temporelle. Deux trajectoires suivant le même chemin spatial auront une SSPD faible même si elles sont parcourues à des vitesses différentes.

### 2.3 Clustering hiérarchique agglomératif

#### 2.3.1 Principe général

Le clustering hiérarchique agglomératif (HCA) construit une hiérarchie de clusters par fusions successives selon un critère de linkage (Kaufmann & Rousseeuw, 1990). L'algorithme procède comme suit :

**Algorithme 1** : Clustering hiérarchique agglomératif

```
Entrée : Matrice de dissimilarité D ∈ ℝ^(N×N) pour N trajectoires
Sortie : Dendrogramme représentant la hiérarchie de fusions

1. Initialisation : Chaque trajectoire i forme un cluster singleton C_i
2. TANT QUE il reste plus d'un cluster :
     a. Trouver la paire de clusters (C_i, C_j) minimisant d(C_i, C_j)
     b. Fusionner C_i et C_j en un nouveau cluster C_k = C_i ∪ C_j
     c. Calculer les distances de C_k à tous les autres clusters
     d. Enregistrer la hauteur de fusion h_k = d(C_i, C_j)
3. Retourner l'arbre hiérarchique (dendrogramme)
```

La **fonction de linkage** $d(C_i, C_j)$ détermine comment calculer la distance entre deux clusters. Plusieurs variantes existent dans la littérature.

#### 2.3.2 Méthode de Ward (minimum variance)

La méthode de Ward (1963), recommandée par Rein et al. (2010) pour sa robustesse, définit la distance entre clusters comme l'augmentation de la variance intra-cluster totale résultant de leur fusion.

**Définition 4** (Critère de Ward) : Pour deux clusters $Q_1$ et $Q_2$, soit $\bar{x}(Q)$ le centroïde du cluster $Q$ :

$$\bar{x}(Q) = \frac{1}{|Q|} \sum_{i \in Q} x_i$$

La distance de Ward est définie par :

$$d_{Ward}(Q_1, Q_2) = \sqrt{\frac{2|Q_1||Q_2|}{|Q_1| + |Q_2|}} |\bar{x}(Q_1) - \bar{x}(Q_2)|_2$$

**Propriétés** :

- Minimise la variance intra-cluster à chaque étape
- Tend à produire des clusters de tailles relativement équilibrées
- Montré robuste dans de nombreuses études de simulation (Milligan, 1981; Breckenridge, 2000)

**Limitation** : Léger biais vers des clusters de tailles égales (Rencher, 2001), à considérer lors de l'interprétation.

### 2.4 Matrice de dissimilarité

L'ensemble du clustering repose sur la matrice de dissimilarité $D \in \mathbb{R}^{N \times N}$ où $D_{ij} = D_{SSPD}(T^i, T^j)$ pour $N$ trajectoires.

**Propriétés de D** :

- Symétrique : $D_{ij} = D_{ji}$
- Diagonale nulle : $D_{ii} = 0$
- Valeurs positives : $D_{ij} \geq 0$

Cette matrice résume toute l'information de dissimilarité et constitue l'unique input du clustering hiérarchique.

---

## 3. PRÉTRAITEMENT DES DONNÉES

### 3.1 Extraction des trajectoires avec Kinovea

#### 3.1.1 Configuration de l'enregistrement

Votre protocole spécifie les paramètres suivants pour l'acquisition vidéo :

|Paramètre|Valeur|Justification|
|---|---|---|
|Caméra|GoPro Hero4 (ou équivalent)|Rapport coût/performance optimisé|
|Résolution|1080p|Précision spatiale suffisante|
|Fréquence|60 fps|Compromis précision/volume de données|
|Mode FOV|"Linear"|Correction de la distorsion grand-angle|
|Position caméra|0.80 m hauteur, 4 m du mur|Van Bergen et al. (2025)|
|Marqueur LED|Position L4-L5 (hanche)|Approximation du centre de masse|

**Grille de calibration** : Placez 3 marqueurs sur le mur espacés de exactement 1 mètre (horizontal et vertical) au centre de la zone d'escalade. Ces marqueurs serviront de référence spatiale pour convertir les pixels en mètres.

#### 3.1.2 Procédure d'extraction dans Kinovea

**Étape 1 : Calibration spatiale**

1. Ouvrir la vidéo dans Kinovea (version ≥ 0.8.27)
2. Aller dans `Outils` → `Grille de calibration` → `Plan`
3. Sélectionner deux marqueurs horizontaux espacés de 1 m
4. Indiquer la distance réelle : 1.00 m
5. Répéter verticalement pour confirmer la calibration

**Étape 2 : Définition des points de coupe**

**CRITIQUE** : Les points de coupe doivent être identifiables sans ambiguïté dans TOUS les essais pour éviter des erreurs systématiques (Rein et al., 2010).

Pour votre étude, utilisez :

- **Début** : Maximum de flexion du genou avant le départ (facilement identifiable visuellement)
- **Fin** : Maximum de hauteur du poignet après réception de la prise finale (critère IFSC de validation)

**Vérification** : Ces deux événements doivent être présents dans 100% des essais, qu'ils soient réussis ou échoués.

**Étape 3 : Tracking de la LED**

```
Procédure manuelle/semi-automatique :
1. Identifier la frame de début (max flexion genou)
2. Placer un "tracking point" sur la LED rouge
3. Utiliser le tracking automatique de Kinovea : 
   Clic-droit sur le point → "Track path forward"
4. Vérifier frame par frame la qualité du tracking
5. Corriger manuellement si nécessaire (perte du marqueur)
6. Arrêter à la frame de fin (max hauteur poignet)
```

**Note sur le tracking automatique** : La LED rouge facilite la détection automatique. Néanmoins, des corrections manuelles sont souvent nécessaires lors de rotations corporelles importantes ou d'occultations temporaires.

**Étape 4 : Export des données**

```
Kinovea → Outils → Export des données → Format CSV
```

Format de sortie recommandé :

```
time (s), x (m), y (m)
0.000, 1.234, 0.567
0.017, 1.236, 0.571
...
```

**Convention de nommage** : `P{ID_participant}_B{bloc}_E{essai}.csv`

Exemple : `P01_B1_E01.csv` pour Participant 01, Bloc 1, Essai 01

### 3.2 Normalisation temporelle

#### 3.2.1 Pourquoi normaliser temporellement ?

Les essais d'escalade ont des durées variables (de quelques secondes à plusieurs dizaines de secondes selon la difficulté et la stratégie). Cette variabilité empêche la comparaison directe point-à-point entre trajectoires.

**Problème** : Deux trajectoires de durées différentes ont des nombres de points différents ($n_1 \neq n_2$), rendant impossible le calcul de distances simples.

**Solution** : La normalisation temporelle "rééchantillonne" chaque trajectoire sur un nombre fixe de points temporels (typiquement 100), permettant l'alignement temporel relatif.

#### 3.2.2 Principe mathématique

La normalisation consiste à interpoler la trajectoire originale $T_{orig} = {(p_i, t_i)}_{i=1}^{n}$ pour obtenir une trajectoire normalisée $T_{norm} = {(p_j', t_j')}_{j=1}^{N_{target}}$ avec $N_{target} = 100$.

**Méthode d'interpolation linéaire** :

1. Créer un nouvel axe temporel normalisé : $\tau \in [0, 1]$ subdivisé en 100 points uniformes
2. Pour chaque composante (x et y), appliquer une interpolation linéaire :

$$x(\tau_j) = x_i + \frac{(x_{i+1} - x_i)(\tau_j - \tau_i)}{\tau_{i+1} - \tau_i}$$

où $\tau_i \leq \tau_j < \tau_{i+1}$ sont les temps normalisés originaux.

#### 3.2.3 Implémentation Python

```python
import numpy as np
from scipy.interpolate import interp1d

def normalize_trajectory(traj_coords, n_frames=100):
    """
    Normalise temporellement une trajectoire à n_frames points.
    
    Parameters
    ----------
    traj_coords : array-like, shape (n_original, 2)
        Coordonnées originales [x, y] de la trajectoire
    n_frames : int, default=100
        Nombre de points cibles après normalisation
        
    Returns
    -------
    traj_normalized : ndarray, shape (n_frames, 2)
        Trajectoire normalisée
        
    Notes
    -----
    Utilise une interpolation linéaire pour le rééchantillonnage.
    La normalisation préserve la forme spatiale générale mais 
    perd l'information de vitesse absolue.
    """
    n_original = len(traj_coords)
    
    # Axe temporel original normalisé [0, 1]
    t_original = np.linspace(0, 1, n_original)
    
    # Axe temporel cible normalisé [0, 1]  
    t_target = np.linspace(0, 1, n_frames)
    
    # Interpolation séparée pour x et y
    fx = interp1d(t_original, traj_coords[:, 0], kind='linear')
    fy = interp1d(t_original, traj_coords[:, 1], kind='linear')
    
    # Évaluation aux nouveaux points temporels
    x_normalized = fx(t_target)
    y_normalized = fy(t_target)
    
    return np.column_stack([x_normalized, y_normalized])
```

**Utilisation** :

```python
# Charger une trajectoire brute
traj_raw = np.loadtxt('P01_B1_E01.csv', delimiter=',', skiprows=1)
coords_raw = traj_raw[:, 1:3]  # Colonnes x et y

# Normaliser à 100 frames
traj_norm = normalize_trajectory(coords_raw, n_frames=100)

# Vérification
print(f"Points originaux : {coords_raw.shape[0]}")
print(f"Points normalisés : {traj_norm.shape[0]}")  # → 100
```

#### 3.2.4 Limitations et précautions

**⚠️ Contrôle de la variation de durée** : Rein et al. (2010) recommandent que les durées originales ne diffèrent pas de plus de 30% pour éviter des déformations excessives.

**Test de qualité** :

```python
def check_duration_variability(trajectories_list):
    """
    Vérifie que la variabilité des durées reste acceptable.
    """
    durations = [len(traj) for traj in trajectories_list]
    max_dur = max(durations)
    min_dur = min(durations)
    variability = (max_dur - min_dur) / min_dur * 100
    
    print(f"Durée min : {min_dur} frames")
    print(f"Durée max : {max_dur} frames")
    print(f"Variabilité : {variability:.1f}%")
    
    if variability > 30:
        print("⚠️ ATTENTION : Variabilité > 30%, risque de déformation")
    else:
        print("✓ Variabilité acceptable")
        
    return variability
```

**Perte d'information** : La normalisation temporelle sacrifie l'information de vitesse absolue pour se concentrer sur la forme spatiale du trajet. Ceci est acceptable pour votre étude puisque l'objectif est de comparer les **patterns géométriques** plutôt que les profils de vitesse.

### 3.3 Organisation des données

#### 3.3.1 Structure matricielle

Après normalisation, chaque trajectoire est représentée comme une matrice $M \in \mathbb{R}^{2 \times 100}$ :

```python
# Format recommandé pour SSPD : shape (2, 100)
# Ligne 1 : coordonnées x
# Ligne 2 : coordonnées y

trajectory_matrix = np.array([
    [x1, x2, ..., x100],  # Coordonnées horizontales
    [y1, y2, ..., y100]   # Coordonnées verticales
])
```

**Attention** : Le package `trajectory_distance` attend des matrices transposées (2×N) alors que la représentation standard est souvent (N×2). Vérifier systématiquement les dimensions !

#### 3.3.2 Structure de projet recommandée

```
votre_projet/
│
├── data/
│   ├── raw_videos/
│   │   ├── P01_B1_E01.mp4
│   │   ├── P01_B1_E02.mp4
│   │   └── ...
│   │
│   ├── extracted_trajectories/
│   │   ├── P01_B1_E01.csv
│   │   ├── P01_B1_E02.csv
│   │   └── ...
│   │
│   └── normalized_trajectories/
│       ├── P01_B1_E01_norm.npy
│       ├── P01_B1_E02_norm.npy
│       └── ...
│
├── scripts/
│   ├── 01_extract_kinovea.py
│   ├── 02_normalize_trajectories.py
│   ├── 03_compute_distances.py
│   ├── 04_hierarchical_clustering.py
│   └── 05_validation_and_scores.py
│
├── results/
│   ├── distance_matrices/
│   ├── dendrograms/
│   ├── cluster_assignments/
│   └── creativity_scores/
│
└── README.md
```

#### 3.3.3 Chargement batch des trajectoires

```python
import os
import numpy as np
from pathlib import Path

def load_all_trajectories(data_dir, participant_id, block_id, condition):
    """
    Charge toutes les trajectoires normalisées pour un participant/bloc/condition.
    
    Parameters
    ----------
    data_dir : str ou Path
        Répertoire contenant les fichiers .npy
    participant_id : str
        ID du participant (ex: "P01")
    block_id : str
        ID du bloc (ex: "B1" ou "B2")
    condition : str
        Condition expérimentale ("pre_fatigue" ou "post_fatigue")
        
    Returns
    -------
    trajectories : list of ndarray
        Liste de matrices (2, 100) pour chaque essai réussi
    trial_ids : list of str
        Identifiants correspondants des essais
    """
    data_path = Path(data_dir)
    pattern = f"{participant_id}_{block_id}_*.npy"
    
    trajectories = []
    trial_ids = []
    
    # Filtrer selon la condition
    if condition == "pre_fatigue":
        block_filter = "B1"
    elif condition == "post_fatigue":
        block_filter = "B2"
    else:
        block_filter = block_id
    
    for filepath in sorted(data_path.glob(pattern)):
        # Charger la trajectoire normalisée
        traj = np.load(filepath)
        
        # Vérifier les dimensions (2, 100)
        assert traj.shape == (2, 100), f"Dimension incorrecte : {traj.shape}"
        
        trajectories.append(traj)
        trial_ids.append(filepath.stem)
    
    print(f"Chargé {len(trajectories)} trajectoires pour {participant_id} - {block_id}")
    
    return trajectories, trial_ids

# Exemple d'utilisation
trajs_pre, ids_pre = load_all_trajectories(
    data_dir="data/normalized_trajectories",
    participant_id="P01",
    block_id="B1",
    condition="pre_fatigue"
)
```

---

## 4. CALCUL DES DISTANCES SSPD

### 4.1 Installation du package trajectory_distance

Le package `trajectory_distance` développé par Besse et al. (2016) implémente efficacement la SSPD et d'autres métriques de trajectoires.

#### 4.1.1 Installation

```bash
# Via pip depuis le dépôt GitHub
pip install git+https://github.com/bguillouet/traj-dist.git

# OU clone + installation locale
git clone https://github.com/bguillouet/traj-dist.git
cd traj-dist
pip install -e .
```

**Dépendances** : `numpy`, `scipy`

#### 4.1.2 Vérification de l'installation

```python
# Test simple
from trajectory_distance.sspd import sspd
import numpy as np

# Créer deux trajectoires de test
traj1 = np.random.randn(2, 100)
traj2 = np.random.randn(2, 100)

# Calculer la distance
dist = sspd(traj1, traj2)
print(f"Distance SSPD : {dist:.3f}")
```

### 4.2 Calcul de la matrice de dissimilarité

#### 4.2.1 Fonction de calcul

```python
from trajectory_distance.sspd import sspd
import numpy as np

def compute_distance_matrix(trajectories, verbose=True):
    """
    Calcule la matrice de dissimilarité SSPD pour un ensemble de trajectoires.
    
    Parameters
    ----------
    trajectories : list of ndarray
        Liste de N trajectoires, chacune de shape (2, 100)
    verbose : bool, default=True
        Afficher la progression du calcul
        
    Returns
    -------
    D : ndarray, shape (N, N)
        Matrice de dissimilarité symétrique
        D[i,j] = distance SSPD entre trajectoire i et j
        
    Notes
    -----
    Complexité : O(N²) avec N = nombre de trajectoires
    Temps de calcul typique : ~0.5s pour 100 trajectoires sur CPU standard
    """
    N = len(trajectories)
    D = np.zeros((N, N))
    
    # Calcul des distances (seulement triangle supérieur par symétrie)
    for i in range(N):
        for j in range(i+1, N):
            # SSPD attend des matrices (2, 100) = (dimensions, temps)
            # Si vos matrices sont (100, 2), transposer avec .T
            dist = sspd(trajectories[i], trajectories[j])
            
            # Remplir les deux triangles (symétrie)
            D[i, j] = dist
            D[j, i] = dist
            
        if verbose and (i+1) % 10 == 0:
            print(f"Progression : {i+1}/{N} trajectoires traitées")
    
    return D
```

#### 4.2.2 Propriétés de la matrice obtenue

```python
def validate_distance_matrix(D):
    """
    Vérifie les propriétés attendues de la matrice de dissimilarité.
    """
    N = D.shape[0]
    
    # Test 1 : Matrice carrée
    assert D.shape == (N, N), "La matrice doit être carrée"
    
    # Test 2 : Symétrie
    assert np.allclose(D, D.T), "La matrice doit être symétrique"
    
    # Test 3 : Diagonale nulle
    assert np.allclose(np.diag(D), 0), "La diagonale doit être nulle"
    
    # Test 4 : Valeurs positives
    assert np.all(D >= 0), "Toutes les distances doivent être ≥ 0"
    
    print("✓ Matrice de dissimilarité valide")
    print(f"  Dimension : {N}×{N}")
    print(f"  Distance min (hors diagonale) : {D[D > 0].min():.3f}")
    print(f"  Distance max : {D.max():.3f}")
    print(f"  Distance moyenne : {D[D > 0].mean():.3f}")
    
    return True
```

#### 4.2.3 Visualisation de la matrice

```python
import matplotlib.pyplot as plt
import seaborn as sns

def plot_distance_matrix(D, trial_labels=None, title="Matrice de dissimilarité SSPD"):
    """
    Visualise la matrice de dissimilarité sous forme de heatmap.
    """
    fig, ax = plt.subplots(figsize=(10, 8))
    
    # Heatmap avec seaborn
    sns.heatmap(D, 
                cmap='viridis', 
                square=True,
                cbar_kws={'label': 'Distance SSPD'},
                ax=ax)
    
    # Labels si fournis
    if trial_labels is not None:
        ax.set_xticklabels(trial_labels, rotation=90, ha='right', fontsize=8)
        ax.set_yticklabels(trial_labels, rotation=0, va='center', fontsize=8)
    
    ax.set_title(title, fontsize=14, fontweight='bold')
    ax.set_xlabel('Essai', fontsize=12)
    ax.set_ylabel('Essai', fontsize=12)
    
    plt.tight_layout()
    return fig, ax

# Exemple d'utilisation
fig, ax = plot_distance_matrix(
    D, 
    trial_labels=ids_pre,
    title="Dissimilarité SSPD - Participant 01 - Pré-fatigue"
)
plt.savefig('results/distance_matrices/P01_B1_distance_matrix.png', dpi=300)
plt.show()
```

### 4.3 Interprétation des valeurs de distance

#### 4.3.1 Échelle des distances

Les valeurs de SSPD dépendent de l'échelle spatiale de vos données (en mètres dans votre cas). Quelques points de repère :

|Distance SSPD|Interprétation|Similarité|
|---|---|---|
|0.0 - 0.5|Trajectoires quasi-identiques|Très haute|
|0.5 - 2.0|Trajectoires similaires (variations mineures)|Haute|
|2.0 - 5.0|Trajectoires modérément différentes|Moyenne|
|> 5.0|Trajectoires très différentes|Faible|

**Note** : Ces seuils sont indicatifs et dépendent de la taille du mur et de l'amplitude des mouvements. Van Bergen et al. (2025) ont utilisé un seuil de ~15 unités pour leur étude, mais sur un mur différent.

#### 4.3.2 Distribution typique

```python
def analyze_distance_distribution(D):
    """
    Analyse statistique de la distribution des distances.
    """
    # Extraire triangle supérieur (sans diagonale)
    triu_indices = np.triu_indices_from(D, k=1)
    distances = D[triu_indices]
    
    print("=" * 50)
    print("ANALYSE DE LA DISTRIBUTION DES DISTANCES")
    print("=" * 50)
    print(f"Nombre de paires : {len(distances)}")
    print(f"Minimum : {distances.min():.3f}")
    print(f"25e percentile : {np.percentile(distances, 25):.3f}")
    print(f"Médiane : {np.median(distances):.3f}")
    print(f"75e percentile : {np.percentile(distances, 75):.3f}")
    print(f"Maximum : {distances.max():.3f}")
    print(f"Moyenne : {distances.mean():.3f}")
    print(f"Écart-type : {distances.std():.3f}")
    
    # Histogramme
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.hist(distances, bins=30, edgecolor='black', alpha=0.7)
    ax.axvline(distances.mean(), color='red', linestyle='--', 
               label=f'Moyenne = {distances.mean():.2f}')
    ax.axvline(np.median(distances), color='green', linestyle='--',
               label=f'Médiane = {np.median(distances):.2f}')
    ax.set_xlabel('Distance SSPD', fontsize=12)
    ax.set_ylabel('Fréquence', fontsize=12)
    ax.set_title('Distribution des distances SSPD', fontsize=14, fontweight='bold')
    ax.legend()
    ax.grid(alpha=0.3)
    plt.tight_layout()
    
    return fig, ax, distances
```

### 4.4 Sauvegarde et chargement

```python
# Sauvegarde de la matrice de distance
np.save('results/distance_matrices/P01_B1_distance_matrix.npy', D)

# Chargement ultérieur
D_loaded = np.load('results/distance_matrices/P01_B1_distance_matrix.npy')
```

---

## 5. CLUSTERING HIÉRARCHIQUE

### 5.1 Construction du dendrogramme

#### 5.1.1 Conversion au format condensé

Les algorithmes de clustering hiérarchique dans `scipy` requièrent la matrice de distance au format "condensé" (vecteur 1D du triangle supérieur).

```python
from scipy.spatial.distance import squareform

def prepare_for_clustering(D):
    """
    Convertit la matrice de dissimilarité N×N au format condensé pour scipy.
    
    Parameters
    ----------
    D : ndarray, shape (N, N)
        Matrice de dissimilarité symétrique
        
    Returns
    -------
    D_condensed : ndarray, shape (N*(N-1)/2,)
        Vecteur condensé contenant le triangle supérieur
    """
    # Vérifier la symétrie
    assert np.allclose(D, D.T), "La matrice doit être symétrique"
    
    # Conversion
    D_condensed = squareform(D)
    
    print(f"Matrice {D.shape} → Vecteur de longueur {len(D_condensed)}")
    
    return D_condensed
```

#### 5.1.2 Clustering avec la méthode Ward

```python
from scipy.cluster.hierarchy import linkage, dendrogram, fcluster

def perform_hierarchical_clustering(D, method='ward'):
    """
    Effectue le clustering hiérarchique agglomératif.
    
    Parameters
    ----------
    D : ndarray, shape (N, N)
        Matrice de dissimilarité
    method : str, default='ward'
        Méthode de linkage : 'ward', 'average', 'complete', 'single'
        
    Returns
    -------
    Z : ndarray, shape (N-1, 4)
        Matrice de linkage encodant la hiérarchie
        Colonnes : [cluster1, cluster2, distance, n_items]
        
    Notes
    -----
    La méthode 'ward' (minimum variance) est recommandée pour sa robustesse
    (Rein et al., 2010; Breckenridge, 2000).
    """
    # Conversion au format condensé
    D_condensed = squareform(D)
    
    # Clustering hiérarchique
    Z = linkage(D_condensed, method=method)
    
    print(f"Clustering hiérarchique effectué avec méthode '{method}'")
    print(f"Nombre de fusions : {len(Z)}")
    print(f"Hauteur finale : {Z[-1, 2]:.3f}")
    
    return Z
```

#### 5.1.3 Visualisation du dendrogramme

```python
def plot_dendrogram(Z, trial_labels=None, threshold=None, 
                   title="Dendrogramme - Clustering hiérarchique"):
    """
    Visualise le dendrogramme du clustering hiérarchique.
    
    Parameters
    ----------
    Z : ndarray
        Matrice de linkage
    trial_labels : list of str, optional
        Labels des feuilles (essais)
    threshold : float, optional
        Seuil de coupure pour colorier les clusters
    title : str
        Titre du graphique
    """
    fig, ax = plt.subplots(figsize=(14, 8))
    
    # Options du dendrogramme
    dendrogram_params = {
        'color_threshold': threshold if threshold else None,
        'above_threshold_color': 'gray',
        'labels': trial_labels,
        'leaf_rotation': 90,
        'leaf_font_size': 8,
    }
    
    # Tracer le dendrogramme
    dend = dendrogram(Z, ax=ax, **dendrogram_params)
    
    # Ligne de seuil si spécifiée
    if threshold:
        ax.axhline(y=threshold, color='red', linestyle='--', linewidth=2,
                  label=f'Seuil = {threshold:.2f}')
        ax.legend()
    
    # Mise en forme
    ax.set_xlabel('Essai', fontsize=12, fontweight='bold')
    ax.set_ylabel('Distance de fusion', fontsize=12, fontweight='bold')
    ax.set_title(title, fontsize=14, fontweight='bold')
    ax.grid(axis='y', alpha=0.3)
    
    plt.tight_layout()
    
    return fig, ax, dend

# Exemple d'utilisation
Z = perform_hierarchical_clustering(D, method='ward')

fig, ax, dend = plot_dendrogram(
    Z, 
    trial_labels=ids_pre,
    threshold=15.0,  # À ajuster selon vos données
    title="Dendrogramme - P01 - Bloc 1 - Pré-fatigue"
)

plt.savefig('results/dendrograms/P01_B1_dendrogram.png', dpi=300, bbox_inches='tight')
plt.show()
```

### 5.2 Détermination du nombre optimal de clusters

#### 5.2.1 Méthode visuelle (analyse des sauts)

La méthode la plus intuitive consiste à identifier visuellement les "grands sauts" dans le dendrogramme, qui indiquent des fusions de clusters très dissimilaires.

```python
def analyze_fusion_heights(Z, n_top=10):
    """
    Analyse les hauteurs de fusion pour identifier les sauts significatifs.
    
    Parameters
    ----------
    Z : ndarray
        Matrice de linkage
    n_top : int, default=10
        Nombre de plus grands sauts à afficher
        
    Returns
    -------
    jumps : ndarray
        Différences entre hauteurs de fusion successives (trié décroissant)
    """
    # Extraire les hauteurs de fusion (colonne 2)
    heights = Z[:, 2]
    
    # Calculer les différences (sauts) entre fusions successives
    jumps = np.diff(heights)
    
    # Trier par ordre décroissant
    jumps_sorted = np.sort(jumps)[::-1]
    
    print("=" * 60)
    print(f"TOP {n_top} SAUTS DANS LES HAUTEURS DE FUSION")
    print("=" * 60)
    print(f"{'Rang':<6} {'Saut':<12} {'Nombre de clusters suggéré'}")
    print("-" * 60)
    
    for i, jump in enumerate(jumps_sorted[:n_top]):
        # Trouver où se situe ce saut dans la séquence originale
        position = np.where(jumps == jump)[0][0]
        n_clusters = len(Z) - position  # N-1 fusions → position donne le nombre
        
        print(f"{i+1:<6} {jump:<12.3f} {n_clusters}")
    
    # Graphique
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(range(1, len(heights)+1), heights, marker='o', markersize=4)
    ax.set_xlabel('Étape de fusion', fontsize=12)
    ax.set_ylabel('Hauteur de fusion', fontsize=12)
    ax.set_title('Évolution des hauteurs de fusion', fontsize=14, fontweight='bold')
    ax.grid(alpha=0.3)
    plt.tight_layout()
    
    return jumps_sorted, fig, ax

# Utilisation
jumps, fig, ax = analyze_fusion_heights(Z, n_top=10)
```

**Interprétation** : Un saut important suggère qu'il est coûteux de fusionner davantage, indiquant que le nombre de clusters juste avant ce saut est optimal.

#### 5.2.2 Extraction des assignations de clusters

Une fois le nombre de clusters déterminé, extraire les assignations :

```python
def get_cluster_assignments(Z, n_clusters):
    """
    Extrait les assignations de clusters pour un nombre donné de clusters.
    
    Parameters
    ----------
    Z : ndarray
        Matrice de linkage
    n_clusters : int
        Nombre de clusters souhaité
        
    Returns
    -------
    labels : ndarray, shape (N,)
        Assignation de cluster pour chaque trajectoire (1-indexed)
    cluster_sizes : dict
        Taille de chaque cluster
    """
    # Couper le dendrogramme à la hauteur correspondant à n_clusters
    labels = fcluster(Z, n_clusters, criterion='maxclust')
    
    # Statistiques
    unique_labels = np.unique(labels)
    cluster_sizes = {label: np.sum(labels == label) for label in unique_labels}
    
    print(f"Assignation en {n_clusters} clusters :")
    print(f"  Nombre d'items : {len(labels)}")
    print(f"  Tailles des clusters : {cluster_sizes}")
    
    return labels, cluster_sizes

# Exemple : tester plusieurs nombres de clusters
for k in [2, 3, 4, 5]:
    labels, sizes = get_cluster_assignments(Z, n_clusters=k)
    print()
```

#### 5.2.3 Approche basée sur un seuil de distance

Van Bergen et al. (2025) ont utilisé un **seuil de distance fixe** (15 unités) plutôt qu'un nombre de clusters fixe. Cette approche a l'avantage de s'adapter automatiquement à la structure des données.

```python
def cut_dendrogram_at_threshold(Z, threshold):
    """
    Coupe le dendrogramme à une hauteur spécifique.
    
    Parameters
    ----------
    Z : ndarray
        Matrice de linkage
    threshold : float
        Hauteur de coupure
        
    Returns
    -------
    labels : ndarray
        Assignations de clusters
    n_clusters : int
        Nombre résultant de clusters
    """
    # Couper selon le critère de distance
    labels = fcluster(Z, threshold, criterion='distance')
    
    n_clusters = len(np.unique(labels))
    cluster_sizes = {label: np.sum(labels == label) 
                    for label in np.unique(labels)}
    
    print(f"Coupure à la hauteur {threshold:.2f} :")
    print(f"  Nombre de clusters : {n_clusters}")
    print(f"  Tailles : {cluster_sizes}")
    
    return labels, n_clusters

# Exemple
labels_15, n_clust_15 = cut_dendrogram_at_threshold(Z, threshold=15.0)
```

**Calibration du seuil** : Examiner l'évolution du nombre de clusters en fonction du seuil :

```python
def plot_clusters_vs_threshold(Z, threshold_range=None):
    """
    Trace l'évolution du nombre de clusters en fonction du seuil.
    """
    if threshold_range is None:
        # Définir automatiquement une plage raisonnable
        heights = Z[:, 2]
        threshold_range = np.linspace(heights.min(), heights.max(), 50)
    
    n_clusters_list = []
    max_cluster_sizes = []
    
    for thresh in threshold_range:
        labels = fcluster(Z, thresh, criterion='distance')
        n_clusters_list.append(len(np.unique(labels)))
        cluster_sizes = [np.sum(labels == label) for label in np.unique(labels)]
        max_cluster_sizes.append(max(cluster_sizes))
    
    # Graphique
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8), sharex=True)
    
    # Nombre de clusters
    ax1.plot(threshold_range, n_clusters_list, 'o-', color='blue', markersize=4)
    ax1.set_ylabel('Nombre de clusters', fontsize=12, fontweight='bold')
    ax1.grid(alpha=0.3)
    ax1.set_title('Évolution du clustering en fonction du seuil', 
                  fontsize=14, fontweight='bold')
    
    # Taille du plus grand cluster
    ax2.plot(threshold_range, max_cluster_sizes, 'o-', color='red', markersize=4)
    ax2.set_xlabel('Seuil de distance', fontsize=12, fontweight='bold')
    ax2.set_ylabel('Taille max cluster', fontsize=12, fontweight='bold')
    ax2.grid(alpha=0.3)
    
    plt.tight_layout()
    
    return fig, (ax1, ax2), threshold_range, n_clusters_list

# Utilisation
fig, axes, thresholds, n_clusters_list = plot_clusters_vs_threshold(Z)
plt.savefig('results/cluster_analysis/threshold_analysis.png', dpi=300)
plt.show()
```

**Conseil pratique** : Cherchez un "coude" dans la courbe où le nombre de clusters se stabilise. C'est souvent un bon compromis entre simplicité (peu de clusters) et granularité (clusters homogènes).

---

## 6. VALIDATION DES CLUSTERS

### 6.1 Score de Hubert-Γ

#### 6.1.1 Principe

Le coefficient de Hubert-Γ mesure la **concordance** entre la matrice de distances observées $D$ et la structure de clusters obtenue (Jain, 1988; Handl et al., 2005).

**Définition** : Soit $C$ la matrice de co-appartenance aux clusters :

$$C_{ij} = \begin{cases} 1 & \text{si trajectoires } i \text{ et } j \text{ dans le même cluster} \ 0 & \text{sinon} \end{cases}$$

Le coefficient de Hubert-Γ standardisé est :

$$\hat{\Gamma} = \frac{\frac{1}{M}\sum_{i=1}^{N-1}\sum_{j=i+1}^{N} [D(i,j) - \mu_D][C(i,j) - \mu_C]}{\sigma_D \sigma_C}$$

où $M = N(N-1)/2$ est le nombre de paires, et $\mu$, $\sigma$ sont les moyennes et écarts-types.

**Interprétation** :

- $\hat{\Gamma}$ élevé → Bonne concordance : trajectoires proches sont dans les mêmes clusters
- $\hat{\Gamma}$ faible → Mauvaise concordance : clustering ne respecte pas la structure de distances

#### 6.1.2 Implémentation Python

```python
def compute_hubert_gamma(D, labels):
    """
    Calcule le coefficient de Hubert-Γ pour évaluer la qualité du clustering.
    
    Parameters
    ----------
    D : ndarray, shape (N, N)
        Matrice de dissimilarité
    labels : ndarray, shape (N,)
        Assignations de clusters
        
    Returns
    -------
    gamma : float
        Coefficient de Hubert-Γ standardisé (corrélation entre D et C)
        
    Notes
    -----
    Un Γ élevé indique une bonne concordance entre distances et clustering.
    """
    N = len(labels)
    
    # Construire la matrice de co-appartenance C
    C = np.zeros((N, N))
    for i in range(N):
        for j in range(N):
            C[i, j] = 1 if labels[i] == labels[j] else 0
    
    # Extraire les triangles supérieurs (paires uniques)
    triu_indices = np.triu_indices(N, k=1)
    D_flat = D[triu_indices]
    C_flat = C[triu_indices]
    
    # Calculer la corrélation (= Γ standardisé)
    gamma = np.corrcoef(D_flat, C_flat)[0, 1]
    
    return gamma

def evaluate_multiple_clusterings(Z, D, k_range=range(2, 16)):
    """
    Évalue le Hubert-Γ pour différents nombres de clusters.
    
    Parameters
    ----------
    Z : ndarray
        Matrice de linkage
    D : ndarray
        Matrice de dissimilarité
    k_range : iterable
        Nombres de clusters à tester
        
    Returns
    -------
    gammas : dict
        Scores Γ pour chaque k
    best_k : int
        Nombre de clusters maximisant Γ
    """
    gammas = {}
    
    for k in k_range:
        labels = fcluster(Z, k, criterion='maxclust')
        gamma = compute_hubert_gamma(D, labels)
        gammas[k] = gamma
        print(f"k = {k:2d} clusters : Γ = {gamma:.4f}")
    
    # Identifier le maximum
    best_k = max(gammas, key=gammas.get)
    print(f"\n✓ Optimum : k = {best_k} clusters (Γ = {gammas[best_k]:.4f})")
    
    return gammas, best_k
```

#### 6.1.3 Visualisation du score Γ

```python
def plot_hubert_gamma(gammas, highlight_best=True):
    """
    Trace l'évolution du score de Hubert-Γ en fonction du nombre de clusters.
    """
    k_values = list(gammas.keys())
    gamma_values = list(gammas.values())
    
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Courbe principale
    ax.plot(k_values, gamma_values, 'o-', linewidth=2, markersize=8,
            color='steelblue', label='Hubert-Γ')
    
    # Mettre en évidence le maximum
    if highlight_best:
        best_k = max(gammas, key=gammas.get)
        best_gamma = gammas[best_k]
        ax.plot(best_k, best_gamma, 'ro', markersize=15, 
                label=f'Optimum (k={best_k})')
        ax.axvline(best_k, color='red', linestyle='--', alpha=0.5)
    
    # Mise en forme
    ax.set_xlabel('Nombre de clusters (k)', fontsize=12, fontweight='bold')
    ax.set_ylabel('Coefficient de Hubert-Γ', fontsize=12, fontweight='bold')
    ax.set_title('Validation par le coefficient de Hubert-Γ', 
                 fontsize=14, fontweight='bold')
    ax.grid(alpha=0.3)
    ax.legend(fontsize=11)
    ax.set_xticks(k_values)
    
    plt.tight_layout()
    
    return fig, ax

# Exemple complet
gammas, best_k = evaluate_multiple_clusterings(Z, D, k_range=range(2, 16))
fig, ax = plot_hubert_gamma(gammas, highlight_best=True)
plt.savefig('results/validation/hubert_gamma_analysis.png', dpi=300)
plt.show()
```

### 6.2 Test AU (Approximately Unbiased)

#### 6.2.1 Principe du bootstrap multiscale

Le test AU développé par Shimodaira (2002, 2004) utilise un **bootstrap multiscale** pour estimer la p-value de chaque cluster du dendrogramme. Cette p-value représente la probabilité que le cluster observé soit un artefact de l'échantillonnage.

**Interprétation des p-values** :

- **AU p-value ≥ 0.95** : Cluster très stable, structure réelle hautement probable
- **AU p-value < 0.95** : Cluster potentiellement artefactuel, interprétation prudente

#### 6.2.2 Implémentation en R avec pvclust

Le package R `pvclust` implémente le test AU de manière optimisée.

```r
# Installation si nécessaire
if (!require("pvclust")) install.packages("pvclust")

library(pvclust)

# Fonction pour analyser un clustering avec AU test
analyze_with_pvclust <- function(distance_matrix_file, n_boot=10000, output_prefix) {
  """
  Effectue le clustering avec validation AU en R.
  
  Parameters
  ----------
  distance_matrix_file : str
      Chemin vers le fichier .csv de la matrice de distance
  n_boot : int
      Nombre d'itérations de bootstrap (10000-20000 recommandé)
  output_prefix : str
      Préfixe pour les fichiers de sortie
  
  Returns
  -------
  Sauvegarde le dendrogramme avec p-values et les résultats numériques
  """
  
  # 1. Charger la matrice de distance
  D <- as.matrix(read.csv(distance_matrix_file, row.names=1))
  
  # 2. Convertir en objet dist
  D_dist <- as.dist(D)
  
  # 3. Clustering avec bootstrap multiscale
  # Attention : peut prendre plusieurs minutes selon N et n_boot
  cat(sprintf("Début du bootstrap avec %d itérations...\n", n_boot))
  
  result <- pvclust(
    data = t(D),  # pvclust attend variables × observations
    method.hclust = "ward.D2",  # Méthode Ward (important : "ward.D2" pour cohérence avec scipy)
    method.dist = "euclidean",  # Déjà des distances, mais requis par pvclust
    nboot = n_boot,
    parallel = TRUE  # Utiliser le calcul parallèle si disponible
  )
  
  cat("Bootstrap terminé.\n")
  
  # 4. Visualisation avec p-values
  png(filename = paste0(output_prefix, "_dendrogram_AU.png"), 
      width = 1400, height = 800, res = 150)
  plot(result, 
       main = "Dendrogramme avec p-values AU",
       cex = 0.8,
       cex.pv = 0.9)
  
  # Rectangles autour des clusters significatifs (AU p-value > 0.95)
  pvrect(result, alpha = 0.95, pv = "au", border = "red", lwd = 2)
  
  dev.off()
  
  # 5. Extraire et sauvegarder les p-values
  # AU p-value : colonne "au"
  # BP p-value : colonne "bp" (bootstrap standard, moins fiable)
  pvalues <- data.frame(
    cluster_id = 1:nrow(result$edges),
    au_pvalue = result$edges$au,
    bp_pvalue = result$edges$bp,
    cluster_height = result$edges$height,
    cluster_size = result$edges$count
  )
  
  # Trier par p-value AU décroissante
  pvalues <- pvalues[order(-pvalues$au_pvalue), ]
  
  # Sauvegarder
  write.csv(pvalues, 
            file = paste0(output_prefix, "_AU_pvalues.csv"),
            row.names = FALSE)
  
  # 6. Résumé à l'écran
  cat("\n========================================\n")
  cat("RÉSULTATS DU TEST AU\n")
  cat("========================================\n")
  
  # Clusters très stables (AU ≥ 0.95)
  stable_clusters <- pvalues[pvalues$au_pvalue >= 0.95, ]
  cat(sprintf("Nombre de clusters AU ≥ 0.95 : %d\n", nrow(stable_clusters)))
  
  if (nrow(stable_clusters) > 0) {
    cat("\nClusters les plus stables :\n")
    print(head(stable_clusters, 10))
  }
  
  return(list(result = result, pvalues = pvalues))
}

# Exemple d'utilisation
result_list <- analyze_with_pvclust(
  distance_matrix_file = "results/distance_matrices/P01_B1_distance_matrix.csv",
  n_boot = 10000,
  output_prefix = "results/validation/P01_B1"
)
```

**Temps de calcul** : Le test AU avec 10,000 itérations prend typiquement 5-30 minutes selon $N$ et la puissance de calcul. Utiliser `parallel = TRUE` pour accélérer sur machines multi-cœurs.

#### 6.2.3 Intégration Python ↔ R

Pour exécuter le script R depuis Python et récupérer les résultats :

```python
import subprocess
import pandas as pd

def run_au_test_in_R(D, trial_labels, output_prefix, n_boot=10000):
    """
    Interface Python pour exécuter le test AU en R via subprocess.
    
    Parameters
    ----------
    D : ndarray
        Matrice de dissimilarité
    trial_labels : list
        Labels des essais
    output_prefix : str
        Préfixe pour les fichiers de sortie
    n_boot : int
        Nombre d'itérations de bootstrap
        
    Returns
    -------
    pvalues_df : DataFrame
        Table des p-values AU pour chaque cluster
    """
    # 1. Sauvegarder la matrice de distance en CSV pour R
    df_distance = pd.DataFrame(D, index=trial_labels, columns=trial_labels)
    csv_path = f"{output_prefix}_distance_matrix.csv"
    df_distance.to_csv(csv_path)
    
    # 2. Créer un script R temporaire
    r_script = f"""
    source('scripts/pvclust_analysis.R')
    
    result_list <- analyze_with_pvclust(
      distance_matrix_file = "{csv_path}",
      n_boot = {n_boot},
      output_prefix = "{output_prefix}"
    )
    """
    
    script_path = f"{output_prefix}_temp_script.R"
    with open(script_path, 'w') as f:
        f.write(r_script)
    
    # 3. Exécuter le script R
    print(f"Exécution du test AU avec {n_boot} itérations de bootstrap...")
    print("Cela peut prendre plusieurs minutes...")
    
    try:
        subprocess.run(['Rscript', script_path], check=True)
        print("✓ Test AU terminé avec succès")
    except subprocess.CalledProcessError as e:
        print(f"✗ Erreur lors de l'exécution du script R : {e}")
        return None
    
    # 4. Charger les résultats
    pvalues_file = f"{output_prefix}_AU_pvalues.csv"
    pvalues_df = pd.read_csv(pvalues_file)
    
    # 5. Résumé
    n_stable = (pvalues_df['au_pvalue'] >= 0.95).sum()
    print(f"\nNombre de clusters très stables (AU ≥ 0.95) : {n_stable}")
    
    print("\nTop 5 clusters par stabilité :")
    print(pvalues_df.nlargest(5, 'au_pvalue')[['cluster_id', 'au_pvalue', 'cluster_size']])
    
    return pvalues_df

# Exemple complet
pvalues_df = run_au_test_in_R(
    D=D,
    trial_labels=ids_pre,
    output_prefix="results/validation/P01_B1",
    n_boot=10000
)
```

### 6.3 Validation convergente

#### 6.3.1 Principe

La stratégie optimale consiste à **combiner plusieurs méthodes de validation** pour identifier le nombre de clusters de manière robuste (Handl et al., 2005).

**Critères de décision convergents** :

1. **Dendrogramme** : Sauts visuels importants dans les hauteurs de fusion
2. **Hubert-Γ** : Pic indiquant la meilleure concordance distance-clustering
3. **Test AU** : p-values élevées (≥ 0.95) confirmant la stabilité
4. **Nombre et taille des clusters** : Distribution raisonnable (pas de singletons excessifs)

#### 6.3.2 Tableau de synthèse

```python
def create_validation_summary(Z, D, k_range=range(2, 11), pvalues_df=None):
    """
    Crée un tableau de synthèse des indicateurs de validation.
    
    Parameters
    ----------
    Z : ndarray
        Matrice de linkage
    D : ndarray
        Matrice de dissimilarité
    k_range : iterable
        Nombres de clusters à évaluer
    pvalues_df : DataFrame, optional
        Résultats du test AU (si disponible)
        
    Returns
    -------
    summary_df : DataFrame
        Tableau synthétique des indicateurs
    """
    summary_data = []
    
    for k in k_range:
        # Assignations
        labels = fcluster(Z, k, criterion='maxclust')
        
        # Tailles des clusters
        cluster_sizes = [np.sum(labels == label) for label in np.unique(labels)]
        max_size = max(cluster_sizes)
        min_size = min(cluster_sizes)
        
        # Hubert-Γ
        gamma = compute_hubert_gamma(D, labels)
        
        # Test AU (si disponible)
        if pvalues_df is not None:
            # Approximation : clusters avec AU ≥ 0.95 et taille ~ k
            stable_clusters = pvalues_df[
                (pvalues_df['au_pvalue'] >= 0.95) & 
                (pvalues_df['cluster_size'] >= min_size)
            ]
            n_stable = len(stable_clusters)
        else:
            n_stable = None
        
        summary_data.append({
            'k': k,
            'Hubert-Γ': gamma,
            'Taille min': min_size,
            'Taille max': max_size,
            'Ratio max/min': max_size / min_size,
            'Clusters stables (AU≥0.95)': n_stable
        })
    
    summary_df = pd.DataFrame(summary_data)
    
    # Mettre en évidence le meilleur k selon Γ
    best_k_idx = summary_df['Hubert-Γ'].idxmax()
    summary_df.loc[best_k_idx, 'Note'] = '✓ Optimum Γ'
    
    print("=" * 80)
    print("TABLEAU DE SYNTHÈSE - VALIDATION DU CLUSTERING")
    print("=" * 80)
    print(summary_df.to_string(index=False))
    print("=" * 80)
    
    return summary_df

# Utilisation
summary_df = create_validation_summary(
    Z=Z, 
    D=D, 
    k_range=range(2, 11),
    pvalues_df=pvalues_df  # Résultats du test AU
)

# Sauvegarde
summary_df.to_csv('results/validation/P01_B1_validation_summary.csv', index=False)
```

#### 6.3.3 Recommandation finale

**Règle de décision** : Retenir le nombre de clusters qui :

1. **Maximise le Hubert-Γ** (ou proche du maximum si plateau)
2. **Présente un saut important** dans le dendrogramme
3. **A des p-values AU élevées** (≥ 0.95 pour la majorité des clusters)
4. **Évite les extrêmes** (trop peu → perte d'information; trop → sur-segmentation)

**En cas de désaccord** entre les critères, privilégier le Hubert-Γ et l'interprétabilité fonctionnelle (les clusters doivent avoir un sens au regard de la biomécanique de l'escalade).

---

## 7. CALCUL DES SCORES DE CRÉATIVITÉ

### 7.1 Fondements théoriques

La créativité motrice en escalade se conceptualise selon deux dimensions complémentaires (Orth et al., 2017; Van Bergen et al., 2025) :

1. **Variabilité fonctionnelle** : Capacité à générer des solutions motrices **diverses** pour un même problème. Reflète l'étendue du répertoire moteur.
    
2. **Originalité** : Capacité à produire des solutions motrices **statistiquement rares** au sein d'une population de référence. Reflète la singularité des stratégies adoptées.
    

Le clustering de trajectoires permet de quantifier objectivement ces deux dimensions en identifiant les **patterns moteurs distincts** (clusters) utilisés par chaque grimpeur.

### 7.2 Score de variabilité fonctionnelle

#### 7.2.1 Définition

La variabilité fonctionnelle d'un participant $p$ est définie comme le nombre de clusters distincts auxquels appartiennent ses trajectoires réussies :

$$\boxed{Variabilité_p = |{c \in Clusters : \exists \text{ trajectoire réussie de } p \text{ dans } c}|}$$

où $|\cdot|$ dénote la cardinalité (taille de l'ensemble).

**Interprétation** :

- Score **élevé** → Large répertoire de solutions motrices, adaptabilité importante
- Score **faible** → Répertoire limité, tendance à répéter la même stratégie

#### 7.2.2 Calcul en Python

```python
def compute_variability_score(participant_labels):
    """
    Calcule le score de variabilité fonctionnelle.
    
    Parameters
    ----------
    participant_labels : array-like
        Assignations de clusters pour les essais réussis d'un participant
        
    Returns
    -------
    variability : int
        Nombre de clusters distincts visités
        
    Examples
    --------
    >>> labels = [1, 1, 2, 3, 2, 1, 3]  # Participant a visité clusters 1, 2, 3
    >>> compute_variability_score(labels)
    3
    """
    unique_clusters = np.unique(participant_labels)
    variability = len(unique_clusters)
    
    return variability

# Exemple pour un participant
participant_id = "P01"
condition = "pre_fatigue"

# Filtrer les essais de ce participant
mask = np.array([trial.startswith(participant_id) for trial in ids_pre])
participant_cluster_labels = labels[mask]

variability_p01 = compute_variability_score(participant_cluster_labels)
print(f"Variabilité fonctionnelle {participant_id} ({condition}) : {variability_p01} clusters")
```

### 7.3 Score d'originalité

#### 7.3.1 Définition formelle

L'originalité intègre la notion de **rareté statistique** des solutions motrices. Un cluster visité par peu de participants contribue davantage à l'originalité qu'un cluster fréquent.

**Étape 1** : Calculer la prévalence de chaque cluster dans la population

$$Prévalence(c) = \frac{\text{Nb de participants ayant } \geq 1 \text{ trajectoire dans } c}{N_{total}}$$

**Étape 2** : Définir l'originalité d'un cluster comme l'inverse de sa prévalence

$$Originalité(c) = \frac{1}{Prévalence(c)}$$

**Étape 3** : Le score d'originalité d'un participant est la somme des originalités de tous les clusters distincts qu'il a visités

$$\boxed{Originalité_p = \sum_{c \in Clusters(p)} \frac{1}{Prévalence(c)}}$$

où $Clusters(p)$ est l'ensemble des clusters distincts visités par le participant $p$.

**Interprétation** :

- Un participant utilisant **seulement des clusters fréquents** (prévalence élevée) aura un score d'originalité **faible**
- Un participant utilisant des **clusters rares** (prévalence faible) aura un score d'originalité **élevé**

#### 7.3.2 Implémentation complète

```python
def compute_prevalence_scores(all_participant_labels, participant_ids):
    """
    Calcule la prévalence de chaque cluster dans la population.
    
    Parameters
    ----------
    all_participant_labels : dict
        Dictionnaire {participant_id: array of cluster labels}
    participant_ids : list
        Liste de tous les IDs de participants
        
    Returns
    -------
    prevalence : dict
        Dictionnaire {cluster_id: prevalence_score}
    cluster_participants : dict
        Dictionnaire {cluster_id: list of participant_ids}
    """
    # Identifier tous les clusters présents
    all_clusters = set()
    for labels in all_participant_labels.values():
        all_clusters.update(labels)
    
    # Compter combien de participants visitent chaque cluster
    cluster_participants = {c: [] for c in all_clusters}
    
    for participant_id, labels in all_participant_labels.items():
        unique_clusters_p = np.unique(labels)
        for c in unique_clusters_p:
            cluster_participants[c].append(participant_id)
    
    # Calculer les prévalences
    N_total = len(participant_ids)
    prevalence = {}
    
    for c, participants_list in cluster_participants.items():
        n_participants = len(participants_list)
        prevalence[c] = n_participants / N_total
    
    return prevalence, cluster_participants

def compute_originality_score(participant_labels, prevalence):
    """
    Calcule le score d'originalité d'un participant.
    
    Parameters
    ----------
    participant_labels : array-like
        Assignations de clusters pour un participant
    prevalence : dict
        Prévalences de chaque cluster
        
    Returns
    -------
    originality : float
        Score d'originalité (somme des inverses de prévalence)
    cluster_contributions : dict
        Contribution de chaque cluster au score total
    """
    unique_clusters = np.unique(participant_labels)
    
    originality = 0
    cluster_contributions = {}
    
    for c in unique_clusters:
        # Originalité = 1 / Prévalence
        orig_c = 1.0 / prevalence[c]
        originality += orig_c
        cluster_contributions[c] = orig_c
    
    return originality, cluster_contributions

def compute_creativity_score(participant_labels, prevalence):
    """
    Calcule le score de créativité total (= originalité selon Van Bergen 2025).
    
    Note : Van Bergen et al. utilisent "creativity score" pour désigner
    ce que nous appelons ici "originality score".
    """
    return compute_originality_score(participant_labels, prevalence)

# Exemple complet
# Hypothèse : données pour plusieurs participants
all_participant_labels = {
    'P01': np.array([1, 1, 2, 3, 2]),  # P01 visite clusters 1, 2, 3
    'P02': np.array([1, 1, 1, 4]),     # P02 visite clusters 1, 4
    'P03': np.array([2, 2, 3, 3, 5]),  # P03 visite clusters 2, 3, 5
    # ... autres participants
}

participant_ids = list(all_participant_labels.keys())

# Calculer les prévalences
prevalence, cluster_participants = compute_prevalence_scores(
    all_participant_labels, 
    participant_ids
)

print("PRÉVALENCES DES CLUSTERS :")
for c, prev in sorted(prevalence.items()):
    participants = cluster_participants[c]
    print(f"  Cluster {c} : Prévalence = {prev:.3f} (Participants : {participants})")

print("\n" + "="*60)

# Calculer les scores pour chaque participant
for pid in participant_ids:
    labels_p = all_participant_labels[pid]
    
    variability = compute_variability_score(labels_p)
    originality, contributions = compute_originality_score(labels_p, prevalence)
    
    print(f"\n{pid} :")
    print(f"  Variabilité fonctionnelle : {variability} clusters")
    print(f"  Score d'originalité : {originality:.3f}")
    print(f"  Détail des contributions :")
    for c, contrib in sorted(contributions.items()):
        print(f"    Cluster {c} : +{contrib:.3f} (prévalence = {prevalence[c]:.3f})")
```

#### 7.3.3 Exemple numérique détaillé

Considérons 3 participants et 5 clusters :

```
Participant | Clusters visités | Trajectoires
------------|------------------|-------------
P01         | 1, 2, 3          | [1,1,2,3,2]
P02         | 1, 4             | [1,1,1,4]
P03         | 2, 3, 5          | [2,2,3,3,5]
```

**Étape 1** : Prévalences

- Cluster 1 : visité par P01, P02 → Prévalence = 2/3 = 0.667
- Cluster 2 : visité par P01, P03 → Prévalence = 2/3 = 0.667
- Cluster 3 : visité par P01, P03 → Prévalence = 2/3 = 0.667
- Cluster 4 : visité par P02 → Prévalence = 1/3 = 0.333
- Cluster 5 : visité par P03 → Prévalence = 1/3 = 0.333

**Étape 2** : Originalités

- Cluster 1 : Originalité = 1/0.667 = 1.50
- Cluster 2 : Originalité = 1/0.667 = 1.50
- Cluster 3 : Originalité = 1/0.667 = 1.50
- Cluster 4 : Originalité = 1/0.333 = 3.00 (rare !)
- Cluster 5 : Originalité = 1/0.333 = 3.00 (rare !)

**Étape 3** : Scores d'originalité

- **P01** : Visite clusters {1, 2, 3}  
    Originalité = 1.50 + 1.50 + 1.50 = **4.50**
    
- **P02** : Visite clusters {1, 4}  
    Originalité = 1.50 + 3.00 = **4.50**
    
- **P03** : Visite clusters {2, 3, 5}  
    Originalité = 1.50 + 1.50 + 3.00 = **6.00** ← Score le plus élevé !
    

**Interprétation** : P03 obtient le score d'originalité le plus élevé car il utilise le cluster 5 qui est rare (prévalence = 1/3). Bien que P01 visite plus de clusters que P02 (3 vs 2), ils ont le même score d'originalité car P02 compense en visitant le cluster rare 4.

### 7.4 Analyse comparative pré/post-fatigue

#### 7.4.1 Structure des données

Pour votre étude, vous comparerez les scores entre deux conditions pour chaque participant :

```python
import pandas as pd

def compute_all_creativity_scores(participant_ids, labels_pre, labels_post, 
                                   ids_pre, ids_post):
    """
    Calcule les scores de créativité pour tous les participants en pré/post-fatigue.
    
    Parameters
    ----------
    participant_ids : list
        Liste des IDs de participants
    labels_pre : ndarray
        Assignations de clusters condition pré-fatigue
    labels_post : ndarray
        Assignations de clusters condition post-fatigue
    ids_pre, ids_post : list
        Identifiants des essais correspondants
        
    Returns
    -------
    scores_df : DataFrame
        Tableau avec colonnes : ['participant', 'condition', 'variability', 'originality']
    """
    # Séparer les labels par participant
    all_labels_pre = {}
    all_labels_post = {}
    
    for pid in participant_ids:
        # Pré-fatigue
        mask_pre = np.array([trial.startswith(pid) for trial in ids_pre])
        all_labels_pre[pid] = labels_pre[mask_pre]
        
        # Post-fatigue
        mask_post = np.array([trial.startswith(pid) for trial in ids_post])
        all_labels_post[pid] = labels_post[mask_post]
    
    # Calculer les prévalences séparément pour chaque condition
    prevalence_pre, _ = compute_prevalence_scores(all_labels_pre, participant_ids)
    prevalence_post, _ = compute_prevalence_scores(all_labels_post, participant_ids)
    
    # Calculer les scores
    scores_data = []
    
    for pid in participant_ids:
        # Pré-fatigue
        var_pre = compute_variability_score(all_labels_pre[pid])
        orig_pre, _ = compute_originality_score(all_labels_pre[pid], prevalence_pre)
        
        scores_data.append({
            'participant': pid,
            'condition': 'pre_fatigue',
            'variability': var_pre,
            'originality': orig_pre
        })
        
        # Post-fatigue
        var_post = compute_variability_score(all_labels_post[pid])
        orig_post, _ = compute_originality_score(all_labels_post[pid], prevalence_post)
        
        scores_data.append({
            'participant': pid,
            'condition': 'post_fatigue',
            'variability': var_post,
            'originality': orig_post
        })
    
    scores_df = pd.DataFrame(scores_data)
    
    return scores_df

# Exemple d'utilisation
participant_ids = [f"P{i:02d}" for i in range(1, 29)]  # P01 à P28

scores_df = compute_all_creativity_scores(
    participant_ids=participant_ids,
    labels_pre=labels_pre,
    labels_post=labels_post,
    ids_pre=ids_pre,
    ids_post=ids_post
)

# Sauvegarde
scores_df.to_csv('results/creativity_scores/all_participants_scores.csv', index=False)

# Aperçu
print(scores_df.head(10))
```

#### 7.4.2 Visualisation comparative

```python
import matplotlib.pyplot as plt
import seaborn as sns

def plot_creativity_comparison(scores_df, metric='variability'):
    """
    Compare les scores pré/post-fatigue pour un métrique donné.
    
    Parameters
    ----------
    scores_df : DataFrame
        Tableau des scores
    metric : str
        'variability' ou 'originality'
    """
    # Pivot pour avoir pré et post en colonnes
    pivot_df = scores_df.pivot(index='participant', 
                                columns='condition', 
                                values=metric)
    
    # Graphique
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))
    
    # 1. Barplot groupé
    ax1 = axes[0]
    scores_df.pivot(index='participant', columns='condition', values=metric).plot(
        kind='bar', ax=ax1, color=['steelblue', 'coral'], alpha=0.8
    )
    ax1.set_xlabel('Participant', fontsize=12, fontweight='bold')
    ax1.set_ylabel(f'{metric.capitalize()}', fontsize=12, fontweight='bold')
    ax1.set_title(f'{metric.capitalize()} - Comparaison Pré/Post-Fatigue', 
                  fontsize=14, fontweight='bold')
    ax1.legend(title='Condition', labels=['Pré-fatigue', 'Post-fatigue'])
    ax1.grid(axis='y', alpha=0.3)
    plt.setp(ax1.xaxis.get_majorticklabels(), rotation=45, ha='right')
    
    # 2. Scatter plot avec ligne d'identité
    ax2 = axes[1]
    ax2.scatter(pivot_df['pre_fatigue'], pivot_df['post_fatigue'], 
                s=100, alpha=0.7, color='purple', edgecolor='black', linewidth=1.5)
    
    # Ligne d'identité (y = x)
    lims = [
        min(pivot_df['pre_fatigue'].min(), pivot_df['post_fatigue'].min()),
        max(pivot_df['pre_fatigue'].max(), pivot_df['post_fatigue'].max())
    ]
    ax2.plot(lims, lims, 'k--', alpha=0.5, linewidth=2, label='Identité (pas de changement)')
    
    ax2.set_xlabel(f'{metric.capitalize()} Pré-Fatigue', fontsize=12, fontweight='bold')
    ax2.set_ylabel(f'{metric.capitalize()} Post-Fatigue', fontsize=12, fontweight='bold')
    ax2.set_title(f'Évolution individuelle - {metric.capitalize()}', 
                  fontsize=14, fontweight='bold')
    ax2.legend()
    ax2.grid(alpha=0.3)
    ax2.set_aspect('equal', adjustable='box')
    
    plt.tight_layout()
    
    return fig, axes

# Créer les graphiques pour chaque métrique
fig_var, _ = plot_creativity_comparison(scores_df, metric='variability')
plt.savefig('results/creativity_scores/variability_comparison.png', dpi=300, bbox_inches='tight')

fig_orig, _ = plot_creativity_comparison(scores_df, metric='originality')
plt.savefig('results/creativity_scores/originality_comparison.png', dpi=300, bbox_inches='tight')

plt.show()
```

#### 7.4.3 Test statistique

```python
from scipy import stats

def test_pre_post_difference(scores_df, metric='variability'):
    """
    Teste la différence pré/post-fatigue avec un test t apparié.
    
    H0 : Pas de différence entre pré et post-fatigue
    H1 : Différence significative (bilatéral)
    """
    # Extraire les scores pré et post
    pre_scores = scores_df[scores_df['condition'] == 'pre_fatigue'][metric].values
    post_scores = scores_df[scores_df['condition'] == 'post_fatigue'][metric].values
    
    # Test t apparié
    t_stat, p_value = stats.ttest_rel(pre_scores, post_scores)
    
    # Taille d'effet (Cohen's d pour mesures répétées)
    diff = pre_scores - post_scores
    d = np.mean(diff) / np.std(diff, ddof=1)
    
    # Résultats
    print("=" * 60)
    print(f"TEST T APPARIÉ - {metric.upper()}")
    print("=" * 60)
    print(f"H0 : Pas de différence pré/post-fatigue")
    print(f"H1 : Différence significative")
    print()
    print(f"Pré-fatigue  : M = {np.mean(pre_scores):.3f}, SD = {np.std(pre_scores, ddof=1):.3f}")
    print(f"Post-fatigue : M = {np.mean(post_scores):.3f}, SD = {np.std(post_scores, ddof=1):.3f}")
    print()
    print(f"t({len(pre_scores)-1}) = {t_stat:.3f}, p = {p_value:.4f}")
    print(f"Cohen's d = {d:.3f}")
    print()
    
    if p_value < 0.001:
        sig = "***"
    elif p_value < 0.01:
        sig = "**"
    elif p_value < 0.05:
        sig = "*"
    else:
        sig = "n.s."
    
    print(f"Significativité : {sig}")
    
    if p_value < 0.05:
        direction = "diminution" if np.mean(diff) > 0 else "augmentation"
        print(f"✓ {direction.capitalize()} significative après fatigue")
    else:
        print("✗ Pas de différence significative")
    
    print("=" * 60)
    
    return {'t': t_stat, 'p': p_value, 'd': d}

# Tests
results_var = test_pre_post_difference(scores_df, metric='variability')
results_orig = test_pre_post_difference(scores_df, metric='originality')
```

**Hypothèse attendue** (H1 de votre protocole) : La fatigue musculaire devrait **diminuer** les scores de variabilité fonctionnelle et d'originalité, reflétant une convergence vers des solutions motrices plus stéréotypées et moins créatives.

---

## 8. PIPELINE COMPLET D'ANALYSE

### 8.1 Script intégré : de l'extraction à l'analyse

Voici un script Python complet qui enchaîne toutes les étapes du pipeline d'analyse.

```python
#!/usr/bin/env python3
"""
Pipeline complet d'analyse de clustering de trajectoires d'escalade.

Ce script enchaîne automatiquement toutes les étapes :
1. Chargement et normalisation des trajectoires
2. Calcul de la matrice SSPD
3. Clustering hiérarchique (méthode Ward)
4. Validation (Hubert-Γ)
5. Calcul des scores de créativité
6. Visualisations et export des résultats

Usage:
    python pipeline_clustering_complete.py --participant P01 --condition pre_fatigue
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path
from scipy.interpolate import interp1d
from scipy.cluster.hierarchy import linkage, fcluster, dendrogram
from scipy.spatial.distance import squareform
from trajectory_distance.sspd import sspd
import argparse

# ============================================================================
# CONFIGURATION
# ============================================================================

class Config:
    """Configuration centralisée du pipeline."""
    
    # Chemins
    DATA_DIR = Path("data/normalized_trajectories")
    RESULTS_DIR = Path("results")
    
    # Paramètres de normalisation
    N_FRAMES = 100
    
    # Paramètres de clustering
    LINKAGE_METHOD = 'ward'
    
    # Seuils de validation
    HUBERT_GAMMA_RANGE = range(2, 16)
    
    # Graphiques
    FIGSIZE_LARGE = (14, 8)
    FIGSIZE_MEDIUM = (10, 6)
    DPI = 300

config = Config()

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================

def setup_directories():
    """Crée la structure de répertoires pour les résultats."""
    subdirs = [
        'distance_matrices',
        'dendrograms',
        'cluster_assignments',
        'creativity_scores',
        'validation',
        'visualizations'
    ]
    
    for subdir in subdirs:
        (config.RESULTS_DIR / subdir).mkdir(parents=True, exist_ok=True)
    
    print("✓ Structure de répertoires créée")

def load_trajectories(participant_id, bloc_id):
    """
    Charge toutes les trajectoires normalisées pour un participant/bloc.
    
    Returns:
        trajectories (list): Liste de matrices (2, 100)
        trial_ids (list): Identifiants des essais
    """
    pattern = f"{participant_id}_{bloc_id}_*.npy"
    filepaths = sorted(config.DATA_DIR.glob(pattern))
    
    if not filepaths:
        raise FileNotFoundError(f"Aucune trajectoire trouvée pour {pattern}")
    
    trajectories = []
    trial_ids = []
    
    for filepath in filepaths:
        traj = np.load(filepath)
        assert traj.shape == (2, config.N_FRAMES), f"Dimension incorrecte : {traj.shape}"
        
        trajectories.append(traj)
        trial_ids.append(filepath.stem)
    
    print(f"✓ Chargé {len(trajectories)} trajectoires pour {participant_id}/{bloc_id}")
    
    return trajectories, trial_ids

# ============================================================================
# ÉTAPE 1 : CALCUL DES DISTANCES SSPD
# ============================================================================

def compute_distance_matrix(trajectories, verbose=True):
    """Calcule la matrice de dissimilarité SSPD."""
    N = len(trajectories)
    D = np.zeros((N, N))
    
    for i in range(N):
        for j in range(i+1, N):
            dist = sspd(trajectories[i], trajectories[j])
            D[i, j] = dist
            D[j, i] = dist
        
        if verbose and (i+1) % 10 == 0:
            print(f"  Progression : {i+1}/{N}")
    
    print(f"✓ Matrice de distance calculée ({N}×{N})")
    
    return D

def save_distance_matrix(D, trial_ids, output_prefix):
    """Sauvegarde la matrice de distance."""
    # Format NumPy
    np.save(f"{output_prefix}_distance_matrix.npy", D)
    
    # Format CSV avec labels
    df = pd.DataFrame(D, index=trial_ids, columns=trial_ids)
    df.to_csv(f"{output_prefix}_distance_matrix.csv")
    
    print(f"✓ Matrice de distance sauvegardée : {output_prefix}")

# ============================================================================
# ÉTAPE 2 : CLUSTERING HIÉRARCHIQUE
# ============================================================================

def perform_clustering(D):
    """Effectue le clustering hiérarchique avec la méthode Ward."""
    D_condensed = squareform(D)
    Z = linkage(D_condensed, method=config.LINKAGE_METHOD)
    
    print(f"✓ Clustering hiérarchique effectué (méthode: {config.LINKAGE_METHOD})")
    
    return Z

def plot_dendrogram_complete(Z, trial_ids, threshold, output_prefix):
    """Trace et sauvegarde le dendrogramme."""
    fig, ax = plt.subplots(figsize=config.FIGSIZE_LARGE)
    
    dend = dendrogram(
        Z, 
        ax=ax,
        labels=trial_ids,
        leaf_rotation=90,
        leaf_font_size=8,
        color_threshold=threshold if threshold else None,
        above_threshold_color='gray'
    )
    
    if threshold:
        ax.axhline(y=threshold, color='red', linestyle='--', linewidth=2,
                  label=f'Seuil = {threshold:.2f}')
        ax.legend()
    
    ax.set_xlabel('Essai', fontsize=12, fontweight='bold')
    ax.set_ylabel('Distance de fusion', fontsize=12, fontweight='bold')
    ax.set_title('Dendrogramme - Clustering hiérarchique', 
                 fontsize=14, fontweight='bold')
    ax.grid(axis='y', alpha=0.3)
    
    plt.tight_layout()
    plt.savefig(f"{output_prefix}_dendrogram.png", dpi=config.DPI, bbox_inches='tight')
    plt.close()
    
    print(f"✓ Dendrogramme sauvegardé : {output_prefix}")

# ============================================================================
# ÉTAPE 3 : VALIDATION
# ============================================================================

def compute_hubert_gamma(D, labels):
    """Calcule le coefficient de Hubert-Γ."""
    N = len(labels)
    C = np.zeros((N, N))
    
    for i in range(N):
        for j in range(N):
            C[i, j] = 1 if labels[i] == labels[j] else 0
    
    triu_indices = np.triu_indices(N, k=1)
    D_flat = D[triu_indices]
    C_flat = C[triu_indices]
    
    gamma = np.corrcoef(D_flat, C_flat)[0, 1]
    
    return gamma

def validate_with_hubert_gamma(Z, D, k_range, output_prefix):
    """Validation par score de Hubert-Γ."""
    gammas = {}
    
    print("\nVALIDATION PAR HUBERT-Γ :")
    print("-" * 40)
    
    for k in k_range:
        labels = fcluster(Z, k, criterion='maxclust')
        gamma = compute_hubert_gamma(D, labels)
        gammas[k] = gamma
        print(f"  k = {k:2d} : Γ = {gamma:.4f}")
    
    best_k = max(gammas, key=gammas.get)
    print(f"\n✓ Optimum : k = {best_k} (Γ = {gammas[best_k]:.4f})")
    
    # Graphique
    fig, ax = plt.subplots(figsize=config.FIGSIZE_MEDIUM)
    
    k_values = list(gammas.keys())
    gamma_values = list(gammas.values())
    
    ax.plot(k_values, gamma_values, 'o-', linewidth=2, markersize=8, color='steelblue')
    ax.plot(best_k, gammas[best_k], 'ro', markersize=15, label=f'Optimum (k={best_k})')
    ax.axvline(best_k, color='red', linestyle='--', alpha=0.5)
    
    ax.set_xlabel('Nombre de clusters (k)', fontsize=12, fontweight='bold')
    ax.set_ylabel('Coefficient de Hubert-Γ', fontsize=12, fontweight='bold')
    ax.set_title('Validation par Hubert-Γ', fontsize=14, fontweight='bold')
    ax.legend()
    ax.grid(alpha=0.3)
    ax.set_xticks(k_values)
    
    plt.tight_layout()
    plt.savefig(f"{output_prefix}_hubert_gamma.png", dpi=config.DPI, bbox_inches='tight')
    plt.close()
    
    # Sauvegarder les résultats numériques
    df_gamma = pd.DataFrame({
        'k': k_values,
        'Hubert_Gamma': gamma_values
    })
    df_gamma.to_csv(f"{output_prefix}_hubert_gamma.csv", index=False)
    
    return gammas, best_k

# ============================================================================
# ÉTAPE 4 : EXTRACTION DES ASSIGNATIONS
# ============================================================================

def extract_cluster_assignments(Z, n_clusters, trial_ids, output_prefix):
    """Extrait et sauvegarde les assignations de clusters."""
    labels = fcluster(Z, n_clusters, criterion='maxclust')
    
    # Statistiques
    unique_labels = np.unique(labels)
    cluster_sizes = {label: np.sum(labels == label) for label in unique_labels}
    
    print(f"\nASSIGNATIONS EN {n_clusters} CLUSTERS :")
    print("-" * 40)
    for label, size in cluster_sizes.items():
        print(f"  Cluster {label} : {size} trajectoires")
    
    # Sauvegarder
    df_assignments = pd.DataFrame({
        'trial_id': trial_ids,
        'cluster': labels
    })
    df_assignments.to_csv(f"{output_prefix}_cluster_assignments.csv", index=False)
    
    print(f"\n✓ Assignations sauvegardées : {output_prefix}")
    
    return labels, cluster_sizes

# ============================================================================
# ÉTAPE 5 : CALCUL DES SCORES DE CRÉATIVITÉ
# ============================================================================

def compute_creativity_scores_single_participant(labels):
    """
    Calcule les scores de créativité pour un participant unique.
    
    Note : Pour l'originalité, nécessite les données de tous les participants.
    Cette fonction calcule uniquement la variabilité fonctionnelle.
    """
    variability = len(np.unique(labels))
    
    print(f"\nSCORES DE CRÉATIVITÉ :")
    print("-" * 40)
    print(f"  Variabilité fonctionnelle : {variability} clusters distincts")
    print(f"  (Originalité : nécessite données multi-participants)")
    
    return variability

# ============================================================================
# PIPELINE PRINCIPAL
# ============================================================================

def run_complete_pipeline(participant_id, bloc_id, threshold=None):
    """
    Exécute le pipeline complet d'analyse pour un participant/bloc.
    
    Parameters
    ----------
    participant_id : str
        ID du participant (ex: "P01")
    bloc_id : str
        ID du bloc (ex: "B1")
    threshold : float, optional
        Seuil de distance pour couper le dendrogramme
        Si None, déterminé automatiquement par Hubert-Γ
    """
    print("\n" + "="*60)
    print(f"PIPELINE D'ANALYSE - {participant_id} / {bloc_id}")
    print("="*60 + "\n")
    
    # Préparation
    setup_directories()
    output_prefix = config.RESULTS_DIR / f"{participant_id}_{bloc_id}"
    
    # ÉTAPE 1 : Chargement
    print("\n[ÉTAPE 1/5] Chargement des trajectoires")
    print("-" * 60)
    trajectories, trial_ids = load_trajectories(participant_id, bloc_id)
    
    # ÉTAPE 2 : Distances
    print("\n[ÉTAPE 2/5] Calcul de la matrice SSPD")
    print("-" * 60)
    D = compute_distance_matrix(trajectories)
    save_distance_matrix(D, trial_ids, 
                         config.RESULTS_DIR / "distance_matrices" / f"{participant_id}_{bloc_id}")
    
    # ÉTAPE 3 : Clustering
    print("\n[ÉTAPE 3/5] Clustering hiérarchique")
    print("-" * 60)
    Z = perform_clustering(D)
    
    # ÉTAPE 4 : Validation
    print("\n[ÉTAPE 4/5] Validation")
    print("-" * 60)
    gammas, best_k = validate_with_hubert_gamma(
        Z, D, 
        config.HUBERT_GAMMA_RANGE,
        config.RESULTS_DIR / "validation" / f"{participant_id}_{bloc_id}"
    )
    
    # Utiliser best_k ou threshold si fourni
    if threshold is None:
        n_clusters = best_k
        print(f"\n→ Utilisation du nombre optimal : k = {n_clusters}")
    else:
        labels_thresh = fcluster(Z, threshold, criterion='distance')
        n_clusters = len(np.unique(labels_thresh))
        print(f"\n→ Utilisation du seuil {threshold:.2f} : k = {n_clusters}")
    
    # ÉTAPE 5 : Assignations et scores
    print("\n[ÉTAPE 5/5] Extraction des assignations et calcul des scores")
    print("-" * 60)
    labels, cluster_sizes = extract_cluster_assignments(
        Z, n_clusters, trial_ids,
        config.RESULTS_DIR / "cluster_assignments" / f"{participant_id}_{bloc_id}"
    )
    
    variability = compute_creativity_scores_single_participant(labels)
    
    # Dendrogramme final avec seuil optimal
    plot_dendrogram_complete(
        Z, trial_ids, 
        threshold=threshold,
        output_prefix=config.RESULTS_DIR / "dendrograms" / f"{participant_id}_{bloc_id}"
    )
    
    # Résumé final
    print("\n" + "="*60)
    print("ANALYSE TERMINÉE AVEC SUCCÈS")
    print("="*60)
    print(f"\nRésultats sauvegardés dans : {config.RESULTS_DIR}")
    print(f"  - Matrice de distance : distance_matrices/")
    print(f"  - Dendrogramme : dendrograms/")
    print(f"  - Assignations : cluster_assignments/")
    print(f"  - Validation : validation/")
    print(f"\nNombre de clusters identifié : {n_clusters}")
    print(f"Score de variabilité : {variability}")
    
    return {
        'Z': Z,
        'D': D,
        'labels': labels,
        'n_clusters': n_clusters,
        'variability': variability,
        'gammas': gammas
    }

# ============================================================================
# INTERFACE LIGNE DE COMMANDE
# ============================================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Pipeline complet d'analyse de clustering de trajectoires"
    )
    
    parser.add_argument('--participant', type=str, required=True,
                       help='ID du participant (ex: P01)')
    parser.add_argument('--bloc', type=str, required=True,
                       help='ID du bloc (ex: B1 ou B2)')
    parser.add_argument('--threshold', type=float, default=None,
                       help='Seuil de distance optionnel (défaut: auto via Hubert-Γ)')
    
    args = parser.parse_args()
    
    # Exécution
    results = run_complete_pipeline(
        participant_id=args.participant,
        bloc_id=args.bloc,
        threshold=args.threshold
    )
    
    print("\n✓ Pipeline terminé.\n")
```

### 8.2 Utilisation du script

```bash
# Analyse d'un participant en condition pré-fatigue
python pipeline_clustering_complete.py --participant P01 --bloc B1

# Analyse avec seuil de distance fixe
python pipeline_clustering_complete.py --participant P01 --bloc B2 --threshold 15.0

# Batch : analyser tous les participants
for i in $(seq -f "%02g" 1 28); do
    python pipeline_clustering_complete.py --participant P$i --bloc B1
    python pipeline_clustering_complete.py --participant P$i --bloc B2
done
```

### 8.3 Script d'analyse multi-participants

Pour calculer les scores d'originalité qui nécessitent les données de toute la cohorte :

```python
#!/usr/bin/env python3
"""
Analyse multi-participants : calcul des scores d'originalité.

Usage:
    python analyze_all_participants.py
"""

import numpy as np
import pandas as pd
from pathlib import Path

# Configuration
RESULTS_DIR = Path("results")
PARTICIPANT_IDS = [f"P{i:02d}" for i in range(1, 29)]  # P01 à P28
CONDITIONS = ['B1', 'B2']  # Pré et post-fatigue

def load_all_cluster_assignments():
    """Charge toutes les assignations de clusters."""
    all_assignments = {}
    
    for condition in CONDITIONS:
        all_assignments[condition] = {}
        
        for pid in PARTICIPANT_IDS:
            filepath = RESULTS_DIR / "cluster_assignments" / f"{pid}_{condition}_cluster_assignments.csv"
            
            if filepath.exists():
                df = pd.read_csv(filepath)
                all_assignments[condition][pid] = df['cluster'].values
            else:
                print(f"⚠️  Fichier manquant : {filepath}")
    
    return all_assignments

def compute_prevalence(all_assignments):
    """Calcule la prévalence de chaque cluster."""
    prevalence = {}
    
    for condition in CONDITIONS:
        all_clusters = set()
        for labels in all_assignments[condition].values():
            all_clusters.update(labels)
        
        cluster_participants = {c: [] for c in all_clusters}
        
        for pid, labels in all_assignments[condition].items():
            unique_clusters = np.unique(labels)
            for c in unique_clusters:
                cluster_participants[c].append(pid)
        
        N_total = len(all_assignments[condition])
        prevalence[condition] = {
            c: len(participants) / N_total 
            for c, participants in cluster_participants.items()
        }
    
    return prevalence

def compute_all_scores(all_assignments, prevalence):
    """Calcule tous les scores de créativité."""
    scores_data = []
    
    for condition in CONDITIONS:
        for pid, labels in all_assignments[condition].items():
            # Variabilité
            variability = len(np.unique(labels))
            
            # Originalité
            originality = 0
            for c in np.unique(labels):
                originality += 1.0 / prevalence[condition][c]
            
            scores_data.append({
                'participant': pid,
                'condition': 'pre_fatigue' if condition == 'B1' else 'post_fatigue',
                'variability': variability,
                'originality': originality
            })
    
    return pd.DataFrame(scores_data)

def main():
    print("\n" + "="*60)
    print("ANALYSE MULTI-PARTICIPANTS")
    print("="*60 + "\n")
    
    # Chargement
    print("Chargement des assignations de clusters...")
    all_assignments = load_all_cluster_assignments()
    
    # Prévalences
    print("Calcul des prévalences...")
    prevalence = compute_prevalence(all_assignments)
    
    # Scores
    print("Calcul des scores de créativité...")
    scores_df = compute_all_scores(all_assignments, prevalence)
    
    # Sauvegarde
    output_file = RESULTS_DIR / "creativity_scores" / "all_participants_scores.csv"
    scores_df.to_csv(output_file, index=False)
    
    print(f"\n✓ Scores sauvegardés : {output_file}")
    
    # Aperçu
    print("\nAPERÇU DES SCORES :")
    print(scores_df.head(10))
    
    # Statistiques descriptives
    print("\nSTATISTIQUES DESCRIPTIVES :")
    print(scores_df.groupby('condition')[['variability', 'originality']].describe())

if __name__ == "__main__":
    main()
```

---

## 9. ERREURS FRÉQUENTES ET SOLUTIONS

### 9.1 Erreurs de prétraitement

#### Erreur 1 : Points de coupe inconsistants

**Problème** : Les points de début/fin ne sont pas identifiables dans tous les essais.

**Symptôme** : Certaines trajectoires sont tronquées ou incluent des phases non pertinentes.

**Solution** :

```python
def verify_cutting_points(trajectories_list, expected_min_duration=30, 
                          expected_max_duration=300):
    """
    Vérifie que les durées des trajectoires sont cohérentes.
    """
    durations = [len(traj) for traj in trajectories_list]
    
    # Identifier les outliers
    outliers = []
    for i, dur in enumerate(durations):
        if dur < expected_min_duration or dur > expected_max_duration:
            outliers.append((i, dur))
    
    if outliers:
        print("⚠️  ATTENTION : Durées suspectes détectées :")
        for idx, dur in outliers:
            print(f"   Trajectoire {idx} : {dur} frames")
        print("\n→ Vérifier manuellement les points de coupe dans Kinovea")
    else:
        print("✓ Toutes les durées sont dans la plage attendue")
    
    return outliers
```

#### Erreur 2 : Variabilité excessive des durées

**Problème** : Les trajectoires varient de >30% en durée avant normalisation.

**Symptôme** : Déformations importantes lors de la normalisation temporelle.

**Solution** :

- Revoir les critères de points de coupe pour qu'ils soient plus précis
- Exclure les essais aberrants (trop courts ou trop longs)
- Augmenter le nombre de frames cibles (100 → 150) si nécessaire

### 9.2 Erreurs de calcul de distance

#### Erreur 3 : Dimensions incorrectes

**Problème** : Le package `trajectory_distance` attend des matrices (2, N) mais vous avez (N, 2).

**Symptôme** :

```
ValueError: shapes (100,2) and (2,100) not aligned
```

**Solution** :

```python
# Vérifier et corriger les dimensions
for i, traj in enumerate(trajectories):
    if traj.shape != (2, 100):
        print(f"Trajectoire {i} : shape incorrecte {traj.shape}")
        if traj.shape == (100, 2):
            trajectories[i] = traj.T  # Transposer
```

#### Erreur 4 : Distances nulles non-diagonales

**Problème** : Deux trajectoires différentes ont une distance nulle.

**Symptôme** : Dendrogramme avec fusions à hauteur zéro.

**Causes possibles** :

1. Trajectoires dupliquées dans les données
2. Erreur dans le calcul SSPD
3. Trajectoires identiques après normalisation

**Solution** :

```python
def check_for_duplicates(D, trial_ids, tolerance=1e-6):
    """Identifie les trajectoires potentiellement dupliquées."""
    N = len(D)
    duplicates = []
    
    for i in range(N):
        for j in range(i+1, N):
            if D[i, j] < tolerance:
                duplicates.append((trial_ids[i], trial_ids[j], D[i, j]))
    
    if duplicates:
        print("⚠️  Paires de trajectoires avec distance quasi-nulle :")
        for id1, id2, dist in duplicates:
            print(f"   {id1} ↔ {id2} : distance = {dist:.6f}")
    else:
        print("✓ Aucune duplication détectée")
    
    return duplicates
```

### 9.3 Erreurs de clustering

#### Erreur 5 : Nombre de clusters instable

**Problème** : Les méthodes de validation donnent des résultats contradictoires.

**Symptôme** : Hubert-Γ suggère k=5, dendrogramme suggère k=3, AU test invalide plusieurs clusters.

**Solution** :

```python
def reconcile_validation_methods(gammas, pvalues_df, Z):
    """
    Analyse multi-critères pour réconcilier les méthodes de validation.
    """
    # 1. Top 3 selon Hubert-Γ
    top_gamma = sorted(gammas.items(), key=lambda x: x[1], reverse=True)[:3]
    print("Top 3 Hubert-Γ :")
    for k, gamma in top_gamma:
        print(f"  k = {k} : Γ = {gamma:.4f}")
    
    # 2. Clusters stables selon AU
    if pvalues_df is not None:
        stable_sizes = pvalues_df[pvalues_df['au_pvalue'] >= 0.95]['cluster_size'].values
        if len(stable_sizes) > 0:
            print(f"\nClusters stables (AU ≥ 0.95) : tailles = {stable_sizes}")
            suggested_k = len(stable_sizes)
            print(f"→ Suggestion AU : k ≈ {suggested_k}")
    
    # 3. Sauts dans dendrogramme
    heights = Z[:, 2]
    jumps = np.diff(heights)
    top_jumps = np.argsort(jumps)[::-1][:3]
    
    print("\nTop 3 sauts dans le dendrogramme :")
    for idx in top_jumps:
        k = len(Z) - idx
        print(f"  k = {k} : saut = {jumps[idx]:.3f}")
    
    # Recommandation
    print("\n" + "="*60)
    print("RECOMMANDATION :")
    print("="*60)
    print("Privilégier le k qui :")
    print("  1. Maximise (ou proche du max) Hubert-Γ")
    print("  2. Correspond à un saut important dans le dendrogramme")
    print("  3. A majoritairement des p-values AU élevées")
    print("  4. Reste interprétable (éviter >10 clusters pour N<100 essais)")
```

#### Erreur 6 : Clusters singletons excessifs

**Problème** : Le clustering produit de nombreux clusters à 1 seul élément.

**Symptôme** : Distribution des tailles très déséquilibrée (ex: [50, 20, 10, 1, 1, 1, 1, ...]).

**Causes** :

1. Nombre de clusters trop élevé
2. Présence d'outliers véritables dans les données
3. Seuil de coupure mal calibré

**Solution** :

```python
def handle_singletons(labels, min_cluster_size=2):
    """
    Identifie et traite les clusters singletons.
    """
    unique_labels = np.unique(labels)
    cluster_sizes = {label: np.sum(labels == label) for label in unique_labels}
    
    singletons = [label for label, size in cluster_sizes.items() if size < min_cluster_size]
    
    if singletons:
        print(f"⚠️  {len(singletons)} cluster(s) singleton(s) détecté(s) : {singletons}")
        print("\nOptions :")
        print("  1. Réduire le nombre de clusters")
        print("  2. Identifier et retirer les outliers véritables")
        print("  3. Accepter si ces trajectoires sont effectivement atypiques")
    
    return singletons, cluster_sizes
```

### 9.4 Erreurs d'interprétation

#### Erreur 7 : Confondre variabilité et bruit

**Problème** : Interpréter une haute variabilité comme nécessairement créative.

**Clarification** :

- **Variabilité fonctionnelle** = diversité de solutions RÉUSSIES
- **Bruit moteur** = variabilité non-fonctionnelle, échecs répétés

**Vérification** :

```python
def separate_success_failure(trial_ids, success_marker='success'):
    """
    Sépare les trajectoires réussies des échecs.
    
    Note : Nécessite un marquage préalable des essais réussis.
    Exemple de convention : 'P01_B1_E01_success' vs 'P01_B1_E01_fail'
    """
    successful_indices = [i for i, tid in enumerate(trial_ids) 
                          if success_marker in tid]
    
    print(f"Essais réussis : {len(successful_indices)} / {len(trial_ids)}")
    print(f"Taux de réussite : {len(successful_indices)/len(trial_ids)*100:.1f}%")
    
    return successful_indices

# N'analyser QUE les essais réussis
successful_indices = separate_success_failure(trial_ids)
trajectories_success = [trajectories[i] for i in successful_indices]
```

**Rappel protocole** : Votre étude analyse uniquement les trajectoires durant la phase d'exploration créative où le participant a **réussi** le bloc. Les échecs sont enregistrés mais exclus de l'analyse de créativité.

#### Erreur 8 : Comparaisons pré/post non-appariées

**Problème** : Comparer les moyennes de groupe sans tenir compte de l'appariement.

**Solution** : Toujours utiliser des tests appariés (t-test apparié, ANOVA à mesures répétées) puisque chaque participant est son propre contrôle.

```python
# ✗ INCORRECT : Test t indépendant
from scipy.stats import ttest_ind
t, p = ttest_ind(scores_pre, scores_post)  # Ne pas faire !

# ✓ CORRECT : Test t apparié
from scipy.stats import ttest_rel
t, p = ttest_rel(scores_pre, scores_post)  # Tenir compte de l'appariement
```

---

## 10. RÉFÉRENCES ET RESSOURCES

### 10.1 Articles fondateurs

**Méthodologie de clustering** :

- **Besse, P.C., Guillouet, B., Loubes, J.-M., & Royer, F. (2016).** Review and perspective for distance-based clustering of vehicle trajectories. _IEEE Transactions on Intelligent Transportation Systems_, 1-12.  
    → Article fondateur sur la distance SSPD
    
- **Rein, R., Button, C., Davids, K., & Summers, J. (2010).** Cluster analysis of movement patterns in multiarticular actions: A tutorial. _Motor Control_, 14, 211-239.  
    → Tutorial de référence pour le clustering de patterns moteurs
    
- **Ward, J.H. (1963).** Hierarchical grouping to optimize an objective function. _Journal of the American Statistical Association_, 58(301), 236-244.  
    → Méthode de Ward (minimum variance)
    

**Application à l'escalade** :

- **Van Bergen et al. (2025).** [Titre complet à récupérer depuis votre document]  
    → Application directe du clustering SSPD aux trajectoires d'escalade
    
- **Medernach et al. (2025).** [Titre complet depuis votre protocole]  
    → Méthodologie d'évaluation de la créativité en escalade
    
- **Orth, D., van der Kamp, J., Memmert, D., & Savelsbergh, G.J.P. (2017).** Creative motor actions as emerging from movement variability. _Frontiers in Psychology_, 8, 1903.  
    → Cadre théorique créativité motrice = variabilité fonctionnelle + originalité
    

**Validation** :

- **Shimodaira, H. (2002).** An approximately unbiased test of phylogenetic tree selection. _Systematic Biology_, 51(3), 492-508.  
    → Test AU (bootstrap multiscale)
    
- **Handl, J., Knowles, J., & Kell, D.B. (2005).** Computational cluster validation in post-genomic data analysis. _Bioinformatics_, 21(15), 3201-3212.  
    → Revue complète des méthodes de validation
    

### 10.2 Ressources logicielles

**Python** :

- **trajectory_distance** : [https://github.com/bguillouet/traj-dist](https://github.com/bguillouet/traj-dist)  
    Package officiel de Besse et al. pour le calcul de SSPD
    
- **scipy.cluster.hierarchy** : [https://docs.scipy.org/doc/scipy/reference/cluster.hierarchy.html](https://docs.scipy.org/doc/scipy/reference/cluster.hierarchy.html)  
    Documentation complète du clustering hiérarchique
    

**R** :

- **pvclust** : [https://cran.r-project.org/web/packages/pvclust/](https://cran.r-project.org/web/packages/pvclust/)  
    Package pour test AU avec bootstrap multiscale

**Kinovea** :

- Site officiel : [https://www.kinovea.org/](https://www.kinovea.org/)  
    Logiciel gratuit d'analyse vidéo pour l'extraction de trajectoires

### 10.3 Tutoriels et guides complémentaires

**Clustering en général** :

- Kaufmann, L., & Rousseeuw, P.J. (1990). _Finding groups in data: An introduction to cluster analysis_. Wiley.  
    → Livre de référence sur les méthodes de clustering
    
- Everitt, B.S., Landau, S., & Leese, M. (2001). _Cluster analysis_ (4th ed.). Arnold.  
    → Guide pratique avec nombreux exemples
    

**Analyse du mouvement** :

- Seifert, L., Komar, J., Araújo, D., & Davids, K. (2016). Neurobiological degeneracy: A key property for functional adaptations of perception and action to constraints. _Neuroscience & Biobehavioral Reviews_, 69, 159-165.  
    → Fondements théoriques de la variabilité fonctionnelle

### 10.4 Support et communauté

**Forums et discussions** :

- Stack Overflow (tag: [scipy], [clustering]) : Pour questions techniques Python
- Cross Validated (tag: [cluster-analysis]) : Pour questions statistiques/méthodologiques

**Groupes de recherche** :

- Ecological Dynamics Research Group (Queensland University of Technology)
- Movement Neuroscience Lab (University of Amsterdam)

---

## CONCLUSION

Ce guide méthodologique vous a présenté une démarche complète pour l'analyse de trajectoires d'escalade par clustering hiérarchique, en s'appuyant sur les travaux fondateurs de Besse et al. (2016), Rein et al. (2010), et l'application spécifique de Van Bergen et al. (2025).

**Les points clés à retenir** :

1. **Prétraitement rigoureux** : Points de coupe identifiables, contrôle de la variabilité des durées, normalisation temporelle appropriée
    
2. **Distance SSPD** : Métrique shape-based robuste, sans paramètres à régler, validée pour les trajectoires d'escalade
    
3. **Méthode Ward** : Algorithme de clustering robuste, minimisant la variance intra-cluster
    
4. **Validation multi-critères** : Combiner Hubert-Γ, test AU, et analyse visuelle du dendrogramme pour une décision robuste
    
5. **Scores de créativité** : Variabilité fonctionnelle (diversité) + Originalité (rareté statistique)
    

**Pour votre étude spécifique** (effets de la fatigue sur la créativité), cette méthodologie permettra de :

- Quantifier objectivement la réduction potentielle du répertoire moteur après fatigue
- Identifier si les grimpeurs convergent vers des solutions plus stéréotypées
- Tester l'hypothèse que la fatigue diminue la créativité motrice

**Prochaines étapes recommandées** :

1. Valider le pipeline sur un sous-échantillon de participants (n=5)
2. Calibrer le seuil de coupure optimal pour votre configuration expérimentale
3. Analyser l'ensemble de la cohorte (N=28 participants)
4. Effectuer les analyses statistiques comparatives pré/post-fatigue
5. Examiner les interactions avec l'orientation régulatrice (promotion vs prévention)

**Ressources annexes** disponibles dans ce projet :

- Scripts Python complets dans `/scripts`
- Données d'exemple dans `/data/example`
- Graphiques de validation dans `/results/validation`

Pour toute question méthodologique, n'hésitez pas à consulter les articles originaux (Besse et al., 2016; Rein et al., 2010) qui fournissent des détails techniques supplémentaires.

**Bonne analyse !**

---

_Document rédigé par Claude (Anthropic) - Janvier 2026_  
_Basé sur : Besse et al. (2016), Rein et al. (2010), Van Bergen et al. (2025)