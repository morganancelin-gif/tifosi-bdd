-- ============================================================
-- Script de vérification : 10 requêtes de test
-- Base de données "tifosi"
-- ============================================================
-- Pour chaque requête : numéro, but, code SQL, résultat attendu,
-- résultat obtenu, et commentaire des écarts éventuels.
-- ============================================================

USE tifosi;

-- ============================================================
-- REQUETE 1
-- But : afficher la liste des noms des focaccias par ordre
-- alphabétique croissant
--
-- Résultat attendu : les 8 noms triés de A à Z
--   Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne,
--   Mozaccia, Paysanne, Raclaccia, Tradizione
--
-- Résultat obtenu : identique au résultat attendu.
-- Écart : aucun.
-- ============================================================
SELECT nom FROM focaccia ORDER BY nom ASC;

-- ============================================================
-- REQUETE 2
-- But : afficher le nombre total d'ingrédients
--
-- Résultat attendu : 25 (nombre de lignes du fichier ingredient.xlsx)
-- Résultat obtenu : 25
-- Écart : aucun.
-- ============================================================
SELECT COUNT(*) AS nombre_ingredients FROM ingredient;

-- ============================================================
-- REQUETE 3
-- But : afficher le prix moyen des focaccias
--
-- Résultat attendu : moyenne de (9.80, 10.80, 8.90, 9.80, 8.90,
-- 11.20, 10.80, 12.80) = 10.38
-- Résultat obtenu : 10.38
-- Écart : aucun.
-- ============================================================
SELECT ROUND(AVG(prix), 2) AS prix_moyen FROM focaccia;

-- ============================================================
-- REQUETE 4
-- But : afficher la liste des boissons avec leur marque,
-- triée par nom de boisson
--
-- Résultat attendu : 12 lignes, triées alphabétiquement par
-- nom de boisson (Capri-sun en premier)
-- Résultat obtenu : 12 lignes, tri conforme
-- Écart : aucun.
-- ============================================================
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;

-- ============================================================
-- REQUETE 5
-- But : afficher la liste des ingrédients pour une Raclaccia
--
-- Résultat attendu : Base Tomate(200), Raclette(50), Cresson(20),
-- Ail(2), Champignon(40), Parmesan(50), Poivre(1) — 7 lignes
-- Résultat obtenu : identique
-- Écart : aucun.
-- ============================================================
SELECT i.nom, c.quantite
FROM comprend c
JOIN ingredient i ON c.id_ingredient = i.id_ingredient
JOIN focaccia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclaccia';

-- ============================================================
-- REQUETE 6
-- But : afficher le nom et le nombre d'ingrédients
-- pour chaque focaccia
--
-- Résultat attendu (recompté manuellement sur le fichier source) :
--   Américaine 8, Emmentalaccia 7, Gorgonzollaccia 8, Hawaienne 9,
--   Mozaccia 10, Paysanne 12, Raclaccia 7, Tradizione 9
-- Résultat obtenu : identique
-- Écart : aucun.
-- ============================================================
SELECT f.nom, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;

-- ============================================================
-- REQUETE 7
-- But : afficher le nom de la focaccia qui a le plus d'ingrédients
--
-- Résultat attendu : Paysanne, 12 (recette la plus fournie)
-- Résultat obtenu : Paysanne, 12
-- Écart : aucun.
-- ============================================================
SELECT f.nom, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY nombre_ingredients DESC
LIMIT 1;

-- ============================================================
-- REQUETE 8
-- But : afficher la liste des focaccias qui contiennent de l'ail
--
-- Résultat attendu : Mozaccia, Gorgonzollaccia, Raclaccia, Paysanne
-- Résultat obtenu : identique
-- Écart : aucun.
-- ============================================================
SELECT DISTINCT f.nom
FROM focaccia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail';

-- ============================================================
-- REQUETE 9
-- But : afficher la liste des ingrédients inutilisés
--
-- Résultat attendu : Salami, Tomate cerise (absents de toutes
-- les recettes du fichier focaccia.xlsx)
-- Résultat obtenu : Salami, Tomate cerise
-- Écart : aucun.
-- ============================================================
SELECT i.nom
FROM ingredient i
LEFT JOIN comprend c ON i.id_ingredient = c.id_ingredient
WHERE c.id_ingredient IS NULL;

-- ============================================================
-- REQUETE 10
-- But : afficher la liste des focaccias qui n'ont pas de champignon
--
-- Résultat attendu (première estimation) : Hawaienne seule.
-- Résultat obtenu : Américaine, Hawaienne (2 lignes).
-- Écart et explication : l'estimation initiale était incomplète.
-- En relisant la recette d'Américaine dans le fichier source
-- (Base tomate, Mozarella, cresson, bacon, pomme de terre,
-- parmesan, poivre, olive noire), elle ne contient effectivement
-- pas de champignon non plus. Le résultat obtenu est donc le bon ;
-- c'est l'estimation manuelle de départ qui était fausse, corrigée
-- après vérification croisée avec les données sources.
-- ============================================================
SELECT f.nom
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia
    FROM comprend c
    JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE i.nom = 'Champignon'
);
