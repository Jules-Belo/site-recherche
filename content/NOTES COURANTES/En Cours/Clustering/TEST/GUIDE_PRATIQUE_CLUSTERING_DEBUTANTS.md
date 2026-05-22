# GUIDE PRATIQUE : CLUSTERING DE TRAJECTOIRES D'ESCALADE POUR DÉBUTANTS

## 📋 TABLE DES MATIÈRES

1. [Installation des logiciels](#1-installation-des-logiciels)
2. [Structure du projet](#2-structure-du-projet)
3. [Les données d'exemple](#3-les-données-dexemple)
4. [Étape 1 : Charger et visualiser les données](#4-étape-1--charger-et-visualiser-les-données)
5. [Étape 2 : Normaliser les trajectoires](#5-étape-2--normaliser-les-trajectoires)
6. [Étape 3 : Calculer les distances](#6-étape-3--calculer-les-distances)
7. [Étape 4 : Faire le clustering](#7-étape-4--faire-le-clustering)
8. [Étape 5 : Valider les résultats](#8-étape-5--valider-les-résultats)
9. [Étape 6 : Calculer les scores de créativité](#9-étape-6--calculer-les-scores-de-créativité)
10. [Script complet automatisé](#10-script-complet-automatisé)
11. [Exercices pratiques](#11-exercices-pratiques)
12. [FAQ et résolution de problèmes](#12-faq-et-résolution-de-problèmes)

---

## 1. INSTALLATION DES LOGICIELS

### 1.1 Installer Python (si vous ne l'avez pas)

#### Sur Windows :
1. Allez sur https://www.python.org/downloads/
2. Téléchargez Python 3.10 ou plus récent
3. **IMPORTANT** : Cochez "Add Python to PATH" pendant l'installation
4. Cliquez sur "Install Now"

#### Sur Mac :
```bash
# Ouvrez le Terminal et tapez :
brew install python3
```

#### Sur Linux (Ubuntu/Debian) :
```bash
sudo apt update
sudo apt install python3 python3-pip
```

### 1.2 Vérifier que Python fonctionne

Ouvrez un terminal (ou "Invite de commandes" sur Windows) et tapez :
```bash
python --version
```

Vous devriez voir quelque chose comme : `Python 3.10.x`

### 1.3 Installer les bibliothèques nécessaires

Dans le terminal, copiez-collez ces commandes **une par une** :

```bash
# Bibliothèques de base pour les calculs et graphiques
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas

# Bibliothèque spéciale pour calculer les distances entre trajectoires
pip install git+https://github.com/bguillouet/traj-dist.git
```

**Note** : Si `pip` ne fonctionne pas, essayez `pip3` à la place.

### 1.4 Créer un environnement virtuel (RECOMMANDÉ)

Un environnement virtuel isole vos installations pour ce projet :

```bash
# Créer l'environnement
python -m venv env_clustering

# L'activer
# Sur Windows :
env_clustering\Scripts\activate

# Sur Mac/Linux :
source env_clustering/bin/activate

# Maintenant installer les bibliothèques (voir 1.3)
```

Pour désactiver l'environnement plus tard :
```bash
deactivate
```

---

## 2. STRUCTURE DU PROJET

Créez ce dossier sur votre ordinateur (par exemple dans Documents) :

```
clustering_escalade/
├── donnees/                    # Vos fichiers de trajectoires
│   ├── trajectoire_1.csv
│   ├── trajectoire_2.csv
│   ├── trajectoire_3.csv
│   ├── trajectoire_4.csv
│   ├── trajectoire_5.csv
│   └── trajectoire_6.csv
├── scripts/                    # Vos codes Python
│   ├── 01_visualisation.py
│   ├── 02_normalisation.py
│   ├── 03_distances.py
│   ├── 04_clustering.py
│   ├── 05_validation.py
│   └── pipeline_complet.py
├── resultats/                  # Résultats générés
│   ├── graphiques/
│   └── analyses/
└── README.md                   # Ce fichier
```

**Comment créer cette structure :**

Sur Windows (Explorateur de fichiers) :
- Clic droit → Nouveau → Dossier
- Nommez-le `clustering_escalade`
- À l'intérieur, créez les sous-dossiers `donnees`, `scripts`, `resultats`

Sur Mac/Linux (Terminal) :
```bash
mkdir -p clustering_escalade/{donnees,scripts,resultats/graphiques,resultats/analyses}
cd clustering_escalade
```

---

## 3. LES DONNÉES D'EXEMPLE

Je vous fournis 6 trajectoires simulées d'escalade. Chaque fichier contient 100 points avec :
- **t** : temps normalisé de 0 à 100
- **x** : position horizontale en mètres (0 à 2.5m)
- **y** : position verticale en mètres (0 à 4m)

### Caractéristiques des trajectoires :

- **Trajectoire 1** : Montée verticale directe (solution basique)
- **Trajectoire 2** : Dévers à gauche (alternative technique)
- **Trajectoire 3** : Zigzag créatif (exploration large)
- **Trajectoire 4** : Arc de cercle vers la droite
- **Trajectoire 5** : Similaire à 1 (même stratégie)
- **Trajectoire 6** : Similaire à 2 (même stratégie)

**Résultat attendu** : 3 clusters
- Cluster A : trajectoires 1 et 5
- Cluster B : trajectoires 2 et 6
- Cluster C : trajectoires 3 et 4

### Fichiers CSV à créer

Je vais vous donner le contenu de chaque fichier. Créez-les dans le dossier `donnees/`.

---

## 4. ÉTAPE 1 : CHARGER ET VISUALISER LES DONNÉES

### Objectif
Apprendre à lire des fichiers CSV et dessiner les trajectoires pour vérifier qu'elles sont correctes.

### Code : `scripts/01_visualisation.py`

```python
"""
Script 1 : Visualisation des trajectoires d'escalade
====================================================

Ce script charge les données et dessine les trajectoires sur un graphique.
C'est la première étape pour vérifier que vos données sont bonnes.
"""

# === IMPORTS ===
# On importe les bibliothèques dont on a besoin
import pandas as pd              # Pour lire les fichiers CSV
import matplotlib.pyplot as plt  # Pour faire des graphiques
import numpy as np              # Pour les calculs
import os                       # Pour gérer les fichiers

# === CONFIGURATION ===
# Définir où sont les fichiers (à adapter selon votre ordinateur)
DOSSIER_DONNEES = "../donnees"
DOSSIER_RESULTATS = "../resultats/graphiques"

# Créer le dossier de résultats s'il n'existe pas
os.makedirs(DOSSIER_RESULTATS, exist_ok=True)

# === FONCTION POUR CHARGER UNE TRAJECTOIRE ===
def charger_trajectoire(nom_fichier):
    """
    Charge une trajectoire depuis un fichier CSV.
    
    Paramètres :
    -----------
    nom_fichier : str
        Le nom du fichier (ex: "trajectoire_1.csv")
    
    Retourne :
    ----------
    pandas.DataFrame
        Un tableau avec les colonnes t, x, y
    """
    # Construire le chemin complet du fichier
    chemin = os.path.join(DOSSIER_DONNEES, nom_fichier)
    
    # Lire le fichier CSV
    print(f"Chargement de {nom_fichier}...")
    donnees = pd.read_csv(chemin)
    
    # Vérifier que les colonnes nécessaires sont présentes
    colonnes_requises = ['t', 'x', 'y']
    for col in colonnes_requises:
        if col not in donnees.columns:
            raise ValueError(f"Colonne '{col}' manquante dans {nom_fichier}")
    
    print(f"  ✓ {len(donnees)} points chargés")
    return donnees

# === FONCTION POUR VISUALISER TOUTES LES TRAJECTOIRES ===
def visualiser_toutes_trajectoires():
    """
    Charge et affiche toutes les trajectoires sur un même graphique.
    """
    # Préparer le graphique
    plt.figure(figsize=(10, 8))
    plt.title("Trajectoires d'escalade", fontsize=16, fontweight='bold')
    plt.xlabel("Position horizontale X (m)", fontsize=12)
    plt.ylabel("Position verticale Y (m)", fontsize=12)
    
    # Définir les couleurs pour chaque trajectoire
    couleurs = ['blue', 'red', 'green', 'orange', 'purple', 'brown']
    
    # Charger et tracer chaque trajectoire
    for i in range(1, 7):
        nom_fichier = f"trajectoire_{i}.csv"
        
        try:
            # Charger les données
            traj = charger_trajectoire(nom_fichier)
            
            # Tracer la trajectoire
            plt.plot(traj['x'], traj['y'], 
                    color=couleurs[i-1], 
                    linewidth=2, 
                    label=f'Trajectoire {i}',
                    marker='o',      # Mettre des points
                    markersize=3,    # Taille des points
                    alpha=0.7)       # Transparence
            
            # Marquer le début (point vert)
            plt.plot(traj['x'].iloc[0], traj['y'].iloc[0], 
                    'go', markersize=10, label=f'Début {i}' if i==1 else '')
            
            # Marquer la fin (point rouge)
            plt.plot(traj['x'].iloc[-1], traj['y'].iloc[-1], 
                    'ro', markersize=10, label=f'Fin {i}' if i==1 else '')
            
        except FileNotFoundError:
            print(f"  ⚠ Fichier {nom_fichier} non trouvé, ignoré")
        except Exception as e:
            print(f"  ✗ Erreur avec {nom_fichier}: {e}")
    
    # Ajouter une grille
    plt.grid(True, alpha=0.3)
    
    # Ajouter la légende
    plt.legend(loc='upper left', fontsize=10)
    
    # Ajuster les limites pour bien voir toutes les trajectoires
    plt.xlim(-0.2, 2.7)
    plt.ylim(-0.2, 4.5)
    
    # Sauvegarder le graphique
    chemin_sortie = os.path.join(DOSSIER_RESULTATS, "toutes_trajectoires.png")
    plt.savefig(chemin_sortie, dpi=300, bbox_inches='tight')
    print(f"\n✓ Graphique sauvegardé : {chemin_sortie}")
    
    # Afficher le graphique
    plt.show()

# === FONCTION POUR VISUALISER CHAQUE TRAJECTOIRE SÉPARÉMENT ===
def visualiser_trajectoires_individuelles():
    """
    Crée un graphique séparé pour chaque trajectoire.
    """
    for i in range(1, 7):
        nom_fichier = f"trajectoire_{i}.csv"
        
        try:
            # Charger les données
            traj = charger_trajectoire(nom_fichier)
            
            # Créer un nouveau graphique
            plt.figure(figsize=(8, 10))
            plt.title(f"Trajectoire {i} - Détail", fontsize=14, fontweight='bold')
            plt.xlabel("Position horizontale X (m)", fontsize=12)
            plt.ylabel("Position verticale Y (m)", fontsize=12)
            
            # Tracer la trajectoire
            plt.plot(traj['x'], traj['y'], 'b-', linewidth=2)
            plt.plot(traj['x'], traj['y'], 'bo', markersize=4, alpha=0.5)
            
            # Points de départ et d'arrivée
            plt.plot(traj['x'].iloc[0], traj['y'].iloc[0], 
                    'go', markersize=15, label='Début')
            plt.plot(traj['x'].iloc[-1], traj['y'].iloc[-1], 
                    'ro', markersize=15, label='Fin')
            
            # Statistiques
            plt.text(0.05, 0.95, 
                    f"Longueur totale: {len(traj)} points\n"
                    f"X min: {traj['x'].min():.2f}m, max: {traj['x'].max():.2f}m\n"
                    f"Y min: {traj['y'].min():.2f}m, max: {traj['y'].max():.2f}m",
                    transform=plt.gca().transAxes,
                    verticalalignment='top',
                    bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5),
                    fontsize=10)
            
            plt.grid(True, alpha=0.3)
            plt.legend()
            
            # Sauvegarder
            chemin_sortie = os.path.join(DOSSIER_RESULTATS, f"trajectoire_{i}_detail.png")
            plt.savefig(chemin_sortie, dpi=200, bbox_inches='tight')
            print(f"✓ Trajectoire {i} sauvegardée : {chemin_sortie}")
            
            plt.close()  # Fermer pour économiser la mémoire
            
        except FileNotFoundError:
            print(f"⚠ Fichier {nom_fichier} non trouvé")
        except Exception as e:
            print(f"✗ Erreur avec {nom_fichier}: {e}")

# === PROGRAMME PRINCIPAL ===
if __name__ == "__main__":
    """
    C'est ici que le programme commence quand vous l'exécutez.
    """
    print("="*60)
    print("VISUALISATION DES TRAJECTOIRES D'ESCALADE")
    print("="*60)
    print()
    
    # 1. Visualiser toutes les trajectoires ensemble
    print("1. Création du graphique avec toutes les trajectoires...")
    visualiser_toutes_trajectoires()
    
    print()
    
    # 2. Visualiser chaque trajectoire individuellement
    print("2. Création des graphiques individuels...")
    visualiser_trajectoires_individuelles()
    
    print()
    print("="*60)
    print("✓ TERMINÉ ! Vérifiez le dossier resultats/graphiques/")
    print("="*60)
```

### Comment exécuter ce script

1. Ouvrez un terminal
2. Allez dans le dossier `scripts/` :
   ```bash
   cd clustering_escalade/scripts
   ```
3. Exécutez le script :
   ```bash
   python 01_visualisation.py
   ```

### Que devriez-vous voir ?

- Des messages dans le terminal confirmant le chargement
- Une fenêtre qui s'ouvre avec le graphique
- Des fichiers PNG créés dans `resultats/graphiques/`

---

## 5. ÉTAPE 2 : NORMALISER LES TRAJECTOIRES

### Objectif
Toutes les trajectoires doivent avoir exactement 100 points pour pouvoir les comparer. On utilise l'interpolation linéaire.

### Pourquoi normaliser ?

Imaginez deux trajectoires :
- Trajectoire A : 80 points
- Trajectoire B : 120 points

Si on les compare directement, on compare "des pommes avec des oranges". La normalisation à 100 points résout ce problème.

### Code : `scripts/02_normalisation.py`

```python
"""
Script 2 : Normalisation temporelle des trajectoires
===================================================

Ce script normalise toutes les trajectoires à exactement 100 points
en utilisant l'interpolation linéaire.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d
import os

# === CONFIGURATION ===
DOSSIER_DONNEES = "../donnees"
DOSSIER_RESULTATS = "../resultats/analyses"
N_POINTS_CIBLE = 100  # Nombre de points après normalisation

os.makedirs(DOSSIER_RESULTATS, exist_ok=True)

# === FONCTION DE NORMALISATION ===
def normaliser_trajectoire(traj, n_points=100):
    """
    Normalise une trajectoire à n_points en utilisant l'interpolation.
    
    Paramètres :
    -----------
    traj : pandas.DataFrame
        Trajectoire avec colonnes t, x, y
    n_points : int
        Nombre de points voulus (défaut: 100)
    
    Retourne :
    ----------
    pandas.DataFrame
        Trajectoire normalisée
    """
    # Nombre de points d'origine
    n_original = len(traj)
    
    # Créer un temps normalisé de 0 à 1
    t_original = np.linspace(0, 1, n_original)
    t_normalise = np.linspace(0, 1, n_points)
    
    # Interpoler X
    # interp1d crée une fonction qui "connecte les points"
    interpolateur_x = interp1d(t_original, traj['x'].values, kind='linear')
    x_normalise = interpolateur_x(t_normalise)
    
    # Interpoler Y
    interpolateur_y = interp1d(t_original, traj['y'].values, kind='linear')
    y_normalise = interpolateur_y(t_normalise)
    
    # Créer le nouveau DataFrame
    traj_normalisee = pd.DataFrame({
        't': np.arange(n_points),
        'x': x_normalise,
        'y': y_normalise
    })
    
    return traj_normalisee

# === FONCTION POUR COMPARER AVANT/APRÈS ===
def comparer_normalisation(nom_fichier):
    """
    Compare visuellement une trajectoire avant et après normalisation.
    """
    # Charger la trajectoire originale
    chemin = os.path.join(DOSSIER_DONNEES, nom_fichier)
    traj_originale = pd.read_csv(chemin)
    
    # Normaliser
    traj_normalisee = normaliser_trajectoire(traj_originale, N_POINTS_CIBLE)
    
    # Créer la comparaison visuelle
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))
    
    # Graphique 1 : Trajectoire originale
    axes[0].plot(traj_originale['x'], traj_originale['y'], 
                'b-o', linewidth=2, markersize=4, alpha=0.6)
    axes[0].set_title(f"AVANT normalisation\n{len(traj_originale)} points", 
                     fontweight='bold')
    axes[0].set_xlabel("X (m)")
    axes[0].set_ylabel("Y (m)")
    axes[0].grid(True, alpha=0.3)
    
    # Graphique 2 : Trajectoire normalisée
    axes[1].plot(traj_normalisee['x'], traj_normalisee['y'], 
                'r-o', linewidth=2, markersize=4, alpha=0.6)
    axes[1].set_title(f"APRÈS normalisation\n{len(traj_normalisee)} points", 
                     fontweight='bold')
    axes[1].set_xlabel("X (m)")
    axes[1].set_ylabel("Y (m)")
    axes[1].grid(True, alpha=0.3)
    
    # Ajuster les limites pour qu'elles soient identiques
    xlim = (min(traj_originale['x'].min(), traj_normalisee['x'].min()) - 0.1,
            max(traj_originale['x'].max(), traj_normalisee['x'].max()) + 0.1)
    ylim = (min(traj_originale['y'].min(), traj_normalisee['y'].min()) - 0.1,
            max(traj_originale['y'].max(), traj_normalisee['y'].max()) + 0.1)
    
    axes[0].set_xlim(xlim)
    axes[0].set_ylim(ylim)
    axes[1].set_xlim(xlim)
    axes[1].set_ylim(ylim)
    
    plt.tight_layout()
    
    # Sauvegarder
    numero = nom_fichier.replace('trajectoire_', '').replace('.csv', '')
    chemin_sortie = os.path.join(DOSSIER_RESULTATS, f"comparaison_norm_{numero}.png")
    plt.savefig(chemin_sortie, dpi=200, bbox_inches='tight')
    print(f"✓ Comparaison sauvegardée : {chemin_sortie}")
    
    return traj_normalisee

# === FONCTION POUR NORMALISER TOUTES LES TRAJECTOIRES ===
def normaliser_toutes():
    """
    Normalise toutes les trajectoires et les sauvegarde.
    """
    trajectoires_normalisees = []
    
    for i in range(1, 7):
        nom_fichier = f"trajectoire_{i}.csv"
        print(f"\nTraitement de {nom_fichier}...")
        
        try:
            # Charger
            chemin = os.path.join(DOSSIER_DONNEES, nom_fichier)
            traj = pd.read_csv(chemin)
            print(f"  Avant : {len(traj)} points")
            
            # Normaliser
            traj_norm = normaliser_trajectoire(traj, N_POINTS_CIBLE)
            print(f"  Après : {len(traj_norm)} points")
            
            # Sauvegarder la version normalisée
            nom_sortie = f"trajectoire_{i}_normalisee.csv"
            chemin_sortie = os.path.join(DOSSIER_RESULTATS, nom_sortie)
            traj_norm.to_csv(chemin_sortie, index=False)
            print(f"  ✓ Sauvegardée : {chemin_sortie}")
            
            # Comparer visuellement
            comparer_normalisation(nom_fichier)
            
            # Stocker en mémoire pour les analyses futures
            trajectoires_normalisees.append({
                'id': i,
                'donnees': traj_norm
            })
            
        except FileNotFoundError:
            print(f"  ⚠ Fichier non trouvé")
        except Exception as e:
            print(f"  ✗ Erreur : {e}")
    
    return trajectoires_normalisees

# === PROGRAMME PRINCIPAL ===
if __name__ == "__main__":
    print("="*60)
    print("NORMALISATION DES TRAJECTOIRES")
    print("="*60)
    print(f"Nombre de points cible : {N_POINTS_CIBLE}")
    print()
    
    trajectoires = normaliser_toutes()
    
    print()
    print("="*60)
    print(f"✓ TERMINÉ ! {len(trajectoires)} trajectoires normalisées")
    print(f"  Fichiers dans : {DOSSIER_RESULTATS}")
    print("="*60)
```

### Explication détaillée de l'interpolation

```python
# Exemple simplifié :
# Vous avez 5 points : [0, 1, 2, 3, 4]
# Valeurs Y : [0, 2, 4, 3, 5]
# Vous voulez 10 points

from scipy.interpolate import interp1d

x_original = [0, 1, 2, 3, 4]
y_original = [0, 2, 4, 3, 5]

# Créer la fonction d'interpolation
f = interp1d(x_original, y_original, kind='linear')

# Nouveaux points
x_nouveau = np.linspace(0, 4, 10)  # 10 points de 0 à 4
y_nouveau = f(x_nouveau)           # Calculer les Y

print("Anciens points :", len(x_original))
print("Nouveaux points :", len(x_nouveau))
# Résultat : l'interpolation "remplit les trous" entre les points
```

---

## 6. ÉTAPE 3 : CALCULER LES DISTANCES

### Objectif
Calculer à quel point chaque trajectoire est différente de toutes les autres en utilisant la métrique SSPD (Symmetrized Segment-Path Distance).

### Qu'est-ce que la SSPD ?

C'est une mesure qui calcule la distance moyenne entre deux trajectoires en considérant leur forme géométrique. Plus la distance est grande, plus les trajectoires sont différentes.

### Code : `scripts/03_distances.py`

```python
"""
Script 3 : Calcul de la matrice de distances SSPD
================================================

Ce script calcule la matrice de distances entre trajectoires
en utilisant la métrique SSPD (Symmetrized Segment-Path Distance).

Aucune dépendance externe n'est requise.
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# === CONFIGURATION ===
DOSSIER_DONNEES = "../resultats/analyses"
DOSSIER_RESULTATS = "../resultats/analyses"
N_TRAJECTOIRES = 6


# ============================================================
# === IMPLEMENTATION DU SSPD ================================
# ============================================================

def distance_point_trajectory(point, trajectory):
    """
    Distance minimale entre un point et une trajectoire.
    
    point : array-like shape (2,)
    trajectory : array shape (N, 2)
    """
    distances = np.linalg.norm(trajectory - point, axis=1)
    return np.min(distances)


def mean_min_distance(traj_A, traj_B):
    """
    Distance moyenne minimale d'une trajectoire A vers B.
    """
    return np.mean([
        distance_point_trajectory(p, traj_B) for p in traj_A
    ])


def sspd(traj_A, traj_B):
    """
    Calcul du SSPD entre deux trajectoires.
    
    traj_A, traj_B : array shape (N, 2)
    """
    d_AB = mean_min_distance(traj_A, traj_B)
    d_BA = mean_min_distance(traj_B, traj_A)
    return 0.5 * (d_AB + d_BA)


# ============================================================
# === CHARGEMENT DES TRAJECTOIRES ============================
# ============================================================

def charger_trajectoires_normalisees():
    """
    Charge les trajectoires normalisées depuis les CSV.
    
    Retourne :
    ----------
    list[np.ndarray]
        Liste de trajectoires (100, 2)
    """
    trajectoires = []

    for i in range(1, N_TRAJECTOIRES + 1):
        chemin = os.path.join(
            DOSSIER_DONNEES,
            f"trajectoire_{i}_normalisee.csv"
        )

        try:
            df = pd.read_csv(chemin)
            traj = df[['x', 'y']].values
            trajectoires.append(traj)
            print(f"✓ Trajectoire {i} chargée : {traj.shape}")

        except FileNotFoundError:
            print(f"✗ Trajectoire {i} manquante")
            trajectoires.append(None)

    return trajectoires


# ============================================================
# === MATRICE DE DISTANCES ==================================
# ============================================================

def calculer_matrice_distances(trajectoires):
    """
    Calcule la matrice SSPD NxN.
    """
    N = len(trajectoires)
    D = np.zeros((N, N))

    print("\nCalcul des distances SSPD...\n")

    for i in range(N):
        for j in range(i + 1, N):
            if trajectoires[i] is not None and trajectoires[j] is not None:
                dist = sspd(trajectoires[i], trajectoires[j])
                D[i, j] = dist
                D[j, i] = dist
                print(f"  SSPD(T{i+1}, T{j+1}) = {dist:.4f}")

    return D


# ============================================================
# === VISUALISATION =========================================
# ============================================================

def visualiser_matrice(D):
    """
    Affiche la heatmap de la matrice de distances.
    """
    plt.figure(figsize=(9, 8))

    sns.heatmap(
        D,
        annot=True,
        fmt=".3f",
        cmap="YlOrRd",
        square=True,
        xticklabels=[f"T{i}" for i in range(1, N_TRAJECTOIRES + 1)],
        yticklabels=[f"T{i}" for i in range(1, N_TRAJECTOIRES + 1)],
        cbar_kws={"label": "Distance SSPD"}
    )

    plt.title("Matrice de distances SSPD", fontweight="bold")
    plt.tight_layout()

    chemin = os.path.join(DOSSIER_RESULTATS, "matrice_distances.png")
    plt.savefig(chemin, dpi=300)
    print(f"\n✓ Heatmap sauvegardée : {chemin}")

    plt.show()


# ============================================================
# === PROGRAMME PRINCIPAL ===================================
# ============================================================

if __name__ == "__main__":
    print("=" * 60)
    print("CALCUL DES DISTANCES SSPD")
    print("=" * 60)

    print("\n1. Chargement des trajectoires normalisées...")
    trajectoires = charger_trajectoires_normalisees()

    print("\n2. Calcul de la matrice de distances...")
    matrice_D = calculer_matrice_distances(trajectoires)

    chemin_csv = os.path.join(DOSSIER_RESULTATS, "matrice_distances.csv")
    np.savetxt(chemin_csv, matrice_D, delimiter=",", fmt="%.6f")
    print(f"\n✓ Matrice sauvegardée : {chemin_csv}")

    print("\n3. Visualisation...")
    visualiser_matrice(matrice_D)

    print("\n✓ SCRIPT 03 TERMINÉ")
```

### Comprendre la SSPD en images

```
Trajectoire A :    o-----o
                    \     \
                     o-----o

Trajectoire B :    o-----o-----o-----o

Distance SSPD = moyenne des distances de chaque point de A 
                vers le segment le plus proche de B,
                PLUS
                moyenne des distances de chaque point de B
                vers le segment le plus proche de A,
                le tout divisé par 2
```

---

## 7. ÉTAPE 4 : FAIRE LE CLUSTERING

### Objectif
Regrouper les trajectoires similaires en utilisant le clustering hiérarchique avec la méthode de Ward.

### Qu'est-ce que le clustering hiérarchique ?

Imaginez que vous devez ranger des livres :
1. Au début, chaque livre est seul
2. Vous regroupez les livres les plus similaires
3. Puis vous regroupez les groupes similaires
4. Jusqu'à avoir tous les livres dans un seul groupe

Le dendrogramme (arbre) montre toute cette hiérarchie.

### Code : `scripts/04_clustering.py`

```python
"""
Script 4 : Clustering hiérarchique Ward
======================================

Ce script effectue le clustering des trajectoires et produit un dendrogramme.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import linkage, dendrogram, fcluster
from scipy.spatial.distance import squareform
import os

# === CONFIGURATION ===
DOSSIER_DONNEES = "../resultats/analyses"
DOSSIER_RESULTATS = "../resultats/analyses"
SEUIL_CLUSTERING = 15.0  # Distance pour couper l'arbre

# === FONCTION POUR CHARGER LA MATRICE ===
def charger_matrice_distances():
    """
    Charge la matrice de distances calculée précédemment.
    """
    chemin = os.path.join(DOSSIER_DONNEES, "matrice_distances.csv")
    
    try:
        matrice_D = np.loadtxt(chemin, delimiter=',')
        print(f"✓ Matrice chargée : {matrice_D.shape}")
        return matrice_D
    except FileNotFoundError:
        print("✗ Fichier matrice_distances.csv introuvable")
        print("  Exécutez d'abord le script 03_distances.py")
        return None

# === FONCTION POUR FAIRE LE CLUSTERING ===
def faire_clustering_ward(matrice_D):
    """
    Effectue le clustering hiérarchique avec la méthode de Ward.
    
    Paramètres :
    -----------
    matrice_D : numpy.ndarray
        Matrice de distances carrée (N, N)
    
    Retourne :
    ----------
    numpy.ndarray
        Matrice de linkage pour le dendrogramme
    """
    print("\nEffectuation du clustering hiérarchique (méthode de Ward)...")
    
    # Convertir la matrice carrée en forme condensée
    # (Requis par scipy : seulement la partie supérieure)
    distances_condensees = squareform(matrice_D)
    
    # Clustering Ward
    # Ward minimise la variance intra-cluster
    Z = linkage(distances_condensees, method='ward')
    
    print("✓ Clustering terminé")
    print(f"  Forme de Z : {Z.shape}")
    print("  (N-1 fusions pour N trajectoires)")
    
    return Z

# === FONCTION POUR TRACER LE DENDROGRAMME ===
def tracer_dendrogramme(Z, sauvegarder=True):
    """
    Trace le dendrogramme (arbre hiérarchique).
    """
    plt.figure(figsize=(12, 8))
    
    # Créer le dendrogramme
    dendro = dendrogram(
        Z,
        labels=[f'T{i}' for i in range(1, 7)],
        color_threshold=SEUIL_CLUSTERING,  # Ligne de coupe
        above_threshold_color='gray'
    )
    
    # Ajouter la ligne de seuil
    plt.axhline(y=SEUIL_CLUSTERING, color='r', linestyle='--', 
                linewidth=2, label=f'Seuil = {SEUIL_CLUSTERING}')
    
    plt.title("Dendrogramme - Clustering hiérarchique des trajectoires", 
             fontsize=14, fontweight='bold')
    plt.xlabel("Trajectoire", fontsize=12)
    plt.ylabel("Distance (méthode de Ward)", fontsize=12)
    plt.legend()
    plt.grid(True, axis='y', alpha=0.3)
    
    # Ajouter des explications
    plt.text(0.5, 0.95, 
            "Les trajectoires reliées plus bas sont plus similaires",
            ha='center', transform=plt.gca().transAxes,
            bbox=dict(boxstyle='round', facecolor='yellow', alpha=0.3),
            fontsize=10)
    
    plt.tight_layout()
    
    if sauvegarder:
        chemin_sortie = os.path.join(DOSSIER_RESULTATS, "dendrogramme.png")
        plt.savefig(chemin_sortie, dpi=300, bbox_inches='tight')
        print(f"\n✓ Dendrogramme sauvegardé : {chemin_sortie}")
    
    plt.show()

# === FONCTION POUR EXTRAIRE LES CLUSTERS ===
def extraire_clusters(Z, seuil=None, n_clusters=None):
    """
    Coupe le dendrogramme pour former des clusters.
    
    Paramètres :
    -----------
    Z : numpy.ndarray
        Matrice de linkage
    seuil : float, optional
        Distance de coupe (si None, utilise n_clusters)
    n_clusters : int, optional
        Nombre de clusters voulus (si None, utilise seuil)
    
    Retourne :
    ----------
    numpy.ndarray
        Labels de cluster pour chaque trajectoire (1, 2, 3, ...)
    """
    if seuil is not None:
        # Couper par distance
        labels = fcluster(Z, seuil, criterion='distance')
        print(f"\nClusters formés avec seuil = {seuil}")
    elif n_clusters is not None:
        # Couper par nombre de clusters
        labels = fcluster(Z, n_clusters, criterion='maxclust')
        print(f"\nClusters formés : {n_clusters} clusters demandés")
    else:
        raise ValueError("Fournir soit 'seuil' soit 'n_clusters'")
    
    return labels

# === FONCTION POUR AFFICHER LES RÉSULTATS ===
def afficher_resultats_clusters(labels):
    """
    Affiche quelles trajectoires sont dans quels clusters.
    """
    n_clusters = len(np.unique(labels))
    
    print("="*60)
    print(f"RÉSULTATS DU CLUSTERING : {n_clusters} clusters")
    print("="*60)
    
    for cluster_id in np.unique(labels):
        trajectoires_dans_cluster = np.where(labels == cluster_id)[0] + 1
        print(f"\nCluster {cluster_id}:")
        print(f"  Trajectoires : {list(trajectoires_dans_cluster)}")
        print(f"  Taille : {len(trajectoires_dans_cluster)} trajectoires")
    
    print("="*60)

# === FONCTION POUR SAUVEGARDER LES ASSIGNATIONS ===
def sauvegarder_assignations(labels):
    """
    Sauvegarde les assignations de cluster dans un CSV.
    """
    df_clusters = pd.DataFrame({
        'trajectoire': [f'T{i}' for i in range(1, 7)],
        'cluster': labels
    })
    
    chemin_sortie = os.path.join(DOSSIER_RESULTATS, "assignations_clusters.csv")
    df_clusters.to_csv(chemin_sortie, index=False)
    print(f"\n✓ Assignations sauvegardées : {chemin_sortie}")
    
    return df_clusters

# === FONCTION POUR VISUALISER LES CLUSTERS ===
def visualiser_clusters(labels):
    """
    Trace les trajectoires colorées par cluster.
    """
    # Charger les trajectoires
    trajectoires = []
    for i in range(1, 7):
        chemin = os.path.join(DOSSIER_DONNEES, f"trajectoire_{i}_normalisee.csv")
        df = pd.read_csv(chemin)
        trajectoires.append(df)
    
    # Définir des couleurs pour les clusters
    couleurs_clusters = {1: 'blue', 2: 'red', 3: 'green', 
                         4: 'orange', 5: 'purple', 6: 'brown'}
    
    plt.figure(figsize=(10, 8))
    
    # Tracer chaque trajectoire
    for i, (traj, cluster) in enumerate(zip(trajectoires, labels)):
        couleur = couleurs_clusters[cluster]
        plt.plot(traj['x'], traj['y'], 
                color=couleur, linewidth=2, 
                label=f'T{i+1} (Cluster {cluster})',
                alpha=0.7)
    
    plt.title("Trajectoires colorées par cluster", 
             fontsize=14, fontweight='bold')
    plt.xlabel("Position X (m)", fontsize=12)
    plt.ylabel("Position Y (m)", fontsize=12)
    plt.legend(loc='best')
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    
    chemin_sortie = os.path.join(DOSSIER_RESULTATS, "trajectoires_par_cluster.png")
    plt.savefig(chemin_sortie, dpi=300, bbox_inches='tight')
    print(f"✓ Visualisation sauvegardée : {chemin_sortie}")
    
    plt.show()

# === PROGRAMME PRINCIPAL ===
if __name__ == "__main__":
    print("="*60)
    print("CLUSTERING HIÉRARCHIQUE DES TRAJECTOIRES")
    print("="*60)
    print()
    
    # 1. Charger la matrice de distances
    print("1. Chargement de la matrice de distances...")
    matrice_D = charger_matrice_distances()
    
    if matrice_D is None:
        print("\n✗ Impossible de continuer sans la matrice de distances")
        exit(1)
    
    # 2. Faire le clustering
    print("\n2. Clustering hiérarchique...")
    Z = faire_clustering_ward(matrice_D)
    
    # 3. Tracer le dendrogramme
    print("\n3. Création du dendrogramme...")
    tracer_dendrogramme(Z)
    
    # 4. Extraire les clusters
    print("\n4. Extraction des clusters...")
    labels = extraire_clusters(Z, seuil=SEUIL_CLUSTERING)
    
    # 5. Afficher les résultats
    afficher_resultats_clusters(labels)
    
    # 6. Sauvegarder
    df_clusters = sauvegarder_assignations(labels)
    
    # 7. Visualiser
    print("\n5. Visualisation des clusters...")
    visualiser_clusters(labels)
    
    print()
    print("="*60)
    print("✓ CLUSTERING TERMINÉ !")
    print("  Vérifiez le dendrogramme pour choisir le bon seuil")
    print("="*60)
```

### Comment lire un dendrogramme

```
        |
    15  |        ___
        |       |   |
    10  |   ___|   |___
        |  |           |
     5  | _|___     ___|___
        | |    |    |      |
     0  +-T1--T5---T2-----T6----T3----T4
```

- **Axe Y** : Distance de fusion
- **Plus deux branches se rejoignent BAS**, plus elles sont similaires
- **Couper horizontalement** à une hauteur choisit le nombre de clusters

---

## 8. ÉTAPE 5 : VALIDER LES RÉSULTATS

### Objectif
S'assurer que les clusters trouvés sont fiables et non dus au hasard.

### Code : `scripts/05_validation.py`

```python
"""
Script 5 : Validation du clustering
=================================

Ce script calcule le score Hubert-Gamma pour valider
la qualité du clustering.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import linkage, fcluster
from scipy.spatial.distance import squareform
import os

# === CONFIGURATION ===
DOSSIER_DONNEES = "../resultats/analyses"
DOSSIER_RESULTATS = "../resultats/analyses"

# === FONCTION HUBERT-GAMMA ===
def calculer_hubert_gamma(matrice_D, labels):
    """
    Calcule le coefficient Hubert-Gamma.
    
    Ce coefficient mesure la corrélation entre :
    - Les distances entre trajectoires
    - Leur appartenance aux mêmes clusters
    
    Valeur proche de 1 = bon clustering
    Valeur proche de 0 = clustering aléatoire
    
    Paramètres :
    -----------
    matrice_D : numpy.ndarray
        Matrice de distances (N, N)
    labels : numpy.ndarray
        Labels de cluster pour chaque trajectoire
    
    Retourne :
    ----------
    float
        Score Hubert-Gamma
    """
    N = len(labels)
    
    # Créer la matrice de co-appartenance C
    # C[i,j] = 1 si i et j dans même cluster, 0 sinon
    C = np.zeros((N, N))
    for i in range(N):
        for j in range(N):
            if labels[i] == labels[j]:
                C[i, j] = 1
            else:
                C[i, j] = 0
    
    # Extraire les triangles supérieurs (sans diagonale)
    indices_sup = np.triu_indices(N, k=1)
    distances_plates = matrice_D[indices_sup]
    coappartenance_plate = C[indices_sup]
    
    # Calculer la corrélation de Pearson
    gamma = np.corrcoef(distances_plates, coappartenance_plate)[0, 1]
    
    return gamma

# === FONCTION POUR TESTER DIFFÉRENTS NOMBRES DE CLUSTERS ===
def tester_nombre_clusters(matrice_D, k_min=2, k_max=5):
    """
    Teste différents nombres de clusters et calcule Hubert-Gamma pour chacun.
    
    Retourne :
    ----------
    dict
        Dictionnaire {nombre_clusters: score_gamma}
    """
    # Clustering Ward
    distances_condensees = squareform(matrice_D)
    Z = linkage(distances_condensees, method='ward')
    
    resultats = {}
    
    print("\nTest de différents nombres de clusters:")
    print("-" * 50)
    
    for k in range(k_min, k_max + 1):
        # Former k clusters
        labels = fcluster(Z, k, criterion='maxclust')
        
        # Calculer Hubert-Gamma
        gamma = calculer_hubert_gamma(matrice_D, labels)
        
        resultats[k] = gamma
        
        print(f"k = {k} clusters → Hubert-Γ = {gamma:.4f}")
        
        # Afficher la composition
        for cluster_id in np.unique(labels):
            trajs = np.where(labels == cluster_id)[0] + 1
            print(f"  Cluster {cluster_id}: {list(trajs)}")
        print()
    
    return resultats

# === FONCTION POUR TRACER LES SCORES ===
def tracer_scores_validation(resultats, sauvegarder=True):
    """
    Trace l'évolution du score Hubert-Gamma en fonction du nombre de clusters.
    """
    k_values = list(resultats.keys())
    gamma_values = list(resultats.values())
    
    plt.figure(figsize=(10, 6))
    
    # Tracer les scores
    plt.plot(k_values, gamma_values, 'bo-', linewidth=2, markersize=10)
    
    # Identifier le maximum
    k_optimal = max(resultats, key=resultats.get)
    gamma_optimal = resultats[k_optimal]
    
    plt.plot(k_optimal, gamma_optimal, 'r*', markersize=20, 
             label=f'Optimal: k={k_optimal}, γ={gamma_optimal:.3f}')
    
    plt.xlabel("Nombre de clusters (k)", fontsize=12, fontweight='bold')
    plt.ylabel("Score Hubert-Γ", fontsize=12, fontweight='bold')
    plt.title("Validation : Hubert-Gamma en fonction du nombre de clusters", 
             fontsize=14, fontweight='bold')
    plt.grid(True, alpha=0.3)
    plt.legend(fontsize=11)
    plt.xticks(k_values)
    
    # Ajouter une note
    plt.text(0.5, 0.05, 
            "Le pic indique le nombre optimal de clusters",
            ha='center', transform=plt.gca().transAxes,
            fontsize=10, style='italic',
            bbox=dict(boxstyle='round', facecolor='yellow', alpha=0.3))
    
    plt.tight_layout()
    
    if sauvegarder:
        chemin_sortie = os.path.join(DOSSIER_RESULTATS, "validation_hubert_gamma.png")
        plt.savefig(chemin_sortie, dpi=300, bbox_inches='tight')
        print(f"\n✓ Graphique sauvegardé : {chemin_sortie}")
    
    plt.show()

# === FONCTION POUR INTERPRÉTER LES RÉSULTATS ===
def interpreter_scores(resultats):
    """
    Aide à interpréter les scores Hubert-Gamma.
    """
    k_optimal = max(resultats, key=resultats.get)
    gamma_optimal = resultats[k_optimal]
    
    print("\n" + "="*60)
    print("INTERPRÉTATION DES RÉSULTATS")
    print("="*60)
    
    print(f"\nNombre optimal de clusters : {k_optimal}")
    print(f"Score Hubert-Γ : {gamma_optimal:.4f}")
    
    print("\nGrille d'interprétation :")
    print("  γ > 0.70  : Excellent clustering")
    print("  γ = 0.50-0.70 : Bon clustering")
    print("  γ = 0.30-0.50 : Clustering modéré")
    print("  γ < 0.30  : Clustering faible")
    
    if gamma_optimal > 0.70:
        qualite = "EXCELLENT"
    elif gamma_optimal > 0.50:
        qualite = "BON"
    elif gamma_optimal > 0.30:
        qualite = "MODÉRÉ"
    else:
        qualite = "FAIBLE"
    
    print(f"\n→ Qualité du clustering : {qualite}")
    
    # Comparer avec les autres k
    print("\nComparaison avec d'autres nombres de clusters :")
    for k, gamma in sorted(resultats.items()):
        etoiles = "★" * int(gamma * 10)
        print(f"  k={k} : {gamma:.4f} {etoiles}")
    
    print("="*60)

# === PROGRAMME PRINCIPAL ===
if __name__ == "__main__":
    print("="*60)
    print("VALIDATION DU CLUSTERING")
    print("="*60)
    print()
    
    # 1. Charger la matrice
    print("1. Chargement de la matrice de distances...")
    chemin_matrice = os.path.join(DOSSIER_DONNEES, "matrice_distances.csv")
    matrice_D = np.loadtxt(chemin_matrice, delimiter=',')
    print(f"✓ Matrice chargée : {matrice_D.shape}")
    
    # 2. Tester différents nombres de clusters
    print("\n2. Test de différents nombres de clusters...")
    resultats = tester_nombre_clusters(matrice_D, k_min=2, k_max=5)
    
    # 3. Tracer les résultats
    print("\n3. Création du graphique de validation...")
    tracer_scores_validation(resultats)
    
    # 4. Interpréter
    interpreter_scores(resultats)
    
    # 5. Sauvegarder les scores
    chemin_scores = os.path.join(DOSSIER_RESULTATS, "scores_validation.csv")
    with open(chemin_scores, 'w') as f:
        f.write("nombre_clusters,hubert_gamma\n")
        for k, gamma in resultats.items():
            f.write(f"{k},{gamma:.6f}\n")
    print(f"\n✓ Scores sauvegardés : {chemin_scores}")
    
    print()
    print("="*60)
    print("✓ VALIDATION TERMINÉE !")
    print("="*60)
```

---

## 9. ÉTAPE 6 : CALCULER LES SCORES DE CRÉATIVITÉ

### Objectif
Transformer les résultats du clustering en scores de créativité : variabilité et originalité.

### Code : `scripts/06_creativite.py`

```python
"""
Script 6 : Calcul des scores de créativité
=========================================

Ce script calcule les scores de variabilité fonctionnelle
et d'originalité à partir des clusters.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# === CONFIGURATION ===
DOSSIER_DONNEES = "../resultats/analyses"
DOSSIER_RESULTATS = "../resultats/analyses"

# === FONCTION POUR CALCULER LA VARIABILITÉ ===
def calculer_variabilite(labels_participant):
    """
    Calcule le score de variabilité fonctionnelle.
    
    Variabilité = nombre de clusters différents utilisés
    
    Paramètres :
    -----------
    labels_participant : list ou array
        Labels de cluster pour chaque essai du participant
    
    Retourne :
    ----------
    int
        Nombre de clusters distincts
    """
    clusters_uniques = len(np.unique(labels_participant))
    return clusters_uniques

# === FONCTION POUR CALCULER LA PRÉVALENCE ===
def calculer_prevalences(tous_labels):
    """
    Calcule la prévalence de chaque cluster dans la population.
    
    Prévalence = proportion de participants ayant utilisé ce cluster
    
    Paramètres :
    -----------
    tous_labels : dict
        {participant_id: [labels de ses essais]}
    
    Retourne :
    ----------
    dict
        {cluster_id: prévalence}
    """
    # Identifier tous les clusters utilisés
    tous_clusters = set()
    for labels in tous_labels.values():
        tous_clusters.update(labels)
    
    # Calculer combien de participants ont utilisé chaque cluster
    prevalences = {}
    n_participants = len(tous_labels)
    
    for cluster in tous_clusters:
        n_participants_avec_cluster = sum(
            1 for labels in tous_labels.values() if cluster in labels
        )
        prevalence = n_participants_avec_cluster / n_participants
        prevalences[cluster] = prevalence
    
    return prevalences

# === FONCTION POUR CALCULER L'ORIGINALITÉ ===
def calculer_originalite(labels_participant, prevalences):
    """
    Calcule le score d'originalité.
    
    Originalité = somme des 1/prévalence pour chaque cluster utilisé
    
    Paramètres :
    -----------
    labels_participant : list ou array
        Labels de cluster pour le participant
    prevalences : dict
        {cluster_id: prévalence}
    
    Retourne :
    ----------
    float
        Score d'originalité
    """
    clusters_uniques = np.unique(labels_participant)
    
    score_originalite = 0
    for cluster in clusters_uniques:
        if prevalences[cluster] > 0:
            score_originalite += 1 / prevalences[cluster]
    
    return score_originalite

# === FONCTION POUR CALCULER LE SCORE CRÉATIVITÉ TOTAL ===
def calculer_creativite_totale(variabilite, originalite, 
                                poids_var=0.5, poids_orig=0.5):
    """
    Calcule un score de créativité combiné.
    
    Paramètres :
    -----------
    variabilite : int
        Score de variabilité
    originalite : float
        Score d'originalité
    poids_var : float
        Poids de la variabilité (0-1)
    poids_orig : float
        Poids de l'originalité (0-1)
    
    Retourne :
    ----------
    float
        Score de créativité total
    """
    # Normaliser la variabilité (max = 6 clusters possibles)
    variabilite_norm = variabilite / 6
    
    # Normaliser l'originalité (max théorique ≈ 6 si tous clusters rares)
    originalite_norm = originalite / 6
    
    # Combiner
    score = (poids_var * variabilite_norm + poids_orig * originalite_norm)
    
    return score

# === EXEMPLE AVEC DONNÉES SIMULÉES ===
def exemple_calcul_creativite():
    """
    Montre un exemple de calcul avec des données simulées.
    """
    print("="*60)
    print("EXEMPLE DE CALCUL DES SCORES DE CRÉATIVITÉ")
    print("="*60)
    print()
    
    # Simuler 3 participants avec 6 essais chacun
    tous_labels = {
        'P1': [1, 1, 1, 2, 2, 3],  # 3 clusters différents
        'P2': [1, 1, 1, 1, 1, 1],  # 1 seul cluster (peu créatif)
        'P3': [1, 2, 3, 1, 2, 3],  # 3 clusters, répétés
    }
    
    print("Données simulées :")
    for p, labels in tous_labels.items():
        print(f"  {p}: clusters = {labels}")
    print()
    
    # Calculer les prévalences
    print("1. Calcul des prévalences...")
    prevalences = calculer_prevalences(tous_labels)
    print("Prévalences des clusters :")
    for cluster, prev in sorted(prevalences.items()):
        print(f"  Cluster {cluster}: {prev:.2f} ({prev*100:.0f}% des participants)")
    print()
    
    # Calculer les scores pour chaque participant
    print("2. Calcul des scores individuels...")
    print()
    
    resultats = []
    
    for participant, labels in tous_labels.items():
        # Variabilité
        variabilite = calculer_variabilite(labels)
        
        # Originalité
        originalite = calculer_originalite(labels, prevalences)
        
        # Score total
        creativite = calculer_creativite_totale(variabilite, originalite)
        
        resultats.append({
            'participant': participant,
            'variabilite': variabilite,
            'originalite': originalite,
            'creativite_totale': creativite
        })
        
        print(f"{participant}:")
        print(f"  Clusters utilisés: {list(np.unique(labels))}")
        print(f"  Variabilité: {variabilite} clusters distincts")
        print(f"  Originalité: {originalite:.3f}")
        print(f"  Créativité totale: {creativite:.3f}")
        print()
    
    # Créer un DataFrame
    df_resultats = pd.DataFrame(resultats)
    
    # Visualiser
    fig, axes = plt.subplots(1, 3, figsize=(15, 5))
    
    # Variabilité
    axes[0].bar(df_resultats['participant'], df_resultats['variabilite'], 
                color='skyblue')
    axes[0].set_title("Variabilité fonctionnelle", fontweight='bold')
    axes[0].set_ylabel("Nombre de clusters")
    axes[0].set_ylim(0, 6)
    axes[0].grid(axis='y', alpha=0.3)
    
    # Originalité
    axes[1].bar(df_resultats['participant'], df_resultats['originalite'], 
                color='lightcoral')
    axes[1].set_title("Originalité", fontweight='bold')
    axes[1].set_ylabel("Score d'originalité")
    axes[1].grid(axis='y', alpha=0.3)
    
    # Créativité totale
    axes[2].bar(df_resultats['participant'], df_resultats['creativite_totale'], 
                color='lightgreen')
    axes[2].set_title("Créativité totale", fontweight='bold')
    axes[2].set_ylabel("Score de créativité")
    axes[2].set_ylim(0, 1)
    axes[2].grid(axis='y', alpha=0.3)
    
    plt.tight_layout()
    
    chemin_sortie = os.path.join(DOSSIER_RESULTATS, "scores_creativite_exemple.png")
    plt.savefig(chemin_sortie, dpi=300, bbox_inches='tight')
    print(f"✓ Graphique sauvegardé : {chemin_sortie}")
    
    plt.show()
    
    return df_resultats

# === FONCTION POUR VOS DONNÉES RÉELLES ===
def calculer_creativite_vraies_donnees():
    """
    Calcule les scores pour vos 6 trajectoires exemple.
    """
    print("\n" + "="*60)
    print("CALCUL POUR VOS TRAJECTOIRES")
    print("="*60)
    print()
    
    # Charger les assignations de cluster
    chemin_assignations = os.path.join(DOSSIER_DONNEES, "assignations_clusters.csv")
    
    try:
        df_clusters = pd.read_csv(chemin_assignations)
        print(f"✓ Assignations chargées : {len(df_clusters)} trajectoires")
        print()
        print(df_clusters)
        print()
        
        # Simuler que c'est un seul participant avec 6 essais
        labels = df_clusters['cluster'].values
        
        # Pour le calcul de prévalence, on simule 1 participant
        # (dans votre vraie étude, vous aurez plusieurs participants)
        tous_labels = {'Participant_1': labels}
        
        prevalences = calculer_prevalences(tous_labels)
        
        print("Prévalences:")
        for c, p in sorted(prevalences.items()):
            print(f"  Cluster {c}: {p:.2f}")
        print()
        
        variabilite = calculer_variabilite(labels)
        originalite = calculer_originalite(labels, prevalences)
        creativite = calculer_creativite_totale(variabilite, originalite)
        
        print("Scores calculés :")
        print(f"  Variabilité : {variabilite}")
        print(f"  Originalité : {originalite:.3f}")
        print(f"  Créativité totale : {creativite:.3f}")
        
        # Note importante
        print()
        print("NOTE IMPORTANTE :")
        print("Avec un seul participant, tous les clusters ont prévalence = 1.0")
        print("Dans votre vraie étude avec N=28 participants, les prévalences")
        print("varieront et donneront des scores d'originalité significatifs.")
        
    except FileNotFoundError:
        print("✗ Fichier assignations_clusters.csv non trouvé")
        print("  Exécutez d'abord le script 04_clustering.py")

# === PROGRAMME PRINCIPAL ===
if __name__ == "__main__":
    print("="*60)
    print("CALCUL DES SCORES DE CRÉATIVITÉ")
    print("="*60)
    print()
    
    # 1. Exemple avec données simulées
    print("PARTIE 1 : Exemple pédagogique avec 3 participants simulés")
    print()
    df_exemple = exemple_calcul_creativite()
    
    # 2. Calcul sur vos données
    print()
    print("PARTIE 2 : Calcul sur vos 6 trajectoires")
    calculer_creativite_vraies_donnees()
    
    print()
    print("="*60)
    print("✓ CALCULS TERMINÉS !")
    print("="*60)
    print()
    print("RAPPEL DES CONCEPTS :")
    print("- Variabilité : diversité des stratégies (nombre de clusters)")
    print("- Originalité : rareté des stratégies (1/prévalence)")
    print("- Créativité : combinaison des deux")
```

---

## 10. SCRIPT COMPLET AUTOMATISÉ

### Code : `scripts/pipeline_complet.py`

```python
"""
Pipeline complet automatisé
==========================

Ce script exécute toutes les étapes du clustering en une seule fois.
"""

import subprocess
import sys
import os

# === LISTE DES SCRIPTS À EXÉCUTER ===
SCRIPTS = [
    ("01_visualisation.py", "Visualisation des trajectoires"),
    ("02_normalisation.py", "Normalisation temporelle"),
    ("03_distances.py", "Calcul des distances SSPD"),
    ("04_clustering.py", "Clustering hiérarchique"),
    ("05_validation.py", "Validation du clustering"),
    ("06_creativite.py", "Calcul des scores de créativité"),
]

def executer_script(nom_script, description):
    """
    Exécute un script Python et affiche le résultat.
    """
    print()
    print("="*70)
    print(f"ÉTAPE : {description}")
    print(f"Script : {nom_script}")
    print("="*70)
    print()
    
    try:
        # Exécuter le script
        resultat = subprocess.run(
            [sys.executable, nom_script],
            check=True,
            capture_output=False,  # Afficher la sortie en temps réel
            text=True
        )
        
        print()
        print(f"✓ {description} terminée avec succès")
        return True
        
    except subprocess.CalledProcessError as e:
        print()
        print(f"✗ Erreur lors de l'exécution de {nom_script}")
        print(f"  Code d'erreur : {e.returncode}")
        return False
    except FileNotFoundError:
        print()
        print(f"✗ Script {nom_script} introuvable")
        return False

def verifier_structure():
    """
    Vérifie que tous les dossiers nécessaires existent.
    """
    dossiers = [
        "../donnees",
        "../resultats",
        "../resultats/graphiques",
        "../resultats/analyses"
    ]
    
    print("Vérification de la structure des dossiers...")
    tous_ok = True
    
    for dossier in dossiers:
        if os.path.exists(dossier):
            print(f"  ✓ {dossier}")
        else:
            print(f"  ✗ {dossier} manquant")
            tous_ok = False
    
    return tous_ok

def main():
    """
    Fonction principale du pipeline.
    """
    print("="*70)
    print("PIPELINE COMPLET D'ANALYSE DE TRAJECTOIRES D'ESCALADE")
    print("="*70)
    print()
    
    # Vérifier la structure
    if not verifier_structure():
        print()
        print("✗ Structure de dossiers incomplète")
        print("  Créez les dossiers manquants avant de continuer")
        return
    
    print("✓ Structure OK")
    
    # Demander confirmation
    print()
    print("Ce pipeline va exécuter les étapes suivantes :")
    for i, (script, description) in enumerate(SCRIPTS, 1):
        print(f"  {i}. {description}")
    print()
    
    reponse = input("Voulez-vous continuer ? (oui/non) : ").strip().lower()
    
    if reponse not in ['oui', 'o', 'yes', 'y']:
        print("Pipeline annulé")
        return
    
    # Exécuter chaque script
    succes = []
    echecs = []
    
    for script, description in SCRIPTS:
        if executer_script(script, description):
            succes.append(script)
        else:
            echecs.append(script)
            
            # Demander si on continue après une erreur
            print()
            continuer = input("Voulez-vous continuer malgré l'erreur ? (oui/non) : ").strip().lower()
            if continuer not in ['oui', 'o', 'yes', 'y']:
                break
    
    # Résumé final
    print()
    print("="*70)
    print("RÉSUMÉ DU PIPELINE")
    print("="*70)
    print()
    print(f"✓ Étapes réussies : {len(succes)}/{len(SCRIPTS)}")
    for script in succes:
        print(f"  ✓ {script}")
    
    if echecs:
        print()
        print(f"✗ Étapes échouées : {len(echecs)}/{len(SCRIPTS)}")
        for script in echecs:
            print(f"  ✗ {script}")
    else:
        print()
        print("🎉 TOUTES LES ÉTAPES ONT RÉUSSI ! 🎉")
    
    print()
    print("="*70)

if __name__ == "__main__":
    main()
```

### Utilisation du pipeline

```bash
# Aller dans le dossier scripts
cd clustering_escalade/scripts

# Lancer le pipeline complet
python pipeline_complet.py
```

Le pipeline vous demandera confirmation avant de commencer et après chaque erreur.

---

## 11. EXERCICES PRATIQUES

### Exercice 1 : Modifier le seuil de clustering

**Objectif** : Comprendre l'impact du seuil sur le nombre de clusters

1. Ouvrez `04_clustering.py`
2. Changez `SEUIL_CLUSTERING` de 15.0 à 10.0
3. Relancez le script
4. Comptez combien de clusters vous obtenez maintenant
5. Essayez avec 20.0

**Questions** :
- Que se passe-t-il avec un seuil plus bas ?
- Et avec un seuil plus haut ?

### Exercice 2 : Créer votre propre trajectoire

**Objectif** : Apprendre à créer des données

1. Créez un fichier `trajectoire_7.csv`
2. Utilisez ce code pour générer une trajectoire en spirale :

```python
import pandas as pd
import numpy as np

t = np.arange(100)
angle = np.linspace(0, 4*np.pi, 100)
rayon = np.linspace(0.5, 1.5, 100)

x = 1.25 + rayon * np.cos(angle)
y = rayon * 2 * np.sin(angle) + 2

df = pd.DataFrame({'t': t, 'x': x, 'y': y})
df.to_csv("donnees/trajectoire_7.csv", index=False)
```

3. Modifiez les scripts pour inclure la trajectoire 7
4. Relancez le clustering

**Question** : Dans quel cluster se retrouve votre trajectoire ?

### Exercice 3 : Analyser l'effet de la normalisation

**Objectif** : Voir l'importance de la normalisation

1. Créez une copie de `02_normalisation.py` → `02_bis.py`
2. Changez `N_POINTS_CIBLE` à 50 au lieu de 100
3. Relancez toute l'analyse avec ces nouvelles données
4. Comparez les résultats

**Question** : Les clusters sont-ils identiques ?

---

## 12. FAQ ET RÉSOLUTION DE PROBLÈMES

### Problème : "ModuleNotFoundError: No module named 'trajectory_distance'"

**Solution** :
```bash
pip install git+https://github.com/bguillouet/traj-dist.git

# Si ça ne marche pas, essayez :
pip3 install git+https://github.com/bguillouet/traj-dist.git

# Ou avec Python directement :
python -m pip install git+https://github.com/bguillouet/traj-dist.git
```

### Problème : "FileNotFoundError" lors de l'exécution des scripts

**Cause** : Vous n'êtes pas dans le bon dossier

**Solution** :
```bash
# Vérifiez où vous êtes
pwd  # Linux/Mac
cd  # Windows

# Allez dans le dossier scripts
cd chemin/vers/clustering_escalade/scripts
```

### Problème : Les graphiques ne s'affichent pas

**Solution** :
```python
# Ajoutez cette ligne au début du script
import matplotlib
matplotlib.use('TkAgg')  # ou 'Qt5Agg'
import matplotlib.pyplot as plt
```

### Problème : "Permission denied" lors de l'installation

**Solution Linux/Mac** :
```bash
pip install --user nom_du_package
```

**Solution Windows** :
- Lancez l'invite de commandes en tant qu'administrateur

### Problème : Les distances sont toutes identiques

**Cause** : Les trajectoires ne sont peut-être pas normalisées correctement

**Vérification** :
```python
import pandas as pd

# Charger une trajectoire
traj = pd.read_csv("resultats/analyses/trajectoire_1_normalisee.csv")

# Vérifier la longueur
print(f"Longueur : {len(traj)}")  # Doit être 100

# Vérifier les valeurs
print(traj.head())
print(traj.tail())
```

### Problème : Le script est trop lent

**Solution** :
- Réduisez le nombre de bootstraps dans la validation (si vous l'implémentez)
- Travaillez avec moins de trajectoires pour débuter
- Vérifiez que vous n'avez pas de boucles infinies

### Aide supplémentaire

Si vous êtes bloqué :

1. **Lisez les messages d'erreur** : Ils vous disent souvent exactement quel est le problème
2. **Vérifiez les fichiers** : Est-ce que tous les CSV sont dans le bon dossier ?
3. **Testez étape par étape** : N'exécutez pas tout d'un coup, allez-y script par script
4. **Utilisez print()** : Ajoutez des `print()` dans le code pour voir où ça bloque

---

## CONCLUSION

Vous avez maintenant un pipeline complet pour analyser des trajectoires d'escalade !

**Ce que vous savez faire** :
1. ✅ Charger et visualiser des trajectoires
2. ✅ Normaliser temporellement
3. ✅ Calculer des distances SSPD
4. ✅ Faire du clustering hiérarchique
5. ✅ Valider les résultats
6. ✅ Calculer des scores de créativité

**Prochaines étapes pour votre recherche** :
- Appliquer ce pipeline à vos vraies données Kinovea
- Comparer pré-fatigue vs post-fatigue
- Analyser les différences entre participants
- Intégrer les mesures psychologiques (QORS)

**Ressources complémentaires** :
- Documentation scipy.cluster : https://docs.scipy.org/doc/scipy/reference/cluster.hierarchy.html
- Tutorial Python pour débutants : https://docs.python.org/fr/3/tutorial/
- Forum Stack Overflow pour questions spécifiques

Bon courage avec votre Master 2 ! 🎓
