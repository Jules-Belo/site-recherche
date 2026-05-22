---
type: hub-concept
project: Effets de la fatigue musculaire sur la créativité en escalade de bloc
created: 2025-01-04
updated: 2025-01-04
tags: [projet-master, hub-concept, escalade, créativité, fatigue]
---
## 📊 Architecture conceptuelle
---

```dataview
TABLE
  type AS "Type",
  tags AS "Tags",
  created AS "Créée"
FROM "NOTES PERMANENTES/Concepts"
WHERE file.name != "00 - CONCEPT"
SORT type DESC, file.name ASC
```

---

## 🔗 Cartographie des dimensions du projet

### Dimension 1 : État physiologique (VI1 - Fatigue musculaire)

| Concept                       | Définition                                                               | Instrument                                      |
| ----------------------------- | ------------------------------------------------------------------------ | ----------------------------------------------- |
| [[fatigue musculaire]]        | Diminution transitoire de la capacité à produire de la force post-effort | SmartBoard (protocole de fatigue contrôlée)     |
| [[État physiologique]]        | État d'entraînement/désentraînement et de forme/méforme du participant   | Mesure de force, RFD, puissance                 |
| [[Physiologie de la fatigue]] | Mécanismes sous-jacents (cérébraux, neuromusculaires)                    | Analyse cinétique SmartBoard                    |
| [[capacités d'action]]        | Ensemble des possibilités motrices actuelles du grimpeur                 | Trajectoires LED + analyse vidéo                |
| [[Affordances]]               | Possibilités d'action perçues relatives aux prises du bloc               | Interaction grimpeur-bloc (avant/après fatigue) |

**Mesure opérationnelle** : Perte de force (%) entre condition non-fatigué vs fatigué

---

### Dimension 2 : Profil psychologique (VI2 - Orientation régulatrice)

| Concept                          | Définition                                                        | Instrument                           |
| -------------------------------- | ----------------------------------------------------------------- | ------------------------------------ |
| [[orientation régulatrice]]      | Mode de régulation motivationnelle : promotion vs prévention      | [[Questionnaire d'Orientation Régulatrice en Sport (QORS)]] (Debanne, 2022)             |
| [[Profil psychologique]]         | Ensemble des caractéristiques psychologiques du participant       | [[Questionnaire d'Orientation Régulatrice en Sport (QORS)]] + [[ECCI-i-FR]]             |
| [[créativité générale]]          | Trait de créativité général mesuré en contexte de vie quotidienne | [[ECCI-i-FR]] (Delpech et al., 2020) |
| [[Psychologie de la créativité]] | Fondements théoriques de la créativité                            | Sternberg & Lubart (1998)            |

**Mesure opérationnelle** : Score différentiel (Promotion - Prévention) via QORS

---

### Dimension 3 : Performance créative (VD - Créativité en escalade)

| Concept                       | Définition                                                         | Instrument                                |
| ----------------------------- | ------------------------------------------------------------------ | ----------------------------------------- |
| [[créativité motrice]]        | Actions originales et fonctionnelles émergeant du couplage P-A     | Analyse vidéo trajectoires LED            |
| [[variabilité fonctionnelle]] | Nombre de trajectoires distinctes (approches différentes réussies) | Clustering hiérarchique [[Kinovea]]       |
| [[originalité]]               | Rareté statistique d'une trajectoire (1/Prévalence)                | Ratio de prévalence inter-participants    |
| [[Fonctionnalité]]            | Contribution de l'action à la réussite du bloc                     | Filtre : essais réussis uniquement        |
| [[Actions créatives]]         | Production de solutions novatrices et adaptées au problème         | Score combiné (variabilité + originalité) |

**Mesure opérationnelle** : Score de créativité = Σ(1/Prévalence_i) pour trajectoires réussies

---

## 📐 Modèles théoriques sous-jacents

```dataview
TABLE
  file.name AS "Théorie/Modèle",
  tags AS "Domaine"
FROM "NOTES PERMANENTES/Concepts"
WHERE contains(file.name, "Modèle") OR contains(file.name, "Approche") OR contains(file.name, "Dynamique") OR contains(file.name, "Couplage")
SORT file.name ASC
```

---

## 🔬 Méthodologie associée

### Instruments de mesure

| Instrument            | Concept mesuré                     | Temps administration       | Notes                               |
| --------------------- | ---------------------------------- | -------------------------- | ----------------------------------- |
| [[Questionnaire d'Orientation Régulatrice en Sport (QORS)]]              | Orientation régulatrice            | J-1 (en ligne)             | 12 items, Likert 1-7                |
| [[ECCI-i-FR]]         | Créativité générale                | J-1 (en ligne)             | 26 items, Likert 1-5                |
| [[SmartBoard]]        | Fatigue musculaire induite         | Jour de test (entre blocs) | Mesure force, RFD, cinétique        |
| [[LED]] + [[Kinovea]] | Trajectoires du centre de gravité  | Jour de test (bloc 1 et 2) | Marqueur 2D, clustering             |
| Caméra GoPro          | Trajectoires + stratégies motrices | Jour de test (bloc 1 et 2) | Analyse qualitative et quantitative |

### Tâches expérimentales

```dataview
TABLE
  file.name AS "Concept-tâche",
  tags AS "Type"
FROM "NOTES PERMANENTES/Concepts"
WHERE contains(file.name, "Tâche") OR contains(file.name, "Bloc") OR contains(file.name, "Exploration")
```

---

## 🎯 Hypothèses opérationnelles

**H1 (Fatigue × Créativité)** : La fatigue musculaire diminue le score de créativité

> VD(condition fatigué) < VD(condition non-fatigué)

**H2 (Orientation régulatrice × Créativité)** : L'orientation "promotion" favorise la créativité indépendamment de la fatigue

> VD(promotion, fatigué) > VD(prévention, fatigué)
>
> VD(promotion, non-fatigué) > VD(prévention, non-fatigué)

**Interaction attendue** : L'orientation "promotion" pourrait compenser partiellement l'effet délétère de la fatigue

---

## 📚 Concepts pivots du projet

Les concepts ci-dessous sont centraux pour comprendre les mécanismes en jeu :

```dataview
TABLE
  type AS "Type",
  file.name AS "Concept",
  length(sources) AS "Nb sources"
FROM "NOTES PERMANENTES/Concepts"
WHERE contains(tags, "concept") AND (contains(tags, "créativité") OR contains(tags, "escalade") OR contains(tags, "dynamique") OR contains(tags, "affordances"))
SORT type DESC, file.name ASC
```

---

## 🔍 Pistes de liaison conceptuelle

### Lien 1 : Fatigue → Modification des affordances → Réduction créativité

[[fatigue musculaire]] → [[capacités d'action]] ↓ → [[Affordances]] réduites → Solutions motrices ↓ → [[variabilité fonctionnelle]] ↓

### Lien 2 : Profil psychologique → Stratégie d'exploration → Créativité motrice

[[orientation régulatrice]] (promotion) → Exploration des contraintes → [[Actions créatives]] → [[originalité]] ↑

### Lien 3 : Interactivité complexe

[[fatigue musculaire]] + [[orientation régulatrice]] → Modification [[Couplage perception-action]] → [[Émergence]] de nouvelles solutions (ou absence de)

---

## 📖 Flux temporel du protocole

1. **J-1** : Administration [[Questionnaire d'Orientation Régulatrice en Sport (QORS)]] + [[ECCI-i-FR]] (en ligne)
2. **Jour J - Phase 1** : Échauffement + Bloc 1 (condition non-fatigué, 10 min) → LED fixée, trajectoires enregistrées
3. **Jour J - Phase 2** : Protocole fatigue [[SmartBoard]] (mesure force max, puis protocole 80% force)
4. **Jour J - Phase 3** : Bloc 2 (condition fatigué, 10 min) → Trajectoires enregistrées

**Durée totale** : 1h-2h par participant | **Collecte vidéo** : 2 blocs × multiples essais

---

## 💾 Analyse des données

### Pipeline d'analyse créativité

1. **Traitement vidéo** : [[Kinovea]] → trajectoires LED en coords 2D
2. **Clustering** : Regroupement trajectoires similaires (hiérarchique)
3. **Variabilité** : Nombre de clusters distincts par participant et condition
4. **Originalité** : Ratio 1/Prévalence(i) pour chaque cluster
5. **Score créativité** : Σ(1/Prévalence_i) pour essais réussis

### Tests statistiques

- Normalité : Kolmogorov-Smirnov (scores créativité)
- Effet fatigue : t-test apparié (avant vs après fatigue)
- Effet orientation : t-test indépendant (promotion vs prévention)
- Bonferroni : Correction pour comparaisons multiples ECCI-i-FR

---

## 🌐 Intégrations disciplinaires

```dataview
TABLE
  file.name AS "Concept",
  tags AS "Domaine(s) pertinent(s)"
FROM "NOTES PERMANENTES/Concepts"
WHERE contains(tags, "dynamique") OR contains(tags, "biomécanique") OR contains(tags, "psychologie") OR contains(tags, "neurologie")
SORT file.name ASC
```

---

## 📎 Documents de référence

- **CERSTAPS_Martha-Vigouroux-Sanchez_Creativite__et_escalade_Vfinale_12_dec.docx** (protocole complet)
- **Questionnaires** : QORS (Debanne, 2022) + ECCI-i-FR (Delpech et al., 2020)
- **Instruments** : SmartBoard, LED, Kinovea, Caméra GoPro

---

## 🔗 Voir aussi

- **Lien inter-concepts** : [[Liens entre les concepts]]
- **Hub rédaction** : [[Rédaction]]
- **MOC Principal** : [[🗺️ MOC Principal]]
