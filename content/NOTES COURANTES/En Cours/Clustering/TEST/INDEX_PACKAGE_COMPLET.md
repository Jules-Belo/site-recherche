# 📦 PACKAGE COMPLET : Analyse de Trajectoires d'Escalade par Clustering

## 📚 CONTENU DU PACKAGE

### 1. Documentation

#### A. Guide de démarrage rapide
- **Fichier** : `README_DEMARRAGE_RAPIDE.md`
- **Pour qui** : Utilisateurs pressés qui veulent commencer immédiatement
- **Contenu** : Installation en 5 minutes, commandes essentielles, troubleshooting

#### B. Guide pratique complet
- **Fichier** : `GUIDE_PRATIQUE_CLUSTERING_DEBUTANTS.md`
- **Pour qui** : Étudiants et chercheurs débutants en programmation
- **Contenu** : 
  - Installation détaillée (Windows/Mac/Linux)
  - 12 sections pédagogiques complètes
  - Code Python commenté ligne par ligne
  - Explications théoriques accessibles
  - Exercices pratiques guidés
  - FAQ et résolution de problèmes

### 2. Données d'exemple

6 fichiers CSV de trajectoires d'escalade simulées (100 points chacune) :

- `trajectoire_1.csv` - Montée verticale directe (stratégie basique)
- `trajectoire_2.csv` - Dévers à gauche (alternative technique)
- `trajectoire_3.csv` - Zigzag créatif (exploration large)
- `trajectoire_4.csv` - Arc de cercle droit (approche latérale)
- `trajectoire_5.csv` - Similaire à trajectoire 1 (même cluster attendu)
- `trajectoire_6.csv` - Similaire à trajectoire 2 (même cluster attendu)

**Format** : Chaque fichier contient 3 colonnes (t, x, y)
- t : temps normalisé (0-99)
- x : position horizontale en mètres (0-2.5m)
- y : position verticale en mètres (0-4m)

**Résultat attendu du clustering** : 3 clusters distincts
- Cluster A : T1 + T5 (montées verticales)
- Cluster B : T2 + T6 (dévers gauche)
- Cluster C : T3 + T4 (stratégies créatives)

### 3. Scripts Python (7 scripts)

#### Scripts individuels (à exécuter dans l'ordre)

1. **01_visualisation.py**
   - Charge et affiche les trajectoires
   - Crée des graphiques individuels et collectifs
   - Vérifie la qualité des données

2. **02_normalisation.py**
   - Normalise toutes les trajectoires à 100 points
   - Utilise l'interpolation linéaire
   - Compare avant/après visuellement
   - Sauvegarde les versions normalisées

3. **03_distances.py**
   - Calcule la matrice de distances SSPD
   - Crée une heatmap de visualisation
   - Affiche des statistiques descriptives
   - Identifie les paires similaires/différentes

4. **04_clustering.py**
   - Effectue le clustering hiérarchique (Ward)
   - Génère le dendrogramme
   - Extrait les assignations de cluster
   - Visualise les trajectoires par cluster

5. **05_validation.py**
   - Calcule le score Hubert-Gamma
   - Teste différents nombres de clusters
   - Identifie le nombre optimal
   - Graphique de validation

6. **06_creativite.py**
   - Calcule la variabilité fonctionnelle
   - Calcule l'originalité
   - Calcule le score de créativité total
   - Exemple pédagogique avec 3 participants

#### Script automatisé

7. **pipeline_complet.py**
   - Exécute tous les scripts automatiquement
   - Vérifie la structure des dossiers
   - Gère les erreurs et propose de continuer
   - Affiche un résumé final

## 🎯 UTILISATION RECOMMANDÉE

### Pour débuter (première fois)
1. Lire `README_DEMARRAGE_RAPIDE.md`
2. Installer Python et les bibliothèques
3. Créer la structure de dossiers
4. Copier les fichiers
5. Exécuter `01_visualisation.py` pour tester

### Pour apprendre (formation)
1. Ouvrir `GUIDE_PRATIQUE_CLUSTERING_DEBUTANTS.md`
2. Suivre les explications section par section
3. Exécuter chaque script individuellement
4. Lire et comprendre le code
5. Faire les exercices pratiques

### Pour analyser vos données
1. Remplacer les CSV d'exemple par vos données Kinovea
2. Vérifier le format (colonnes t, x, y)
3. Ajuster les paramètres si nécessaire
4. Lancer `pipeline_complet.py`

## 📋 CHECKLIST PRÉ-UTILISATION

