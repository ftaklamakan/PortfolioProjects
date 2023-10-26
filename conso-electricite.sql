-- Données issues de https://www.data.gouv.fr/fr/datasets/consommation-annuelle-delectricite-et-gaz-par-region-et-par-code-naf/
-- pré-nettoyé à l'aide d'Excel puis importé dans Azure Data Studio


-- sélectionner tout et trier par année la plus proche
SELECT *
FROM dbo.[conso-frelec]
ORDER BY annee DESC


-- filtrer la région 'grand est'
SELECT *
FROM dbo.[conso-frelec]
WHERE libelle_region like '%Grand Est%'
ORDER BY annee DESC

-- avec la filtration de la consommation de gaz, nous regardons les situations les plus consommatrices
SELECT *
FROM dbo.[conso-frelec]
WHERE libelle_region like '%Grand Est%' and filiere <> 'Gaz'
ORDER BY conso DESC

-- nous vérifions les secteurs les plus consommateurs
SELECT libelle_grand_secteur, SUM(conso) AS conso_total
FROM dbo.[conso-frelec]
WHERE libelle_region like '%Grand Est%' and filiere <> 'Gaz'
GROUP BY libelle_grand_secteur
ORDER BY conso_total DESC

-- observons les secteurs les plus consommateurs et ses années
SELECT libelle_grand_secteur, annee, SUM(conso) AS conso_total
FROM dbo.[conso-frelec]
WHERE libelle_region like '%Grand Est%' and filiere <> 'Gaz'
GROUP BY libelle_grand_secteur, annee
ORDER BY conso_total DESC

-- observons les secteurs les plus consommateurs par années
SELECT operateur, annee, SUM(conso) AS conso_total
FROM dbo.[conso-frelec]
WHERE libelle_region like '%Grand Est%' and filiere <> 'Gaz'
GROUP BY operateur,annee
ORDER BY annee DESC



SELECT *
FROM dbo.[conso-frelec]
WHERE filiere <> 'Gaz' 


-- CTE Table
WITH IndustrieConso (libelle_grand_secteur, annee, conso_total)
AS
(
SELECT libelle_grand_secteur, annee, SUM(conso) AS conso_total
FROM dbo.[conso-frelec]
WHERE libelle_region like '%Grand Est%' and filiere <> 'Gaz'
GROUP BY libelle_grand_secteur, annee
)

SELECT *
FROM IndustrieConso
ORDER BY conso_total DESC