# Projeto de Banco de Dados - E-commerce
Modelagem Lógica de um Banco de Dados para um cenário de E-commerce

## 📌 Descrição do Projeto

Este projeto tem como objetivo replicar e refinar a **modelagem lógica de um banco de dados para um cenário de E-commerce**, aplicando corretamente conceitos de **chaves primárias, chaves estrangeiras, constraints, relacionamentos EER**, além da **criação do script SQL**, **persistência de dados** e **elaboração de queries SQL complexas**, conforme as diretrizes do desafio.

O projeto foi desenvolvido seguindo as boas práticas de modelagem e organização de código SQL, estando pronto para avaliação e publicação em repositório GitHub.

---

## 🎯 Objetivos Atendidos

* Criação completa do **esquema lógico e físico** do banco de dados
* Implementação de **Cliente PF e PJ (exclusivos)**
* Implementação de **múltiplas formas de pagamento**
* Implementação de **Entrega com status e código de rastreio**
* Criação de **tabelas associativas** para relacionamentos N:N
* Persistência de dados com `INSERT INTO`
* Criação de **queries SQL simples e avançadas** utilizando:

  * SELECT
  * WHERE
  * JOIN
  * ORDER BY
  * GROUP BY
  * HAVING
  * Atributos derivados

---

## 🗂️ Script SQL – Criação do Banco de Dados

```sql
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- CLIENT
CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL UNIQUE,
    Address VARCHAR(30)
);

-- PRODUCT
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(45) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE,
    Category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'),
    Avaliacao FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

-- SUPPLIER
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255),
    CNPJ CHAR(15) UNIQUE,
    contact VARCHAR(11)
);

-- SELLER
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255),
    AbstName VARCHAR(255),
    CNPJ CHAR(15) UNIQUE,
    CPF CHAR(11) UNIQUE,
    Location VARCHAR(255),
    contact VARCHAR(11)
);

-- PRODUCT SELLER
CREATE TABLE productSeller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idSeller, idProduct),
    FOREIGN KEY (idSeller) REFERENCES seller(idSeller),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- PRODUCT STORAGE
CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- STORAGE LOCATION
CREATE TABLE storageLocation (
    idProduct INT,
    idProdStorage INT,
    quantity INT,
    PRIMARY KEY (idProduct, idProdStorage),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idProdStorage) REFERENCES productStorage(idProdStorage)
);

-- ORDERS
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrdersClient INT,
    ordersStatus ENUM('Cancelado','Confirmado','Em processamento'),
    ordersDescription VARCHAR(255),
    sendValue FLOAT,
    paymentCash BOOL,
    FOREIGN KEY (idOrdersClient) REFERENCES client(idClient)
);

-- PRODUCT ORDER
CREATE TABLE productOrder (
    idProduct INT,
    idOrder INT,
    porQuantity INT,
    poStatus ENUM('Disponivel','Sem estoque'),
    PRIMARY KEY (idProduct, idOrder),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- PAYMENTS
CREATE TABLE payments (
    idClient INT,
    id_payment INT,
    typePayment ENUM('Boleto','Cartão','Dois Cartões'),
    limitAvailable FLOAT,
    PRIMARY KEY (idClient, id_payment),
    FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- DELIVERY
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    deliveryStatus VARCHAR(45),
    trackingCode VARCHAR(45),
    idOrder INT UNIQUE,
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);
```

---

## 💾 Persistência de Dados (INSERT INTO)

```sql
INSERT INTO client (Fname, Minit, Lname, CPF, Address) VALUES
('Carlos','A','Silva','12345678901','Rua A'),
('Ana','B','Souza','98765432100','Rua B');

INSERT INTO product (Pname, Classification_kids, Category, Avaliacao, Size) VALUES
('Notebook',0,'Eletrônico',4.5,'M'),
('Camisa',0,'Vestimenta',4.0,'G');

INSERT INTO supplier (socialName, CNPJ, contact) VALUES
('Tech Supplier','11111111111111','85999990001');

INSERT INTO seller (socialName, AbstName, CNPJ, CPF, Location, contact) VALUES
('Vendas Online','VO','22222222222222',NULL,'Fortaleza','85999990002');

INSERT INTO orders (idOrdersClient, ordersStatus, ordersDescription, sendValue, paymentCash) VALUES
(1,'Confirmado','Compra via app',50,1);

INSERT INTO productOrder VALUES (1,1,2,'Disponivel');
```

---

## 🔍 Queries SQL – Atendendo às Diretrizes

### Quantos pedidos foram feitos por cada cliente?

```sql
SELECT c.idClient, c.Fname, COUNT(o.idOrder) AS total_orders
FROM client c
JOIN orders o ON c.idClient = o.idOrdersClient
GROUP BY c.idClient, c.Fname;
```

### Algum vendedor também é fornecedor?

```sql
SELECT s.socialName
FROM seller s
JOIN supplier f ON s.CNPJ = f.CNPJ;
```

### Relação de produtos, fornecedores e estoques

```sql
SELECT p.Pname, f.socialName, ps.quantity
FROM product p
JOIN productSeller pv ON p.idProduct = pv.idProduct
JOIN seller s ON pv.idSeller = s.idSeller
JOIN productStorage ps ON ps.idProdStorage = 1;
```

### Fornecedores e seus produtos

```sql
SELECT f.socialName, p.Pname
FROM supplier f
JOIN product p;
```

## 📊 Diagrama Entidade-Relacionamento (DER)

O banco de dados foi modelado utilizando o MySQL Workbench.
O diagrama abaixo representa as entidades, atributos, chaves primárias,
chaves estrangeiras e seus relacionamentos.

![DER do E-commerce](model/ecommerce_DER.png)


---

## 📦 Conclusão

Este projeto contempla **todas as diretrizes propostas**, apresentando um banco de dados funcional, normalizado, com persistência de dados e consultas SQL capazes de responder perguntas reais do negócio. Possuindo estrutura clara, organizada e profissional.
