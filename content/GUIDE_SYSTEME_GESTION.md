# 🎯 Système de Gestion Complet pour votre Étude

## Créativité et Escalade de Bloc - Master 2 Recherche

---

## 🚀 Ce qui a été créé pour vous

J'ai développé un **système de gestion automatisé complet** pour faciliter votre stage de recherche sur les effets de la fatigue musculaire sur la créativité en escalade de bloc.

---

## 📦 Contenu du Système

### 1. **Base de Données SQLite** (`database.py`)
- Gestion de 30 participants avec codes anonymes automatiques
- Programmation et suivi des sessions expérimentales
- Historique complet des emails envoyés
- Stockage sécurisé des données expérimentales
- Conformité RGPD (anonymisation, séparation des données)

### 2. **Système d'Emails Automatisés** (`emails.py`)
- **4 types d'emails professionnels en HTML** :
  - ✉️ Invitation à l'étude
  - ✉️ Confirmation de session programmée
  - ✉️ Rappel la veille avec liens LimeSurvey
  - ✉️ Remerciement après participation
- Support Gmail, AMU, ou tout serveur SMTP
- Mode simulation pour tester sans envoyer

### 3. **Dashboard Web Interactif** (`app.py`)
- Interface moderne et intuitive (Flask)
- **Statistiques en temps réel** :
  - Progression du recrutement (X/30)
  - Sessions complétées et programmées
  - Niveau IRCRA moyen
  - Consentements et questionnaires
- **Actions en 1 clic** :
  - Ajouter un participant
  - Programmer une session
  - Envoyer les rappels
  - Exporter les données

### 4. **Scripts d'Automatisation** (`automatisation.py`)
- Envoi automatique des rappels quotidiens (cron job)
- Génération de rapports hebdomadaires
- Vérification de cohérence des données
- Détection automatique des problèmes

### 5. **Tests et Validation** (`test_system.py`)
- Suite de tests complète
- Vérification de toutes les fonctionnalités
- Validation avant utilisation en production

### 6. **Documentation Complète** (`README.md`)
- Guide d'installation pas à pas
- Exemples d'utilisation
- Dépannage et FAQ
- Conformité RGPD

---

## 💡 Fonctionnalités Clés

### ✅ Gestion des Participants
- Codes anonymes automatiques (ex: P7A3K9B2C5)
- Vérification des critères d'inclusion (âge, niveau IRCRA, blessures)
- Suivi du statut : recruté → programmé → complété
- Table de correspondance sécurisée (identité ↔ code)

### 📅 Programmation Intelligente
- Contrebalancement automatique de l'ordre des blocs (A-B / B-A)
- Calendrier des sessions
- Rappels automatiques J-1
- Gestion des annulations et reprogrammations

### 📧 Communication Automatisée
- Emails HTML professionnels et attrayants
- Personnalisation avec les données du participant
- Liens directs vers les questionnaires LimeSurvey
- Historique complet des envois

### 📊 Suivi en Temps Réel
- Dashboard web avec barres de progression
- Codes couleur par statut
- Alertes pour actions à effectuer
- Export JSON pour analyses

### 🔒 Sécurité RGPD
- Anonymisation automatique
- Séparation données / identités
- Archivage sécurisé (AMUbox)
- Droits des participants respectés

---

## 🎨 Aperçu du Dashboard

```
┌──────────────────────────────────────────────────────────┐
│  🧗 Étude : Créativité & Escalade de Bloc               │
│  Système de gestion des participants                     │
└──────────────────────────────────────────────────────────┘

╔════════════════╦════════════════╦════════════════╗
║   15/30        ║       8        ║       3        ║
║ Participants   ║   Sessions     ║   Sessions     ║
║   recrutés     ║  complétées    ║  programmées   ║
║ [████████░░░░] ║                ║                ║
║      50%       ║                ║                ║
╚════════════════╩════════════════╩════════════════╝

[➕ Ajouter]  [📅 Programmer]  [🔔 Rappels]  [📊 Exporter]

┌──────────────────────────────────────────────────────────┐
│  📋 Liste des Participants                               │
├──────┬──────────┬─────────────────┬────────┬──────────┤
│ Code │ Nom      │ Email           │ Niveau │ Statut   │
├──────┼──────────┼─────────────────┼────────┼──────────┤
│ P7A3 │ Dupont M │ m.dupont@...    │   20   │ ✓ Complété
│ P2B5 │ Martin L │ l.martin@...    │   19   │ 📅 Programmé
│ P9C1 │ Durand S │ s.durand@...    │   21   │ ⏳ Recruté
└──────┴──────────┴─────────────────┴────────┴──────────┘
```

