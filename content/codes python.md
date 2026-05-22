# Guide rapide des 5 scripts de clustering

L'architecture proposée vise à identifier des patterns de mouvement distincts par clustering hiérarchique, puis à opérationnaliser la créativité motrice comme la combinaison de variabilité fonctionnelle et d'originalité.

## 01_preparation.py

**Objectif** : Préparer les données brutes pour analyse

- Charge 20 trajectoires CSV (t, x, y)
- Visualise trajectoires par condition (pré/post séparés)
- Normalise à 100 points (interpolation + lissage)
- Calcule variabilité amplitude X pré/post
- Test t apparié pour effet fatigue
- Graphique avant/après normalisation

**Sorties** : `graphiques/visualisation_*.png`, `analyses/donnees_normalisees.pkl`

---

## 02_clustering_complet.py

**Objectif** : Calculer distances et clusteriser

- Matrice distances SSPD 20×20
- Clustering hiérarchique Ward
- Dendrogramme avec seuil
- Extraction clusters k=2 à k=6
- Visualisation spatiale par cluster
- Répartition pré/post dans chaque cluster

**Sorties** : `graphiques/dendrogramme.png`, `graphiques/clusters_k*.png`, `analyses/resultats_clustering.pkl`

---

## 03_validation_robuste.py

**Objectif** : Valider qualité clustering

- **Hubert-Gamma** : corrélation distances/co-appartenance (k=2→8)
- **Calinski-Harabasz** : variance inter/intra-clusters
- **Bootstrapping** : stabilité par retrait participants
- Graphiques comparatifs 3 métriques
- Rapport convergence → k optimal

**Sorties** : `graphiques/validation_*.png`, `analyses/rapport_validation.txt`

---

## 04_caracterisation_clusters.py

**Objectif** : Analyser profils cinématiques et créativité

**Cinématique** :

- Vitesses (vx, vy, magnitude)
- Accélérations, amplitudes, sinuosité
- ANOVA inter-clusters
- Radar profils moyens

**Créativité** :

- Variabilité fonctionnelle (nb clusters utilisés)
- Originalité (rareté clusters)
- Test t pré/post

**Sorties** : `graphiques/cinematique_*.png`, `graphiques/creativite_*.png`, `analyses/statistiques_*.txt`

---

## 05_pipeline.py

**Objectif** : Exécuter tout le pipeline automatiquement

- Lance scripts 01→04 séquentiellement
- Vérifie structure dossiers
- Gestion erreurs (continue si échec)
- Rapport synthétique succès/échecs

**Usage** : `python 05_pipeline.py` depuis `clustering_escalade/`