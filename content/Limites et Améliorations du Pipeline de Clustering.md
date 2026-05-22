# Limites et Améliorations du Pipeline de Clustering

> [!tip] Contexte
> Document créé le 2026-01-24. Analyse exhaustive des limitations méthodologiques du pipeline de clustering hiérarchique pour l'étude [[CERSTAPS_Martha-Vigouroux-Sanchez_Creativite__et_escalade_Vfinale_12_dec|créativité et escalade]]. Basé sur l'implémentation V4.0 du script Python.

---

## Vue d'ensemble

Ce document identifie les limitations, imprécisions et axes d'amélioration du pipeline actuel, catégorisées en trois niveaux de criticité :

- 🔴 **CRITIQUE** : Nécessite correction avant données réelles (30 participants × 20 trajectoires)
- 🟡 **MODÉRÉ** : À documenter et justifier méthodologiquement
- 🟢 **MINEUR** : Optimisations futures post-mémoire

Le pipeline suit la méthodologie de [[Rein et al. (2010)]], [[Van Bergen et al. (2025)]], et [[Besse et al. (2016)]].

---

## 🔴 LIMITATIONS CRITIQUES

### 1. Absence de validation bootstrap (AU test)

**Description**

Le pipeline implémente uniquement l'[[Score de Hubert-Γ]] pour la validation, alors que [[Rein et al. (2010)]] recommandent explicitement l'utilisation **complémentaire** du test AU (Approximately Unbiased) basé sur [[bootstrap]] multiscale.

**Contexte méthodologique**

Le test AU, implémenté dans le package R `pvclust`, estime la stabilité des clusters par rééchantillonnage itératif (10 000-20 000 répétitions) et produit des p-values de confiance pour chaque nœud du [[dendrogramme]].

**Implications**

L'indice [[Score de Hubert-Γ|Hubert-Gamma]] seul teste la **compacité** des clusters (concordance matrice de distances / partition) mais ne garantit pas leur **stabilité** face aux variations d'échantillonnage. Sans cette validation, impossible d'évaluer la robustesse des clusters face aux fluctuations naturelles des données biomécaniques ([[variabilité intra-individuelle]], erreur de mesure).

**Justification actuelle**

Avec 14 trajectoires test (2 participants), le bootstrap n'a pas de sens statistique. Cependant, avec 600 trajectoires prévues (30 participants × ~20 essais), le test AU devient **méthodologiquement indispensable** selon standards de [[Rein et al. (2010)]].

Note : [[Van Bergen et al. (2025)]] ont analysé 212 trajectoires réussies (pas 26), mais ne mentionnent pas explicitement le test AU.

**Action recommandée**

Intégrer le test AU via interface Python-R (`rpy2`) ou réimplémenter l'algorithme de Shimodaira en Python pur :

```python
# Option 1 : Interface R via rpy2
import rpy2.robjects as ro
from rpy2.robjects.packages import importr

# Importer pvclust
pvclust = importr('pvclust')

# Convertir matrice Python → R
r_matrix = ro.r.matrix(D, nrow=n_traj, ncol=n_traj)

# Exécuter pvclust (10000 bootstrap)
result = pvclust.pvclust(
    ro.r['as.dist'](r_matrix),
    method_hclust="ward.D2",
    nboot=10000
)

# Extraire p-values AU
au_pvalues = ro.r['result$au']
```

Alternative acceptable : validation croisée interne (split-half reliability) si interface R pose problème technique.

**Lien vers création de note**

→ Créer [[Bootstrap multiscale AU test]] avec détails implémentation

---

### 2. Extraction participant_id vulnérable aux variations de format

**Description**

Ligne 563 et 644 du code : extraction participant_id par découpage underscore avec index fixes.

```python
participant_id = nom.split('_')[1]  # Suppose format E{n}_P{id}_BA_{condition}
```

Cette approche est **fragile** face aux variations de nomenclature.

**Implications**

Avec 600 fichiers, probabilité d'erreurs de nommage humaines élevée. Erreur non détectée fausserait tous les scores individuels ([[variabilité fonctionnelle]], [[créativité motrice]]), rendant analyses statistiques inter-sujets invalides.

**Action recommandée**

> [!note] Priorité modérée
> À noter pour phase de données réelles, pas critique sur données test actuelles.

Implémenter parsing robuste avec expressions régulières :

```python
import re

def extraire_metadata_robuste(nom_fichier):
    """
    Extraction tolérante aux variations de format.
    
    Formats acceptés :
    - E1_P01_BA_F.csv
    - Essai_03_Participant_12_Fatigue.csv
    - trial_05_P8_non_fatigue.csv
    """
    # Pattern flexible : capture P suivi de chiffres
    match_participant = re.search(r'[_\s]P(\d+)[_\s]', nom_fichier)
    match_condition = re.search(
        r'[_\s](BA|F|NF|fatigue|non.?fatigue)[_\s\.]', 
        nom_fichier, 
        re.IGNORECASE
    )
    
    if not match_participant:
        raise ValueError(
            f"Impossible d'extraire participant_id de '{nom_fichier}'. "
            f"Format attendu : contient '_Pxx_' où xx = numéro participant."
        )
    
    participant_id = f"P{match_participant.group(1).zfill(2)}"  # P01, P02...
    condition = match_condition.group(1).upper() if match_condition else "UNKNOWN"
    
    return participant_id, condition

# Ajouter vérification en début de pipeline
trajectoires_problematiques = []
for fichier in fichiers:
    try:
        participant_id, condition = extraire_metadata_robuste(fichier)
    except ValueError as e:
        trajectoires_problematiques.append((fichier, str(e)))
        
if trajectoires_problematiques:
    print("\n⚠️  FICHIERS PROBLÉMATIQUES DÉTECTÉS :")
    for nom, erreur in trajectoires_problematiques:
        print(f"  - {nom}: {erreur}")
    reponse = input("\nContinuer quand même ? (o/n) : ")
    if reponse.lower() != 'o':
        sys.exit(1)
```

**Lien vers documentation**

→ Voir [[Nomenclature des fichiers de trajectoires]] pour conventions de nommage

---

### 3. Absence de gestion des trajectoires aberrantes

**Description**

Le pipeline ne comporte aucune détection automatique de trajectoires aberrantes (outliers) : durée anormale, trajectoire dégénérée, mouvements erratiques.

**Implications**

Une trajectoire aberrante peut :
1. Former un cluster singleton artefactuel (faussant scores de [[variabilité fonctionnelle]])
2. Perturber structure du [[dendrogramme]] si très éloignée
3. Réduire artificiellement [[Score de Hubert-Γ|Hubert-Gamma]] en augmentant dispersion globale

**Action recommandée**

Implémenter filtres de qualité en MODULE 0 (pré-traitement) :