---

## 📈 Workflow Automatisé

### Phase 1 : Recrutement
```
Ajout participant dans dashboard
        ↓
Code anonyme généré (ex: P7A3K9B2C5)
        ↓
📧 Email d'invitation envoyé automatiquement
        ↓
Participant confirme → Statut: "recruté"
```

### Phase 2 : Programmation
```
Sélection participant + date + heure
        ↓
Ordre blocs contrebalancé automatiquement
        ↓
📧 Email de confirmation envoyé
        ↓
Statut: "session_programmée"
```

### Phase 3 : Rappel J-1
```
18h00 la veille : Script automatique (cron)
        ↓
Détection sessions de demain
        ↓
📧 Email rappel avec liens LimeSurvey
   • Notice d'information + consentement
   • Questionnaire QORS (12 items)
   • Questionnaire ECCI (26 items)
        ↓
Participant complète questionnaires en ligne
```

### Phase 4 : Session
```
Participant arrive au labo
        ↓
Vérification consentement papier
        ↓
Échauffement → Blocs → SmartBoard
        ↓
Enregistrement données dans système
        ↓
Statut: "session_completee"
        ↓
📧 Email de remerciement
```

---

## 🔧 Installation Rapide

### 1. Prérequis
```bash
# Python 3.8+
python3 --version

# Installation Flask
pip3 install flask
```

### 2. Configuration
```bash
cd systeme_gestion_participants

# Copier le template de configuration
cp .env.example .env

# Éditer avec vos informations
nano .env
```

### 3. Test du système
```bash
# Vérifier que tout fonctionne
python3 test_system.py
```

### 4. Lancement
```bash
# Démarrer le dashboard
python3 app.py

# Accéder à http://localhost:5000
```

---

## 📧 Configuration des Emails

### Option 1 : Gmail (recommandé pour tester)
```
SMTP_SERVER=smtp.gmail.com
EMAIL_FROM=votre.email@gmail.com
EMAIL_PASSWORD=mot_de_passe_application
```

**Important** : Générer un "mot de passe d'application" dans les paramètres Google

### Option 2 : Aix-Marseille Université
```
SMTP_SERVER=smtp.univ-amu.fr
EMAIL_FROM=prenom.nom@univ-amu.fr
EMAIL_PASSWORD=votre_mot_de_passe
```

### Mode Simulation
Sans configuration SMTP, le système fonctionne en mode simulation :
- Tous les emails sont "simulés" (affichés mais non envoyés)
- Parfait pour tester le workflow complet
- Aucun risque d'envoi accidentel

---

## 🤖 Automatisation (Cron)

### Envoi quotidien des rappels à 18h
```bash
# Ouvrir crontab
crontab -e

# Ajouter cette ligne
0 18 * * * cd /chemin/vers/systeme && python3 automatisation.py rappels
```

### Rapport hebdomadaire le lundi à 9h
```bash
0 9 * * 1 cd /chemin/vers/systeme && python3 automatisation.py rapport
```

---

## 📊 Exemples d'Utilisation

### Ajouter un participant
```bash
# Via le dashboard (interface web)
1. Clic sur "➕ Ajouter un participant"
2. Remplir le formulaire
3. Le code est généré automatiquement
4. Email d'invitation envoyé

# Résultat: Participant dans la base avec code PXXXXXXXX
```

### Programmer une session
```bash
# Via le dashboard
1. Clic sur "📅 Programmer une session"
2. Sélectionner participant
3. Choisir date et heure
4. Ordre des blocs contrebalancé auto
5. Email de confirmation envoyé
```

### Envoyer les rappels
```bash
# Manuellement (dashboard)
Clic sur "🔔 Envoyer les rappels"

# OU automatiquement (cron)
python3 automatisation.py rappels
```

### Exporter les données
```bash
# Via dashboard
Clic sur "📊 Exporter les données"

# OU via terminal
curl http://localhost:5000/export > donnees.json
```

---

## 📁 Structure des Fichiers

