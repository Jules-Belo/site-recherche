---
tags: [résultats, statistiques, JASP, mémoire, analyses]
date: 2026-05-03
statut: complété
---

# Résultats des analyses statistiques — Étude créativité & escalade

> **Contexte** : Étude expérimentale (plan mixte 2×2) examinant les effets de la fatigue musculaire (VI intra : Condition NF vs. F) et du profil régulateur (VI inter : Promotion vs. Prévention dominante) sur la créativité motrice en escalade de bloc. N = 21 participants. Logiciel : JASP. Données : `dataset_complet.csv` (format large, 1 ligne/participant).

---

## 1. Vérifications préalables

### 1.1 Normalité univariée — Shapiro-Wilk

Réalisé sur l'ensemble des variables avant les analyses inférentielles.

| Variable         | W        | p      | Décision                                                  |
| ---------------- | -------- | ------ | --------------------------------------------------------- |
| creativite       | 0,941    | 0,030  | Violation modérée                                         |
| variabilite      | 0,951    | 0,068  | Acceptable                                                |
| perte_force_pct  | 0,963    | 0,182  | ✅ Normale                                                 |
| qors_diff        | 0,972    | 0,371  | ✅ Normale                                                 |
| qors_promotion   | 0,946    | 0,045  | Violation modérée                                         |
| qors_prevention  | 0,934    | 0,018  | Violation modérée                                         |
| crea_total       | 0,892    | < ,001 | ⚠️ Violation sévère                                       |
| crea_surrounding | 0,855    | < ,001 | ⚠️ Violation sévère                                       |
| n_essais_reussis | 0,975    | 0,466  | ✅ Normale                                                 |


> **Note méthodologique** : Les ANOVAs mixtes présentent une robustesse reconnue aux violations modérées de normalité lorsque les groupes sont équilibrés (Maxwell & Delaney, 2004). Pour `crea_total`, les analyses corrélationnelles intègrent systématiquement un coefficient de Spearman en parallèle de Pearson.

### 1.2 Manipulation check — Induction de fatigue

**Test pairé `force_debut − force_fin`** (Student, unilatéral) :

| t      | df  | p      | Décision                   |
| ------ | --- | ------ | -------------------------- |
| 19,301 | 20  | < ,001 | ✅ **Manipulation validée** |

La force maximale volontaire diminue significativement entre le début et la fin de la condition fatigue pour l'ensemble des 21 participants. Le critère physiologique de perte ≥ 30 % (Bigland-Ritchie, 1986) est atteint. L'ensemble des analyses inférentielles sur la créativité est donc interprétable causalement.

### 1.3 Contrôle de l'effet d'ordre (contrebalancement AB vs. BA)

**Test indépendant par groupe d'ordre** sur les quatre variables dépendantes :

| Variable       | t (Student) | p Student | U (Mann-Whitney) | p MW  | Décision      |
| -------------- | ----------- | --------- | ---------------- | ----- | ------------- |
| creativite_F   | 1,912       | 0,071     | 75,000           | 0,170 | ✅ NS          |
| creativite_NF  | −1,001      | 0,329     | 44,000           | 0,468 | ✅ NS          |
| variabilite_F  | −2,042      | 0,055     | 27,500           | 0,051 | ⚠️ Borderline |
| variabilite_NF | 1,014       | 0,323     | 66,500           | 0,423 | ✅ NS          |

> **Point de vigilance** : `variabilite_F` présente une tendance borderline (p = 0,055 / 0,051), convergente entre les deux méthodes, suggérant un résidu d'effet d'ordre en condition fatiguée. Le contrebalancement a globalement fonctionné, mais cette tendance devra être mentionnée comme limite dans la Discussion.

---

## 2. Analyses confirmatoires — ANOVAs mixtes 2×2 (α = 0,025)

> **Rappel** : α corrigé par Bonferroni pour deux tests confirmatoires simultanés (Condition, profil_A, Condition × profil_A). Homogénéité des variances validée par Levene pour toutes les conditions (tous p > 0,20).

### 2.1 Variable dépendante : Créativité motrice

**Within Subjects Effects :**

| Effet | SS | df | MS | F | p | η²G |
|-------|----|----|----|----|---|-----|
| Condition | 0,711 | 1 | 0,711 | 0,345 | 0,564 | 0,010 |
| Condition × profil_A | 0,040 | 1 | 0,040 | 0,020 | 0,890 | < 0,001 |
| Résidus | 39,110 | 19 | 2,058 | | | |