- [ ] Python 3.8+ installé
- [ ] Bibliothèques installées (numpy, scipy, matplotlib, pandas, seaborn, trajectory_distance)
- [ ] Structure de dossiers créée
- [ ] 6 fichiers CSV dans `donnees/`
- [ ] 7 scripts Python dans `scripts/`
- [ ] Environnement virtuel activé (recommandé)

## 🔧 PERSONNALISATION

### Paramètres modifiables

**02_normalisation.py**
```python
N_POINTS_CIBLE = 100  # Nombre de points après normalisation
```

**04_clustering.py**
```python
SEUIL_CLUSTERING = 15.0  # Distance de coupe du dendrogramme
```

**06_creativite.py**
```python
poids_var = 0.5   # Poids de la variabilité
poids_orig = 0.5  # Poids de l'originalité
```

### Adaptation à vos données

Si vos trajectoires ont des caractéristiques différentes :
- Ajustez les limites des axes dans les graphiques
- Modifiez les couleurs et styles de tracé
- Adaptez le seuil de clustering selon votre dendrogramme

## 📊 OUTPUTS GÉNÉRÉS

### Dans `resultats/graphiques/`
- `toutes_trajectoires.png` - Vue d'ensemble
- `trajectoire_X_detail.png` - Graphiques individuels (×6)
- `comparaison_norm_X.png` - Avant/après normalisation (×6)
- `trajectoires_par_cluster.png` - Trajectoires colorées par cluster

### Dans `resultats/analyses/`
- `trajectoire_X_normalisee.csv` - Données normalisées (×6)
- `matrice_distances.csv` - Matrice de distances SSPD
- `matrice_distances.png` - Heatmap de la matrice
- `dendrogramme.png` - Arbre hiérarchique
- `assignations_clusters.csv` - Qui est dans quel cluster
- `validation_hubert_gamma.png` - Courbe de validation
- `scores_validation.csv` - Scores pour différents k
- `scores_creativite_exemple.png` - Graphiques de créativité

## 🎓 CONCEPTS ABORDÉS

### Mathématiques et statistiques
- Interpolation linéaire
- Distance SSPD (Symmetrized Segment-Path Distance)
- Clustering hiérarchique (méthode de Ward)
- Coefficient de corrélation (Hubert-Gamma)

### Programmation Python
- Manipulation de fichiers CSV avec pandas
- Calculs numériques avec numpy
- Visualisations avec matplotlib/seaborn
- Analyse scientifique avec scipy
- Organisation de code en modules

### Sciences du sport
- Biomécanique de l'escalade
- Variabilité fonctionnelle
- Originalité et créativité motrice
- Analyse de trajectoires

## 📖 RÉFÉRENCES INTÉGRÉES

Les scripts s'appuient sur :
- Besse et al. (2016) - Distance SSPD
- Rein et al. (2010) - Clustering en sciences du mouvement
- Higgins (1997) - Théorie de l'orientation régulatrice
- Van Bergen et al. (2025) - Application à l'escalade

## 💡 CONSEILS D'UTILISATION

### Pour les débutants en programmation
1. Ne vous découragez pas face aux erreurs
2. Lisez les messages d'erreur attentivement
3. Testez les scripts un par un
4. Utilisez print() pour comprendre ce qui se passe
5. Consultez la FAQ en cas de blocage

### Pour les chercheurs expérimentés
1. Le code est volontairement verbeux pour la pédagogie
2. Vous pouvez optimiser les boucles avec numpy vectorization
3. La validation AU test n'est pas implémentée (nécessite R)
4. Adaptez les paramètres selon votre protocole

## ⚠️ LIMITATIONS

- Les trajectoires d'exemple sont simulées (pas de vraies données Kinovea)
- La validation est limitée à Hubert-Gamma (AU test nécessite R)
- Tracking 2D uniquement (pas de profondeur 3D)
- Petit échantillon (6 trajectoires) pour l'exemple
- Normalisation temporelle basique (interpolation linéaire)

## 🚀 PROCHAINES ÉTAPES

Après avoir maîtrisé ce package :
1. Appliquer à vos vraies données d'escalade
2. Comparer conditions pré/post-fatigue
3. Intégrer les données psychologiques (QORS)
4. Analyser les interactions participants × conditions
5. Tests statistiques (ANOVA mixte)

## 📞 SUPPORT

En cas de problème :
1. Consultez la section FAQ du guide complet
2. Vérifiez les messages d'erreur
3. Assurez-vous que tous les fichiers sont au bon endroit
4. Vérifiez les versions des bibliothèques

Bon courage avec votre Master 2 ! 🎓🧗‍♀️