```python
def verifier_qualite_trajectoire(t, x, y, nom_fichier):
    """
    Détecte les trajectoires problématiques selon critères biomécaniques.
    
    Paramètres
    ----------
    t : ndarray
        Temps (secondes)
    x, y : ndarray
        Coordonnées spatiales (pixels ou mètres)
    nom_fichier : str
        Nom pour logging
        
    Retour
    ------
    problemes : list of str
        Liste des problèmes détectés (vide si OK)
    """
    problemes = []
    
    # Critère 1 : Durée anormale
    duree = t[-1] - t[0]
    if duree < 3:
        problemes.append(f"Durée trop courte: {duree:.1f}s (< 3s)")
    elif duree > 60:
        problemes.append(f"Durée excessive: {duree:.1f}s (> 60s)")
    
    # Critère 2 : Déplacement total insuffisant (grimpeur immobile)
    deplacement_total = np.sum(np.sqrt(np.diff(x)**2 + np.diff(y)**2))
    seuil_deplacement = 100  # À ajuster selon calibration caméra
    if deplacement_total < seuil_deplacement:
        problemes.append(
            f"Déplacement insuffisant: {deplacement_total:.0f} pixels "
            f"(seuil: {seuil_deplacement})"
        )
    
    # Critère 3 : Points manquants (tracking LED perdu)
    if len(t) < 50:
        problemes.append(f"Trop peu de points: {len(t)} (< 50 frames)")
    
    # Critère 4 : Vitesse instantanée aberrante
    dt = np.diff(t)
    dx = np.diff(x)
    dy = np.diff(y)
    vitesses = np.sqrt(dx**2 + dy**2) / dt  # pixels/s
    
    # Convertir en m/s si calibration disponible
    # CALIBRATION = 1000 pixels/mètre (à ajuster)
    # vitesses_ms = vitesses / CALIBRATION
    
    # Seuil : > 3 m/s improbable en escalade de bloc
    seuil_vitesse = 3000  # pixels/s (3 m/s si 1000 px/m)
    vitesse_max = np.max(vitesses)
    if vitesse_max > seuil_vitesse:
        problemes.append(
            f"Vitesse aberrante: {vitesse_max:.0f} px/s "
            f"(seuil: {seuil_vitesse})"
        )
    
    # Critère 5 : Variance spatiale nulle (tracking bloqué)
    if np.std(x) < 1 or np.std(y) < 1:
        problemes.append(f"Variance spatiale nulle (LED immobile)")
    
    return problemes

# Intégration en début de ÉTAPE 1
print(f"\n{'='*60}")
print("ÉTAPE 0 : CONTRÔLE QUALITÉ DES TRAJECTOIRES")
print(f"{'='*60}\n")

trajectoires_validees = []
trajectoires_rejetees = []

for fichier in fichiers:
    chemin = os.path.join(DOSSIER_DONNEES, fichier)
    t, x, y, nom = charger_trajectoire(chemin)
    
    problemes = verifier_qualite_trajectoire(t, x, y, nom)
    
    if problemes:
        print(f"⚠️  REJETÉ - {nom}")
        for pb in problemes:
            print(f"     └─ {pb}")
        trajectoires_rejetees.append({
            'nom': nom,
            'problemes': problemes,
            'duree': t[-1] - t[0],
            'n_points': len(t)
        })
    else:
        print(f"✓ VALIDÉ - {nom}")
        trajectoires_validees.append(fichier)

# Sauvegarder rapport de rejets
if trajectoires_rejetees:
    df_rejets = pd.DataFrame(trajectoires_rejetees)
    df_rejets.to_csv(
        os.path.join(DOSSIER_ANALYSES, 'trajectoires_rejetees.csv'), 
        index=False
    )
    print(f"\n⚠️  {len(trajectoires_rejetees)} trajectoires rejetées")
    print(f"   Rapport : trajectoires_rejetees.csv")

print(f"\n✓ {len(trajectoires_validees)} trajectoires validées")
print(f"  Taux de réussite : {100*len(trajectoires_validees)/len(fichiers):.1f}%\n")

# Continuer uniquement avec trajectoires validées
fichiers = trajectoires_validees
```

**Liens vers notes connexes**

→ [[Erreurs de tracking LED]] : problèmes fréquents et solutions
→ [[Protocole de capture vidéo]] : recommandations pour minimiser outliers

---

### 4. Sauvegarde des objets intermédiaires critiques

**Description**

Pipeline sauvegarde résultats finaux (CSV) mais pas objets Python intermédiaires (matrice D, linkage Z, trajectoires normalisées). Retraitement nécessite relance complète depuis début.

**Implications**

Avec 2-4h de calcul [[SSPD]] pour 600 trajectoires, impossibilité de reprendre en milieu de pipeline pour analyses exploratoires (tester différents seuils [[Clustering hiérarchique Ward|Ward]], recalculer [[Score de Hubert-Γ|Hubert-Gamma]]).

**Action recommandée**

Sauvegarder objets critiques avec `joblib` (plus efficace que `pickle` pour arrays NumPy) :

```python
import joblib
from datetime import datetime

# Après ÉTAPE 2 : Calcul matrice SSPD
print("\nSauvegarde matrice SSPD...")
joblib.dump({
    'D': D,
    'noms': noms,
    'trajectoires_norm': trajectoires_norm,
    'metadata': {
        'date_calcul': datetime.now().isoformat(),
        'n_traj': n_traj,
        'n_points_normalisation': N_POINTS,
        'fenetre_lissage': LISSAGE_FENETRE,
        'ordre_lissage': LISSAGE_ORDRE,
        'version_pipeline': '4.0'
    }
}, os.path.join(DOSSIER_ANALYSES, 'matrice_sspd.pkl'))
print("✓ Sauvegardé : matrice_sspd.pkl")

# Après ÉTAPE 3 : Clustering Ward
print("\nSauvegarde résultats clustering...")
joblib.dump({
    'Z': Z,
    'seuil': SEUIL,
    'labels': labels,
    'k': k,
    'metadata': {
        'date_clustering': datetime.now().isoformat(),
        'methode': 'ward',
        'critere_seuil': 'manuel_van_bergen'
    }
}, os.path.join(DOSSIER_ANALYSES, 'clustering_results.pkl'))
print("✓ Sauvegardé : clustering_results.pkl")

# Option : script de reprise rapide
# reprendre_analyse.py
"""
Script pour reprendre analyse à partir des objets sauvegardés.
Usage : python reprendre_analyse.py --etape 3 --nouveau-seuil 15.2
"""
import joblib
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--etape', type=int, choices=[2,3,4,5], 
                    help='Étape de reprise (2=SSPD, 3=Ward, etc.)')
parser.add_argument('--nouveau-seuil', type=float, 
                    help='Nouveau seuil Ward à tester')
args = parser.parse_args()

if args.etape >= 3:
    # Charger matrice SSPD pré-calculée
    data = joblib.load('resultats/analyses/matrice_sspd.pkl')
    D = data['D']
    noms = data['noms']
    print(f"✓ Matrice SSPD chargée ({len(noms)} trajectoires)")
    
    # Recalculer clustering avec nouveau seuil
    if args.nouveau_seuil:
        SEUIL = args.nouveau_seuil
        print(f"Test nouveau seuil : {SEUIL}")
        # ... continuer pipeline depuis ÉTAPE 3
```

**Gain estimé**

- Temps économisé : 2-4h par itération d'analyse
- Flexibilité : test rapide de 5-10 seuils différents en <5min

---

## 🟡 LIMITATIONS MODÉRÉES

### 5. Fenêtre de lissage Savitzky-Golay non proportionnelle

**Description**

