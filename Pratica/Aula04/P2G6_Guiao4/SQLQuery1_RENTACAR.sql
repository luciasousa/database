CREATE SCHEMA RENT_A_CAR;
GO

CREATE TABLE client(
	nif DECIMAL(9,0) PRIMARY KEY NOT NULL CHECK(nif > 0),
	nome VARCHAR(40) NOT NULL, 
	endereço VARCHAR(40) NOT NULL, 
	num_carta DECIMAL(9,0) UNIQUE NOT NULL CHECK(num_carta > 0)
);

CREATE TABLE balcao(
	numero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nome VARCHAR(40) NOT NULL,
	endereço VARCHAR(40) NOT NULL
);

CREATE TABLE tipo_veiculo(
	codigo INT PRIMARY KEY NOT NULL,
	designacao VARCHAR(40) NOT NULL,
	arcondicionado BIT NOT NULL
);

CREATE TABLE veiculo(
	matricula DECIMAL(9,0) PRIMARY KEY NOT NULL,
	ano INT NOT NULL CHECK(ano > 0),
	marca VARCHAR(40) NOT NULL,
	tipo_codigo INT REFERENCES tipo_veiculo(codigo) NOT NULL
);

CREATE TABLE aluguer(
	numero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	duracao INT NOT NULL,
	data_aluguer DATE NOT NULL,
	cliente_NIF DECIMAL(9,0) REFERENCES client(nif) NOT NULL,
	balcao_num INT REFERENCES balcao(numero) NOT NULL,
	matricula_veiculo DECIMAL(9,0) REFERENCES veiculo(matricula) NOT NULL
);

CREATE TABLE similaridade(
	codigoA INT REFERENCES tipo_veiculo(codigo) NOT NULL,
	codigoB INT REFERENCES tipo_veiculo(codigo) NOT NULL,
	PRIMARY KEY(codigoA,codigoB)
);

CREATE TABLE ligeiro(
	tipo_codigo INT PRIMARY KEY REFERENCES tipo_veiculo(codigo) NOT NULL,
	numlugares INT NOT NULL CHECK(numlugares > 0),
	portas INT NOT NULL CHECK(portas > 0),
	combustivel VARCHAR(20) NOT NULL
);

CREATE TABLE pesado(
	tipo_codigo INT PRIMARY KEY REFERENCES tipo_veiculo(codigo) NOT NULL,
	peso INT NOT NULL CHECK(peso > 0),
	passageiros INT NOT NULL CHECK(passageiros > 0)
);
