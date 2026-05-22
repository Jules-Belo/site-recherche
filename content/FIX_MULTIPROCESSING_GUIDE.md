# FIX ERREUR MULTIPROCESSING - GUIDE DE RESTRUCTURATION

## 🔴 PROBLÈME IDENTIFIÉ

```
RuntimeError: An attempt has been made to start a new process before the
current process has finished its bootstrapping phase.
```

**Cause** : Sur macOS (et Windows), Python `multiprocessing` exige que le code d'exécution principal soit protégé par `if __name__ == '__main__':` pour éviter la réimportation infinie lors de la création de processus enfants.

---

## ✅ SOLUTION : Restructuration du fichier

### ÉTAPE 1 : Identifier les sections de ton code

Ton fichier `clustering_hierarchique.py` a cette structure actuelle :

```
┌─────────────────────────────────────────────────────┐
│ IMPORTS                                             │
│ import os, pandas, numpy, scipy, ...               │
├─────────────────────────────────────────────────────┤
│ CONFIGURATION GLOBALE                               │
│ DOSSIER_DONNEES = "..."                            │
│ N_POINTS = 200                                      │
├─────────────────────────────────────────────────────┤
│ MODULE 1 : FONCTIONS DE NORMALISATION              │
│ def charger_trajectoire(...)                       │
│ def normaliser_trajectoire(...)                    │
├─────────────────────────────────────────────────────┤
│ MODULE 2 : [Anciennes fonctions SSPD commentées]   │
├─────────────────────────────────────────────────────┤
│ MODULE 3 : FONCTIONS CLUSTERING                    │
│ def determiner_seuil_manuel(...)                   │
├─────────────────────────────────────────────────────┤
│ MODULE 4 : FONCTIONS VALIDATION                    │
│ def calculer_hubert_gamma(...)                     │
├─────────────────────────────────────────────────────┤
│ MODULE 5A/5B/5C : FONCTIONS VISUALISATION          │
│ def visualiser_lissage(...)                        │
│ def tracer_dendrogramme(...)                       │
│ [etc...]                                           │
├─────────────────────────────────────────────────────┤
│ MODULE 6 : FONCTIONS ANALYSES POST-CLUSTERING      │
│ def calculer_variabilite_participants(...)         │
│ [etc...]                                           │
├─────────────────────────────────────────────────────┤
│ 🔴 SECTION PROBLÉMATIQUE (CODE D'EXÉCUTION)        │
│ #%% ÉTAPE 1 : NORMALISATION                        │
│ print("ÉTAPE 1...")                                │
│ for fichier in fichiers:                           │
│     ...                                            │
│                                                    │
│ #%% ÉTAPE 2 : CALCUL SSPD                          │
│ D, temps = calculer_matrice_distances_sspd(...)    │ ← LIGNE 872 (erreur ici)
│                                                    │
│ #%% ÉTAPE 3, 4, 5...                               │
│ [reste du pipeline]                                │
└─────────────────────────────────────────────────────┘
```

### ÉTAPE 2 : Repérer où commence le code d'exécution

**Ligne de démarcation** : La première ligne qui **EXÉCUTE** du code (pas une définition).

Dans ton cas, c'est probablement quelque chose comme :

```python
#%% ÉTAPE 1 : NORMALISATION

print(f"\n{'='*60}")  # ← ICI commence le code d'exécution
print("ÉTAPE 1 : NORMALISATION DES TRAJECTOIRES")
```

**Cette ligne et TOUT ce qui suit doit être indenté sous `if __name__ == '__main__':`**

### ÉTAPE 3 : Appliquer la modification

#### A. Localiser la ligne de démarcation

Ouvre `clustering_hierarchique.py` et cherche cette ligne (probablement vers ligne 720-750) :

```python
#%% ÉTAPE 1 : NORMALISATION

print(f"\n{'='*60}")
```

#### B. Ajouter le bloc de protection JUSTE AVANT

**AVANT** cette ligne, ajoute :

```python
# ============================================================================
# BLOC PRINCIPAL D'EXÉCUTION
# ============================================================================
# Protection obligatoire pour multiprocessing sur macOS/Windows
# Tout le code d'exécution (ÉTAPES 1-5) doit être dans ce bloc

if __name__ == '__main__':
```