```
systeme_gestion_participants/
│
├── database.py           # 💾 Gestion base de données SQLite
├── emails.py            # 📧 Système d'envoi d'emails
├── app.py               # 🌐 Application web Flask
├── automatisation.py    # 🤖 Scripts automatisés
├── test_system.py       # ✅ Tests et validation
│
├── README.md            # 📖 Documentation complète
├── .env.example         # ⚙️ Template de configuration
│
└── participants.db      # 💾 Base de données (créée automatiquement)
```

---

## 🎯 Avantages du Système

### ✅ Gain de Temps
- **Automatisation** : Emails, rappels, contrebalancement
- **Interface intuitive** : Tout en quelques clics
- **Rapports automatiques** : Progression en temps réel

### 🔒 Sécurité
- **Anonymisation** : Codes aléatoires automatiques
- **RGPD** : Séparation données/identités
- **Traçabilité** : Historique complet

### 📊 Suivi Rigoureux
- **Dashboard** : Vue d'ensemble instantanée
- **Statistiques** : Niveau moyen, progression, etc.
- **Alertes** : Rappels manquants, incohérences

### 🧪 Fiabilité
- **Tests complets** : 6 tests automatisés
- **Mode simulation** : Tester sans risque
- **Validation** : Vérifications de cohérence

---

## 🚦 Prochaines Étapes

### 1. Configuration Initiale (30 min)
- [ ] Installer les dépendances
- [ ] Configurer le fichier .env
- [ ] Tester le système (test_system.py)
- [ ] Lancer le dashboard

### 2. Configuration LimeSurvey (1h)
- [ ] Créer les 3 questionnaires :
  - Notice + Consentement
  - QORS (12 items)
  - ECCI (26 items)
- [ ] Noter les URLs dans .env
- [ ] Tester l'accès aux liens

### 3. Tests avec Participants Fictifs (1h)
- [ ] Ajouter 2-3 participants test
- [ ] Programmer des sessions
- [ ] Tester envoi d'emails (simulation)
- [ ] Vérifier export de données

### 4. Configuration Production (30 min)
- [ ] Configurer SMTP réel (Gmail ou AMU)
- [ ] Tester envoi réel à votre email
- [ ] Configurer cron pour rappels
- [ ] Backup automatique sur AMUbox

### 5. Formation (30 min)
- [ ] Former les co-responsables scientifiques
- [ ] Documenter les procédures spécifiques
- [ ] Définir les responsabilités

---

## 💡 Conseils d'Utilisation

### Pour le Recrutement
- Utilisez les listes d'étudiants SMUC escalade
- Affichez dans la Faculté des Sciences du Sport
- Envoyez par email aux contacts directs
- Le système gère l'envoi d'invitations automatiquement

### Pour les Sessions
- Programmez 2-3 semaines à l'avance
- Laissez le système envoyer les rappels J-1
- Vérifiez les questionnaires complétés avant la session
- Enregistrez les données juste après

### Pour le Suivi
- Consultez le dashboard quotidiennement
- Utilisez les rapports hebdomadaires
- Exportez régulièrement pour backup
- Vérifiez la cohérence des données

---

## 🆘 Support

### Problèmes Techniques
- Consultez le README.md (section Dépannage)
- Exécutez test_system.py pour diagnostiquer
- Vérifiez les logs dans le terminal

### Questions Scientifiques
**Responsables scientifiques :**
- Dr. Laurent Vigouroux : laurent.vigouroux@univ-amu.fr
- Dr. Cécile Martha : cecile.martha@univ-amu.fr
- Pr. Xavier Sanchez : xavier.sanchez@univ-orleans.fr

---

## 🎉 Résumé

Vous disposez maintenant d'un **système professionnel complet** qui :

✅ Automatise le recrutement et le suivi de 30 participants
✅ Envoie des emails professionnels automatiquement
✅ Gère les sessions avec contrebalancement
✅ Assure la conformité RGPD
✅ Fournit un dashboard en temps réel
✅ Génère des rapports d'avancement
✅ Est entièrement testé et validé

**Temps gagné estimé** : **40-60 heures** sur la durée du stage

**Prêt à démarrer ?** Lancez `python3 test_system.py` ! 🚀

---

*Système développé pour le Master 2 Recherche*
*Institut des Sciences du Mouvement - Aix-Marseille Université*
*Décembre 2024*