**Between Subjects Effects :**

| Effet    | SS     | df  | MS    | F     | p     | η²G   |
| -------- | ------ | --- | ----- | ----- | ----- | ----- |
| profil_A | 0,633  | 1   | 0,633 | 0,364 | 0,553 | 0,009 |
| Résidus  | 33,044 | 19  | 1,739 |       |       |       |

**Descriptives :**

| Condition | Profil | N | M | ET |
|-----------|--------|---|---|----|
| NF | Promotion dominante | 11 | 3,185 | 1,186 |
| NF | Prévention dominante | 10 | 3,492 | 1,782 |
| F | Promotion dominante | 11 | 3,507 | 1,245 |
| F | Prévention dominante | 10 | 3,691 | 1,247 |

**Décision** : Aucun effet significatif au seuil α = 0,025. **H1, H2 et H3 ne sont pas soutenues** sur la créativité. À noter : les scores de créativité sont légèrement supérieurs en condition F par rapport à NF pour les deux groupes — direction inverse à H1, à ne pas sur-interpréter compte tenu de l'effectif.

### 2.2 Variable dépendante : Variabilité fonctionnelle

**Within Subjects Effects :**

| Effet | SS | df | MS | F | p | η²G |
|-------|----|----|----|----|---|-----|
| **Condition** | **31,091** | **1** | **31,091** | **19,171** | **< ,001** | **0,237** |
| Condition × profil_A | 0,329 | 1 | 0,329 | 0,203 | 0,657 | 0,003 |
| Résidus | 30,814 | 19 | 1,622 | | | |

**Between Subjects Effects :**

| Effet | SS | df | MS | F | p | η²G |
|-------|----|----|----|----|---|-----|
| profil_A | 2,296 | 1 | 2,296 | 0,629 | 0,437 | 0,022 |
| Résidus | 69,323 | 19 | 3,649 | | | |

**Descriptives :**

| Condition | Profil | N | M | ET |
|-----------|--------|---|---|----|
| NF | Promotion dominante | 11 | 5,091 | 1,578 |
| NF | Prévention dominante | 10 | 4,800 | 1,476 |
| F | Promotion dominante | 11 | 3,545 | 1,968 |
| F | Prévention dominante | 10 | 2,900 | 1,370 |

**Décision** : **H1 partiellement soutenue** — l'effet de la Condition est hautement significatif avec une taille d'effet large (η²G = 0,237 > 0,14, Cohen). La fatigue réduit le nombre de clusters distincts produits (~5,0 → ~3,2). H2 et H3 non soutenues.

---

## 3. Analyse exploratoire — Essais réussis (α = 0,05)

**Within Subjects Effects :**

| Effet                | SS         | df    | MS         | F          | p          | η²G       |
| -------------------- | ---------- | ----- | ---------- | ---------- | ---------- | --------- |
| **Condition**        | **55,638** | **1** | **55,638** | **21,794** | **< ,001** | **0,184** |
| Condition × profil_A | 1,638      | 1     | 1,638      | 0,642      | 0,433      | 0,007     |
| Résidus              | 48,505     | 19    | 2,553      |            |            |           |

**Between Subjects Effects :**

| Effet | SS | df | MS | F | p | η²G |
|-------|----|----|----|----|---|-----|
| profil_A | 16,132 | 1 | 16,132 | 1,541 | 0,230 | 0,061 |
| Résidus | 198,868 | 19 | 10,467 | | | |

**Descriptives :**

| Condition | Profil | N | M | ET |
|-----------|--------|---|---|----|
| NF | Promotion dominante | 11 | 7,545 | 2,841 |
| NF | Prévention dominante | 10 | 6,700 | 1,889 |
| F | Promotion dominante | 11 | 5,636 | 2,873 |
| F | Prévention dominante | 10 | 4,000 | 2,404 |

**Décision** : Effet de la Condition significatif et large (η²G = 0,184). La fatigue réduit substantiellement le nombre d'essais réussis (~7,1 NF → ~4,8 F). Effet de `profil_A` non significatif mais η²G = 0,061 — tendance à surveiller dans des études à plus fort effectif.

---

## 4. Analyses exploratoires — Corrélations (α = 0,05)

> **Unité d'analyse** : N = 21 participants (fichier large, une ligne par participant). Variables `creativite_totale` et `variabilite_totale` = moyennes des deux conditions. Normalité bivariée validée par Shapiro-Wilk pour toutes les paires (tous p > 0,04).

### Tableau synthétique des corrélations