#### C. Indenter TOUT le code qui suit

Sélectionne **TOUT le code d'exécution** (de `print(f"\n{'='*60}")` jusqu'à la dernière ligne du fichier).

**Indenter de 4 espaces** (ou 1 tab selon ta config).

**Résultat attendu** :

```python
# [... imports, configuration, toutes les fonctions ...]

# ============================================================================
# BLOC PRINCIPAL D'EXÉCUTION
# ============================================================================

if __name__ == '__main__':
    
    #%% ÉTAPE 1 : NORMALISATION
    
    print(f"\n{'='*60}")
    print("ÉTAPE 1 : NORMALISATION DES TRAJECTOIRES")
    print(f"{'='*60}\n")
    
    # Lister tous les fichiers CSV du dossier données
    fichiers = sorted([f for f in os.listdir(DOSSIER_DONNEES) 
                       if f.endswith('.csv') and not f.startswith('.')])
    
    print(f"Fichiers trouvés : {len(fichiers)}\n")
    
    # ... [reste de l'ÉTAPE 1]
    
    #%% ÉTAPE 2 : CALCUL MATRICE SSPD
    
    print(f"\n{'='*60}")
    print("ÉTAPE 2 : CALCUL MATRICE DISTANCES SSPD (VERSION OPTIMISÉE)")
    print(f"{'='*60}\n")
    
    # ... [reste de l'ÉTAPE 2 avec parallele=True]
    
    #%% ÉTAPE 3 : CLUSTERING WARD
    
    # ... [ÉTAPE 3]
    
    #%% ÉTAPE 4 : VALIDATION
    
    # ... [ÉTAPE 4]
    
    #%% ÉTAPE 5 : ANALYSES POST-CLUSTERING
    
    # ... [ÉTAPE 5]
    
    # RAPPORT FINAL
    print("✅ PIPELINE TERMINÉ")
```

---

## 🔧 MÉTHODE RAPIDE (avec éditeur de texte)

### Sur VSCode / PyCharm / Sublime Text

1. **Ouvrir** `clustering_hierarchique.py`

2. **Chercher** la première ligne d'exécution (probablement `#%% ÉTAPE 1 : NORMALISATION`)

3. **Avant cette ligne**, ajouter :
   ```python
   if __name__ == '__main__':
   ```

4. **Sélectionner** tout le code d'exécution (de cette ligne jusqu'à la fin du fichier)

5. **Indenter** la sélection :
   - **VSCode** : `Tab` ou `Cmd/Ctrl + ]`
   - **PyCharm** : `Tab`
   - **Sublime** : `Tab`

6. **Sauvegarder** le fichier

7. **Réexécuter** le script → L'erreur devrait disparaître

---

## ✅ VÉRIFICATION POST-MODIFICATION

Après modification, ton fichier doit ressembler à ça (structure schématique) :

```python
"""
CLUSTERING - CRÉATIVITÉ EN ESCALADE
Version 4.0
"""

import os
import pandas as pd
# ... [tous les imports]

# CONFIGURATION GLOBALE
DOSSIER_DONNEES = "/Users/julesbelo/..."
N_POINTS = 200
# ... [configuration]

from sspd_optimized_module import calculer_matrice_distances_sspd

#%% MODULE 1 : FONCTIONS DE CHARGEMENT
def charger_trajectoire(chemin_fichier):
    # ...

def normaliser_trajectoire(t, x, y):
    # ...

#%% MODULE 3 : CLUSTERING HIERARCHIQUE
def determiner_seuil_manuel(Z, noms):
    # ...

# [... TOUTES les définitions de fonctions ...]

# ============================================================================
# BLOC PRINCIPAL D'EXÉCUTION
# ============================================================================

if __name__ == '__main__':       # ← LIGNE AJOUTÉE
    
    #%% ÉTAPE 1 : NORMALISATION       # ← TOUT INDENTÉ DE 4 ESPACES
    
    print(f"\n{'='*60}")
    print("ÉTAPE 1 : NORMALISATION DES TRAJECTOIRES")
    print(f"{'='*60}\n")
    
    # [... code ÉTAPE 1 ...]
    
    #%% ÉTAPE 2 : CALCUL MATRICE SSPD
    
    # [... code ÉTAPE 2 ...]
    
    D, temps_calcul = calculer_matrice_distances_sspd(
        trajectoires, 
        parallele=True,      # ← Maintenant ça fonctionnera !
        n_jobs=None,
        verbose=True
    )
    
    # [... ÉTAPES 3, 4, 5 ...]
```

