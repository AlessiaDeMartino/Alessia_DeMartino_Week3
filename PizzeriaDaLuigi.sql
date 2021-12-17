create database PizzeriaDaLuigi


create table Pizza(
CodicePizza int constraint PK_CodicePizza primary key,
Nome varchar(50) not null,
Prezzo decimal (3,2) not null constraint CHK_PIZZA check (Prezzo>0),
);

create table Ingrediente (
CodiceIngrediente int constraint PK_CodiceIngrediente primary key,
Nome varchar(50) not null,
Costo decimal (3,2) not null constraint CHK_Ingrediente check (Costo>0),
ScorteMagazzino int not null constraint CHK_Scorte check (ScorteMagazzino>0),
);

create table Composizione (
CodicePizza int constraint FK_CodicePizza foreign key references Pizza(CodicePizza),
CodiceIngrediente int constraint FK_CodiceIngrediente foreign key references Ingrediente(CodiceIngrediente)
constraint PK_Composizione primary key (CodicePizza,CodiceIngrediente)
);

insert into Pizza values (001,'Margherita', 5);
insert into Pizza values (002,'Bufala',7);
insert into Pizza values (003,'Diavola',6);
insert into Pizza values (004,'Quattro Stagioni', 6.50);
insert into Pizza values (005,'Porcini',7);
insert into Pizza values (006,'Dionisio',8);
insert into Pizza values (007,'Ortolana',8);
insert into Pizza values (008,'Patate e Salsiccia',6);
insert into Pizza values (009,'Pomodorini',6);
insert into Pizza values (010, 'Quattro Formaggi',7.50);
insert into Pizza values (011,'Caprese',7.50);
insert into Pizza values (012,'Zeus',7.50);

insert into Ingrediente values (1,'Pomodoro',2.30,100);
insert into Ingrediente values (2, 'Mozzarella', 1.50, 70);
insert into Ingrediente values (3, 'Mozzarella Di Bufala', 3.50,50);
insert into Ingrediente values (4, 'Spianata piccante', 2.70, 20);
insert into Ingrediente values (5, 'Funghi',4.40, 80), (6,'Carciofi',2, 20), 
(7, 'Cotto',3.60, 30), (8,'Olive',1.70, 15),
(9,'Funghi Porcini',6.40,20),(10, 'Stracchino', 2.50,10), 
(11,'Speck',1.36,20), (12,'Rucola',1.70,30), 
(13,'Grana', 3.50,20),(14,'Verdure di Stagione',3.70,35),
(15, 'Patate', 2.56,25), (16,'Salsiccia', 3,15), 
(17, 'Pomodorini', 4.50,40), (18, 'Ricotta',3.50,10), 
(19,'Provola',4.40,5), (20,'Gorgonzola',2.40,5),
(21,'Pomodoro fresco', 3.10,15), (22, 'Basilico', 1.20,70), 
(23, 'Bresaola', 3.70,12);

--margherita
insert into Composizione values (001,1);
insert into Composizione values (001,2);

--bufala
insert into Composizione values (002,1);
insert into Composizione values (002,3);

--diavola
insert into Composizione values (003,1);
insert into Composizione values (003,2);
insert into Composizione values (003,4);

--Quattro Stagioni
insert into Composizione values (004,1);
insert into Composizione values (004,2);
insert into Composizione values (004,5);
insert into Composizione values (004,6);
insert into Composizione values (004,7);
insert into Composizione values (004,8);

--Porcini
insert into Composizione values (005,1);
insert into Composizione values (005,2);
insert into Composizione values (005,9);

--Dionisio
insert into Composizione values (006,1);
insert into Composizione values (006,2);
insert into Composizione values (006,10);
insert into Composizione values (006,11);
insert into Composizione values (006,12);
insert into Composizione values (006,13);

--Ortolana
insert into Composizione values (007,1);
insert into Composizione values (007,2);
insert into Composizione values (007,14);

--Patate e Salsiccia
insert into Composizione values (008,2);
insert into Composizione values (008,15);
insert into Composizione values (008,16);

--Pomodorini
insert into Composizione values (009,2);
insert into Composizione values (009,17);
insert into Composizione values (009,18);

