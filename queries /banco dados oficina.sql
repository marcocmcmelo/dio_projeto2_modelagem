create database if not exists oficina_mecanica default character set utf8;

use oficina_mecanica;

-- Criação das tabelas banco de dados oficina_mecanica

-- Tabela clientes
create table if not exists oficina_mecanica.clientes(
  idclientes int not null auto_increment,
  nome varchar(100) not null,
  cpf_cnpj varchar(14) not null,
  rua varchar(30) not null,
  numrua varchar(10) not null,
  complemento varchar(45),
  bairro varchar(45) not null,
  cidade varchar(45) not null,
  estado varchar(45) not null,
  cep varchar(10) not null,
  telefone varchar(15) not null,
  email varchar(100) not null,
  datacadastro timestamp default current_timestamp,
  primary key (idclientes),
  unique index cpf_unique (cpf_cnpj)
  )
engine = InnoDB;

-- Tabela Equipes
create table if not exists oficina_mecanica.equipes(
idequipes int not null auto_increment,
descricao varchar(45),
primary key (idequipes)
)
engine = InnoDB;

-- Tabela Veículos
create table if not exists oficina_mecanica.veiculos(
idveiculos int not null auto_increment,
modelo varchar(45) not null,
marca varchar(45) not null,
placa varchar(10) not null,
ano varchar(5),
idclientes int not null,
idequipes int not null,
primary key(idveiculos, idclientes, idequipes),
unique index placa_unique (placa),
index fk_veiculos_clientes_idx (idclientes),
index fk_veiculos_equipes_idx (idequipes),
constraint fk_veiculos_clientes foreign key (idclientes) 
references oficina_mecanica.clientes(idclientes) on delete no action on update no action,
constraint fk_veiculos_equipes foreign key(idequipes)
references oficina_mecanica.equipes(idequipes) on delete no action on update no action)
engine = InnoDB;

-- Tabela mecânicos
create table if not exists oficina_mecanica.mecanicos(
idmecanicos int not null auto_increment,
nome varchar(45) not null,
endereco varchar(255) not null,
especialidade varchar(45) not null,
telefone varchar(15) not null,
primary key (idmecanicos)
)
engine = InnoDB;


-- Tabela peças
create table if not exists oficina_mecanica.pecas(
idpecas int not null auto_increment,
descricao varchar(45) not null,
valor decimal(10,2) not null,
primary key(idpecas)
)
engine = InnoDB;


-- Tabela mao_obra
create table if not exists oficina_mecanica.mao_obra(
idmao_obra int not null auto_increment,
descricao varchar(100) not null,
valor_mao_obra decimal(10,2) not null,
primary key(idmao_obra)
)
engine = InnoDB;


-- Tabela Equipes_mecanicos
create table if not exists oficina_mecanica.equipes_mecanicos(
idmecanicos int not null,
idequipes int not null,
primary key (idmecanicos, idequipes),
index fk_mec_equipes_idx (idequipes),
index fk_mec_mec_idx ( idmecanicos),
constraint fk_mec_mecanicos foreign key (idmecanicos)
references oficina_mecanica.mecanicos (idmecanicos) on delete no action on update no action,
constraint fk_mec_equipes foreign key (idequipes)
references oficina_mecanica.equipes(idequipes) on delete no action on update no action
)
engine = InnoDB;


-- Tabela ordem de serviço
create table if not exists oficina_mecanica.ordem_servico(
idordem_servico int not null auto_increment,
idveiculos int not null,
data_emissao date not null,
data_entrega date not null,
valor decimal(10,2) not null,
status_os enum('Aberto', 'Pendente', 'Autorizada', 'Em Andamento', 'Finalizada', 'Cancelada') default 'Pendente',
idequipes int not null,
primary key (idordem_servico, idveiculos, idequipes),
index fk_os_veiculo_idx (idequipes),
constraint fk_os_veiculos foreign key (idequipes)
references oficina_mecanica.veiculos (idequipes) on delete no action on update no action
)
engine = InnoDB;