**Points de contrôle** :

✅ Ligne `if __name__ == '__main__':` présente AVANT le code d'exécution
✅ Tout le code d'exécution (ÉTAPES 1-5) indenté de 4 espaces
✅ Les définitions de fonctions (MODULE 1-6) restent NON indentées
✅ Les imports et configuration restent NON indentés

---

## 🐛 DÉPANNAGE

### Erreur persiste après modification ?

**Vérification 1** : Indentation correcte

```python
# ✅ CORRECT
if __name__ == '__main__':
    print("ÉTAPE 1")  # ← 4 espaces d'indentation
    
# ❌ INCORRECT
if __name__ == '__main__':
print("ÉTAPE 1")  # ← Pas d'indentation → SyntaxError
```

**Vérification 2** : Ligne `if __name__ == '__main__':` bien placée

```python
# ✅ CORRECT : APRÈS toutes les définitions
def ma_fonction():
    pass

if __name__ == '__main__':
    ma_fonction()

# ❌ INCORRECT : AVANT les définitions
if __name__ == '__main__':
    ma_fonction()  # ← NameError: ma_fonction not defined

def ma_fonction():
    pass
```

### Autre problème : `IndentationError`

**Cause** : Mélange de tabs et espaces.

**Solution** : Dans ton éditeur, convertir toutes les tabs en espaces :
- **VSCode** : `Cmd/Ctrl + Shift + P` → "Convert Indentation to Spaces"
- **PyCharm** : Settings → Editor → Code Style → Python → "Use tab character" décoché

---

## 📊 COMPARAISON AVANT/APRÈS

### AVANT (provoque l'erreur)

```python
# [imports]
# [configuration]
# [fonctions]

#%% ÉTAPE 1
print("ÉTAPE 1")  # ← Exécuté directement au lancement
for fichier in fichiers:
    # ...

#%% ÉTAPE 2
D, temps = calculer_matrice_distances_sspd(
    trajectoires, 
    parallele=True  # ← CRASH ici
)
```

**Comportement** :
1. Script lance → Exécute ÉTAPE 1
2. ÉTAPE 2 crée processus enfants
3. Chaque processus enfant réimporte le script
4. → Réexécute ÉTAPE 1 dans chaque processus
5. → Crée encore plus de processus
6. → Boucle infinie → RuntimeError

### APRÈS (fonctionne)

```python
# [imports]
# [configuration]
# [fonctions]

if __name__ == '__main__':  # ← Protection ajoutée
    
    #%% ÉTAPE 1
    print("ÉTAPE 1")
    for fichier in fichiers:
        # ...
    
    #%% ÉTAPE 2
    D, temps = calculer_matrice_distances_sspd(
        trajectoires, 
        parallele=True  # ← Fonctionne maintenant
    )
```

**Comportement** :
1. Script lance → Entre dans `if __name__ == '__main__':`
2. ÉTAPE 2 crée processus enfants
3. Chaque processus enfant réimporte le script
4. → MAIS `__name__` vaut `'__mp_main__'` dans les enfants
5. → Ne rentre PAS dans le `if` → N'exécute pas le code
6. → Pas de boucle infinie → Tout fonctionne ✅

---

## 🎯 EN RÉSUMÉ

**Pour faire fonctionner ton code MAINTENANT** :

**Solution rapide** : Passer `parallele=False` à la ligne 872

**Solution définitive** : Ajouter `if __name__ == '__main__':` avant le code d'exécution et indenter

**Fichier modèle** : Je te prépare une version corrigée ci-dessous ↓

---

## 📎 TEMPLATE CORRIGÉ

Voici le template exact de la fin de ton fichier (après toutes les fonctions) :

