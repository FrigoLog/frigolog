INSERT INTO tipo_usuario (tipo) VALUES
('Administrador'), ('Moderador');

INSERT INTO empresa (nome, cnpj) VALUES
('Frigolog desenv', '12345678900014');

INSERT INTO usuario (nome, senha, email, fk_tipo_usuario, fk_empresa) 
VALUES ('Thays', 'thays123', 'thays@frigolog.com', 1, 1);

INSERT INTO endereco (cep, numero) 
VALUES ('09987657', '512A');

INSERT INTO tipo_ambiente (tipo)
VALUES ('Comércio'), ('Transportadora');

INSERT INTO ambiente_terceiros (nome, fk_empresa, 
fk_tipo_ambiente, fk_endereco) VALUES
('FedEx', 1, 2, 1), ('Assaí Atacadista', 1, 1, 1);

INSERT INTO configuracao_unidade (temp_min, temp_max) 
VALUE (0.0, 4.0);

INSERT INTO tipo_unidade (tipo) VALUES
('Geladeira'), ('Caminhão');

INSERT INTO unidade (nome, fk_tipo_unidade, fk_ambiente, fk_config_unidade)
VALUES ('Caminhão 1', 2, 1, 1), ('Geladeira 1', 1, 1, 1);

INSERT INTO sensor (identificador, fk_unidade)
VALUES ('SENSOR_CAMINHAO1_A', 1), ('SENSOR_GELADEIRA1_A', 2);

