---
type: méthodo
tags: [questionnaire, cotation, items_inversés, ECCI-i-FR, QORS, BFI-Fr]
sources: [Delpech et al. (2020), Epstein et al. (2008), Debanne (2022), Plaisant et al. (2010)]
created: 2026-04-09
---

# Cotation : items inversés — ECCI-i-FR, QORS, BFI-Fr

> **Formule générale d'inversion** : `score_inversé = (max_échelle + 1) − score_brut`  
> ECCI-i-FR et BFI-Fr : `6 − score_brut` (échelle 1–5)  
> QORS : pas d'inversion (voir ci-dessous)

---

## ECCI-i-FR — 4 items à inverser

| Item   | Formulation                                                                        | Dimension   | Certitude                                                                                        |
| ------ | ---------------------------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------ |
| **2**  | *"Je note mes nouvelles idées seulement quand je suis prêt.e à m'en servir"*       | Capturing   | ⚠️ Signe − omis dans Delpech, mais corrélation item-total = .33 (positive) → inversion implicite |
| **7**  | *"Habituellement, je ne lis que des revues portées sur mon domaine de compétence"* | Broadening  | ✓ Marqué −7 explicitement dans Delpech et al. (2020)                                             |
| **9**  | *"Je n'aime pas travailler sur des tâches complexes"*                              | Challenging | ⚠️ Signe − omis dans Delpech, mais corrélation item-total = .35 (positive) → inversion implicite |
| **10** | *"Quand mes idées sont peu claires, j'ai parfois besoin de changer d'air"*         | Capturing   | ✓ Marqué −10 explicitement dans Delpech et al. (2020)                                            |

**Justification** : Dans l'ECCI-i original (Epstein et al., 2008), les items à formulation négative sont des *dummy items* reverse-scored utilisés uniquement pour calculer un score de cohérence interne (ICS) — ils ne contribuent pas aux scores de sous-échelle. Delpech et al. les ont intégrés comme items réguliers dans la version française. Les items 2 et 9 présentent une formulation négative claire mais le signe − est absent du texte publié : l'erreur typographique est révélée par le fait que leurs corrélations item-total sont positives (.33 et .35), ce qui serait impossible sans inversion préalable.

**⚠️ Vérifier dans LimeSurvey** si la configuration a automatiquement géré l'inversion avant d'appliquer le traitement en Python (pour ne pas inverser deux fois).

---

## QORS — Aucun item inversé

Les 12 items retenus (7 Promotion + 5 Prévention) sont tous formulés positivement dans le sens de leur sous-échelle. Scoring direct : moyenne des 7 items Promotion → score promotion ; moyenne des 5 items Prévention → score prévention. Confirmé par le Tableau 3 de Debanne (2022) : aucun poids factoriel négatif sur la dimension correspondante.

---

## BFI-Fr — 5 items à inverser (sous-échelles utilisées uniquement)

| Sous-échelle | Items inversés | Formulation type |
|---|---|---|
| Extraversion (items 1,6,11,16,21,26,31,36) | **6, 21, 31** | Traits d'introversion (*"est réservé"*, *"est peu communicatif"*, *"est discret"*) |
| Ouverture (items 5,10,15,20,25,30,35,40,41,44) | **35, 41** | Traits de fermeture (*"peu d'imagination"*, *"peu curieux"*) |

Source : John et al. (1999) via Plaisant et al. (2010). Numérotation selon le BFI-Fr complet à 45 items.

---

**Voir aussi** : [[ECCI-i-FR]] • [[Questionnaire d'Orientation Régulatrice en Sport (QORS)]] • [[Profil psychologique]]
