---
type: documentation
tags: [documentation, méthode, template]
created: 2025-01-03
---
# Instructions : Analyse Standardisée d'Articles Scientifiques

## Objectif

Créer des fiches d'analyse complètes, structurées et concises pour tous les articles du corpus de recherche M2 sur **fatigue musculaire, profil psychologique et créativité en escalade**.

---

## Workflow Automatique

### **Localisation Automatique du PDF** 

**Instructions pour Claude** :

1. Quand je mentionne un article (auteur + année), chercher **automatiquement** dans :
    - Notes Obsidian existantes (via `obsidian_simple_search`)
    - Fichier extraction si existe : `RESSOURCES/Articles/[Auteur] et al. ([Année]) extraction.md`
    - Fichiers récemment uploadés dans la session en cours
    
2. **Si PDF uploadé dans la conversation** : Le lire directement (privilégie toujours l'analyse de l'article en anglais plutôt que de celui en français) et l'utiliser comme base principale

3. **Si fichier extraction trouvé** : L'utiliser comme base secondaire
    
4. **Si ni extraction ni upload** : Demander poliment à l'utilisateur :
    - "Tu as oublié d'uploader le PDF de [Auteur et al. (Année)]."

5. **Approche combinée optimale** : PDF uploadé + fichier extraction existant = analyse la plus complète
    
6. **NE JAMAIS** :
    - Tenter de lire les PDF via `view` dans `/mnt/project/` (format binaire inutilisable)
    - Utiliser `pdftotext` ou autres outils CLI (résultats insuffisants)
    - Annoncer des limitations techniques avant d'avoir testé les sources disponibles

---

### **Flux de Travail Type**

```
USER: "Analyse Van Bergen et al. (2025)"
    ↓
CLAUDE: [Recherche automatique dans Obsidian]
    ↓
OPTION A - PDF uploadé dans conversation + fichier extraction :
    ├─→ [Lit directement le PDF uploadé]
    ├─→ [Vérifie si fichier extraction existe pour compléter]
	    ├─→ [Lit RESSOURCES/Articles/Van Bergen et al. (2025) extraction.md]
    └─→ [Crée fiche complète]

OPTION A - PDF déjà uploadé dans conversation (sans fichier extraction) :
    ├─→ [Lit directement le PDF uploadé]
    ├─→ [Vérifie si fichier extraction existe pour compléter]
    ├─→ [Crée fiche complète]
    └─→ [Si fichier extraction n'existe pas indique le après création de la fiche dans l'interface claude]

OPTION B - Ni extraction ni PDF :
    ├─→ "Pourriez-vous uploader le PDF de Van Bergen et al. (2025) ?"
    └─→ [Attend upload → OPTION B]
    
TOUTES OPTIONS :
    ↓
CLAUDE: [Sauvegarde dans RESSOURCES/Articles/Van Bergen et al. (2025).md]
```

---

### **Ordre de Priorité des Sources** (NOUVELLE SECTION)

Pour garantir la meilleure qualité d'analyse, voici l'ordre de priorité des sources :

