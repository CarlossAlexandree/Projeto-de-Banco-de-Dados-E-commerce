-- =========================
-- BANCO DE DADOS - ECOMMERCE
-- =========================

DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- =========================
-- CLIENT
-- =========================

CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(30),
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);

-- =========================
-- PRODUCT
-- =========================

CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(45) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE,
    Category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
    Avaliacao FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

-- =========================
-- PAYMENTS
-- =========================

CREATE TABLE payments (
    idClient INT,
    id_payment INT,
    typePayment ENUM ('Boleto','Cartão','Dois Cartões'),
    limitAvailable FLOAT,
    PRIMARY KEY (idClient, id_payment),
    CONSTRAINT fk_payment_client
        FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- =========================
-- ORDERS
-- =========================

CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrdersClient INT,
    ordersStatus ENUM('Cancelado','Confirmado','Em processamento')
        DEFAULT 'Em processamento',
    ordersDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_orders_client
        FOREIGN KEY (idOrdersClient) REFERENCES client(idClient)
);

-- =========================
-- PRODUCT STORAGE
-- =========================

CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- =========================
-- SUPPLIER
-- =========================

CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- =========================
-- SELLER
-- =========================

CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15) NOT NULL,
    CPF CHAR(11),
    Location VARCHAR(255),
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- =========================
-- PRODUCT SELLER
-- =========================

CREATE TABLE productSeller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idSeller, idProduct),
    CONSTRAINT fk_productSeller_seller
        FOREIGN KEY (idSeller) REFERENCES seller(idSeller),
    CONSTRAINT fk_productSeller_product
        FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- =========================
-- PRODUCT ORDER
-- =========================

CREATE TABLE productOrder (
    idProduct INT,
    idOrder INT,
    porQuantity INT DEFAULT 1,
    poStatus ENUM ('Disponivel','Sem estoque') DEFAULT 'Disponivel',
    PRIMARY KEY (idProduct, idOrder),
    CONSTRAINT fk_productOrder_product
        FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productOrder_order
        FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- =========================
-- STORAGE LOCATION (PRODUCT x STORAGE)
-- =========================

CREATE TABLE storageLocation (
    idProduct INT,
    idProdStorage INT,
    quantity INT DEFAULT 0,
    PRIMARY KEY (idProduct, idProdStorage),
    CONSTRAINT fk_storage_product
        FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_storage
        FOREIGN KEY (idProdStorage) REFERENCES productStorage(idProdStorage)
);

SHOW tables;