```python
# ============================================================================
# TOUTES LES FONCTIONS DÉFINIES CI-DESSUS
# ============================================================================

# ============================================================================
# BLOC PRINCIPAL D'EXÉCUTION
# Protection obligatoire pour multiprocessing sur macOS/Windows
# ============================================================================

if __name__ == '__main__':
    
    #%% ÉTAPE 1 : NORMALISATION
    
    print(f"\n{'='*60}")
    print("ÉTAPE 1 : NORMALISATION DES TRAJECTOIRES")
    print(f"{'='*60}\n")
    
    # Lister tous les fichiers CSV du dossier données
    fichiers = sorted([f for f in os.listdir(DOSSIER_DONNEES) 
                       if f.endswith('.csv') and not f.startswith('.')])
    
    print(f"Fichiers trouvés : {len(fichiers)}\n")
    
    # Stockage pour visualisations
    trajectoires_brutes = []
    trajectoires_norm = []
    noms_traj = []
    
    # Boucle de normalisation
    for i, fichier in enumerate(fichiers, 1):
        chemin = os.path.join(DOSSIER_DONNEES, fichier)
        
        # Charger la trajectoire brute
        t, x, y, nom = charger_trajectoire(chemin)
        
        # Stocker pour visualisation comparée
        trajectoires_brutes.append((x, y))
        
        # Normaliser (interpolation + lissage)
        t_norm, x_norm, y_norm = normaliser_trajectoire(t, x, y)
        
        # Sauvegarder trajectoire normalisée
        df_norm = pd.DataFrame({'t': t_norm, 'x': x_norm, 'y': y_norm})
        chemin_sortie = os.path.join(DOSSIER_NORMALISES, f"{nom}_norm.csv")
        df_norm.to_csv(chemin_sortie, index=False)
        
        # Stocker pour clustering ultérieur
        trajectoires_norm.append((x_norm, y_norm))
        noms_traj.append(nom)
        
        # Visualiser l'effet du lissage sur la première trajectoire (exemple)
        if i == 1:
            visualiser_lissage(t, x, y, t_norm, x_norm, y_norm, nom)
        
        print(f"[{i:2d}/{len(fichiers)}] {nom:30s} | {len(t):3d}→{N_POINTS} pts | ✓")
    
    # Générer visualisations comparatives
    visualiser_toutes_trajectoires(trajectoires_brutes, noms_traj, 
                                   "Trajectoires brutes (avant normalisation)",
                                   "00bis_trajectoires_brutes.png", normalise=False)
    
    visualiser_toutes_trajectoires(trajectoires_norm, noms_traj,
                                   "Trajectoires normalisées (après lissage)",
                                   "00bis_trajectoires_normalisees.png", normalise=True)
    
    #%% ÉTAPE 2 : CALCUL MATRICE SSPD (VERSION OPTIMISÉE)
    
    print(f"\n{'='*60}")
    print("ÉTAPE 2 : CALCUL MATRICE DISTANCES SSPD (VERSION OPTIMISÉE)")
    print(f"{'='*60}\n")
    
    # Charger toutes les trajectoires normalisées
    fichiers_norm = sorted([f for f in os.listdir(DOSSIER_NORMALISES) 
                            if f.endswith('_norm.csv')])
    n_traj = len(fichiers_norm)
    
    trajectoires = []
    noms = []
    
    print("Chargement des trajectoires normalisées...\n")
    for fichier in fichiers_norm:
        chemin = os.path.join(DOSSIER_NORMALISES, fichier)
        df = pd.read_csv(chemin)
        
        # Convertir en array (n_points, 2) avec colonnes [x, y]
        traj = df[['x', 'y']].values
        trajectoires.append(traj)
        
        # Extraire nom sans suffixe '_norm.csv'
        nom = fichier.replace('_norm.csv', '')
        noms.append(nom)
        
        print(f"  ✓ {nom} : shape {traj.shape}")
    
    # CALCUL DE LA MATRICE AVEC OPTIMISATIONS
    D, temps_calcul = calculer_matrice_distances_sspd(
        trajectoires, 
        parallele=True,      # ← Maintenant fonctionnel !
        n_jobs=None,
        verbose=True
    )
    
    # SAUVEGARDE
    np.savetxt(os.path.join(DOSSIER_ANALYSES, "matrice_distances.csv"), D, delimiter=',')
    
    # [... continue avec ÉTAPES 3, 4, 5 indentées de la même manière ...]
```

**Télécharge ce template et adapte-le à ton code !**
