# Base de données Tifosi

Base de données MySQL/MariaDB pour **Tifosi**, restaurant de street-food italien,
permettant de gérer les focaccias, leurs ingrédients, les boissons et leurs marques.

## Prérequis

- MySQL ou MariaDB (testé avec MariaDB 10.4 via XAMPP)
- Un client en ligne de commande `mysql`

## 1. Création de la base de données et de l'utilisateur

Conformément aux consignes du projet, la base est nommée **tifosi** et n'est
accessible que par un utilisateur dédié du même nom, disposant uniquement des
droits nécessaires à l'administration de cette base (principe de moindre privilège :
aucun accès aux autres bases du serveur).

Connecte-toi en administrateur (`root`) :

```bash
mysql -u root -p
```

Puis exécute :

```sql
CREATE DATABASE tifosi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'tifosi'@'localhost' IDENTIFIED BY 'TonMotDePasse';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;
```

**Explication des choix :**

- `CHARACTER SET utf8mb4` : garantit le bon encodage des caractères accentués
  (é, è, œ...) présents dans les noms de recettes et d'ingrédients.
- `CREATE USER 'tifosi'@'localhost'` : compte dédié, distinct de `root`,
  utilisable uniquement en connexion locale.
- `GRANT ALL PRIVILEGES ON tifosi.*` : tous les droits d'administration
  (création/modification de tables, lecture/écriture des données), mais
  **uniquement** sur la base `tifosi` — aucun accès aux autres bases du serveur.

Vérifie la connexion avec le nouvel utilisateur :

```bash
mysql -u tifosi -p tifosi
```

## 2. Structure du projet

## 3. Modèle de données

Le modèle conceptuel fourni par le restaurant a été traduit en 9 tables relationnelles :

- **Tables de référence** : `ingredient`, `marque`, `client`, `focaccia`
- **Tables avec clé étrangère simple** : `boisson` (liée à `marque`),
  `menu` (lié à `focaccia`)
- **Tables d'association** (issues des relations n,n du modèle conceptuel) :
  `comprend` (focaccia ↔ ingrédient, avec quantité), `contient` (menu ↔ boisson),
  `achete` (client ↔ menu, avec date d'achat)

### Sécurité et intégrité des données

- Champs obligatoires (`NOT NULL`) sur toutes les données essentielles
  (noms, prix, emails...)
- Valeurs uniques (`UNIQUE`) sur les noms de référence (ingrédient, marque,
  focaccia, menu) et sur l'email client, pour éviter les doublons
- Contraintes `CHECK` sur les prix et quantités, qui doivent rester positifs
- Contraintes de clé étrangère (`FOREIGN KEY`) sur toutes les relations, avec :
  - `ON DELETE RESTRICT` sur les données de référence, pour empêcher une
    suppression accidentelle de données encore utilisées ailleurs
  - `ON DELETE CASCADE` sur les tables d'association, dont les lignes n'ont
    aucun sens sans leur enregistrement parent

## 4. Installation

Exécute les scripts dans l'ordre, en te connectant avec l'utilisateur `tifosi` :

```bash
mysql -u tifosi -p tifosi < sql/01_schema.sql
mysql -u tifosi -p tifosi < sql/02_data.sql
mysql -u tifosi -p tifosi < sql/03_queries.sql
```

Les scripts sont **rejouables** : ils nettoient les données existantes avant de
les réinsérer, donc ils peuvent être exécutés plusieurs fois sans erreur.

## 5. Requêtes de vérification

Le script `sql/03_queries.sql` regroupe les 10 requêtes de test demandées,
chacune documentée directement dans le fichier (but, résultat attendu, résultat
obtenu, écarts éventuels).
