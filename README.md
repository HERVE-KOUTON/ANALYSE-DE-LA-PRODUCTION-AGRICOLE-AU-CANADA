# Analyse de la Production Agricole au Canada 🌾📊

Ce projet a été réalisé dans le cadre d'une étude d'opportunité pour une société de capital-risque américaine. L'objectif est d'analyser les marchés étrangers de grains afin d'optimiser la chaîne d'approvisionnement pour de récents investissements dans l'industrie de la microbrasserie et de la microdistillation (production de bières artisanales et de spiritueux).

## 🎯 Objectifs du Projet
* **Comprendre** l'évolution historique et actuelle de la production et des prix des cultures majeures au Canada.
* **Modéliser** une base de données relationnelle locale à l'aide de données prétéraitées.
* **Analyser** l'impact de la valeur relative des dollars canadien (CAD) et américain (USD) sur les prix fermiers.
* **Extraire des insights** stratégiques via des requêtes SQL pour répondre aux besoins opérationnels des parties prenantes.

---

## 💾 Données Utilisées
Les analyses s'appuient sur quatre ensembles de données simplifiés provenant de *Statistique Canada* et de la *Banque du Canada* :
1. **Annual_Crop_Data.csv** : Mesures de production agricole pour les principales cultures par province (1908 - 2020).
2. **Monthly_Farm_Prices.csv** : Prix moyens mensuels des produits agricoles par province (1980 - 2020).
3. **Daily_FX.csv** : Taux de change quotidiens USD-CAD.
4. **Monthly_FX.csv** : Taux de change moyens mensuels USD-CAD.

---

## 🛠️ Technologies et Outils
* **Langage** : R
* **Environnement** : Jupyter Notebook
* **Gestion de Base de Données** : SQLite (`RSQLite` / `RODBC`)
* **Analyse de données** : SQL queries (Jointures, Sous-requêtes, Agrégations)

---

## ⚙️ Architecture de la Base de Données
Le script charge les fichiers d'analyse directement depuis des URLs distantes pour alimenter quatre tables distinctes dans une base SQLite locale :
* `CROP_DATA`
* `FARM_PRICES`
* `DAILY_FX`
* `MONTHLY_FX`

---

## 🚀 Comment exécuter ce projet
1. Clonez ce dépôt sur votre machine locale.
2. Ouvrez le fichier Jupyter Notebook basé sur R inclus dans le projet.
3. Exécutez les cellules du carnet pour connecter la base de données, charger automatiquement les fichiers d'inventaire et exécuter les requêtes SQL analytiques.