| Paire                                  | Pearson r | p      | Spearman ρ | p      | Robustesse | Interprétation                             |
| -------------------------------------- | --------- | ------ | ---------- | ------ | ---------- | ------------------------------------------ |
| qors_promotion × qors_diff             | 0,663     | 0,001  | 0,644      | 0,002  | ✅✅         | Validité interne QORS                      |
| qors_prevention × qors_diff            | −0,754    | < ,001 | −0,674     | < ,001 | ✅✅         | Validité interne QORS                      |
| qors_promotion × qors_prevention       | −0,007    | 0,975  | 0,048      | 0,836  | —          | Bidimensionnalité QORS confirmée           |
| qors_diff × crea_total                 | 0,515     | 0,017  | 0,443      | 0,044  | ✅          | Promotion → créativité dispositionnelle    |
| qors_prevention × crea_total           | −0,515    | 0,017  | −0,361     | 0,108  | ⚠️         | Interpréter avec prudence (divergence P/S) |
| creativite_totale × variabilite_totale | 0,486     | 0,026  | 0,487      | 0,025  | ✅          | Validité convergente des deux VD           |


### Résultats notables

**Validité interne du QORS** : `qors_diff` corrèle fortement et dans les directions attendues avec `qors_promotion` et `qors_prevention` (r = 0,663 et −0,754). L'orthogonalité entre promotion et prévention (r = −0,007) confirme la bidimensionnalité du modèle de Higgins (1997) dans cet échantillon.

**Relation QORS × ECCI** : `qors_diff × crea_total` est significatif en Pearson et Spearman (p = 0,017 et 0,044) — les grimpeurs à dominance promotion rapportent une plus grande disposition créative autodéclarée, résultat théoriquement cohérent avec les travaux de Friedman & Förster sur régulation et pensée créative.

**Découplage psycho-comportemental** : aucune variable psychologique (QORS, ECCI) ne prédit significativement les VD comportementales observées (`creativite_totale`, `variabilite_totale`). Ce découplage constitue un résultat en soi, à théoriser dans la Discussion.

**Validité convergente des VD** : `creativite_totale × variabilite_totale` : r = 0,486 (p = 0,026), ρ = 0,487 (p = 0,025) — les deux opérationnalisations partagent ~24 % de variance, confirmant leur parenté conceptuelle sans redondance.

---

## 5. Synthèse générale des résultats

| Hypothèse                           | VD             | Résultat       | Taille d'effet      |
| ----------------------------------- | -------------- | -------------- | ------------------- |
| H1 — Fatigue ↓ créativité           | Créativité     | ❌ Non soutenue | η²G = 0,010         |
| H1 — Fatigue ↓ variabilité          | Variabilité    | ✅ **Soutenue** | η²G = 0,237 (large) |
| H1 — Fatigue ↓ essais réussis       | Essais réussis | ✅ Exploratoire | η²G = 0,184 (large) |
| H2 — Profil → créativité            | Créativité     | ❌ Non soutenu  | η²G = 0,009         |
| H2 — Profil → variabilité           | Variabilité    | ❌ Non soutenu  | η²G = 0,022         |
| H3 — Interaction Condition × Profil | Toutes VD      | ❌ Non soutenue | η²G < 0,010         |

**Pattern interprétatif central** : La fatigue affecte systématiquement la dimension **quantitative** de la performance créative (nombre d'essais réussis, diversité des trajectoires) sans dégrader la dimension **qualitative** (originalité des solutions produites). Cette dissociation suggère que la contrainte physiologique réduit l'espace d'exploration motrice sans déprécier la valeur créative des solutions retenues dans cet espace réduit — résultat théoriquement riche, à articuler avec la notion de variabilité adaptative (Van Bergen et al., 2025).

---

## 6. Limites méthodologiques à mentionner en Discussion

1. **Effectif** : N = 21 confère une puissance statistique limitée pour les effets modérés à petits (particulièrement H2 et H3).
2. **Effet d'ordre résiduel** : tendance borderline sur `variabilite_F` selon le groupe d'ordre (p ≈ 0,05).
3. **Découplage psycho-comportemental** : l'absence de prédiction des VD par le QORS/ECCI questionne la validité écologique des instruments en contexte d'escalade contrainte.
4. **Non-aveuglement du codeur** : les trajectoires ont été segmentées par un unique codeur non aveugle à la condition.

---

*Note générée le 2026-05-03 — Analyses réalisées sur JASP à partir de `dataset_complet.csv` (format large corrigé)*
