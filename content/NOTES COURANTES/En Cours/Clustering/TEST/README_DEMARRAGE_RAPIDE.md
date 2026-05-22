# 🚀 DÉMARRAGE RAPIDE - Clustering de Trajectoires

## Installation en 5 minutes

### Étape 1 : Installer Python (si nécessaire)

**Télécharger Python** : https://www.python.org/downloads/
- ⚠️ Cochez "Add Python to PATH" pendant l'installation

### Étape 2 : Créer la structure de dossiers

```bash
# Sur Windows (PowerShell) :
mkdir clustering_escalade
cd clustering_escalade
mkdir donnees, scripts, resultats
cd resultats
mkdir graphiques, analyses

# Sur Mac/Linux (Terminal) :
mkdir -p clustering_escalade/{donnees,scripts,resultats/{graphiques,analyses}}
cd clustering_escalade
```

### Étape 3 : Copier les fichiers

1. Placez les **6 fichiers trajectoire_X.csv** dans le dossier `donnees/`
2. Placez tous les **scripts Python** dans le dossier `scripts/`

### Étape 4 : Installer les bibliothèques

```bash
# Ouvrez un terminal/invite de commandes
cd clustering_escalade

# Exécutez ces commandes UNE PAR UNE :
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install seaborn
pip install git+https://github.com/bguillouet/traj-dist.git
```

**Si vous avez des erreurs**, essayez avec `pip3` au lieu de `pip`.

### Étape 5 : Lancer l'analyse

```bash
cd scripts
python 01_visualisation.py
```

Si ça fonctionne, vous verrez des graphiques et des messages de succès !

## 🎯 Lancer le pipeline complet

```bash
cd scripts
python pipeline_complet.py
```

Le pipeline exécutera automatiquement toutes les étapes.

## 📁 Structure finale

```
clustering_escalade/
├── donnees/
│   ├── trajectoire_1.csv
│   ├── trajectoire_2.csv
│   ├── trajectoire_3.csv
│   ├── trajectoire_4.csv
│   ├── trajectoire_5.csv
│   └── trajectoire_6.csv
├── scripts/
│   ├── 01_visualisation.py
│   ├── 02_normalisation.py
│   ├── 03_distances.py
│   ├── 04_clustering.py
│   ├── 05_validation.py
│   ├── 06_creativite.py
│   └── pipeline_complet.py
└── resultats/
    ├── graphiques/
    └── analyses/
```

## ❓ Problèmes courants

### "pip n'est pas reconnu"
→ Vous n'avez pas coché "Add Python to PATH" lors de l'installation
→ Réinstallez Python en cochant cette option

### "ModuleNotFoundError"
→ Une bibliothèque n'est pas installée
→ Relancez : `pip install nom_du_module`

### "FileNotFoundError"
→ Vous n'êtes pas dans le bon dossier
→ Utilisez `cd` pour aller dans `clustering_escalade/scripts`

## 📖 Documentation complète

Consultez **GUIDE_PRATIQUE_CLUSTERING_DEBUTANTS.md** pour :
- Explications détaillées de chaque étape
- Code commenté ligne par ligne
- Exercices pratiques
- FAQ complète

## ✅ Checklist de vérification

Avant de commencer, vérifiez :
- [ ] Python installé (version 3.8+)
- [ ] Structure de dossiers créée
- [ ] 6 fichiers CSV dans `donnees/`
- [ ] 7 scripts Python dans `scripts/`
- [ ] Bibliothèques installées

**Tout est OK ?** Lancez `python 01_visualisation.py` ! 🎉
