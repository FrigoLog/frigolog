use frigolog;

CREATE TABLE empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45),
	cnpj CHAR(14)
);

CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    senha VARCHAR(50),
    fk_empresa INT,
    CONSTRAINT ctFkUsuarioEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE email (
	id_email INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(80),
    fk_usuario INT,
    CONSTRAINT ctFkEmailUsuario FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario)
);

CREATE TABLE administrador (
	id_administrador INT PRIMARY KEY AUTO_INCREMENT,
    fk_usuario INT,
    CONSTRAINT ctFkAdmUsuario FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario)
);

CREATE TABLE tipo_ambiente (
	id_tipo_ambiente INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE ambiente_terceiros (
	id_ambiente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_empresa INT,
    fk_tipo_ambiente INT,
    CONSTRAINT ctFkAmbienteEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa),
    CONSTRAINT ctFkAmbienteTipo FOREIGN KEY (fk_tipo_ambiente) REFERENCES tipo_ambiente (id_tipo_ambiente)
);

CREATE TABLE endereco (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    cep CHAR(8),
    numero VARCHAR(10),
    fk_ambiente INT UNIQUE,
    CONSTRAINT ctFkEnderecoAmbiente FOREIGN KEY (fk_ambiente) REFERENCES ambiente_terceiros (id_ambiente)
);

CREATE TABLE unidade (
	id_unidade INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_tipo_unidade INT,
    fk_ambiente INT,
    CONSTRAINT ctUnidadeTipo FOREIGN KEY (fk_tipo_unidade) REFERENCES tipo_ambiente (id_tipo_ambiente),
    CONSTRAINT ctUnidadeAmbiente FOREIGN KEY (fk_ambiente) REFERENCES ambiente_terceiros (id_ambiente)
);

CREATE TABLE configuracao_unidade (
	id_configuracao INT PRIMARY KEY AUTO_INCREMENT,
    temp_min FLOAT,
    temp_max FLOAT,
    fk_unidade INT UNIQUE,
    CONSTRAINT ctFkConfigUnidade FOREIGN KEY (fk_unidade) REFERENCES unidade (id_unidade)
);

CREATE TABLE sensor (
	id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    identificador VARCHAR(30),
    fk_unidade INT UNIQUE,
    CONSTRAINT ctFkSensorUnidade FOREIGN KEY (fk_unidade) REFERENCES unidade (id_unidade)
);

CREATE TABLE leitura (
	id_leitura INT PRIMARY KEY AUTO_INCREMENT,
    temperatura FLOAT,
    data_hora DATETIME,
    fk_sensor INT,
    CONSTRAINT fkLeituraSensor FOREIGN KEY (fk_sensor) REFERENCES sensor (id_sensor)
);

INSERT INTO empresa (nome, cnpj) VALUE ('FrigoLog Desenv', '12345678900012');
INSERT INTO usuario (nome, senha, fk_empresa) VALUE ('Bruno Rafael', 'bruno123', 1);
INSERT INTO email (email, fk_usuario) VALUE ('bruno.rafael@frigolog.com', 1);
INSERT INTO administrador (fk_usuario) VALUE (1);
INSERT INTO tipo_ambiente (tipo) VALUES ('Geladeira', 'Comércio');
INSERT INTO ambiente_terceiros (nome, fk_empresa, fk_tipo_ambiente) VALUE ('Assaí Atacadista', 1, 2);
INSERT INTO endereco (cep, numero, fk_ambiente) VALUE ('09960170', '1003', 1);
INSERT INTO unidade (nome, fk_tipo_unidade, fk_ambiente) VALUE ('Geladeira A', 1, 1);
INSERT INTO configuracao_unidade (temp_min, temp_max, fk_unidade) VALUE (0, 4, 1);
INSERT INTO sensor (identificador, fk_unidade) VALUE ('SENSOR_GELADEIRA_A_98761', 1);
