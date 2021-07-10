CREATE SCHEMA ATL_MANAGEMENT;
GO

CREATE TABLE atl(
	identificador INT NOT NULL,
	localizacao VARCHAR(80) NOT NULL,
	PRIMARY KEY(identificador)
);

CREATE TABLE classe(
	id INT NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE pessoa(
	email VARCHAR(80) NOT NULL,
	nome VARCHAR(80) NOT NULL,
	no_cc DECIMAL(8,0) NOT NULL,
	morada VARCHAR(80) NOT NULL,
	data_nascimento DATE NOT NULL,
	PRIMARY KEY(email)
);

CREATE TABLE professor(
	no_funcionario INT NOT NULL,
	email VARCHAR(80) NOT NULL,
	contacto_telefonico DECIMAL(9,0) NOT NULL,
	FOREIGN KEY(email) REFERENCES pessoa(email),
	PRIMARY KEY(no_funcionario)
);

CREATE TABLE turma(
	identificador_atl INT NOT NULL,
	identificador INT NOT NULL,
	num_max_alunos INT NOT NULL CHECK(num_max_alunos > 0),
	designacao VARCHAR(100) NOT NULL,
	ano_letivo VARCHAR(10) NOT NULL,
	classe_id INT NOT NULL,
	no_funcionario INT NOT NULL,
	FOREIGN KEY(identificador_atl) REFERENCES atl(identificador),
	FOREIGN KEY(classe_id) REFERENCES classe(id),
	FOREIGN KEY(no_funcionario) REFERENCES professor(no_funcionario),
	PRIMARY KEY(identificador)
);

CREATE TABLE atividade(
	id INT NOT NULL,
	custo DECIMAL(6,2) NOT NULL CHECK(custo > 0),
	designacao VARCHAR(100) NOT NULL,
	email VARCHAR(80) NOT NULL,
	turma_inscrita INT NOT NULL,
	FOREIGN KEY(turma_inscrita) REFERENCES turma(identificador),
	PRIMARY KEY(id)
);

CREATE TABLE pessoa_autorizada(
	email VARCHAR(80) NOT NULL,
	contacto_telefonico DECIMAL(9,0) NOT NULL,
	FOREIGN KEY(email) REFERENCES pessoa(email),
	PRIMARY KEY(email)
);

CREATE TABLE encarregado_educacao(
	email VARCHAR(80) NOT NULL,
	relacao_aluno VARCHAR(40) NOT NULL,
	contacto_telefonico DECIMAL(9,0) NOT NULL,
	FOREIGN KEY(email) REFERENCES pessoa(email),
	PRIMARY KEY(email)
);

CREATE TABLE aluno(
	email VARCHAR(80) NOT NULL,
	FOREIGN KEY(email) REFERENCES pessoa(email),
	PRIMARY KEY(email)
);