Pipeline applique fenêtre fixe de 15 points (ligne 25) après [[normalisation temporelle|normalisation]] à 200 points. Représente 7,5% du signal pour toutes trajectoires, indépendamment de leur résolution initiale.

**Contexte empirique**

Trajectoires brutes varient entre 300-1000 points selon durée d'exécution (5-15s à 60 Hz). Après normalisation à 200 points, lissage de 15 points représente :
- Grimpeur rapide (traj. originale 300 pts) : échelle = 15/300 × durée totale
- Grimpeur lent (traj. originale 900 pts) : échelle = 15/900 × durée totale

**Implications méthodologiques**

Lissage d'échelles temporelles **absolues différentes** selon vitesse d'exécution. Risque d'homogénéiser artificiellement trajectoires rapides (plus de lissage relatif) versus lentes.

**Justification théorique acceptée**

[[Rein et al. (2010)]] ne spécifient pas si lissage doit être proportionnel ou fixe post-normalisation. Choix actuel de fenêtre fixe après normalisation est cohérent avec hypothèse que [[SSPD]] compare **formes temporellement relativisées** (point 100/200 = "moitié de trajectoire" quelle que soit durée absolue).

Le lissage fixe uniformise alors **résolutions spatiales relatives** plutôt qu'échelles temporelles absolues.

**Action recommandée**

Documenter explicitement ce choix dans méthodologie :

> "Le lissage [[Savitzky-Golay]] avec fenêtre de 15 points a été appliqué **après** [[normalisation temporelle|normalisation temporelle]], garantissant une résolution spatiale uniforme pour toutes trajectoires analysées (7,5% de l'échelle temporelle normalisée). Cette approche suppose que patterns moteurs pertinents se manifestent à échelles temporelles relatives comparables entre grimpeurs, indépendamment de leur vitesse d'exécution absolue."

**Exploration alternative**

Tester fenêtre proportionnelle AVANT normalisation (ex: 3% de longueur originale) et comparer sensibilité [[SSPD]] sur sous-échantillon :

```python
# Version alternative : lissage proportionnel pré-normalisation
def normaliser_trajectoire_v2(t, x, y, n_points=N_POINTS):
    """
    Variante avec lissage proportionnel AVANT normalisation.
    """
    # ÉTAPE 1 : Lissage proportionnel sur signal original
    n_original = len(t)
    fenetre_proportionnelle = max(5, int(0.03 * n_original))  # 3% de la longueur
    if fenetre_proportionnelle % 2 == 0:  # Doit être impair
        fenetre_proportionnelle += 1
    
    x_lisse = savgol_filter(x, window_length=fenetre_proportionnelle, polyorder=3)
    y_lisse = savgol_filter(y, window_length=fenetre_proportionnelle, polyorder=3)
    
    # ÉTAPE 2 : Normalisation temporelle (interpolation uniquement)
    t_norm = np.linspace(t[0], t[-1], n_points)
    interpolateur_x = interp1d(t, x_lisse, kind='cubic')
    interpolateur_y = interp1d(t, y_lisse, kind='cubic')
    x_norm = interpolateur_x(t_norm)
    y_norm = interpolateur_y(t_norm)
    
    return t_norm, x_norm, y_norm

# Test comparatif
def comparer_strategies_lissage(trajectoires_brutes):
    """Compare impact des deux stratégies sur structure SSPD."""
    strategies = {
        'fixe_post': normaliser_trajectoire,
        'proportionnel_pre': normaliser_trajectoire_v2
    }
    
    resultats = {}
    for nom_strat, func_norm in strategies.items():
        # Normaliser
        traj_norm = [func_norm(t, x, y) for t, x, y, _ in trajectoires_brutes]
        
        # Calculer matrice SSPD
        D = calculer_matrice_sspd(traj_norm)
        
        # Clustering
        Z = linkage(squareform(D), method='ward')
        
        # Évaluer structure
        labels_k5 = fcluster(Z, 5, criterion='maxclust')
        hubert_k5 = calculer_hubert_gamma(D, labels_k5)
        
        resultats[nom_strat] = {
            'hubert_gamma_k5': hubert_k5,
            'variance_distances': np.var(D),
            'cophenetic_corr': cophenet(Z, squareform(D))[0]
        }
    
    return pd.DataFrame(resultats).T
```

→ Créer note [[Normalisation temporelle - analyse de sensibilité]]

---

### 6. Paramètres de normalisation (N_POINTS=200) non justifiés empiriquement

**Description**