--Quattro Formaggi
insert into Composizione values (010,2);
insert into Composizione values (010,19);
insert into Composizione values (010,20);
insert into Composizione values (010,13);

--Caprese
insert into Composizione values (011,2);
insert into Composizione values (011,21);
insert into Composizione values (011,22);

--Zeus
insert into Composizione values (012,2);
insert into Composizione values (012,23);
insert into Composizione values (012,12);


--Si implementino le seguenti query:
--1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select p.Nome, P.Prezzo
from Pizza p
where p.Prezzo>6

--2. Estrarre la pizza/le pizze più costosa/e.
select Nome
from pizza
where prezzo = (select MAX(Prezzo) 
from pizza)

--3. Estrarre le pizze «bianche»
select distinct p.Nome
from pizza p
where p.Nome not in
(select p.Nome 
from Pizza p join Composizione c on p.CodicePizza=c.CodicePizza
join Ingrediente i on c.CodiceIngrediente=i.CodiceIngrediente
where i.Nome='Pomodoro') 


--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo).
select p.Nome
from Pizza p join Composizione c on p.CodicePizza=c.CodicePizza
join Ingrediente i on c.CodiceIngrediente=i.CodiceIngrediente
where i.Nome like 'Funghi%'


--1. Inserimento di una nuova pizza (parametri: nome, prezzo) 
create procedure InserisciPizza 
@CodicePizza int,
@Nome varchar(30),
@Prezzo decimal (3,2)
as 
begin
begin try
insert into Pizza values(@CodicePizza,@Nome,@Prezzo)
end try
begin catch
select ERROR_MESSAGE()
end catch
end
GO

execute InserisciPizza 013,'Ricci', 9.90;

select * from Pizza

--2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome 
--ingrediente) 
create procedure AssegnaIngredienteAPizza
@NomePizza varchar(30),
@NomeIngrediente varchar(50)
as 
begin
begin try
declare @IDPizza int
declare @IDIngrediente int

    select @IDPizza= p.CodicePizza
	from pizza p
	where p.Nome=@NomePizza

	select @IDIngrediente=i.CodiceIngrediente
	from ingrediente i
	where i.Nome=@NomeIngrediente

insert into Composizione values (@IDPizza, @IDIngrediente);
end try
begin catch
select ERROR_LINE() as [Riga in cui si è verificata l'eccezione], ERROR_MESSAGE() as [Messaggio d'errore]
	end catch
end

execute AssegnaIngredienteAPizza 'Ricci', 'Pomodoro'

select * from Composizione


--3. Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)
create procedure AggiornaPrezzo
@NomePizza varchar(20),
@NuovoPrezzo decimal (3,2)
as 
begin
begin try
declare @IDPizza int

select @IDPizza=p.CodicePizza
FROM pizza p
where p.Nome=@NomePizza

update Pizza set Prezzo=@NuovoPrezzo where Nome=@NomePizza 
end try
begin catch
select ERROR_LINE() as [Riga in cui si è verificata l'eccezione], ERROR_MESSAGE() as [Messaggio d'errore]
	end catch
end

execute AggiornaPrezzo 'Caprese', 8;

--4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome 
--ingrediente) 
create procedure EliminaIngrediente

@NomePizza varchar(30),
@NomeIngrediente varchar(30)
as 
begin
begin try
declare @IDPizza int
declare @IDIngrediente int

select @IDPizza=p.CodicePizza
from Pizza p
where p.Nome=@NomePizza


select @IDIngrediente=i.CodiceIngrediente
from Ingrediente i
where i.Nome=@NomeIngrediente

delete from Composizione where (CodicePizza=@IDPizza AND CodiceIngrediente=@IDIngrediente)
end try
begin catch
select ERROR_LINE() as [Riga in cui si è verificata l'eccezione], ERROR_MESSAGE() as [Messaggio d'errore]
	end catch
end
execute EliminaIngrediente 'Zeus', 'Rucola'

select * from Composizione

--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente 
--(parametro: nome ingrediente) 
create procedure IncrementoPrezzo
@NomeIngrediente varchar(30)
as 
begin
begin try

