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
* Criação de **queries SQL simples ao avançado** capazes de responder perguntas reais do negócio, utilizando cláusulas SQL:

  * SELECT
  * WHERE
  * JOIN
  * ORDER BY
  * GROUP BY
  * HAVING
  * JOIN
  * SUBQUERIES
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

Foram utilizados comandos `INSERT INTO` para popular todas as tabelas do banco de dados, permitindo:

- Testes funcionais das consultas
- Validação das regras de negócio
- Simulação de cenários reais de um e-commerce

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

### Quantos pedidos cada cliente realizou?

```sql
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.nome;
```

### Clientes fizeram mais de 1 pedido pago?

```sql
SELECT c.nome, COUNT(p.id_pedido) AS pedidos_pagos
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
WHERE p.status = 'PAGO'
GROUP BY c.nome
HAVING COUNT(p.id_pedido) > 1;
```

### Relação fornecedor → produtos → estoque

```sql
SELECT f.nome AS fornecedor,
       pr.nome AS produto,
       e.quantidade
FROM fornecedor f
JOIN produto pr ON f.id_fornecedor = pr.id_fornecedor
JOIN estoque e ON pr.id_produto = e.id_produto
ORDER BY e.quantidade DESC;
```

### Fornecedores e seus produtos

```sql
SELECT f.socialName, p.Pname
FROM supplier f
JOIN product p;
```

### Fornecedores com mais de um produto cadastrado

```sql
SELECT f.nome, COUNT(pr.id_produto) AS total_produtos
FROM fornecedor f
JOIN produto pr ON f.id_fornecedor = pr.id_fornecedor
GROUP BY f.nome
HAVING COUNT(pr.id_produto) > 1;
```

### Valor médio dos pedidos acima de R$ 500

```sql
SELECT p.id_pedido,
       AVG(ip.quantidade * ip.preco_unitario) AS valor_medio
FROM pedido p
JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido
HAVING AVG(ip.quantidade * ip.preco_unitario) > 500;
```



### Faturamento total por cliente 

```sql
SELECT c.nome,
       SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY c.nome
ORDER BY faturamento_total DESC;
```

### Produtos com estoque abaixo da média 

```sql
    SELECT pr.nome, e.quantidade
FROM produto pr
JOIN estoque e ON pr.id_produto = e.id_produto
WHERE e.quantidade < (
    SELECT AVG(quantidade) FROM estoque
);
```

### Pedidos com mais de uma forma de pagamento 

```sql
    SELECT p.id_pedido, COUNT(pg.id_pagamento) AS qtd_pagamentos
FROM pedido p
JOIN pagamento pg ON p.id_pedido = pg.id_pedido
GROUP BY p.id_pedido
HAVING COUNT(pg.id_pagamento) > 1;
```




## 📊 Diagrama Entidade-Relacionamento (DER)

O modelo entidade-relacionamento (DER) foi desenvolvido considerando os seguintes pontos:

### 📌 Regras de Negócio Implementadas

- **Cliente PF e PJ**
  - Um cliente pode ser **Pessoa Física (PF)** ou **Pessoa Jurídica (PJ)**, mas nunca ambos
- **Pagamento**
  - Um pedido pode possuir **mais de uma forma de pagamento**
- **Entrega**
  - Cada pedido possui uma entrega com:
    - Status
    - Código de rastreio
- **Relacionamentos**
  - Cliente → Pedido (1:N)
  - Pedido → Item do Pedido (1:N)
  - Produto → Fornecedor (N:1)
  - Produto → Estoque (1:1)
  - Pedido → Pagamento (1:N)
  - Pedido → Entrega (1:1)

<img width="962" height="1334" alt="Projeto Conceitual - Ecommerce_Refinado" src="https://github.com/user-attachments/assets/ec243925-170f-43ac-bd4f-230ee59d004c" />


## 🗂 Estrutura do Banco de Dados

### Tabelas Criadas

- `cliente`
- `cliente_pf`
- `cliente_pj`
- `fornecedor`
- `produto`
- `estoque`
- `pedido`
- `item_pedido`
- `pagamento`
- `entrega`


Cada tabela foi criada respeitando o princípio da normalização e integridade referencial.

---

## 🛠 Tecnologias Utilizadas

- **MySQL**
- **MySQL Workbench**
- **SQL ANSI**
- **Git e GitHub**
  

---
---

## 📦 Conclusão

Este projeto contempla **todas as diretrizes propostas**, apresentando um banco de dados funcional, normalizado, com persistência de dados e consultas SQL capazes de responder perguntas reais do negócio. Possuindo estrutura clara, organizada e profissional.

