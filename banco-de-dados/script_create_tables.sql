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