-- Tabela OS mão de obra
create table if not exists oficina_mecanica.OS_mao_obra(
idmao_obra int not null,
idordem_servico int not null,
idveiculos int not null,
primary key (idmao_obra, idordem_servico, idveiculos),
index fk_mo_os_idx (idordem_servico, idveiculos),
index fk_maoobra_idx (idmao_obra),
constraint fk_mo_os foreign key (idmao_obra) references oficina_mecanica.mao_obra (idmao_obra)
on delete no action on update no action,
constraint fk_mo_os_veiculo foreign key (idordem_servico, idveiculos) 
references oficina_mecanica.ordem_servico (idordem_servico, idveiculos)
on delete no action on update no action
)
engine = InnoDB;


-- Tabela OS_pecas
create table if not exists oficina_mecanica.os_pecas (
idpecas int not null,
idordem_servico int not null,
idveiculos int not null,
primary key (idpecas, idordem_servico, idveiculos),
index fk_pecas_os_idx (idordem_servico, idveiculos),
index fk_pecas_idx (idpecas),
constraint fk_pecas_os foreign key (idpecas) references oficina_mecanica.pecas(idpecas)
on delete no action on update no action,
constraint fk_ordemserico foreign key (idordem_servico, idveiculos) 
references oficina_mecanica.ordem_servico (idordem_servico, idveiculos)
on delete no action on update no action
)
engine = InnoDB;


-- Tabela pagamentos
create table if not exists oficina_mecanica.pagamentos(
idpagamentos int not null auto_increment,
valor_pagto decimal(10,2) not null,
data_pagto datetime not null,
metodo_pagto enum('Pix', 'Cartão Crédito', 'Cartão Débito', 'Dinheiro') not null,
status_pagto enum('Pendente', 'Concluído', 'Cancelado') not null,
observacao varchar(255),
idordem_servico int not null,
primary key (idpagamentos, idordem_servico),
index fk_pagto_idx (idordem_servico),
constraint fk_pagto_os foreign key (idordem_servico) 
references oficina_mecanica.ordem_servico(idordem_servico)
on delete no action on update no action
)
engine = InnoDB;



-- Tabela cartão de crédito
create table if not exists oficina_mecanica.cartao_credito(
idcartao int not null auto_increment,
nometitular varchar(100) not null,
ultimos_quatro_digitos varchar(4) not null,
bandeira varchar(45) not null,
token varchar(255) not null,
idPagamentos int not null,
primary key (idcartao, idpagamentos),
index fk_cc_pagtp_idx (idpagamentos),
constraint fk_cc_pagto foreign key (idpagamentos) references oficina_mecanica.pagamentos(idpagamentos)
on delete no action on update no action
)
engine = InnoDB;

-- Inserindo registros nas tabelas

