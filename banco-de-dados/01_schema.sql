CREATE DATABASE frigolog;
use frigolog;

CREATE TABLE tipo_usuario (
	id_tipo_usuario INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(25)
);

CREATE TABLE empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45),
	cnpj CHAR(14)
);

CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    senha VARCHAR(50),
    email VARCHAR(80),
    fk_tipo_usuario INT,
    fk_empresa INT,
    CONSTRAINT ctFkUsuarioEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT ctFkTipoUsuario FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario)
);

CREATE TABLE tipo_locais (
	id_tipo_locais INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE endereco (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    cep CHAR(8),
    numero VARCHAR(10)
);

CREATE TABLE ambiente_terceiros (
	id_ambiente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_empresa INT,
    fk_tipo_ambiente INT,
	fk_endereco INT UNIQUE,
    CONSTRAINT ctFkEnderecoAmbiente FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco),
    CONSTRAINT ctFkAmbienteEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa),
    CONSTRAINT ctFkAmbienteTipo FOREIGN KEY (fk_tipo_ambiente) REFERENCES tipo_ambiente (id_tipo_ambiente)
);

CREATE TABLE configuracao_unidade (
	id_configuracao INT PRIMARY KEY AUTO_INCREMENT,
    temp_min FLOAT,
    temp_max FLOAT
);

CREATE TABLE unidade (
	id_unidade INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_tipo_unidade INT,
    fk_ambiente INT,
	fk_unidade INT,
    CONSTRAINT ctFkConfigUnidade FOREIGN KEY (fk_config_unidade) REFERENCES configuracao_unidade (id_configuracao),
    CONSTRAINT ctUnidadeTipo FOREIGN KEY (fk_tipo_unidade) REFERENCES tipo_ambiente (id_tipo_ambiente),
    CONSTRAINT ctUnidadeAmbiente FOREIGN KEY (fk_ambiente) REFERENCES ambiente_terceiros (id_ambiente)
);

CREATE TABLE sensor (
	id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    identificador VARCHAR(30),
    fk_unidade INT,
    CONSTRAINT ctFkSensorUnidade FOREIGN KEY (fk_unidade) REFERENCES unidade (id_unidade)
);

CREATE TABLE leitura (
	id_leitura INT PRIMARY KEY AUTO_INCREMENT,
    temperatura FLOAT,
    data_hora DATETIME,
    fk_sensor INT,
    CONSTRAINT fkLeituraSensor FOREIGN KEY (fk_sensor) REFERENCES sensor (id_sensor)
);