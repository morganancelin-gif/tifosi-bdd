-- ============================================
-- Schéma de la base de données "tifosi"
-- ============================================

USE tifosi;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS achete;
DROP TABLE IF EXISTS contient;
DROP TABLE IF EXISTS comprend;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS boisson;
DROP TABLE IF EXISTS focaccia;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS marque;
DROP TABLE IF EXISTS ingredient;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- Tables "indépendantes" (pas de clé étrangère)
-- ============================================

CREATE TABLE ingredient (
  id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE marque (
  id_marque INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE client (
  id_client INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  code_postal INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE focaccia (
  id_focaccia INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE,
  prix DECIMAL(5,2) NOT NULL,
  CONSTRAINT chk_focaccia_prix CHECK (prix >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tables avec 1 clé étrangère (issues d'une association 0,n / 1,1)
-- ============================================

CREATE TABLE boisson (
  id_boisson INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE,
  id_marque INT NOT NULL,
  CONSTRAINT fk_boisson_marque
    FOREIGN KEY (id_marque) REFERENCES marque(id_marque)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE menu (
  id_menu INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE,
  prix DECIMAL(5,2) NOT NULL,
  id_focaccia INT NOT NULL,
  CONSTRAINT chk_menu_prix CHECK (prix >= 0),
  CONSTRAINT fk_menu_focaccia
    FOREIGN KEY (id_focaccia) REFERENCES focaccia(id_focaccia)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tables d'association (issues d'une association n,n)
-- ============================================

CREATE TABLE comprend (
  id_focaccia INT NOT NULL,
  id_ingredient INT NOT NULL,
  quantite INT NOT NULL,
  PRIMARY KEY (id_focaccia, id_ingredient),
  CONSTRAINT chk_comprend_quantite CHECK (quantite > 0),
  CONSTRAINT fk_comprend_focaccia
    FOREIGN KEY (id_focaccia) REFERENCES focaccia(id_focaccia)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comprend_ingredient
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE contient (
  id_menu INT NOT NULL,
  id_boisson INT NOT NULL,
  PRIMARY KEY (id_menu, id_boisson),
  CONSTRAINT fk_contient_menu
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_contient_boisson
    FOREIGN KEY (id_boisson) REFERENCES boisson(id_boisson)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE achete (
  id_client INT NOT NULL,
  id_menu INT NOT NULL,
  date_achat DATE NOT NULL,
  PRIMARY KEY (id_client, id_menu, date_achat),
  CONSTRAINT fk_achete_client
    FOREIGN KEY (id_client) REFERENCES client(id_client)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_achete_menu
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