UPDATE Pizza SET Prezzo=Prezzo+Prezzo*10/100 WHERE CodicePizza
	    IN (SELECT p.CodicePizza
		FROM Ingrediente i join Composizione c on i.CodiceIngrediente=c.CodiceIngrediente
		join pizza p on p.CodicePizza=c.CodicePizza
		WHERE i.Nome=@NomeIngrediente)
end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO

execute IncrementoPrezzo @NomeIngrediente='Mozzarella'
select * from Pizza

--Si implementino le seguenti funzioni:
--1. Tabella listino pizze (nome, prezzo) (parametri: nessuno)
create function ListinoPizze ()
returns table
as
return 
Select p.Nome as [Nome Pizza], p.Prezzo as [Prezzo Pizza]
from Pizza p

select * from dbo.ListinoPizze()

--2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome
--ingrediente)
create function ListinoPizzeConIngrediente (@NomeIngrediente varchar(30))
returns table
as
return 
Select p.Nome as [Nome Pizza], p.Prezzo as [Prezzo Pizza]
from Pizza p
where   CodicePizza
	    IN (SELECT p.CodicePizza
		FROM Ingrediente i join Composizione c on i.CodiceIngrediente=c.CodiceIngrediente
		join pizza p on p.CodicePizza=c.CodicePizza
		WHERE i.Nome=@NomeIngrediente)

select * from dbo.ListinoPizzeConIngrediente('pomodoro fresco');


--3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente
--(parametri: nome ingrediente)
create function ListinoPizzeSenzaIngrediente (@Nome_Ingrediente varchar(30))
returns table
as
return 
Select p.Nome as [Nome Pizza], p.Prezzo as [Prezzo Pizza]
from Pizza p
where   CodicePizza
	    NOT IN (SELECT p.CodicePizza
		FROM Ingrediente i join Composizione c on i.CodiceIngrediente=c.CodiceIngrediente
		join pizza p on p.CodicePizza=c.CodicePizza
		WHERE i.Nome=@Nome_Ingrediente)

select * from dbo.ListinoPizzeSenzaIngrediente('Patate');

--4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
create function CalcoloNumPizze (@NomeIngredient varchar(30))
returns int
as
begin
declare @numPizze int
Select @numPizze=count(*)
from Pizza p
where   CodicePizza
	    IN (SELECT p.CodicePizza
		FROM Ingrediente i join Composizione c on i.CodiceIngrediente=c.CodiceIngrediente
		join pizza p on p.CodicePizza=c.CodicePizza
		WHERE i.Nome=@NomeIngredient)

return @numPizze
end

select dbo.CalcoloNumPizze('Mozzarella')


--5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice
--ingrediente)
create function CalcoloNumPizzeSenzaIngrediente (@CodiceIngr int)
returns int
as
begin
declare @numPizze int
Select @numPizze=count(*)
from Pizza p
where   CodicePizza
	    NOT IN (SELECT p.CodicePizza
		FROM Ingrediente i join Composizione c on i.CodiceIngrediente=c.CodiceIngrediente
		join pizza p on p.CodicePizza=c.CodicePizza
		WHERE i.CodiceIngrediente=@CodiceIngr)

return @numPizze
end
select dbo.CalcoloNumPizzeSenzaIngrediente(1)

--6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
create function CalcolaNumIngredienti (@NomePizza varchar(30))
returns int
as
begin
declare @numIngr int
Select @numIngr= count(*)
from Ingrediente i
where CodiceIngrediente
	    NOT IN (SELECT i.CodiceIngrediente
		FROM Ingrediente i join Composizione c on i.CodiceIngrediente=c.CodiceIngrediente
		join pizza p on p.CodicePizza=c.CodicePizza
		WHERE p.Nome=@NomePizza)
return @numIngr
end

select dbo.CalcolaNumIngredienti('Dioniso')

--Realizzare una view che rappresenta il menù con tutte le pizze.

create View Menu ([Nome Pizza], [Prezzo], [Ingredienti])
as (	
select p.Nome, p.Prezzo, STRING_AGG(i.Nome, ',') as [Ingredienti]
from Pizza p join Composizione c on c.CodicePizza=p.CodicePizza
			   join Ingrediente i on c.CodiceIngrediente=i.CodiceIngrediente
			   group by p.Nome, p.Prezzo)			    
			   
select distinct * from Menu