insert into oficina_mecanica.clientes
(nome, cpf_cnpj, rua, numrua, complemento, bairro, cidade, estado, cep, telefone, email)
values
('João Silva', '12345678901', 'Rua das Flores', '123', 'Apt 101', 'Centro', 'São Paulo', 'SP', '01001-000', '(11) 99999-1111', 'joao.silva@email.com'),
('Maria Oliveira', '23456789012', 'Av. Paulista', '456', 'Bloco B', 'Bela Vista', 'São Paulo', 'SP', '01310-200', '(11) 98888-2222', 'maria.oliveira@email.com'),
('Carlos Souza', '34567890123', 'Rua do Mercado', '789', NULL, 'Centro', 'Rio de Janeiro', 'RJ', '20010-020', '(21) 97777-3333', 'carlos.souza@email.com'),
('Ana Costa', '45678901234', 'Rua das Acácias', '101', 'Casa', 'Jardim América', 'Curitiba', 'PR', '80010-000', '(41) 96666-4444', 'ana.costa@email.com'),
('Pedro Lima', '56789012345', 'Av. das Nações', '202', NULL, 'Centro', 'Brasília', 'DF', '70040-010', '(61) 95555-5555', 'pedro.lima@email.com'),
('Luiza Santos', '67890123456', 'Rua do Sol', '303', 'Apt 202', 'Centro', 'Recife', 'PE', '50010-020', '(81) 94444-6666', 'luiza.santos@email.com'),
('Rafael Almeida', '78901234567', 'Rua dos Limoeiros', '404', 'Sobrado', 'Vila Mariana', 'São Paulo', 'SP', '04020-040', '(11) 93333-7777', 'rafael.almeida@email.com'),
('Juliana Pereira', '89012345678', 'Av. Atlântica', '505', NULL, 'Copacabana', 'Rio de Janeiro', 'RJ', '22010-050', '(21) 92222-8888', 'juliana.pereira@email.com'),
('Fernando Mendes', '90123456789', 'Rua das Palmeiras', '606', 'Casa', 'Centro', 'Belo Horizonte', 'MG', '30010-070', '(31) 91111-9999', 'fernando.mendes@email.com'),
('Patrícia Araújo', '01234567890', 'Rua do Bosque', '707', NULL, 'Centro', 'Porto Alegre', 'RS', '90010-080', '(51) 90000-0000', 'patricia.araujo@email.com');


insert into oficina_mecanica.equipes (descricao)
values
('Mecânica Geral'),
('Alinhamento e Balanceamento'),
('Troca de Óleo'),
('Suspensão e Freios'),
('Diagnóstico Eletrônico'),
('Funilaria e Pintura'),
('Lavagem e Higienização'),
('Troca de Pneus'),
('Revisão Preventiva'),
('Motor e Transmissão');

insert into oficina_mecanica.veiculos (modelo, marca, placa, ano, idclientes, idequipes)
values
('Civic', 'Honda', 'ABC1D23', '2020', 1, 1),
('Corolla', 'Toyota', 'DEF4G56', '2019', 2, 2),
('Gol', 'Volkswagen', 'HIJ7K89', '2018', 3, 3),
('Onix', 'Chevrolet', 'LMN0P12', '2021', 4, 4),
('Fiesta', 'Ford', 'QRS3T45', '2017', 5, 5),
('HB20', 'Hyundai', 'UVW6X78', '2022', 6, 6),
('Spin', 'Chevrolet', 'YZA9B01', '2015', 7, 7),
('Compass', 'Jeep', 'CDE2F34', '2023', 8, 8),
('Sandero', 'Renault', 'GHI5J67', '2016', 9, 9),
('Tiguan', 'Volkswagen', 'KLM8N90', '2020', 10, 10);



insert into oficina_mecanica.mecanicos (nome, endereco, especialidade, telefone)
values
('João Pereira', 'Rua das Flores, 123 - Centro, São Paulo/SP', 'Mecânica Geral', '(11) 99999-1111'),
('Maria Oliveira', 'Av. Paulista, 456 - Bela Vista, São Paulo/SP', 'Alinhamento e Balanceamento', '(11) 98888-2222'),
('Carlos Souza', 'Rua do Mercado, 789 - Centro, Rio de Janeiro/RJ', 'Diagnóstico Eletrônico', '(21) 97777-3333'),
('Ana Costa', 'Rua das Acácias, 101 - Jardim América, Curitiba/PR', 'Suspensão e Freios', '(41) 96666-4444'),
('Pedro Lima', 'Av. das Nações, 202 - Asa Sul, Brasília/DF', 'Troca de Óleo', '(61) 95555-5555'),
('Luiza Santos', 'Rua do Sol, 303 - Boa Viagem, Recife/PE', 'Funilaria e Pintura', '(81) 94444-6666'),
('Rafael Almeida', 'Rua dos Limoeiros, 404 - Vila Mariana, São Paulo/SP', 'Troca de Pneus', '(11) 93333-7777'),
('Juliana Pereira', 'Av. Atlântica, 505 - Copacabana, Rio de Janeiro/RJ', 'Lavagem e Higienização', '(21) 92222-8888'),
('Fernando Mendes', 'Rua das Palmeiras, 606 - Centro, Belo Horizonte/MG', 'Revisão Preventiva', '(31) 91111-9999'),
('Patrícia Araújo', 'Rua do Bosque, 707 - Centro, Porto Alegre/RS', 'Motor e Transmissão', '(51) 90000-0000');


