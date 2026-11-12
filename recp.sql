Criação de Esquemas


create table investidores (
id serial primary key,
nome varchar(150) not null,
cpf varchar(11) UNIQUE not null,
nivel_experiencia int DEFAULT 0 CHECK (nivel_experiencia >=0)
);


create table carteiras(
id serial primary key,
investidor_id int references investidores(id),
endereco_wallet varchar(50) UNIQUE not null,
rede_blockchain varchar(50) not null,
saldo_usd decimal(10, 2) not null
	CHECK (saldo_usd >0),
status varchar(20) DEFAULT 'Ativa'
	CHECK (status IN (
		'Ativa',
		'Em análise',
		'Pausada',
		'Bloqueada'
	))
)


create table corretoras(
id serial primary key,
nome_exchange varchar(100) not null,
cnpj varchar(14) UNIQUE not null,
email_suporte varchar(100) UNIQUE not null
);


create table criptomoedas(
id serial primary key,
corretora_id int references corretoras(id),
nome_moeda varchar(50) not null,
preco_unitario_usd decimal(10, 2) not null
	CHECK (preco_unitario_usd >0),
 categoria VARCHAR(20) DEFAULT 'Layer1'
        CHECK (categoria IN (
            'Layer1',
            'DeFi',
            'Memecoin',
            'Stablecoin'
        ))
);


create table transacoes_cripto(
id serial primary key,
carteira_id int references corretoras(id),
criptomoeda_id int references criptomoedas (id),
quantidade decimal(10, 2) not null
	CHECK (quantidade >0),
valor_pago decimal(10, 2) not null
	CHECK (valor_pago >0),
data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


Inserção de Dados


insert into investidores (nome, cpf, nivel_experiencia) VALUES
('Pedro Silva', '12345678901', 1),
('Maria Eduarda', '23456789012', 2),
('Pedro Oliveira', '34567890123', 3),
('Ana Clara', '45678901234', 4),
('Lucas Pereira', '56789012345', 5);


insert into carteiras (investidor_id, endereco_wallet, rede_blockchain, saldo_usd, status) VALUES
(1, 'ABC-123', 'Bitcoin', 3000.00, 'Ativa'),
(2, 'DEF-456', 'Ethereum', 2500.00, 'Em análise'),
(3, 'GHI-789', 'Solana', 1200.00, 'Ativa'),
(4, 'JKL-012', 'Solana', 11000.00, 'Pausada'),
(5, 'MNO-345', 'Bitcoin', 1000.00, 'Bloqueada');


insert into corretoras (nome_exchange, cnpj, email_suporte) VALUES
('Bradesco', '12345678000101', 'suporte@bradesco.com'),
('Itaú', '23456789000102', 'suporte@itaú.com'),
('NuBank', '34567890000103', 'suporte@nubank.com'),
('Sicredi', '45678901000104', 'suporte@sicredi.com'),
('Caixa', '56789012000105', 'suporte@caixa.com');


insert into criptomoedas (corretora_id, nome_moeda, preco_unitario_usd, categoria) VALUES
(1, 'Bitcoin', 9500.00, 'Layer1'),
(2, 'Ethereum', 3200.00, 'Layer1'),
(3, 'Solana', 1800.00, 'Layer1'),
(4, 'Solana', 1000.00, 'DeFi'),
(5, 'Bitcoin', 10.00, 'Memecoin');


insert into transacoes_cripto(carteira_id, criptomoeda_id, quantidade, valor_pago, data_transacao) VALUES
(1, 1, 1.00, 4750.00, '2026-10-01 10:30:00'),
(2, 2, 1.00, 3200.00, '2026-10-02 11:00:00'),
(3, 3, 10.00, 1800.00, '2026-10-03 12:00:00'),
(4, 4, 20.00, 240.00, '2026-10-04 13:00:00'),
(5, 5, 300.00, 750.00, '2026-10-05 14:00:00');


Consultas avançadas

--1
SELECT
    c.endereco_wallet,
    c.rede_blockchain,
    c.saldo_usd,
    i.nome AS nome_investidor,
    i.cpf
    FROM carteiras c
    INNER JOIN investidores i
    ON c.investidor_id = i.id
    WHERE c.status IN ('Ativa', 'Em Analise');


--2
SELECT
    co.nome_exchange,
    SUM(t.valor_pago) AS total_movimentado
    FROM corretoras co
    INNER JOIN criptomoedas cr
    ON co.id = cr.corretora_id
    INNER JOIN transacoes_cripto t
    ON cr.id = t.criptomoeda_id
    GROUP BY co.nome_exchange
    ORDER BY total_movimentado DESC;


--3
SELECT
    c.endereco_wallet,
    cr.nome_moeda,
    t.quantidade,
    t.valor_pago,
    t.data_transacao
    FROM transacoes_cripto t
    INNER JOIN carteiras c
    ON t.carteira_id = c.id
    INNER JOIN criptomoedas cr
    ON t.criptomoeda_id = cr.id
    WHERE t.valor_pago > 500
    ORDER BY t.valor_pago DESC;


Views

--1
CREATE VIEW vw_painel_carteiras AS SELECT
    c.endereco_wallet,
    c.rede_blockchain,
    c.status,
    c.saldo_usd,
    i.nome AS nome_investidor,
    i.cpf
FROM carteiras c
INNER JOIN investidores i
    ON c.investidor_id = i.id;


--2



SELECT * FROM investidores
SELECT * FROM carteiras
SELECT * FROM corretoras
SELECT * FROM criptomoedas
SELECT * FROM transacoes_cripto
-
SELECT * FROM vw_painel_carteiras;
