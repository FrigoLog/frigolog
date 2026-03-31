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

-- TESTES ---------------

INSERT INTO empresa (nome, cnpj) VALUES
('FrigoTech', '12345678000199'),
('ColdStorage', '98765432000188');

INSERT INTO usuario (nome, senha, fk_empresa) VALUES
('João', '123', 1),
('Maria', '123', 1),
('Carlos', '123', 2);

INSERT INTO email (email, fk_usuario) VALUES
('joao@frigotech.com', 1),
('maria@frigotech.com', 2),
('carlos@coldstorage.com', 3);

INSERT INTO administrador (fk_usuario) VALUES
(1),
(3);

INSERT INTO tipo_ambiente (tipo) VALUES
('Câmara fria'),
('Estoque'),
('Transporte');

INSERT INTO ambiente_terceiros (nome, fk_empresa, fk_tipo_ambiente) VALUES
('Câmara A', 1, 1),
('Câmara B', 1, 1),
('Estoque Central', 2, 2);

INSERT INTO endereco (cep, numero, fk_ambiente) VALUES
('09990000', '100', 1),
('09990001', '200', 2),
('01010000', '300', 3);

INSERT INTO unidade (nome, fk_tipo_unidade, fk_ambiente) VALUES
('Freezer 1', 1, 1),
('Freezer 2', 1, 2),
('Container 1', 3, 3);

INSERT INTO configuracao_unidade (temp_min, temp_max, fk_unidade) VALUES
(-10, -2, 1),
(-8, -1, 2),
(2, 8, 3);

INSERT INTO sensor (identificador, fk_unidade) VALUES
('SENSOR_A1', 1),
('SENSOR_A2', 2),
('SENSOR_B1', 3);

INSERT INTO leitura (temperatura, data_hora, fk_sensor) VALUES
(-5, '2026-03-30 10:00:00', 1),
(-7, '2026-03-30 11:00:00', 1),
(-3, '2026-03-30 12:00:00', 1),

(-9, '2026-03-30 10:00:00', 2),
(-2, '2026-03-30 11:00:00', 2),
(0,  '2026-03-30 12:00:00', 2),

(5, '2026-03-30 10:00:00', 3),
(7, '2026-03-30 11:00:00', 3),
(10,'2026-03-30 12:00:00', 3);




SELECT 
    l.id_leitura,
    l.temperatura,
    l.data_hora,
    s.identificador,
    u.nome AS unidade
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
JOIN unidade u ON s.fk_unidade = u.id_unidade;

SELECT 
    e.nome AS empresa,
    l.temperatura,
    l.data_hora
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
JOIN unidade u ON s.fk_unidade = u.id_unidade
JOIN ambiente_terceiros a ON u.fk_ambiente = a.id_ambiente
JOIN empresa e ON a.fk_empresa = e.id_empresa;



SELECT 
    u.nome AS unidade,
    l.temperatura,
    cu.temp_min,
    cu.temp_max,
    l.data_hora
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
JOIN unidade u ON s.fk_unidade = u.id_unidade
JOIN configuracao_unidade cu ON cu.fk_unidade = u.id_unidade
WHERE l.temperatura < cu.temp_min 
   OR l.temperatura > cu.temp_max;
   
   SELECT 
    u.nome,
    AVG(l.temperatura) AS media_temp
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
JOIN unidade u ON s.fk_unidade = u.id_unidade
GROUP BY u.nome;

SELECT 
    u.nome,
    MAX(l.temperatura) AS max_temp,
    MIN(l.temperatura) AS min_temp
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
JOIN unidade u ON s.fk_unidade = u.id_unidade
GROUP BY u.nome;

SELECT 
    u.nome,
    COUNT(*) AS total_alertas
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
JOIN unidade u ON s.fk_unidade = u.id_unidade
JOIN configuracao_unidade cu ON cu.fk_unidade = u.id_unidade
WHERE l.temperatura < cu.temp_min 
   OR l.temperatura > cu.temp_max
GROUP BY u.nome;

SELECT 
    s.identificador,
    MAX(l.data_hora) AS ultima_leitura
FROM leitura l
JOIN sensor s ON l.fk_sensor = s.id_sensor
GROUP BY s.identificador;


