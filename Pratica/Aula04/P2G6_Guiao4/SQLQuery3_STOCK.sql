CREATE SCHEMA STOCK_MANAGEMENT;
GO

--DROP TABLE tipo_fornecedor
--DROP TABLE fornecedor
--DROP TABLE condicoes_de_pagamento
--DROP TABLE encomenda
--DROP TABLE guardado
--DROP TABLE armazem
--DROP TABLE taxa_de_iva
--DROP TABLE produto
--DROP TABLE tem

CREATE TABLE tipo_fornecedor(
	codigo INT PRIMARY KEY CHECK(codigo > 0) NOT NULL,
	designacao VARCHAR(20) NOT NULL
);

CREATE TABLE fornecedor(
	nif DECIMAL(9,0) PRIMARY KEY NOT NULL,
	tipo_codigo INT REFERENCES tipo_fornecedor(codigo) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	numero_de_fax DECIMAL(9,0) UNIQUE NOT NULL,
	endereco VARCHAR(40) NOT NULL
);

CREATE TABLE condicoes_de_pagamento(
	nif DECIMAL(9,0) REFERENCES fornecedor(nif) NOT NULL,
	cond_pagamento VARCHAR(20) NOT NULL,
	PRIMARY KEY(nif, cond_pagamento)
);

CREATE TABLE encomenda(
	numero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	data_de_realizacao DATE NOT NULL,
	fornecedor VARCHAR(40) NOT NULL,
	fornecedor_nif DECIMAL(9,0) REFERENCES fornecedor(nif) NOT NULL
);

CREATE TABLE produto(
	codigo INT PRIMARY KEY CHECK(codigo > 0) NOT NULL,
	nome VARCHAR(20) NOT NULL,
	preco DECIMAL(6,2) CHECK (preco > 0) NOT NULL
);

CREATE TABLE tem(
	numero_encomenda INT IDENTITY(1,1) PRIMARY KEY REFERENCES encomenda(numero) NOT NULL,
	codigo_produto INT REFERENCES produto(codigo) NOT NULL,
	quantidade INT CHECK(quantidade > 0) NOT NULL,
	preco_compra DECIMAL(6,2) CHECK (preco_compra > 0) NOT NULL
);

CREATE TABLE taxa_de_iva(
	taxa_de_iva INT CHECK (taxa_de_iva > 0) NOT NULL,
	codigo_produto INT REFERENCES produto(codigo) NOT NULL,
	PRIMARY KEY(taxa_de_iva,codigo_produto)
);

CREATE TABLE armazem(
	codigo INT PRIMARY KEY NOT NULL,
	localizacao VARCHAR(40) NOT NULL,
	nome VARCHAR(20) NOT NULL
);

CREATE TABLE guardado(
	codigo_produto INT REFERENCES produto(codigo) NOT NULL,
	codigo_armazem INT REFERENCES armazem(codigo) NOT NULL,
	PRIMARY KEY(codigo_produto,codigo_armazem)
);