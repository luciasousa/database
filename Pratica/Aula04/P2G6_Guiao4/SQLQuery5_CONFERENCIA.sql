CREATE SCHEMA CONFERENCE_MANAGEMENT;
GO

/*DROP SCHEMA CONFERENCE_MANAGEMENT;
DROP TABLE conferencia;
DROP TABLE artigo_cientifico;
DROP TABLE escrito_por;
DROP TABLE autor;
DROP TABLE instituicao;
DROP TABLE comprovativo;
DROP TABLE participante;
DROP TABLE estudante;
DROP TABLE nao_estudante;*/

CREATE TABLE conferencia(
	ID INT NOT NULL,
	nome VARCHAR(40) NOT NULL,
	localizacao VARCHAR(80) NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE artigo_cientifico(
	no_registo INT NOT NULL,
	título VARCHAR(80) NOT NULL,
	ID_conferencia INT NOT NULL,
	FOREIGN KEY(ID_conferencia) REFERENCES conferencia(ID),
	PRIMARY KEY(no_registo)
);

CREATE TABLE instituicao(
	endereco VARCHAR(80) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	PRIMARY KEY(endereco)
);

CREATE TABLE autor(
	email VARCHAR(80) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	endereco_instituicao VARCHAR(80) NOT NULL,
	FOREIGN KEY(endereco_instituicao) REFERENCES instituicao(endereco),
	PRIMARY KEY(email)
);

CREATE TABLE escrito_por(
	no_registo_artigo INT NOT NULL,
	email_autor VARCHAR(80) NOT NULL,
	FOREIGN KEY(no_registo_artigo) REFERENCES artigo_cientifico(no_registo),
	FOREIGN KEY(email_autor) REFERENCES autor(email),
	PRIMARY KEY(no_registo_artigo, email_autor)
);

CREATE TABLE comprovativo(
	codigo INT NOT NULL,
	localizacao_eletronica VARCHAR(80) NOT NULL,
	endereco_instituicao VARCHAR(80) NOT NULL,
	FOREIGN KEY(endereco_instituicao) REFERENCES instituicao(endereco),
	PRIMARY KEY(codigo)
);

CREATE TABLE participante(
	email VARCHAR(80) NOT NULL,
	nome VARCHAR(40) NOT NULL,
	data_inscricao DATE,
	morada VARCHAR(80) NOT NULL,
	endereco_instituicao VARCHAR(80) NOT NULL,
	ID_conferencia INT NOT NULL,
	FOREIGN KEY(endereco_instituicao) REFERENCES instituicao(endereco),
	FOREIGN KEY(ID_conferencia) REFERENCES conferencia(ID),
	PRIMARY KEY(email)
);

CREATE TABLE estudante(
	email VARCHAR(80) NOT NULL,
	numero INT NOT NULL,
	codigo_comprovatico INT NOT NULL,
	FOREIGN KEY(email) REFERENCES participante(email),
	FOREIGN KEY(codigo_comprovatico) REFERENCES comprovativo(codigo),
	PRIMARY KEY(email)
);

CREATE TABLE nao_estudante(
	email VARCHAR(80) NOT NULL,
	numero INT NOT NULL,
	ref_transacao_bancaria INT NOT NULL,
	FOREIGN KEY(email) REFERENCES participante(email),
	PRIMARY KEY(email, numero)
);