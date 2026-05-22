Voici une procédure en étapes, calquée sur Van Bergen et al. (2025) pour les trajectoires, en intégrant formalisme de distance SSPD (Besse et al., 2016) et logique de clustering/validation de Rein et al. (2010).​

## 1. Acquisition et préparation des trajectoires

- Filmer les essais avec une vue fixe et calibrée, puis extraire la trajectoire d’un marqueur (p. ex. LED sur la hanche) en 2D ($x,y$) à fréquence constante, comme dans Van Bergen (GoPro 60 Hz, suivi dans Kinovea).​
    
- Convertir les trajectoires en coordonnées réelles (mètres) via une grille de calibration ou un repère de perspective sur le mur, pour obtenir $(x(t),y(t))$ en unités physiques.
    

## 2. Définition des trajectoires et pré‑traitement

- Représenter chaque trajectoire comme une suite ordonnée de points $(p1,…,pn)$ (pièce‑wise linéaire), au sens de Besse : segments consécutifs entre points successifs.
    
- Ne pas forcément imposer la même longueur temporelle à toutes les trajectoires ; l’approche SSPD est insensible à l’index temporel, ce qui évite la normalisation temporelle stricte de Rein.
    

## 3. Distance entre trajectoires (SSPD)

- Utiliser la Symmetrized Segment‑Path Distance (SSPD) comme distance de base entre deux trajectoires, comme le font Van Bergen pour caractériser la dissimilarité de forme (ils citent précisément cette distance).​
    
- Concrètement, pour deux trajectoires $T_{1}$ et $T_{2}$ :
    
    - Calculer, pour chaque point de $T_{1}$, la distance minimale à $T_{2}$ (distance point‑vers‑trajet via la distance point‑segment).
        
    - En faire la moyenne → $SPD(T_{1},T_{2})$; répéter dans l’autre sens $SPD(T_{2},T_{1})$; puis $SSPD = (SPD(T_{1},T_{2}) + SPD(T_{2},T_{1}))/2$.
        

## 4. Construction de la matrice de distances

- Calculer la matrice de distances $D$ de taille $N×N$ pour tous les essais (toutes les trajectoires réussies), comme décrit par Besse pour l’entrée du clustering.
    
- Cette matrice remplit le même rôle que la matrice de distances de Rein (entre essais) et sert d’entrée à un algorithme de clustering hiérarchique.​
    

## 5. Clustering hiérarchique

- Appliquer un clustering hiérarchique agglomératif sur la matrice $D$, de préférence avec un lien robuste (average linkage ou Ward, Besse montrant de bonnes performances avec Ward).
    
- Générer le dendrogramme qui montre la hiérarchie des fusions de trajectoires en clusters, comme dans la procédure « étape 2 : cluster analysis » de Rein.
    

## 6. Choix du nombre de clusters

- Explorer le nombre de clusters en coupant le dendrogramme à différents seuils et en observant les sauts de hauteur de fusion (grands sauts = clusters bien séparés), comme recommandé par Rein.
    
- En complément, utiliser un critère « type genou » sur une courbe (par ex. Within‑Like / Between‑Like de Besse ou Hubert‑Γ de Rein) en fonction du nombre de clusters, et retenir le nombre à partir duquel ajouter un cluster n’améliore plus nettement la compacité.​
    

## 7. Validation interne des clusters

- Calculer un indice de type Hubert‑$Γ$ pour différentes partitions (k clusters) : il mesure l’adéquation entre la matrice $D$ et la structure de clusters, un pic ou « coude » indiquant un nombre de clusters adapté.​
    
- Optionnellement, si dispo dans ton environnement, appliquer un bootstrap multiscale (type AU p‑value de Shimodaira utilisé par Rein) pour estimer la stabilité de chaque cluster (p‑value proche de 1 → cluster très stable).​
    

## 8. Interprétation des clusters de trajectoires

- Pour chaque cluster, visualiser quelques trajectoires représentatives (par ex. trajectoire médiane ou « exemplar » au sens de Besse) pour vérifier que les trajectoires partagent bien un schéma de déplacement cohérent (chemin sur le mur, structure globale).
    
- Utiliser ensuite les clusters comme Van Bergen :
    - nombre de clusters distincts par individu = taille de répertoire (variabilité fonctionnelle)
    - originalité/creativity = rareté statistique des clusters auxquels ses trajectoires appartiennent (clusters peu fréquents → plus originaux).​
        

## 9. Variables de sortie à calculer

- Dendrogramme hiérarchique (global, pour visualiser les regroupements de trajectoires).​
- Nombre optimal de clusters (issu de la combinaison dendrogramme + Hubert‑$Γ$ / critères de Besse).​
- Pour chaque cluster : taille, exemplaire, éventuellement p‑value de stabilité si bootstrap implémenté.​
- Pour chaque sujet :
    - nombre de clusters différents visités (variabilité)
    - indice d’originalité basé sur la prévalence des clusters (comme Van Bergen).​
        
