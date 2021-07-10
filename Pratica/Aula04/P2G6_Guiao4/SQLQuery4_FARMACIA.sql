CREATE SCHEMA PRESCRIPTION_SYSTEM;
GO

/*DROP SCHEMA PRESCRIPTION_SYSTEM;
DROP TABLE efetua;
DROP TABLE paciente;
DROP TABLE medico;
DROP TABLE prescricao;
DROP TABLE vende;
DROP TABLE farmaco;
DROP TABLE companhia_farmaceutica;
DROP TABLE farmaceutica;
DROP TABLE farmacia;*/

CREATE TABLE farmacia(
	NIF INT NOT NULL,
	nome VARCHAR(40) NOT NULL,
	endereco VARCHAR(80) NOT NULL,
	telefone INT NOT NULL CHECK(telefone > 0),
	PRIMARY KEY(NIF)
);

CREATE TABLE farmaceutica(
	no_registo_nacional INT NOT NULL,
	nome VARCHAR(40) NOT NULL,
	endereco VARCHAR(80) NOT NULL,
	telefone INT NOT NULL CHECK(telefone > 0),
	NIF_farmacia INT NOT NULL,
	FOREIGN KEY(NIF_farmacia) REFERENCES farmacia(NIF),
	PRIMARY KEY(no_registo_nacional)
);

CREATE TABLE companhia_farmaceutica(
	no_registo_nacional_cf INT NOT NULL,
	nome VARCHAR(40) NOT NULL,
	endereco VARCHAR(80) NOT NULL,
	telefone INT NOT NULL CHECK(telefone > 0),
	PRIMARY KEY(no_registo_nacional_cf)
);

CREATE TABLE farmaco(
	no_registo_nacional_cf INT NOT NULL,
	formula VARCHAR(80) NOT NULL,
	nome_comercial VARCHAR(40) NOT NULL,
	FOREIGN KEY(no_registo_nacional_cf) REFERENCES companhia_farmaceutica(no_registo_nacional_cf),
	PRIMARY KEY(no_registo_nacional_cf)
);

CREATE TABLE vende(
	NIF_farmacia INT NOT NULL,
	no_registo_nacional_cf INT NOT NULL,
	FOREIGN KEY(NIF_farmacia) REFERENCES farmacia(NIF),
	FOREIGN KEY(no_registo_nacional_cf) REFERENCES companhia_farmaceutica(no_registo_nacional_cf),
	PRIMARY KEY(NIF_farmacia, no_registo_nacional_cf)
);

CREATE TABLE prescricao(
	no_prescricao INT NOT NULL,
	data_consulta DATE,
	NIF_farmacia INT NOT NULL,
	data_processamento DATE,
	FOREIGN KEY(NIF_farmacia) REFERENCES farmacia(NIF),
	PRIMARY KEY(no_prescricao)
);

CREATE TABLE medico(
	no_identificacao INT NOT NULL,
	nome VARCHAR(40) NOT NULL,
	especialidade VARCHAR(40) NOT NULL,
	PRIMARY KEY(no_identificacao)
);

CREATE TABLE paciente(
	no_utente INT NOT NULL,
	nome VARCHAR(40) NOT NULL,
	data_nascimento DATE,
	endereco VARCHAR(80) NOT NULL,
	PRIMARY KEY(no_utente)
);

CREATE TABLE efetua(
	no_identificacao INT NOT NULL,
	no_utente INT NOT NULL,
	no_prescricao INT NOT NULL,
	FOREIGN KEY(no_identificacao) REFERENCES medico(no_identificacao),
	FOREIGN KEY(no_utente) REFERENCES paciente(no_utente),
	FOREIGN KEY(no_prescricao) REFERENCES prescricao(no_prescricao),
	PRIMARY KEY(no_identificacao, no_utente, no_prescricao)
);