insert into oficina_mecanica.pecas (descricao, valor)
values
('Filtro de óleo', 45.90),
('Pastilha de freio', 120.00),
('Correia dentada', 85.50),
('Amortecedor dianteiro', 250.75),
('Velas de ignição', 35.00),
('Bateria 60Ah', 450.00),
('Disco de freio', 180.90),
('Pneu 175/65 R14', 350.00),
('Radiador de motor', 500.00),
('Filtro de Ar', 40.00);

insert into oficina_mecanica.mao_obra (descricao, valor_mao_obra)
values
('Troca de óleo e filtro', 150.00),
('Alinhamento e balanceamento', 120.00),
('Substituição de pastilhas de freio', 200.00),
('Troca de correia dentada', 350.00),
('Revisão completa', 800.00),
('Substituição de amortecedores', 400.00),
('Diagnóstico eletrônico', 100.00),
('Troca de bateria', 50.00),
('Regulagem de motor', 250.00),
('Reparação do sistema de ar-condicionado', 300.00);

insert into oficina_mecanica.equipes_mecanicos (idmecanicos, idequipes)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

insert into oficina_mecanica.ordem_servico (idveiculos, data_emissao, data_entrega, valor, status_os, idequipes)
values
(1, '2025-01-01', '2025-01-05', 1500.00, 'Aberto', 1),
(2, '2025-01-02', '2025-01-06', 800.00, 'Pendente', 2),
(3, '2025-01-03', '2025-01-07', 1200.00, 'Autorizada', 3),
(4, '2025-01-04', '2025-01-08', 2000.00, 'Em Andamento', 4),
(5, '2025-01-05', '2025-01-09', 500.00, 'Finalizada', 5),
(6, '2025-01-06', '2025-01-10', 300.00, 'Cancelada', 6),
(7, '2025-01-07', '2025-01-11', 1000.00, 'Pendente', 7),
(8, '2025-01-08', '2025-01-12', 2500.00, 'Aberto', 8),
(9, '2025-01-09', '2025-01-13', 1800.00, 'Autorizada', 9),
(10, '2025-01-10', '2025-01-14', 2200.00, 'Finalizada', 10);

insert into oficina_mecanica.OS_mao_obra (idmao_obra, idordem_servico, idveiculos)
values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);


insert into oficina_mecanica.os_pecas (idpecas, idordem_servico, idveiculos)
values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);


insert into oficina_mecanica.pagamentos (valor_pagto, data_pagto, metodo_pagto, status_pagto, observacao, idordem_servico)
values
(1500.00, '2025-01-01 10:00:00', 'Pix', 'Concluído', 'Pagamento integral via Pix', 1),
(800.00, '2025-01-02 12:00:00', 'Cartão Crédito', 'Pendente', 'Aguardando aprovação do cartão', 2),
(1200.00, '2025-01-03 09:30:00', 'Cartão Débito', 'Concluído', 'Pagamento realizado no débito', 3),
(2000.00, '2025-01-04 14:15:00', 'Dinheiro', 'Concluído', 'Pagamento em dinheiro na entrega', 4),
(500.00, '2025-01-05 16:45:00', 'Pix', 'Cancelado', 'Cancelado pelo cliente antes do pagamento', 5),
(300.00, '2025-01-06 11:00:00', 'Cartão Crédito', 'Concluído', 'Pagamento no crédito', 6),
(1000.00, '2025-01-07 13:20:00', 'Cartão Débito', 'Pendente', 'Aguardando compensação do banco', 7),
(2500.00, '2025-01-08 15:00:00', 'Dinheiro', 'Concluído', 'Pagamento em dinheiro', 8),
(1800.00, '2025-01-09 08:30:00', 'Pix', 'Pendente', 'Aguardando confirmação do pagamento', 9),
(2200.00, '2025-01-10 10:00:00', 'Cartão Crédito', 'Concluído', 'Pagamento no crédito, parcelado em 3x', 10);


