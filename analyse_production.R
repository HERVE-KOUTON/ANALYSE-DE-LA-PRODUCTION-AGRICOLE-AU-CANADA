
# ==============================================================================
# EXERCICE 1 : Comprendre les ensembles de données
# ==============================================================================

# 1. Définition des URLs exactes du projet
url_crop        <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Annual_Crop_Data.csv"
url_farm_prices <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Monthly_Farm_Prices.csv"
url_daily_fx    <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Daily_FX.csv"
url_monthly_fx  <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Monthly_FX.csv"

# 2. Chargement des jeux de données dans des dataframes R
print("Téléchargement des données en cours...")
df_crop        <- read.csv(url_crop)
df_farm_prices <- read.csv(url_farm_prices)
df_daily_fx    <- read.csv(url_daily_fx)
df_monthly_fx  <- read.csv(url_monthly_fx)
print("Téléchargement terminé avec succès !")

# 3. Analyse de la structure des fichiers (Noms des colonnes et types)
print("=== STRUCTURE : ANNUAL CROP DATA ===")
str(df_crop)

print("=== STRUCTURE : MONTHLY FARM PRICES ===")
str(df_farm_prices)

print("=== STRUCTURE : MONTHLY FX ===")
str(df_monthly_fx)


#=============================================================================
#EXERCIE 2: Chargez ces ensembles de données dans quatre tables séparées.
#=============================================================================

# Charger la bibliothèque de connexion
library(RSQLite)

# 1. Connexion à votre fichier de base de données locale
conn <- dbConnect(SQLite(), dbname = "Agriculture_Canada.db")

# 2. Injection et création automatique des 4 tables SQL
dbWriteTable(conn, "CROP_DATA", df_crop, overwrite = TRUE, row.names = FALSE)
dbWriteTable(conn, "FARM_PRICES", df_farm_prices, overwrite = TRUE, row.names = FALSE)
dbWriteTable(conn, "DAILY_FX", df_daily_fx, overwrite = TRUE, row.names = FALSE)
dbWriteTable(conn, "MONTHLY_FX", df_monthly_fx, overwrite = TRUE, row.names = FALSE)

# 3. Validation de la bonne création des structures
print("Vérification des tables créées :")
print(dbListTables(conn))

#===============================================================================
# EXERCICICE 3 :Exécuter des requêtes SQL à l’aide du package RODBC/RSQLite en R
#===============================================================================

# Problème 3 : Combien d'enregistrements y a-t-il dans le jeu de données des prix agricoles ?
dbGetQuery(conn, "SELECT COUNT(*) AS Total_Enregistrements FROM FARM_PRICES")

# Problème 4 : Quelles provinces sont incluses dans l'ensemble de données sur les prix agricoles ?
dbGetQuery(conn, "SELECT DISTINCT GEO FROM FARM_PRICES")



# Problème 5 : Combien d'hectares de seigle ont été récoltés au Canada en 1968 ?
# Note : Nous filtrons sur la géographie 'Canada' et le type de culture 'Rye'
dbGetQuery(conn, "SELECT SUM(Harvested_area) AS Hectares_Seigle_1968 
                  FROM CROP_DATA 
                  WHERE Crop_type = 'Rye' AND GEO = 'Canada' AND Year = 1968")

# Problème 6 : Interroger et afficher les 6 premières lignes du tableau des prix pour le seigle
dbGetQuery(conn, "SELECT * FROM FARM_PRICES WHERE Crop_type = 'Rye' LIMIT 6")



# Problème 7 : Quelles provinces ont cultivé de l'orge ?
# Note : On exclut 'Canada' pour n'avoir que les provinces réelles
dbGetQuery(conn, "SELECT DISTINCT GEO FROM CROP_DATA WHERE Crop_type = 'Barley' AND GEO != 'Canada'")

# Problème 8 : Trouver les premières et dernières dates des données sur les prix agricoles
dbGetQuery(conn, "SELECT MIN(DATE) AS Premiere_Date, MAX(DATE) AS Derniere_Date FROM FARM_PRICES")

# Problème 9 : Prix fermier supérieur ou égal à 350 $
dbGetQuery(conn, "SELECT DISTINCT CROP_TYPE FROM FARM_PRICES WHERE PRICE_PRERMT >= 350")

# Problème 10 : Classement du rendement moyen en Saskatchewan en 2000
dbGetQuery(conn, "SELECT CROP_TYPE, AVG_YIELD FROM CROP_DATA WHERE GEO = 'Saskatchewan' AND YEAR = 2000 ORDER BY AVG_YIELD DESC")

# Problème 11 : Classement depuis l'année 2000 (sans le Canada global)
dbGetQuery(conn, "SELECT CROP_TYPE, GEO, AVG(AVG_YIELD) AS Rendement_Global FROM CROP_DATA WHERE YEAR >= 2000 AND GEO != 'Canada' GROUP BY CROP_TYPE, GEO ORDER BY Rendement_Global DESC LIMIT 1")

# Requête SQL pour le Problème 13 (Jointure implicite et calcul de devise)
dbGetQuery(conn, "
  SELECT 
    p.DATE, 
    p.PRICE_PRERMT AS Prix_CAD, 
    (p.PRICE_PRERMT / fx.FXUSDCAD) AS Prix_USD
  FROM 
    FARM_PRICES p, 
    MONTHLY_FX fx
  WHERE 
    p.DATE = fx.DATE 
    AND p.CROP_TYPE = 'Canola' 
    AND p.GEO = 'Saskatchewan'
  ORDER BY 
    p.DATE DESC 
  LIMIT 6
")