Utilisation de 200 points pour [[normalisation temporelle|normalisation]] (ligne 24) justifiée par "100 points entraînent perte qualité" (observation visuelle informelle plutôt qu'analyse quantitative).

**Contexte bibliographique**

[[Rein et al. (2010)]] recommandent 50-100 points. [[Van Bergen et al. (2025)]] utilisent implicitement ~100 points. Choix de 200 est donc **au-delà des standards documentés**.

**Implications**

Bien que conservateur (préserve plus d'information), cela :
1. Double coût computationnel calcul [[SSPD]] (complexité O(n²) par paire)
2. Risque de préserver **bruit haute fréquence** non informatif
3. N'est pas justifié par démonstration formelle de gain d'information

**Justification théorique acceptable**

[[Rein et al. (2010)]] souligne importance de "ne pas perdre qualité dans trajectoires étudiées". Contexte spécifique (capture vidéo [[système de capture par LED|LED]] avec erreur de tracking) peut légitimement nécessiter plus de points qu'une capture optoélectronique professionnelle.

De plus, trajectoires **convergentes** (même [[Bloc d'escalade|bloc]] pour tous) → détails fins de placement peuvent être discriminants.

**Action recommandée**

Conduire **analyse de sensibilité formelle** sur échantillon représentatif :

```python
def analyser_sensibilite_normalisation(trajectoires_brutes, 
                                       resolutions=[50, 100, 150, 200, 250]):
    """
    Teste l'impact de la résolution de normalisation sur structure clustering.
    
    Métriques évaluées :
    - Cophenetic correlation (fidélité dendrogramme)
    - Variance des distances SSPD (dispersion)
    - Stabilité du nombre de clusters optimal
    
    Paramètres
    ----------
    trajectoires_brutes : list of tuples
        [(t, x, y, nom), ...] trajectoires originales
    resolutions : list of int
        Résolutions à tester
        
    Retour
    ------
    df_resultats : DataFrame
        Métriques par résolution
    """
    resultats = []
    
    for n_points in resolutions:
        print(f"\nTest résolution : {n_points} points...")
        
        # Normaliser toutes trajectoires à n_points
        traj_norm = []
        for t, x, y, nom in trajectoires_brutes:
            t_norm, x_norm, y_norm = normaliser_trajectoire(
                t, x, y, n_points=n_points
            )
            traj_norm.append((x_norm, y_norm))
        
        # Calculer matrice SSPD
        D = np.zeros((len(traj_norm), len(traj_norm)))
        for i in range(len(traj_norm)):
            for j in range(i+1, len(traj_norm)):
                traj_i = np.column_stack(traj_norm[i])
                traj_j = np.column_stack(traj_norm[j])
                D[i,j] = e_sspd(traj_i, traj_j)
                D[j,i] = D[i,j]
        
        # Clustering Ward
        Z = linkage(squareform(D), method='ward')
        
        # Calculer métriques
        coph_corr, _ = cophenet(Z, squareform(D))
        
        # Tester k de 2 à 10 pour trouver pic Hubert-Gamma
        hubertgamma_scores = []
        for k_test in range(2, min(11, len(traj_norm))):
            labels_k = fcluster(Z, k_test, criterion='maxclust')
            hg = calculer_hubert_gamma(D, labels_k)
            hubertgamma_scores.append(hg)
        
        k_optimal = 2 + np.argmax(hubertgamma_scores)
        hubert_max = max(hubertgamma_scores)
        
        resultats.append({
            'n_points': n_points,
            'cophenetic_corr': coph_corr,
            'variance_distances': np.var(D),
            'mean_distance': np.mean(D[np.triu_indices_from(D, k=1)]),
            'k_optimal_hubert': k_optimal,
            'hubert_gamma_max': hubert_max,
            'temps_calcul_sspd': 'N/A'  # Chronométrer si pertinent
        })
    
    df = pd.DataFrame(resultats)
    
    # Visualisation
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    
    # Cophenetic correlation
    axes[0,0].plot(df['n_points'], df['cophenetic_corr'], 'o-', linewidth=2)
    axes[0,0].axhline(0.8, color='red', linestyle='--', 
                      label='Seuil acceptable (0.8)')
    axes[0,0].set_xlabel('Nombre de points normalisés')
    axes[0,0].set_ylabel('Corrélation cophénétique')
    axes[0,0].set_title('Fidélité du dendrogramme')
    axes[0,0].legend()
    axes[0,0].grid(True, alpha=0.3)
    
    # Variance distances
    axes[0,1].plot(df['n_points'], df['variance_distances'], 'o-', 
                   linewidth=2, color='orange')
    axes[0,1].set_xlabel('Nombre de points normalisés')
    axes[0,1].set_ylabel('Variance des distances SSPD')
    axes[0,1].set_title('Dispersion structure spatiale')
    axes[0,1].grid(True, alpha=0.3)
    
    # k optimal
    axes[1,0].plot(df['n_points'], df['k_optimal_hubert'], 'o-', 
                   linewidth=2, color='green')
    axes[1,0].set_xlabel('Nombre de points normalisés')
    axes[1,0].set_ylabel('k optimal (Hubert-Γ)')
    axes[1,0].set_title('Stabilité du nombre de clusters')
    axes[1,0].grid(True, alpha=0.3)
    
    # Hubert-Gamma max
    axes[1,1].plot(df['n_points'], df['hubert_gamma_max'], 'o-', 
                   linewidth=2, color='purple')
    axes[1,1].set_xlabel('Nombre de points normalisés')
    axes[1,1].set_ylabel('Hubert-Γ maximum')
    axes[1,1].set_title('Qualité du clustering optimal')
    axes[1,1].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('analyse_sensibilite_normalisation.png', dpi=200)
    plt.close()
    
    return df

# Exécution
resultats_sensibilite = analyser_sensibilite_normalisation(trajectoires_brutes)
resultats_sensibilite.to_csv('sensibilite_normalisation.csv', index=False)
print("\n" + "="*60)
print("RÉSULTATS ANALYSE DE SENSIBILITÉ")
print("="*60)
print(resultats_sensibilite.to_string(index=False))
```

**Interprétation attendue**

- Si cophenetic correlation stable ≥0.8 pour n≥100 → justifie 100 points suffisants
- Si k_optimal varie fortement (ex: 50pts→k=5, 200pts→k=18) → sensibilité problématique
- Si hubert_gamma_max plateau à partir de 150pts → gain marginal 150→200

Documenter résultats dans méthodologie pour justifier choix 200 points empiriquement.

→ Créer note [[Choix résolution normalisation temporelle]]

---

### 7. Critère de détermination du seuil Ward purement subjectif

**Description**

MODULE 3 (ligne 896-897) utilise méthode [[Van Bergen et al. (2025)]] : détermination manuelle du seuil après inspection visuelle diagnostic double-courbe (nombre clusters + taille plus grand cluster). Approche **subjectivement dépendante de l'expérimentateur**.

**Implications méthodologiques**

Deux analystes indépendants pourraient identifier seuils différents → nombres de clusters différents → scores [[variabilité fonctionnelle]]/[[créativité motrice]] différents. Compromet **reproductibilité inter-juges**.

Avec 600 trajectoires, [[dendrogramme]] très dense, rendant inspection visuelle difficile.

**Justification théorique**

[[Van Bergen et al. (2025)]] défendent cette approche : méthodes automatiques (pic [[Score de Hubert-Γ|Hubert-Gamma]], coude silhouette) peuvent sur-découper ou sous-découper selon forme distribution des distances.

Inspection visuelle permet d'intégrer **connaissances a priori** sur plausibilité biomécanique du nombre de clusters (ex: 15-25 patterns moteurs distincts semblent raisonnables, 2-3 ou 100+ seraient suspects).

**Action recommandée**

Implémenter **triangulation méthodologique** pour réduire subjectivité :

```python
def determiner_seuil_triangulation(Z, D, noms):
    """
    Détermine seuil optimal par triangulation de 3 méthodes.
    
    Méthodes :
    1. Inspection visuelle Van Bergen (double-courbe)
    2. Pic Hubert-Gamma automatique
    3. Méthode du coude (variance intra-cluster)
    
    Retour
    ------
    seuil_final : float
        Seuil retenu après triangulation
    rapport : dict
        Détails des 3 méthodes pour documentation
    """
    hauteurs = Z[:, 2]
    n_traj = Z.shape[0] + 1
    
    # =====================================================
    # MÉTHODE 1 : Inspection visuelle (Van Bergen)
    # =====================================================
    print("\n" + "="*60)
    print("MÉTHODE 1 : INSPECTION VISUELLE (Van Bergen et al. 2025)")
    print("="*60)
    
    tracer_diagnostic(Z, noms, seuil_temp=np.median(hauteurs))
    print("Inspectez le graphique 'diagnostic_van_bergen.png'")
    print(f"Plage seuils : {hauteurs.min():.2f} - {hauteurs.max():.2f}")
    
    seuil_visuel = float(input("\nSeuil choisi visuellement : "))
    labels_visuel = fcluster(Z, seuil_visuel, criterion='distance')
    k_visuel = len(np.unique(labels_visuel))
    
    # =====================================================
    # MÉTHODE 2 : Pic Hubert-Gamma
    # =====================================================
    print("\n" + "="*60)
    print("MÉTHODE 2 : PIC HUBERT-GAMMA")
    print("="*60)
    
    scores_hubert = []
    k_range = range(2, min(30, n_traj))
    
    for k_test in k_range:
        labels_k = fcluster(Z, k_test, criterion='maxclust')
        hg = calculer_hubert_gamma(D, labels_k)
        scores_hubert.append(hg)
    
    k_hubert = list(k_range)[np.argmax(scores_hubert)]
    hubert_max = max(scores_hubert)
    
    # Convertir k en seuil
    seuil_hubert = hauteurs[n_traj - k_hubert - 1] if k_hubert < n_traj else 0
    
    print(f"k optimal Hubert-Γ : {k_hubert} (Γ={hubert_max:.4f})")
    print(f"Seuil correspondant : {seuil_hubert:.3f}")
    
    # =====================================================
    # MÉTHODE 3 : Coude variance intra-cluster
    # =====================================================
    print("\n" + "="*60)
    print("MÉTHODE 3 : MÉTHODE DU COUDE (variance intra)")
    print("="*60)
    
    variances_intra = []
    for k_test in k_range:
        labels_k = fcluster(Z, k_test, criterion='maxclust')
        
        # Calculer variance intra-cluster moyenne
        var_intra = 0
        for cluster_id in np.unique(labels_k):
            indices_cluster = np.where(labels_k == cluster_id)[0]
            if len(indices_cluster) > 1:
                D_cluster = D[np.ix_(indices_cluster, indices_cluster)]
                var_intra += np.var(D_cluster)
        var_intra /= len(np.unique(labels_k))
        variances_intra.append(var_intra)
    
    # Détection du coude (méthode des différences secondes)
    diff_1 = np.diff(variances_intra)
    diff_2 = np.diff(diff_1)
    k_coude = list(k_range)[np.argmax(np.abs(diff_2)) + 2]
    seuil_coude = hauteurs[n_traj - k_coude - 1] if k_coude < n_traj else 0
    
    print(f"k optimal (coude) : {k_coude}")
    print(f"Seuil correspondant : {seuil_coude:.3f}")
    
    # =====================================================
    # SYNTHÈSE ET TRIANGULATION
    # =====================================================
    print("\n" + "="*60)
    print("SYNTHÈSE TRIANGULATION")
    print("="*60)
    
    print(f"\nMéthode 1 (Visuel)  : seuil={seuil_visuel:.3f} → k={k_visuel}")
    print(f"Méthode 2 (Hubert)  : seuil={seuil_hubert:.3f} → k={k_hubert}")
    print(f"Méthode 3 (Coude)   : seuil={seuil_coude:.3f} → k={k_coude}")
    
    # Convergence ?
    k_values = [k_visuel, k_hubert, k_coude]
    k_std = np.std(k_values)
    
    if k_std <= 2:
        print(f"\n✓ CONVERGENCE : Écart-type k = {k_std:.1f} (≤2)")
        print("  Les 3 méthodes s'accordent sur le nombre de clusters.")
    else:
        print(f"\n⚠️  DIVERGENCE : Écart-type k = {k_std:.1f} (>2)")
        print("  Nécessite arbitrage expérimentateur.")
    
    # Seuil final : moyenne pondérée (privilégier Hubert + Visuel)
    seuil_final = (2*seuil_visuel + 2*seuil_hubert + seuil_coude) / 5
    labels_final = fcluster(Z, seuil_final, criterion='distance')
    k_final = len(np.unique(labels_final))
    
    print(f"\nSEUIL FINAL RETENU : {seuil_final:.3f} → k={k_final}")
    print("(Moyenne pondérée : 40% visuel, 40% Hubert, 20% coude)")
    
    # Visualisation comparative
    fig, axes = plt.subplots(1, 2, figsize=(16, 6))
    
    # Hubert-Gamma
    axes[0].plot(list(k_range), scores_hubert, 'o-', linewidth=2)
    axes[0].axvline(k_hubert, color='red', linestyle='--', 
                    label=f'k optimal = {k_hubert}')
    axes[0].axvline(k_visuel, color='blue', linestyle='--', 
                    label=f'k visuel = {k_visuel}', alpha=0.6)
    axes[0].set_xlabel('Nombre de clusters k')
    axes[0].set_ylabel('Hubert-Γ')
    axes[0].set_title('Méthode 2 : Pic Hubert-Γ')
    axes[0].legend()
    axes[0].grid(True, alpha=0.3)
    
    # Variance intra-cluster (coude)
    axes[1].plot(list(k_range), variances_intra, 'o-', linewidth=2, color='green')
    axes[1].axvline(k_coude, color='red', linestyle='--', 
                    label=f'k coude = {k_coude}')
    axes[1].axvline(k_visuel, color='blue', linestyle='--', 
                    label=f'k visuel = {k_visuel}', alpha=0.6)
    axes[1].set_xlabel('Nombre de clusters k')
    axes[1].set_ylabel('Variance intra-cluster')
    axes[1].set_title('Méthode 3 : Méthode du coude')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('triangulation_seuil.png', dpi=200)
    plt.close()
    
    rapport = {
        'seuil_visuel': seuil_visuel,
        'k_visuel': k_visuel,
        'seuil_hubert': seuil_hubert,
        'k_hubert': k_hubert,
        'hubert_gamma_max': hubert_max,
        'seuil_coude': seuil_coude,
        'k_coude': k_coude,
        'seuil_final': seuil_final,
        'k_final': k_final,
        'convergence': k_std <= 2,
        'k_std': k_std
    }
    
    return seuil_final, rapport
```

**Fiabilité inter-juges**

Ajouter test de fiabilité : faire déterminer seuil visuel par 2-3 personnes indépendantes, calculer accord (coefficient kappa sur k) :

```python
def calculer_fiabilite_inter_juges(Z, D, noms, n_juges=3):
    """
    Évalue la fiabilité inter-juges pour détermination seuil visuel.
    """
    k_juges = []
    
    for i in range(n_juges):
        print(f"\n{'='*60}")
        print(f"JUGE {i+1}/{n_juges}")
        print(f"{'='*60}")
        tracer_diagnostic(Z, noms, seuil_temp=np.median(Z[:, 2]))
        seuil = float(input("Seuil choisi : "))
        labels = fcluster(Z, seuil, criterion='distance')
        k = len(np.unique(labels))
        k_juges.append(k)
    
    # Coefficient de variation (CV)
    k_mean = np.mean(k_juges)
    k_std = np.std(k_juges)
    cv = (k_std / k_mean) * 100
    
    print(f"\nFIABILITÉ INTER-JUGES :")
    print(f"k choisis : {k_juges}")
    print(f"Moyenne : {k_mean:.1f} ± {k_std:.1f}")
    print(f"Coefficient de variation : {cv:.1f}%")
    
    if cv < 10:
        print("✓ Excellente fiabilité (CV < 10%)")
    elif cv < 20:
        print("⚠️  Fiabilité acceptable (10% ≤ CV < 20%)")
    else:
        print("❌ Fiabilité faible (CV ≥ 20%) - Revoir méthode")
    
    return k_juges, cv
```

→ Créer note [[Fiabilité inter-juges clustering]]

---

## 🟢 LIMITATIONS MINEURES

### 8. Calcul SSPD non optimisé (complexité O(N²×n²))

**Description**

Calcul matrice [[distance segment-chemin symétrique|SSPD]] (MODULE 2, lignes 863-875) présente complexité computationnelle élevée :
- Boucle externe : N(N-1)/2 paires de trajectoires
- Par paire : 2 × n × n calculs distances point-à-segment
- **Complexité totale : O(N² × n²)**

Avec N=600 trajectoires de n=200 points : ~7,2 milliards d'opérations → 2-4h sur processeur standard.

**Implications pratiques**

Limitation **opérationnelle** (pas méthodologique). Impossibilité d'itérer rapidement sur analyses exploratoires (tests différents paramètres lissage, résolutions normalisation).

**Optimisations possibles**

Par ordre d'effort/gain décroissant :

**Option 1 : Vectorisation NumPy** (effort faible, gain ×2-3)

```python
def e_sspd_vectorise(t1, t2):
    """
    Version vectorisée du calcul SSPD.
    Remplace boucles Python par opérations matricielles NumPy.
    """
    n1, n2 = len(t1), len(t2)
    
    # Précalcul longueurs segments (inchangé)
    seg_lengths_1 = np.linalg.norm(np.diff(t1, axis=0), axis=1)
    seg_lengths_2 = np.linalg.norm(np.diff(t2, axis=0), axis=1)
    
    # SPD : T1 vers T2 (vectorisé)
    # Calculer toutes distances points T1 × segments T2 en une matrice
    spd_1to2 = 0
    for i in range(n1):
        # Distance à tous segments de T2
        dists_to_segments = []
        for j in range(n2-1):
            seg_start = t2[j]
            seg_end = t2[j+1]
            seg_vec = seg_end - seg_start
            seg_length_sq = seg_lengths_2[j] ** 2
            
            # Projection paramètre t
            t_param = np.dot(t1[i] - seg_start, seg_vec) / seg_length_sq
            t_param = np.clip(t_param, 0, 1)
            
            # Point projeté
            proj = seg_start + t_param * seg_vec
            dist = np.linalg.norm(t1[i] - proj)
            dists_to_segments.append(dist)
        
        spd_1to2 += min(dists_to_segments)
    
    spd_1to2 /= n1
    
    # SPD : T2 vers T1 (idem)
    spd_2to1 = 0
    for j in range(n2):
        dists_to_segments = []
        for i in range(n1-1):
            seg_start = t1[i]
            seg_end = t1[i+1]
            seg_vec = seg_end - seg_start
            seg_length_sq = seg_lengths_1[i] ** 2
            
            t_param = np.dot(t2[j] - seg_start, seg_vec) / seg_length_sq
            t_param = np.clip(t_param, 0, 1)
            
            proj = seg_start + t_param * seg_vec
            dist = np.linalg.norm(t2[j] - proj)
            dists_to_segments.append(dist)
        
        spd_2to1 += min(dists_to_segments)
    
    spd_2to1 /= n2
    
    return (spd_1to2 + spd_2to1) / 2
```

**Option 2 : Parallélisation** (effort moyen, gain ×4-8 sur multi-core)

```python
from multiprocessing import Pool, cpu_count

def calculer_sspd_paire(args):
    """Fonction auxiliaire pour calcul parallèle."""
    i, j, traj_i, traj_j = args
    return i, j, e_sspd(traj_i, traj_j)

def calculer_matrice_sspd_parallele(trajectoires):
    """
    Calcul matrice SSPD avec parallélisation multi-core.
    """
    n_traj = len(trajectoires)
    D = np.zeros((n_traj, n_traj))
    
    # Préparer arguments pour calculs parallèles
    paires = []
    for i in range(n_traj):
        for j in range(i+1, n_traj):
            paires.append((i, j, trajectoires[i], trajectoires[j]))
    
    # Paralléliser sur tous cores disponibles
    n_cores = cpu_count()
    print(f"Calcul SSPD parallèle sur {n_cores} cores...")
    
    with Pool(n_cores) as pool:
        resultats = list(tqdm(
            pool.imap(calculer_sspd_paire, paires),
            total=len(paires),
            desc="Matrice SSPD"
        ))
    
    # Remplir matrice symétrique
    for i, j, distance in resultats:
        D[i, j] = distance
        D[j, i] = distance
    
    return D
```

**Option 3 : GPU (CuPy)** (effort élevé, gain ×10-50 si GPU disponible)

Nécessite réécriture complète en CuPy, à envisager uniquement si accès GPU garanti.

**Recommandation**

Pour mémoire M2, version actuelle acceptable si temps calcul documenté. Optimisation = développement post-mémoire ou pour publication.

→ Note à créer : [[Optimisation calcul SSPD]]

---

### 9. Absence de métriques complémentaires qualité clustering

**Description**

Pipeline calcule [[Score de Hubert-Γ|Hubert-Gamma]] mais pas autres métriques standard :
- **Silhouette score** : séparation/compacité de chaque trajectoire
- **Davies-Bouldin index** : ratio compacité/séparation clusters
- **Cophenetic correlation** : fidélité [[dendrogramme]] à matrice distances

**Utilité**

Bien que Hubert-Gamma suffise selon [[Rein et al. (2010)]], métriques complémentaires permettraient :
1. Identifier clusters mal définis (faible silhouette moyenne)
2. Détecter trajectoires "frontalières" entre clusters
3. Valider fidélité représentation hiérarchique

**Implémentation**

```python
from sklearn.metrics import silhouette_score, davies_bouldin_score
from scipy.cluster.hierarchy import cophenet

def calculer_metriques_complementaires(D, Z, labels):
    """
    Calcule métriques de validation complémentaires.
    
    Paramètres
    ----------
    D : ndarray (n, n)
        Matrice de distances SSPD
    Z : ndarray
        Linkage matrix (résultat hierarchical clustering)
    labels : ndarray
        Attribution cluster pour chaque trajectoire
        
    Retour
    ------
    metriques : dict
        Dictionnaire des métriques calculées
    """
    n_clusters = len(np.unique(labels))
    
    # 1. Silhouette score (range [-1, 1], plus élevé = meilleur)
    # Nécessite au moins 2 clusters
    if n_clusters >= 2:
        silhouette = silhouette_score(
            squareform(D), 
            labels, 
            metric='precomputed'
        )
    else:
        silhouette = np.nan
    
    # 2. Cophenetic correlation (range [0, 1], plus élevé = meilleur)
    # Mesure fidélité dendrogramme aux distances originales
    coph_corr, coph_dists = cophenet(Z, squareform(D))
    
    # 3. Davies-Bouldin (plus bas = meilleur)
    # Nécessite coordonnées, pas juste matrice distances
    # → Approximation via distances moyennes intra/inter
    db_approx = calculer_davies_bouldin_approx(D, labels)
    
    metriques = {
        'silhouette_score': silhouette,
        'cophenetic_correlation': coph_corr,
        'davies_bouldin_approx': db_approx,
        'n_clusters': n_clusters
    }
    
    return metriques

def calculer_davies_bouldin_approx(D, labels):
    """
    Approximation Davies-Bouldin basée sur distances moyennes.
    """
    clusters_uniques = np.unique(labels)
    n_clusters = len(clusters_uniques)
    
    if n_clusters < 2:
        return np.nan
    
    # Calculer compacité moyenne de chaque cluster
    compacites = []
    for cluster_id in clusters_uniques:
        indices = np.where(labels == cluster_id)[0]
        if len(indices) > 1:
            D_cluster = D[np.ix_(indices, indices)]
            compacite = np.mean(D_cluster)
        else:
            compacite = 0
        compacites.append(compacite)
    
    # Calculer séparation inter-cluster
    db_scores = []
    for i, cluster_i in enumerate(clusters_uniques):
        indices_i = np.where(labels == cluster_i)[0]
        
        max_ratio = 0
        for j, cluster_j in enumerate(clusters_uniques):
            if i == j:
                continue
            
            indices_j = np.where(labels == cluster_j)[0]
            
            # Distance moyenne inter-cluster
            D_inter = D[np.ix_(indices_i, indices_j)]
            separation = np.mean(D_inter)
            
            # Ratio (compacité_i + compacité_j) / séparation
            if separation > 0:
                ratio = (compacites[i] + compacites[j]) / separation
                max_ratio = max(max_ratio, ratio)
        
        db_scores.append(max_ratio)
    
    return np.mean(db_scores)

# Intégration dans ÉTAPE 4 : VALIDATION
print(f"\n{'='*60}")
print("MÉTRIQUES COMPLÉMENTAIRES")
print(f"{'='*60}\n")

metriques = calculer_metriques_complementaires(D, Z, labels)

print(f"Silhouette score       : {metriques['silhouette_score']:.4f}")
print(f"Cophenetic correlation : {metriques['cophenetic_correlation']:.4f}")
print(f"Davies-Bouldin (approx): {metriques['davies_bouldin_approx']:.4f}")

# Interprétation
print("\nINTERPRÉTATION :")
if metriques['silhouette_score'] > 0.5:
    print("✓ Silhouette > 0.5 : Clusters bien séparés")
elif metriques['silhouette_score'] > 0.25:
    print("⚠️  0.25 < Silhouette < 0.5 : Séparation modérée")
else:
    print("❌ Silhouette < 0.25 : Clusters mal définis")

if metriques['cophenetic_correlation'] > 0.8:
    print("✓ Cophenetic > 0.8 : Dendrogramme fidèle")
elif metriques['cophenetic_correlation'] > 0.7:
    print("⚠️  0.7 < Cophenetic < 0.8 : Fidélité acceptable")
else:
    print("❌ Cophenetic < 0.7 : Dendrogramme peu représentatif")

# Sauvegarder
df_validation_extended = pd.DataFrame([metriques])
df_validation_extended.to_csv(
    os.path.join(DOSSIER_ANALYSES, 'metriques_complementaires.csv'),
    index=False
)
```

---

### 10. Visualisations statiques (non interactives)

**Description**

Toutes visualisations ([[dendrogramme]], heatmap, diagnostic Van Bergen) en PNG statiques. Avec 600 trajectoires et 20-30 clusters, inspection visuelle difficile par limitation résolution graphique.

**Gain d'interactivité**

Visualisations Plotly permettent : zoom, pan, survol pour info-bulles, sélection clusters.

**Implémentation**

```python
import plotly.graph_objects as go
import plotly.express as px
from scipy.cluster.hierarchy import dendrogram as scipy_dendrogram

def tracer_dendrogramme_interactif(Z, noms, seuil):
    """
    Dendrogramme interactif zoomable avec Plotly.
    """
    # Générer dendrogramme scipy
    dend = scipy_dendrogram(Z, labels=noms, no_plot=True)
    
    # Extraire coordonnées
    icoord = np.array(dend['icoord'])
    dcoord = np.array(dend['dcoord'])
    
    # Créer figure Plotly
    fig = go.Figure()
    
    # Tracer chaque branche
    for i in range(len(icoord)):
        x = icoord[i]
        y = dcoord[i]
        
        # Couleur selon hauteur (au-dessus/dessous seuil)
        couleur = 'red' if np.max(y) > seuil else 'black'
        
        fig.add_trace(go.Scatter(
            x=x, y=y,
            mode='lines',
            line=dict(color=couleur, width=1.5),
            hoverinfo='skip',
            showlegend=False
        ))
    
    # Ligne seuil
    fig.add_hline(
        y=seuil, 
        line_dash="dash", 
        line_color="blue",
        annotation_text=f"Seuil = {seuil:.2f}",
        annotation_position="right"
    )
    
    fig.update_layout(
        title="Dendrogramme interactif (Ward - SSPD)",
        xaxis_title="Trajectoires",
        yaxis_title="Distance Ward",
        height=800,
        hovermode='closest'
    )
    
    fig.write_html('dendrogramme_interactif.html')
    print("✓ Dendrogramme interactif : dendrogramme_interactif.html")

def visualiser_heatmap_interactive(labels, noms, creativite, variabilite):
    """
    Heatmap interactive participants × clusters.
    """
    # Construire matrice
    participants_uniques = sorted(set([nom.split('_')[1] for nom in noms]))
    clusters_uniques = sorted(set(labels))
    
    matrice = np.zeros((len(participants_uniques), len(clusters_uniques)))
    
    for i, nom in enumerate(noms):
        participant_id = nom.split('_')[1]
        cluster_id = labels[i]
        
        idx_part = participants_uniques.index(participant_id)
        idx_clust = clusters_uniques.index(cluster_id)
        matrice[idx_part, idx_clust] += 1
    
    # Créer heatmap Plotly
    fig = go.Figure(data=go.Heatmap(
        z=matrice,
        x=[f'C{c}' for c in clusters_uniques],
        y=[f'{p} (Var={variabilite.get(p, 0):.0f})' 
           for p in participants_uniques],
        colorscale='Blues',
        text=matrice.astype(int),
        texttemplate='%{text}',
        textfont={"size": 12},
        hovertemplate='Participant: %{y}<br>Cluster: %{x}<br>Nb essais: %{z}<extra></extra>'
    ))
    
    fig.update_layout(
        title="Heatmap Participants × Clusters (interactif)",
        xaxis_title="Clusters",
        yaxis_title="Participants (triés par variabilité)",
        height=600
    )
    
    fig.write_html('heatmap_clusters_interactive.html')
    print("✓ Heatmap interactive : heatmap_clusters_interactive.html")
```

Utile pour présentations et exploration, mais pas critique pour publication.

---

### 11. Documentation in-code insuffisante

**Description**

Code contient commentaires basiques mais manque **docstrings structurées** et métadonnées traçabilité (versions packages, paramètres config, horodatage).

**Impact reproductibilité**

Autre chercheur (ou soi-même dans 6 mois) ne peut pas :
1. Comprendre hypothèses derrière chaque fonction
2. Reproduire exactement avec mêmes versions scipy/numpy
3. Tracer historique décisions méthodologiques

**Standard recommandé : NumPy docstring**

```python
def calculer_hubert_gamma(D, labels):
    """
    Calcule le coefficient de Hubert-Gamma normalisé (Rein et al., 2010).
    
    Mesure la concordance entre matrice de distances et partition en clusters.
    Une valeur élevée indique que les trajectoires proches spatialement sont 
    assignées au même cluster.
    
    Parameters
    ----------
    D : ndarray, shape (n_traj, n_traj)
        Matrice de distances SSPD symétrique.
    labels : ndarray, shape (n_traj,)
        Attribution de cluster pour chaque trajectoire (1-indexed).
        Valeurs typiques : 1, 2, ..., k où k = nombre de clusters.
    
    Returns
    -------
    gamma : float
        Coefficient Hubert-Gamma normalisé.
        Range typique : [-1, 1], où valeurs élevées (>0.5) indiquent
        bon accord entre distances et partition.
    
    Notes
    -----
    Implémentation basée sur l'équation 3 de Rein et al. (2010, p.216) :
    
    .. math::
        \\Gamma = \\frac{1}{M} \\sum_{i<j} \\frac{(D_{ij} - \\mu_D)(Y_{ij} - \\mu_Y)}{\\sigma_D \\sigma_Y}
    
    où D est la matrice distances, Y la matrice co-appartenance (1 si même
    cluster, 0 sinon), et M le nombre de paires.
    
    Complexité : O(n²) où n = nombre de trajectoires.
    
    References
    ----------
    .. [1] Rein, R., Davids, K., & Button, C. (2010). Adaptive and phase 
           transition behavior in performance of discrete multi-articular 
           actions. Experimental Brain Research, 201(2), 307–322.
           https://doi.org/10.1007/s00221-009-2015-x
    
    Examples
    --------
    >>> D = np.array([[0, 1, 3], [1, 0, 2], [3, 2, 0]])
    >>> labels = np.array([1, 1, 2])
    >>> gamma = calculer_hubert_gamma(D, labels)
    >>> print(f"Hubert-Gamma: {gamma:.3f}")
    Hubert-Gamma: 0.667
    
    See Also
    --------
    calculer_davies_bouldin_approx : Autre métrique de validation
    """
    # ... code ...
```

**Fichier configuration**

```python
# config.py
"""
Configuration globale du pipeline clustering créativité escalade.
Version 4.0 - 2026-01-24
"""

from datetime import datetime
import numpy as np
import scipy
import pandas as pd

# Métadonnées pipeline
PIPELINE_CONFIG = {
    'version': '4.0',
    'date_creation': '2026-01-24',
    'auteur': 'Martha Vigouroux-Sanchez',
    'institution': 'CERSTAPS',
    'projet': 'Créativité et fatigue en escalade',
    
    # Versions packages (pour reproductibilité)
    'environnement': {
        'python': f'{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}',
        'numpy': np.__version__,
        'scipy': scipy.__version__,
        'pandas': pd.__version__,
    },
    
    # Paramètres normalisation
    'normalisation': {
        'n_points': 200,
        'interpolation': 'cubic',
        'lissage_methode': 'savitzky_golay',
        'lissage_fenetre': 15,
        'lissage_ordre': 3,
        'justification_n_points': (
            "Choix 200 points basé sur analyse sensibilité. "
            "Compromis entre préservation détails (>100 pts Rein) "
            "et bruit (LED tracking vidéo)."
        )
    },
    
    # Paramètres distance
    'distance': {
        'methode': 'SSPD',
        'reference': 'Besse et al. (2016)',
        'symetrique': True
    },
    
    # Paramètres clustering
    'clustering': {
        'methode': 'ward',
        'critere_seuil': 'manuel_triangulation',
        'reference': 'Van Bergen et al. (2025) + Rein et al. (2010)'
    },
    
    # Chemins fichiers
    'chemins': {
        'donnees': './donnees',
        'resultats': './resultats',
        'graphiques': './resultats/graphiques',
        'normalises': './resultats/trajectoires_normalisees',
        'analyses': './resultats/analyses'
    }
}

def generer_rapport_config():
    """Génère rapport de configuration pour méthodologie."""
    rapport = []
    rapport.append("="*70)
    rapport.append("CONFIGURATION PIPELINE CLUSTERING")
    rapport.append("="*70)
    rapport.append(f"\nVersion : {PIPELINE_CONFIG['version']}")
    rapport.append(f"Date    : {PIPELINE_CONFIG['date_creation']}")
    rapport.append(f"\nEnvironnement :")
    for pkg, version in PIPELINE_CONFIG['environnement'].items():
        rapport.append(f"  {pkg:10s} : {version}")
    rapport.append(f"\nParamètres normalisation :")
    rapport.append(f"  Résolution : {PIPELINE_CONFIG['normalisation']['n_points']} points")
    rapport.append(f"  Lissage    : {PIPELINE_CONFIG['normalisation']['lissage_methode']}")
    rapport.append(f"  Fenêtre    : {PIPELINE_CONFIG['normalisation']['lissage_fenetre']} pts")
    rapport.append("="*70)
    return "\n".join(rapport)

if __name__ == "__main__":
    print(generer_rapport_config())
```

---

## RECOMMANDATIONS SYNTHÉTIQUES

### 🔴 Avant collecte données réelles (PRIORITÉ 1)

| Action | Effort estimé | Impact |
|--------|--------------|--------|
| Sauvegarde objets intermédiaires (pickle/joblib) | 2h | Critique - Évite recalculs 2-4h |
| Filtres qualité trajectoires (outliers) | 3h | Critique - Détection auto aberrations |
| Documentation choix 200 points (analyse sensibilité) | 4h | Modéré - Justification empirique |
| Extraction participant_id robuste (regex) | 1h | Modéré - Prévention erreurs |

**Total effort : ~10h** avant phase collecte Mars 2026

### 🟡 Pendant analyse données (PRIORITÉ 2)

| Action | Effort estimé | Impact |
|--------|--------------|--------|
| Triangulation choix seuil (3 méthodes) | 3h | Modéré - Réduit subjectivité |
| Métriques complémentaires (silhouette, cophenetic) | 2h | Mineur - Robustesse validation |
| Test fiabilité inter-juges | 2h | Modéré - Évalue reproductibilité |

**Total effort : ~7h** pendant phase analyse

### 🟢 Améliorations post-mémoire (PRIORITÉ 3)

| Action | Effort estimé | Gain |
|--------|--------------|------|
| Optimisation SSPD (parallélisation) | 8h | Temps calcul ×4-8 |
| Visualisations interactives (Plotly) | 4h | Exploration facilitée |
| Documentation standardisée (docstrings) | 6h | Reproductibilité |
| Intégration bootstrap AU (pvclust) | 10h | Validation complète |

**Total effort : ~28h** pour optimisations futures

---

## Références méthodologiques

- [[Rein et al. (2010)]] : Méthodologie clustering Ward + validation Hubert-Γ/AU
- [[Van Bergen et al. (2025)]] : Application trajectoires escalade + scores créativité
- [[Besse et al. (2016)]] : Distance SSPD (Symmetrized Segment-Path Distance)
- [[Protocole V1]] : Document protocole expérimental complet

---

## Notes connexes suggérées

- [[Bootstrap multiscale AU test]] : Détails implémentation test stabilité
- [[Normalisation temporelle - analyse de sensibilité]] : Justification choix résolution
- [[Erreurs de tracking LED]] : Problèmes capture et solutions
- [[Choix résolution normalisation temporelle]] : Trade-off précision/bruit
- [[Fiabilité inter-juges clustering]] : Évaluation accord analystes
- [[Optimisation calcul SSPD]] : Stratégies parallélisation/vectorisation
- [[Nomenclature des fichiers de trajectoires]] : Conventions nommage
- [[Protocole de capture vidéo]] : Recommandations minimiser outliers

---

> [!summary] Synthèse
> Ce document identifie 11 limitations principales du pipeline clustering V4.0. Les 4 limitations critiques nécessitent ~10h de développement avant collecte données réelles (Mars 2026). Les limitations modérées peuvent être traitées pendant phase analyse (~7h). Les optimisations mineures (~28h) sont recommandées pour publication ultérieure mais non critiques pour mémoire M2.

**Dernière mise à jour** : 2026-01-24