insert into oficina_mecanica.cartao_credito (nometitular, ultimos_quatro_digitos, bandeira, token, idPagamentos)
values
('João Silva', '1234', 'VISA', 'token_001', 1),
('Maria Oliveira', '5678', 'MasterCard', 'token_002', 2),
('Carlos Souza', '9101', 'Elo', 'token_003', 3),
('Ana Costa', '1122', 'VISA', 'token_004', 4),
('Roberto Lima', '3344', 'MasterCard', 'token_005', 5),
('Fernanda Pereira', '5566', 'VISA', 'token_006', 6),
('Juliana Santos', '7788', 'Elo', 'token_007', 7),
('Paulo Alves', '9900', 'VISA', 'token_008', 8),
('Patrícia Gomes', '2233', 'MasterCard', 'token_009', 9),
('Lucas Rocha', '4455', 'VISA', 'token_010', 10);

-- Consulta simples 

select * from clientes;

select * from veiculos;

select * from mecanicos;

select * from equipes;

-- Consultas com where

select nome, cpf_cnpj, telefone, estado from clientes
where estado in ('SP', 'RJ');

select * from veiculos
where ano > 2020;

select * from pecas
where valor > 100.00;


-- Consultas com ordenação
select * from pecas
order by valor desc;

select * from mao_obra
order by valor_mao_obra;


-- Consultas com agrupamento
select estado, count(idclientes) as total_clientes from clientes group by estado;

select metodo_pagto, count(idpagamentos) as total_pagto from pagamentos group by metodo_pagto;

select metodo_pagto, count(idpagamentos) as total_pagto 
from pagamentos 
group by metodo_pagto 
order by total_pagto asc;

-- consultas com join (junção tabelas)

select p.idpagamentos, p.valor_pagto, p.data_pagto, p.metodo_pagto, c.nometitular, c.bandeira
FROM oficina_mecanica.pagamentos p
JOIN oficina_mecanica.cartao_credito c
ON p.idpagamentos = c.idpagamentos
WHERE p.metodo_pagto = 'Cartão Crédito'
AND p.status_pagto = 'Concluído'
ORDER BY p.data_pagto DESC;

select p.idpagamentos, p.valor_pagto, p.data_pagto, p.metodo_pagto, c.nometitular, c.bandeira
FROM oficina_mecanica.pagamentos p
JOIN oficina_mecanica.cartao_credito c
ON p.idpagamentos = c.idpagamentos
WHERE p.metodo_pagto = 'Cartão Crédito'
ORDER BY p.data_pagto DESC;

select p.idpagamentos, p.valor_pagto, p.data_pagto, p.metodo_pagto, c.nometitular, c.bandeira
FROM oficina_mecanica.pagamentos p
JOIN oficina_mecanica.cartao_credito c
ON p.idpagamentos = c.idpagamentos
WHERE p.metodo_pagto in ('Cartão Crédito', 'Cartão Débito', 'Pix', 'Dinehiro')
having valor_pagto > 1000.00
ORDER BY p.data_pagto DESC;

select p.idpagamentos, p.valor_pagto, p.data_pagto, p.metodo_pagto, c.nometitular, c.bandeira
FROM oficina_mecanica.pagamentos p
JOIN oficina_mecanica.cartao_credito c
ON p.idpagamentos = c.idpagamentos
WHERE p.metodo_pagto in ('Cartão Crédito', 'Cartão Débito', 'Pix', 'Dinehiro')
ORDER BY p.data_pagto DESC;