| Rang  | Source                            | Avantages                                                                                 | Limitations                         |
| ----- | --------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------- |
| **1** | PDF uploadé + Extraction Obsidian | Texte intégral anglais (ou français mais privilégier l'anglais) + annotations thématiques | Nécessite les deux fichiers         |
| **2** | PDF uploadé seul                  | Texte complet, structure intacte, citations exactes                                       | Pas d'annotations préexistantes     |
| **3** | Extraction Obsidian seule         | Notes thématiques, citations clés, liens existants                                        | Peut être en français, incomplet    |
| **4** | Recherche web (si autorisée)      | Métadonnées, abstract, contexte                                                           | Texte intégral souvent inaccessible |

**Règle d'or** : Toujours privilégier la combinaison (1) ou au minimum (2) pour les articles majeurs (statut 🔴 ou 🟠).

---

## Structure du Fichier Final

### Emplacement
`RESSOURCES/Articles/[Auteur et al. (Année)].md`

### Template Complet

```markdown
---
type: article
title: "[Titre complet de l'article]"
authors: [Auteur1, Auteur2, Auteur3]
year: YYYY
journal: [Nom du journal]
doi: XX.XXXX/xxxxx
tags: [thème1, thème2, thème3]
status: [🔴 Fondateur | 🟠 Important | 🟡 Complémentaire | ⚪ Contexte]
---

# [Titre de l'article]

**Citation complète APA** : Auteur, A., Auteur, B., & Auteur, C. (YYYY). Titre de l'article. *Nom du Journal*, *Volume*(Numéro), Pages. https://doi.org/XX.XXXX/xxxxx

---

## Typologie de l'article

moc:: [[02 - MOC Créativité et Escalade]] | [[03 - MOC Fatigue et Performance]] | [[04 - MOC Psychologie du Sport]]
citation:: [Citation APA complète]
type_etude:: [Expérimentale | Théorique | Revue systématique | Méta-analyse | Étude de cas]
approche:: [Psychologique | Biomécanique | Écologique | Physiologique | Mixte]
mots_cles:: #mot1 #mot2 #mot3 #mot4
pdf:: [[Nom du fichier.pdf]]
discipline:: [Discipline principale, sous-discipline]

---

## 📋 Résumé

[2-3 phrases synthétisant l'article : problématique, approche, résultat principal]

---

## 🎯 Hypothèse(s)

**Hypothèse principale** : [Formulation claire]

**Hypothèses secondaires** (si applicable) :
- H1 : [...]
- H2 : [...]

---

## 🔬 Méthodologie
### Cadre Théorique
**Bases conceptuelles** :
[Liste concise avec référence]

**Construits théoriques centraux** :
| Concept                       | Opérationnalisation proposée                                                                      |
| ----------------------------- | ------------------------------------------------------------------------------------------------- |
| **Construit 1**        | [défnition de l'opérationnalisation 1] |
| **Construit 2** | [défnition de l'opérationnalisation 1] |

### Variables

**VI (Variables Indépendantes)** : [Liste concise]
**VD (Variables Dépendantes)** : [Liste concise]

### Design Expérimental

[1-2 phrases décrivant le plan expérimental : type de design, groupes, conditions]

### Procédure

[3-5 phrases résumant les étapes principales de l'expérience]

**Participants** : N = [nombre], caractéristiques principales
**Mesures** : [Instruments/questionnaires principaux]

---

## 📊 Résultats Principaux

### Résultat clé 1

[2-3 phrases expliquant le résultat]

**Implication** : [En quoi c'est important]

### Résultat clé 2

[...]

### Résultat clé 3

[...]

[Maximum 5 résultats principaux avec les chiffres de l'article]

---

## 🌟 Contribution Théorique

### Apports Majeurs

1. [Apport 1] : [Explication brève]
2. [Apport 2] : [Explication brève]
3. [Apport 3] : [Explication brève]

### Positionnement Théorique

[En 1-2 ligne :Comment l'article se situe par rapport aux théories existantes : rupture, continuité, extension ?]

---

## ⚠️ Limites

### Identifiées par les auteurs

1. [Limite 1]
2. [Limite 2]

### Critiques additionnelles

1. [Limite méthodologique non mentionnée]
2. [Gap conceptuel]

---

## 🎯Pertinence pour l'Étude

### Justification de l'inclusion

[2-3 phrases expliquant pourquoi cet article est dans le corpus]

### Liens avec mes hypothèses

**H1 (Fatigue → Créativité)** :
- [Lien direct ou indirect avec l'article]
- [Mécanisme proposé]

**H2 (Profil psycho → Créativité)** :
- [Lien direct ou indirect]
- [Contribution conceptuelle]

### Applications méthodologiques

[Ce que cet article apporte pour la méthodologie de mon étude]

| Sections                | applications                  |
| ----------------------- | ----------------------------- |
| **Mesures utilisables** | [Liste]                       |
| **Design inspirant**    | [Aspects à reprendre]         |
| **Pièges à éviter**     | [Limites à ne pas reproduire] |

---

## 🔗 Liens Conceptuels

### Articles similaires
- [[Article 1]] : [Type de lien]
- [[Article 2]] : [Type de lien]

### Contradictions avec
- [[Article X]] : [Nature de la contradiction]

### Complète/Approfondit
- [[Article Y]] : [En quoi c'est complémentaire]

### Lien avec mes Hypothèses
[H1 : 1 ligne]
[H2 : 1 ligne]
[Lien théorique] : [liste]
[Gap comblé]

---

## 💡 Concepts Clés

### Définitions Opérationnelles

| Concept | Définition de l'article |
|---------|-------------------------|
| [Concept 1] | [Définition précise 1-2 phrases] |
| [Concept 2] | [Définition précise 1-2 phrases] |

### Citations Majeures

> **[Thème de la citation]** :
> *"[Citation textuelle]"* (p. X)

> **[Autre thème]** :
> *"[Citation]"* (p. Y)

---

## Notes pour Rédaction

### Pour l'Introduction

[2-3 points clés à intégrer dans l'intro de mon mémoire]

### Pour la Discussion

[2-3 points pour interpréter mes futurs résultats à la lumière de cet article]

### Limites à mentionner

[Limites de l'article qui justifient mon approche]

---

## 📎 Fichiers Associés

- PDF : [[Fichier.pdf]]
- Notes d'extraction : [[Fichier extraction.md]]
- Synthèse thématique : [[moc X]]

---

**Date de création** : YYYY-MM-DD
**Dernière modification** : YYYY-MM-DD
**Statut d'analyse** : [⏳ En cours | ✅ Complète | 🔄 À réviser]
```

---

## Règles de Formatage

### Hiérarchie des Titres

```markdown
# Titre niveau 1 : Titre principal de l'article
## Titre niveau 2 : Sections principales (Résumé, Hypothèse, etc.)
### Titre niveau 3 : Sous-sections (Apports Majeurs, VI/VD, etc.)
#### Titre niveau 4 : Détails spécifiques
##### Titre niveau 5 : Si nécessaire
###### Titre niveau 6 : Rarement utilisé
```

### Usage du Gras (MINIMAL)

**Utiliser uniquement pour** :
- Noms de construits théoriques dans le texte courant
- Mots-clés dans une définition
- Mise en valeur ponctuelle (max 1-2 mots)

**Éviter** :
- Phrases entières en gras
- Gras systématique dans les listes
- Titres en gras (déjà gérés par les #)

### Exemples

✅ **BON** :
```markdown
### Contribution Théorique

L'article introduit le concept de variabilité fonctionnelle définie comme la capacité à maintenir la performance malgré des contraintes changeantes. Les auteurs proposent que la créativité motrice émerge de cette variabilité.
```

❌ **MAUVAIS** :
```markdown
### Contribution Théorique

L'article introduit le concept de **variabilité fonctionnelle** définie comme **la capacité à maintenir la performance malgré des contraintes changeantes**. Les auteurs proposent que **la créativité motrice émerge de cette variabilité**.
```

---

## Typologie des Articles

### Statuts

| Statut | Signification | Critère |
|--------|---------------|---------|
| 🔴 Fondateur | Article incontournable | Base théorique centrale, >200 citations, définit concepts clés |
| 🟠 Important | Article majeur pour corpus | Lien direct avec H1 ou H2, méthodologie pertinente |
| 🟡 Complémentaire | Apport spécifique | Complète un aspect particulier, contexte théorique |
| ⚪ Contexte | Background général | Contexte large, références générales |

### Types d'Études

- **Expérimentale** : Manipulation de VI, mesure de VD, protocole contrôlé
- **Théorique** : Proposition conceptuelle, pas de données empiriques
- **Revue systématique** : Synthèse de littérature avec méthodologie rigoureuse
- **Méta-analyse** : Analyse statistique de plusieurs études
- **Étude de cas** : Analyse approfondie d'un cas particulier

### Approches

- **Psychologique** : Focus sur traits, processus cognitifs, motivation
- **Biomécanique** : Analyse du mouvement, forces, cinématique
- **Écologique** : Approche dynamique, affordances, couplage perception-action
- **Physiologique** : Capacités physiques, fatigue, métabolisme
- **Mixte** : Combine plusieurs approches

---

## Gestion des Liens Bidirectionnels

### Syntaxe Obsidian

```markdown
## Liens Conceptuels

### Articles similaires
- [[Orth et al. (2017)]] : Base théorique (créativité = émergence)
- [[Van Bergen et al. (2025)]] : Application empirique en escalade

### Complète/Approfondit
- [[Newell (1986)]] : Modèle de contraintes (fondation)
- [[Hristovski et al. (2011)]] : Créativité près limites système

### Concepts mobilisés
- [[Variabilité fonctionnelle]]
- [[Créativité motrice]]
- [[Contraintes]]
- [[Affordances]]
```

### MOCs (Maps of Content)

**Lier systématiquement à** :
- `[[00-ARTICLES]]` : MOC général de tous les articles
- `[[02 - MOC Créativité et Escalade]]` : Si lien avec créativité/escalade
- `[[03 - MOC Fatigue et Performance]]` : Si lien avec fatigue
- `[[04 - MOC Psychologie du Sport]]` : Si lien avec profils psycho

---

## Règles de Concision

### Longueur Cible

| Section      | Longueur cible      | Justification                    |
| ------------ | ------------------- | -------------------------------- |
| Résumé       | 2-3 phrases         | Vue d'ensemble rapide            |
| Hypothèse    | 1-3 items           | Clarté                           |
| Méthodologie | 5-8 phrases totales | Essentiel sans détails superflus |
| Résultats    | 3-5 résultats       | Principaux seulement             |
| Contribution | 3-5 points          | Apports majeurs                  |
| Pertinence   | 2 paragraphes       | Liens H1/H2 + méthodologie       |

### Principes de Rédaction

1. **Une idée par phrase** : Phrases courtes et précises
2. **Éviter répétitions** : Ne pas reformuler 3 fois la même chose
3. **Privilégier listes** : Pour énumérations (VI, VD, résultats)
4. **Citations ciblées** : Max 3-5 citations vraiment clés
5. **Tableaux synthétiques** : Pour comparaisons/définitions multiples

**Longueur totale cible** : 1500-2500 mots (pas 4000+)

### Sortie dans Claude
- Indique uniquement si la fiche à bien été réalisée et son emplacement
- Ne développe pas son contenu dans Claude, ni les règles respectées
---

## Checklist Finale

Avant de finaliser une fiche, vérifier :

- [ ] Métadonnées complètes (type, auteurs, année, DOI, tags, statut)
- [ ] Typologie remplie (moc, citation APA, type_etude, approche, mots_cles, pdf, discipline)
- [ ] Résumé en 2-3 phrases max
- [ ] Hypothèses clairement formulées
- [ ] Méthodologie concise (VI/VD, design, procédure en <8 phrases)
- [ ] 3-5 résultats principaux avec implications
- [ ] Contribution théorique explicitée
- [ ] Limites identifiées (auteurs + critiques)
- [ ] Pertinence pour étude expliquée (H1 + H2 + méthodologie)
- [ ] Liens bidirectionnels vers 3-5 articles/concepts minimum
- [ ] 2-5 citations clés avec pages
- [ ] Notes pour rédaction (intro + discussion)
- [ ] Pas d'abus de gras (titres privilégiés)
- [ ] Longueur totale raisonnable (~1500-2500 mots)

---

## Cas Particuliers

### Articles Théoriques (pas d'expérience)

**Méthodologie** → Remplacer par :

```markdown
## Approche Conceptuelle

### Cadre Théorique

[Bases théoriques mobilisées]

### Argumentation

[Structure de l'argumentation en 3-5 points]

### Modèle Proposé

[Description du modèle/framework proposé]
```

### Revues Systématiques

**Résultats** → Adapter en :

```markdown
## Synthèse de la Littérature

### Résultats Convergents

[Ce sur quoi les études s'accordent]

### Résultats Divergents

[Contradictions identifiées]

### Gaps Identifiés

[Manques dans la littérature]
```

### Méta-analyses

**Ajouter section spécifique** :

```markdown
### Taille d'Effet Globale

[Effect size principal avec IC 95%]

### Modérateurs

[Variables modératrices identifiées]
```

---

## Exemple d'une bonne note

**Points forts** :
- Structure claire avec émojis pour repérage rapide
- Résumé concis mais informatif
- Liens explicites H1/H2
- Tableaux synthétiques
- Citations ciblées avec pages
- Contribution théorique bien explicitée

**Problèmes à éviter** :
- Résumé trop long (>5 phrases)
- Gras excessif dans tout le texte
- Pas de liens vers autres articles
- Méthodologie trop détaillée (>15 phrases)
- Résultats non hiérarchisés (10+ résultats listés)
- Pas de lien clair avec hypothèses de l'étude

---

## Ressources Complémentaires




### MOCs à Consulter

- `[[02 - MOC Créativité et Escalade]]` : Vue d'ensemble créativité
- `[[00-ARTICLES]]` : Liste hiérarchisée des articles

---

**Dernière mise à jour** : 2025-01-04
**Version** : 1.5
**Auteur** : Système de recherche bibliographique M2
