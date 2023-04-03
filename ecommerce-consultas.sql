set schema 'ecommerce926';

-- 1. Listar todos os cliente que tem o nome 'ANA'. > Dica: Buscar sobre função Like
select *, lower(cl.nome) from cliente cl where cl.nome ilike '%ana%';
	
-- 2. Pedidos feitos em 2023
select * from pedido pd where pd.data_criacao >= '01-01-2023' and pd.data_criacao < '01-01-2024' order by pd.data_criacao;

-- 3. Pedidos feitos em Janeiro de qualquer ano
select * from pedido pd where to_char(pd.data_criacao, 'MM') = '01';

-- 4. Itens de pedido com valor entre R$2 e R$5
select * from item_pedido ip where ip.valor between 2 and 5 order by ip.valor;

-- 5. Trazer o Item mais caro comprado em um pedido
select max(ip.valor) from item_pedido ip;

-- 6. Listar todos os status diferentes de pedidos;
select distinct pd.status from pedido pd;

-- 7. Listar o maior, menor e valor médio dos produtos disponíveis.
select max(pr.valor), min(pr.valor), avg(pr.valor) from produto pr;

-- 8. Listar fornecedores com os dados: nome, cnpj, logradouro, numero, cidade e uf de todos os fornecedores;
select fr.nome, fr.cnpj, ed.logradouro, ed.numero, ed.cidade, ed.uf from fornecedor fr, endereco ed where fr.id_endereco = ed.id;

-- 9. Informações de produtos em estoque com os dados: id do estoque, descrição do produto, quantidade do produto no estoque, logradouro, numero, cidade e uf do estoque;
select ie.id_estoque, pr.descricao, ie.quantidade, ed.logradouro, ed.numero, ed.cidade, ed.uf from item_estoque ie, estoque et, endereco ed, produto pr
	where ie.id_produto = pr.id and ie.id_produto = pr.id and et.id_endereco = ed.id;

-- 10. Informações sumarizadas de estoque de produtos com os dados: descrição do produto, código de barras, quantidade total do produto em todos os estoques;
select pr.descricao, pr.codigo_barras, sum(ie.quantidade) qtd_total from produto pr, item_estoque ie where ie.id_produto = pr.id group by pr.descricao, pr.codigo_barras order by qtd_total;

-- 11. Informações do carrinho de um cliente específico (cliente com cpf '26382080861') com os dados: descrição do produto, quantidade no carrinho, valor do produto.
select pr.descricao, ic.quantidade, pr.valor from item_carrinho ic, cliente cl, produto pr where cl.cpf = '26382080861' and ic.id_produto = pr.id and ic.id_cliente = cl.id;

-- 12. Relatório de quantos produtos diferentes cada cliente tem no carrinho ordenado pelo cliente que tem mais produtos no carrinho para o que tem menos, 
-- com os dados: id do cliente, nome, cpf e quantidade de produtos diferentes no carrinho.
select cl.id, cl.nome, cl.cpf, count(*) produtos_carrinho from item_carrinho ic, cliente cl where ic.id_cliente = cl.id group by cl.id, cl.nome, cl.cpf order by produtos_carrinho desc;

-- 13. Relatório com os produtos que estão em um carrinho a mais de 10 meses, ordenados pelo inserido a mais tempo, 
-- com os dados: id do produto, descrição do produto, data de inserção no carrinho, id do cliente e nome do cliente;
select pr.id, pr.descricao, ic.data_insercao, cl.id, cl.nome from item_carrinho ic, cliente cl, produto pr 
	where ic.data_insercao < current_date - interval '10 months' and ic.id_produto = pr.id and ic.id_cliente = cl.id order by ic.data_insercao asc;

-- 14. Relatório de clientes por estado, com os dados: uf (unidade federativa) e quantidade de clientes no estado;
select ed.uf, count(*) from cliente cl join endereco ed on ed.id = cl.id_endereco group by ed.uf order by ed.uf;

-- 15. Listar cidade com mais clientes e a quantidade de clientes na cidade;
select ed.cidade, count(*) qtd_clientes from cliente cl join endereco ed on ed.id = cl.id_endereco group by ed.cidade order by qtd_clientes desc;

