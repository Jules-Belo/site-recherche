
>*Voici un résumé de l'analyse complète réalisée sur un petit jeu de donnée.*

### Extraction de trajectoires : 
- Analyse réalisées sur le logiciel [Tracker](https://opensourcephysics.github.io/tracker-website/) (introduction à Tracker --> [Lien](https://pcjoffre.fr/Data/divers/utilisation_tracker.pdf))
- Effectuée en semi-automatique, avec manipulation manuelle lors de dérives
	- Exemple : ![[📸Test_lb.png|600]]
- Les données brutes ont été extraites et sauvegardées sur des fichiers .csv séparés
- Le logiciel s'est révélé efficace lors du suivi automatique avec 30% d'évolution entre chaque point
	- Cependant lorsque la led était face à la caméra, un halo lumineux bloquait le suivi automatique et entrainait une dérive.

### DATA : 
- 6 trajectoires distinctes (patterns de mouvements différents pour 4/6 d'entres elles)
- Débutent à des coordonnées différentes
- Pas de même longueurs (± 500-1200 points)
- Fichiers CSV séparés pour chaque essais avec 3 colonnes (t,x,y)
- Filmées avec un Iphone 15 (4k, 60fps)
---
### Analyses des trajectoires

L'analyse a suivi la logique de [[Van Bergen et al. (2025)]], et des précisions ont été apportées de [[Besse et al. (2016)]], [[Rein et al. (2010)]] et [[Komar et al. (2014)]] qui ont enrichi l'analyse ou du moins ont permis une compréhension plus fine des analyses réalisées par Van Bergen.

#### ***Étape 1 : Chargement des données*** 

- vérification `.csv`, 
- séparateur, 
- durée, 
- nombre de points.
```python
============================================================
ÉTAPE 1 : CHARGEMENT TRAJECTOIRES RÉELLES
============================================================

Chargement depuis : /Users/julesbelo/Desktop/clustering_escalade_V2/donnees
Nombre de fichiers : 6

✓ traj_LB_7aB.csv                          |  509 points | Durée: 16.95s
✓ traj_LR_7aB.csv                          |  505 points | Durée: 16.82s
✓ traj_essai_1_LR.csv                      |  993 points | Durée: 33.10s
✓ traj_essai_2_LR.csv                      | 1215 points | Durée: 76.64s
✓ traj_essai_3_LB.csv                      | 1549 points | Durée: 128.46s
✓ traj_essai_4_LB.csv                      |  962 points | Durée: 161.83s

✓ 6/6 trajectoires chargées
```
![[📸00_trajectoires_brutes.png]]

#### ***Étape 2 : Normalisation*** 

- normalisation à 100 points pour chaque trajectoire (définit manuellement)
	- `N_POINTS_CIBLE = 100`
- Lissage léger des courbes pour retirer les légères variations (justifié par [[Van Bergen et al. (2025)]] comme un retrait des hésitations pour ne pas dégrader l'analyse)
- Alignement de tous les points de départ

```
Normalisation de 6 trajectoires...

✓ traj_LB_7aB.csv                          |  509 → 100 points
✓ traj_LR_7aB.csv                          |  505 → 100 points
✓ traj_essai_1_LR.csv                      |  993 → 100 points
✓ traj_essai_2_LR.csv                      | 1215 → 100 points
✓ traj_essai_3_LB.csv                      | 1549 → 100 points
✓ traj_essai_4_LB.csv                      |  962 → 100 points

✓ 6 trajectoires normalisées
```

![[📸01_normalisation_validation.png|600]]
#### ***Étape 3 : Distances SSPD*** 

- Calcul des distances inter-trajectoire via SSPD
- [Lien github](https://github.com/bguillouet/traj-dist/blob/master/traj_dist/pydist/sspd.py) vers code source SSPD

```
✓ Matrice calculée

Distances SSPD :
  Min    : 0.0657
  Max    : 0.3766
  Moyenne: 0.2083
  Médiane: 0.2120

✓ Sauvegardée : matrice_distances.csv
```

![[📸02_matrice_distances.png|550]]

#### ***Étape 4 : Clustering*** 

- Clustering avec [méthode de Ward](https://fr.wikipedia.org/wiki/Méthode_de_Ward) 
	- minimisation de la variance à chaque étape de calcul
- Sortie : Dendrogramme hiérarchique tel que : ![[📸03_dendrogramme.png|500]]
- Avec un jeu de 400 données le dendrogramme ressemble à :  ![[📸06_dendrogramme.png|500]]
- Détermination automatique du seuil mais peut être définit arbitrairement pour coller aux valeurs de validation. Auto = plus élégant mais avec un petit jeu de données se définit plus comme une "[heuristique de jugement](https://fr.wikipedia.org/wiki/Heuristique_de_jugement)" que comme un seuil précis
```python
# CONFIGURATION
MODE_AUTO_SEUIL = True  # True = automatique, False = manuel
SEUIL_MANUEL = 0.10  # Ajuster selon dendrogramme
```

- sortie
```
============================================================
CLUSTERS (seuil = 0.137)
============================================================

Nombre : 4

Cluster 1 (n=3) :
  - traj_LR_7aB
  - traj_essai_3_LB
  - traj_essai_4_LB

Cluster 2 (n=1) :
  - traj_LB_7aB

Cluster 3 (n=1) :
  - traj_essai_1_LR

Cluster 4 (n=1) :
  - traj_essai_2_LR

✓ Sauvegardé : clusters.csv
```

- Enfin, visualisation des trajectoires regroupées par couleurs pour chaque cluster identifié
![[📸04_clusters_spatiaux.png]]

#### ***Étape 5 : Validation*** 
- validation par deux outils
	- H-G : [[Van Bergen et al. (2025)]]
	- C-H : [[Komar et al. (2014).pdf]]
- Testé pour un résultat de 2-5 clusters
```python
def tester_validations(D, k_min=2, k_max=5):
```
![[📸05_validation.png||500]]
- Indique le nombre optimal de cluster, si les indicateurs sont sur la même valeur alors robustesse élevée.

```
============================================================
ÉTAPE 5 : VALIDATION
============================================================

Test k=2 à k=5

k=2 | Γ=-0.8815 | CH=10.59
k=3 | Γ=-0.8827 | CH=10.33
k=4 | Γ=-0.6361 | CH=11.56
k=5 | Γ=-0.6361 | CH=11.56

✓ Optimal Gamma : k=4
✓ Optimal CH    : k=4
```

#### ***Étape 6 : Validation*** 
- Calcul de la prévalence
- Calcul de l'originalité
- Calcul créativité totale

```
============================================================
ÉTAPE 6 : SCORES CRÉATIVITÉ
============================================================

Prévalences :
  Cluster 1: 50.00%
  Cluster 2: 16.67%
  Cluster 3: 16.67%
  Cluster 4: 16.67%

✓ Scores : scores_creativite.csv

============================================================
STATISTIQUES
============================================================

Originalité moyenne : 4.000
Créativité moyenne  : 0.625
```
![[📸06_scores_creativite.png]]


>[!warning] A noter
>Lors de l'ajout d'un départ normalisé et similaire pour chaque trajectoire, les clusters ont été modifiés. 
>- Les trajectoires : 
>>- traj_LR_7aB
>>- traj_LB_7aB
>
>Etaient sensiblement les mêmes et pourtant se retrouvent dans le même cluster. Ce qui n'était pas le cas avant le départ au même point. Le dendrogramme ressemblait précédemment à : 
>![[📸03_dendrogramme 1.png]]
>Cette modification peut être due au faible échantillon étudié mais nécessite une certaine attention lors de l'analyse
