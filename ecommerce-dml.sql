set schema 'ecommerce';

-- 5 produtos
insert into produto(descricao, codigo_barras, valor) values 
	('Carrinho de Controle Remoto', '558534037291', 50.00),
	('Boneca da Barbie', '946649472388', 45.99),
	('Jogo da Memoria', '488094762624', 60.00),
	('War', '735254781293', 150.00),
	('Banco Imobiliário', '214026648390', 125.00);

select * from produto order by id;

-- delete from produto *;

-- Endereços
insert into endereco(cep, logradouro, numero, cidade, uf) values
	('29200100', 'Avenida Trajano Lino Gonçalves', 36, 'Guarapari', 'ES'),
	('74893160', 'Rua 3 Unidade 207', 921, 'Goiânia', 'GO'),
	('69021525', 'Rua Surucuá', 535, 'Manaus', 'AM'),
	('98765432', 'Rua Springboot', 455, 'Santa Rosa', 'RS'),
	('12121244', 'Rua dos Java Fans', 1080, 'Sao Paulo', 'SP'),
	('12151232', 'SQL street', 10, 'Bragança', 'SP'),
	('12151234', 'SQL street', 19, 'Bragança', 'SP'),
	('12151235', 'SQL street', 20, 'Bragança', 'SP');

select * from endereco order by id;

-- delete from endereco *;

-- 5 clientes
insert into cliente(nome, cpf, id_endereco) values  
	('Henrique', '01013232544', 1),
	('Hilario', '91013232523', 1),
	('Job', '01013654544', 2),
	('Leonardo', '01013654000', 3),
	('Matheus', '01013654599', 4);

select * from cliente order by id;

-- delete from cliente *;

-- 2 fornecedores
insert into fornecedor(nome, cnpj, id_endereco) values
	('Submarino', '81133458000110', 5),
	('Americanas', '42563116000189', 6);
	-- associe os produtos com esses dois fornecedores
insert into fornecedor_produto(id_fornecedor, id_produto) values (1, 1), (2, 2), (1, 3), (1, 4), (2, 5);

select * from fornecedor order by id;
select * from fornecedor_produto order by (id_fornecedor, id_produto);

-- delete from fornecedor *;
-- delete from fornecedor_produto *;

-- 2 estoques
insert into estoque(id_endereco) values (7), (8);
	-- adicione os produtos cadastrados nos estoque
insert into estoque_produto(id_estoque, id_produto, quantidade) values (1, 1, 30), (1, 2, 30), (2, 3, 30), (1, 4, 30), (2, 5, 30);

select * from estoque order by id;
select * from estoque_produto order by (id_estoque, id_produto);

-- delete from fornecedor *;
-- delete from fornecedor_produto *;

-- 3 campanhas de cupons
insert into cupom(descricao, valor, data_inicio, data_validade) values
	('APP20 - Primeira compra no APP', 20.00, '2023-03-27', '2023-05-05'),
	('BLACK35 - Descontro Black Friday', 35.00, '2023-01-01', '2023-11-25'),
	('NATAL25 - Desconto de Natal', 25.00, '2023-01-01', '2023-12-25');

select * from cupom order by id;

-- delete from cupom *;

-- 2 clientes devem ter pelo menos 3 produtos no carrinho
insert into carrinho(id_cliente) values (1), (2), (3), (4), (5);
insert into carrinho_produto(id_carrinho, id_produto, quantidade, data_insercao) values
	(1, 1, 1, '2023-03-30'), (1, 3, 2, '2023-03-30'), (1, 4, 1, '2023-03-30'),
	(3, 1, 2, '2023-03-24'), (3, 2, 1, '2023-03-24'), (3, 5, 1, '2023-03-25');

select * from carrinho;
select * from carrinho_produto;

-- delete from carrinho *;
-- delete from carrinho_produto *;

-- 2 pedidos que utilizaram cupons
insert into pedido(previsao_entrega, meio_pagamento, status, id_cliente, data_criacao, id_cupom) values
	('2023-03-30', 'Boleto', 'Em trânsito', 1, '2023-03-30 10:00:00', null),
	('2023-03-27', 'PIX', 'Saiu para entrega', 2, '2023-03-20 10:00:00', 1),
	('2023-03-24', 'PIX', 'Entregue', 4, '2023-03-18 10:00:00', null),
	('2023-03-24', 'PIX', 'Entregue', 3, '2023-03-18 12:00:00', null),
	('2023-03-24', 'Cartao de credito', 'Entregue', 5, '2023-03-18 08:00:00', 2),
	('2023-03-29', 'PIX', 'Em preparo', 5, '2023-03-29 11:00:00', null);

select * from pedido order by id;

-- delete from pedido *;

-- 6 pedidos com pelo menos 2 produtos cada um
insert into produto_pedido(id_pedido, id_produto, quantidade, valor) values
	(1, 2, 1, 45.99), (1, 1, 1, 50),
	(2, 1, 1, 50), (2, 3, 1, 60),
	(3, 3, 1, 60), (3, 1, 1, 50),
	(4, 1, 1, 50), (4, 4, 2, 300),
	(5, 1, 1, 50), (5, 2, 1, 45.99),
	(6, 5, 1, 125), (6, 1, 1, 50);

select * from produto_pedido;

-- delete from produto_pedido *;