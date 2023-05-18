 
/*
 * Crie um banco de dados para armazenar dados de filmes e atores.
 * 
 * 
 * * Comece pelo Modelo Lógico do banco de dados.
 * * Crie mais atributos se for necessário.
 * * Crie uma seleção que mostra os filmes e atores que participaram.
 * * Mostre todos os filmes em que Eddie Murphy participou como ator.
 * * Mostre todos os atores e seus filmes em o cachê foi maior que 150000.
 * * Mostre todos os atores que participaram de pelo menos 2 filmes.
 * * Mostre todos os atores que participaram de pelo menos 2 filmes entre 2008 e 2014.
 * * Dado o título de um filme, mostre o nome da produtora.
 * * Mostre todos os filmes de produtoras brasileiras ou iranianas. 
 * * Mostre o filme que pagou o maior cachê para um ator.
 * * Mostre o ator com maior cachê.
 * * Mostre os atores com maior cachê acima da média.
 * 
 * Bons estudos!
 */



drop database if exists Filmes;
create database Filmes;
use Filmes;



create table Produtoras (
	id				int				primary key			auto_increment,
	nome			varchar(30)		not null,
	site			varchar(40),
	nacionalidade	varchar(20)
);


create table Filmes (
	id				int				primary key			auto_increment,
	titulo			varchar(30)		not null,
	ano				int,
	minutos			int,
	produtora_id	int				references Produtoras(id)
);


create table Atores (
	id				int				primary key			auto_increment,
	nome			varchar(30)		not null,
	data_nasc		date,
	altura			decimal(4,3)
);




create table Ator_Filme (
	filme_id		int				references Filme(id),
	ator_id			int				references Atores(id),
	cache			decimal(12,2)
);




insert into Produtoras (nome, site, nacionalidade) values
	("Paramond", "www.paramond.com", "Estados Unidos"),
	("MGM", "www.mgm.com", "Estados Unidos"),
	("Video Filmes", "www.videofilmes.com", "Brasil"),
	("Globo Filmes", "www.globofilmes.com", "Brasil"),
	("Universal", "www.universal.com", "Estados Unidos");


insert into Filmes (titulo, ano, minutos, produtora_id) values
	("Indiana Jones",         1981, 120, 1),
	("Matrix",                1999, 135, 3),
	("O Alto da Compadecida", 2000, 120, 4),
	("Blade Runner",          1982, 145, 1),
	("Laranja Mecânica",      1971, 140, 4),
	("O sétimo selo",         1957, 130, 3),
	("Central do Brasil",     1998, 110, 3);



insert into Atores (nome, data_nasc, altura) values
	("Fernanda Montenegro", "1929-10-16", 1.81),
	("Malcolm McDowell",    "1943-06-13", 1.56),
	("Keanu Reeves",        "1964-09-02", 1.69),
	("Maud Hansson",        "1937-12-05", 1.79),
	("Denise Fraga",        "1964-10-15", 1.50),
	("Luís Melo",           "1957-11-13", 1.76),
	("Harrison Ford",       "1942-06-13", 1.60),
	("Marco Nanini",        "1948-05-31", 1.59),
	("Rogério Cardoso",     "1937-03-07", 1.86);



insert into Ator_Filme (filme_id, ator_id, cache) values
	(1, 7, 240000),
	(2, 3, 185000),
	(3, 1, 218000),
	(3, 5, 440000),
	(3, 6, 100000),
	(3, 8, 515000),
	(3, 9, 588000),
	(4, 7, 140000),
	(5, 2, 500000),
	(6, 4, 285000),
	(7, 1, 340000);

/*
 * Crie uma seleção que mostra os filmes e atores que participaram.
 */
 
select F.titulo, A.nome 
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id;

/*
 * 4. Mostre todos os filmes em que Eddie Murphy participou como ator.
 */
 
select F.titulo, F.ano, A.nome 
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where A.nome like "%keanu%";

/*
 * 5. Mostre todos os atores e seus filmes em que o cachê foi maior que 150000.
 */
 
select F.titulo, A.nome, FA.cache
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where FA.cache > 150000;
 
/*
 * 6. Mostre todos os atores que participaram de pelo menos 2 filmes.
 */
 
select A.nome as "Ator/Atriz",
	count(*) as "Filmes"
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	group by A.nome
	having count(*) >= 2;
 
/*
 * 7. Mostre todos os atores que participaram de pelo menos 2 filmes entre 2008 e 2014.
 */

select A.nome as "Ator/Atriz",
	count(*) as "Filmes"
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where F.ano between 2008 and 2014
	group by A.nome
	having count(*) >= 2;
      
/*
 * 8. Dado o título de um filme, mostre o nome da produtora.
 */

select F.titulo, P.nome
	from  Filmes F join Produtoras P 
	on F.produtora_id = P.id
	where F.titulo like "%Indiana Jones%";
 
/*
 * 9. Mostre todos os filmes de produtoras brasileiras ou iranianas. 
 */

select F.titulo, P.nome
	from Filmes F join Produtoras P 
	on F.produtora_id = P.id
	where P.nacionalidade in ('Brasil','Irã');

 /* 10. Mostre o filme que pagou o maior cachê para um ator.
 */

-- >>> Solução 1: usando order by e limit <<<

select F.titulo, FA.cache, A.nome 
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	order by FA.cache desc 
	limit 1;
 
-- >>> Solução 2: usando variável <<<

set @maior = (select max(cache) from Ator_Filme);
  
select F.titulo, FA.cache, A.nome
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where FA.cache = @maior;
 
-- >>> Solução 3: usando sub query <<<

select F.titulo, FA.cache
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where FA.cache = 
    (select max(cache) from Ator_Filme);
 
/*
 * 11. Mostre o ator com maior cachê.
 */

select A.nome, FA.cache
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where FA.cache = 
    (select max(cache) from Ator_Filme);
 
/*
 * 12. Mostre os atores com maior cachê acima da média.
 */
 
select A.nome, FA.cache
	from Filmes F join Ator_Filme FA 
	on F.id = FA.filme_id 
	join Atores A 
	on A.id = FA.ator_id
	where FA.cache > (select avg(cache) 
	from Ator_Filme);
 














