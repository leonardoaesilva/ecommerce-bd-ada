-- DDL - data definition language

create schema ecommerce;

set schema 'ecommerce';

create table produto(
    id serial primary key,
    descricao varchar(1000) not null,
    codigo_barras varchar(44) unique not null,
    valor numeric not null
);

-- drop table produto;
 
create table endereco(
    id serial primary key,
    cep char(8) not null,
    logradouro varchar(1000) not null,
    numero varchar(30) not null default 's/n',
    cidade varchar(200) not null,
    uf char(2) not null
);

-- drop table endereco;

create table cliente(
    id serial primary key,
    nome varchar(895) not null,
    cpf char(11) not null,
    id_endereco integer not null references endereco(id),
    unique (cpf, id_endereco)
);

-- drop table cliente;

create table cupom(
	id serial primary key,
	descricao varchar(1000) not null,
	valor numeric not null,
	data_inicio timestamp not null default current_timestamp,
	data_validade timestamp not null default current_timestamp
);

-- drop table cupom;

create table pedido(
    id serial primary key,
    previsao_entrega date not null,
    meio_pagamento varchar(200) not null,
    status varchar(100) not null,
    id_cliente integer not null references cliente(id),
    data_criacao timestamp not null,
    id_cupom integer unique references cupom(id)
);

-- drop table pedido;

create table produto_pedido(
    id_pedido integer not null references pedido(id),
    id_produto integer not null references produto(id),
    quantidade integer not null,
    valor numeric not null,
    primary key (id_pedido, id_produto)
);

-- drop table produto_pedido;

create table fornecedor(
	id serial primary key,
	nome varchar(895) not null,
	cnpj char(14) unique not null,
	id_endereco integer unique not null references endereco(id)
);

-- drop table fornecedor;

create table fornecedor_produto(
	id_fornecedor integer not null references fornecedor(id),
	id_produto integer not null references produto(id),
	primary key (id_fornecedor, id_produto)
);

-- drop table fornecedor_produto;

create table estoque(
	id serial primary key,
	id_endereco integer unique not null references endereco(id)
);

-- drop table estoque;

create table estoque_produto(
	id_estoque integer not null references estoque(id),
	id_produto integer not null references produto(id),
	quantidade integer not null,
	primary key(id_estoque, id_produto)
);

-- drop table estoque_produto;

create table carrinho(
	id serial primary key,
	id_cliente integer unique not null references cliente(id)
);

-- drop table carrinho;

create table carrinho_produto(
	id serial primary key,
	id_carrinho integer not null references carrinho(id),
	id_produto integer not null references produto(id),
	quantidade integer not null,
	data_insercao timestamp not null default current_timestamp
);

-- drop table carrinho_produto;