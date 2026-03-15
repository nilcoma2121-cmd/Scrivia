# Scrivia — Contexte Projet Complet

## App
Application mobile Flutter d'apprentissage orthographe anti-dépendance IA.
- Détecte fautes en temps réel (LanguageTool à intégrer)
- Génère leçons personnalisées (Gemini à intégrer)
- Stocke progression (Firebase Firestore ✅)
- Freemium : gratuit limité / Premium 4,99€/mois

## Stack technique
- Flutter (Dart) — iOS + Android
- Firebase Auth ✅ — connexion email/mot de passe
- Cloud Firestore ✅ — base de données utilisateurs
- Google Fonts ✅ — Syne + Nunito
- LanguageTool — À INTÉGRER
- Gemini API — À INTÉGRER

## Fichiers lib/
- main.dart — routing Auth/Onboarding/App
- theme.dart — couleurs + widgets communs
- home.dart — page accueil
- stats.dart — statistiques
- lessons.dart + lesson_detail — leçons
- write.dart — espace écriture
- settings.dart — réglages
- auth.dart — connexion/inscription
- onboarding.dart — questionnaire nouveaux users
- firebase_options.dart — config Firebase auto-générée

## Couleurs
- bg: #F7F5FF, accent: #6C47FF, accent2: #9B7FFF
- green: #00C48C, red: #FF4D6A, orange: #FF8C42
- dark: #1A1535, muted: #9691B0

## GitHub
https://github.com/nilcoma2121-cmd/Scrivia

## Prochaines étapes
1. Intégrer LanguageTool pour correction temps réel
2. Intégrer Gemini pour génération leçons
3. Connecter vraies données Firebase aux pages
4. Clavier iOS système