-- 16. Exibir informações de um pedido específico, pedido com id 952, com os dados (não tem problema repetir dados em mais de uma linha): 
-- nome do cliente, id do pedido, previsão de entrega, status do pedido, descrição dos produtos comprados, quantidade comprada produto, valor total pago no produto;
select cl.nome, pd.id, pd.previsao_entrega, pd.status, pr.descricao, ip.quantidade, ip.valor from pedido pd 
	join item_pedido ip on ip.id_pedido = pd.id join cliente cl on cl.id = pd.id_cliente join produto pr on pr.id = ip.id_produto where pd.id = 952;

-- 17. Relatório de clientes que realizaram algum pedido em 2022, com os dados: id_cliente, nome_cliente, data da última compra de 2022;
select cl.id, cl.nome, max(pd.data_criacao) from cliente cl join pedido pd on pd.id_cliente = cl.id where pd.data_criacao between '2022-01-01' and '2022-12-31' 
	group by cl.id, cl.nome, pd.data_criacao order by pd.data_criacao;

-- 18. Relatório com os TOP 10 clientes que mais gastaram esse ano, com os dados: nome do cliente, valor total gasto;
select cl.nome, sum(ip.quantidade * ip.valor) valor_gasto from cliente cl join pedido pd on pd.id_cliente = cl.id join item_pedido ip on ip.id_pedido = pd.id 
	where pd.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO') group by cl.id, cl.nome order by valor_gasto desc limit 10;

-- 19. Relatório com os TOP 10 produtos vendidos esse ano, com os dados: descrição do produto, quantidade vendida, valor total das vendas desse produto;
select pr.descricao, sum(ip.quantidade) qtd_vendida, sum(ip.quantidade * ip.valor) valor_total_vendido from produto pr 
	join item_pedido ip on ip.id_produto = pr.id join pedido pd on pd.id = ip.id_pedido	where pd.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO') 
	group by pr.id, pr.descricao order by qtd_vendida desc limit 10;

-- 20. Exibir o ticket médio do nosso e-commerce, ou seja, a média dos valores totais gasto em pedidos com sucesso;
select round(avg(ip.quantidade * ip.valor), 2) media_gasto from pedido pd join item_pedido ip on ip.id_pedido = pd.id where pd.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO');

-- 21. Relatório dos clientes gastaram acima de R$ 10000 em um pedido, com os dados: id_cliente, nome do cliente, valor máximo gasto em um pedido;
select c.id, c.nome, max(valor_gasto) maior_valor_gasto from (
	select cl.id, cl.nome, sum(ip.quantidade * ip.valor) valor_gasto from cliente cl 
		join pedido pd on pd.id_cliente = cl.id	join item_pedido ip on ip.id_pedido = pd.id	where pd.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO') 
		group by cl.id, cl.nome, pd.id having sum(ip.quantidade * ip.valor) > 10000) as c
	group by c.id, c.nome order by maior_valor_gasto desc;

-- 22. Listar TOP 10 cupons mais utilizados e o total descontado por eles.
select cp.descricao, pd.id_cupom, count(pd.id_cupom) qtd_utilizada, sum(cp.valor) desconto_total from pedido pd, cupom cp 
	where pd.id_cupom = cp.id and pd.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO') group by pd.id_cupom, cp.descricao order by qtd_utilizada desc limit 10;

-- 23. Listar cupons que foram utilizados mais que seu limite;
select cp.id, cp.descricao, count(*) quantidade_usada, cp.limite_maximo_usos from pedido pd 
	join cupom cp on cp.id = pd.id_cupom group by cp.id, cp.descricao, cp.limite_maximo_usos having count(*) > cp.limite_maximo_usos order by quantidade_usada desc;

-- 24. Listar todos os ids dos pedidos que foram feitos por pessoas que moram em São Paulo (unidade federativa, uf, SP) e compraram o produto com código de barras '97692630963921';
select pd.id, cl.nome, ed.uf, ed.cidade, ed.logradouro, pr.descricao, pr.codigo_barras, pd.data_criacao, pd.previsao_entrega, pd.status, pd.meio_pagamento, pd.id_cupom from pedido pd 
	join cliente cl on cl.id = pd.id_cliente join endereco ed on ed.id = cl.id_endereco join item_pedido ip on ip.id_pedido = pd.id join produto pr on pr.id = ip.id_produto 
	where ed.UF = 'SP' and pr.codigo_barras = '97692630963921';