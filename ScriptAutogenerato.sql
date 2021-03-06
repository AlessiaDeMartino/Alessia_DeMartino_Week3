USE [master]
GO
/****** Object:  Database [PizzeriaDaLuigi]    Script Date: 17/12/2021 15:20:34 ******/
CREATE DATABASE [PizzeriaDaLuigi]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PizzeriaDaLuigi', FILENAME = N'C:\Users\Alessia.a.de.martino\PizzeriaDaLuigi.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PizzeriaDaLuigi_log', FILENAME = N'C:\Users\Alessia.a.de.martino\PizzeriaDaLuigi_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PizzeriaDaLuigi] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PizzeriaDaLuigi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ARITHABORT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  MULTI_USER 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PizzeriaDaLuigi] SET QUERY_STORE = OFF
GO
USE [PizzeriaDaLuigi]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcolaNumIngredienti]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcolaNumIngredienti] (@NomePizza varchar(30))
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
GO
/****** Object:  UserDefinedFunction [dbo].[CalcoloNumPizze]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcoloNumPizze] (@NomeIngredient varchar(30))
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
GO
/****** Object:  UserDefinedFunction [dbo].[CalcoloNumPizzeSenzaIngrediente]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcoloNumPizzeSenzaIngrediente] (@CodiceIngr int)
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
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[CodicePizza] [int] NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Prezzo] [decimal](3, 2) NOT NULL,
 CONSTRAINT [PK_CodicePizza] PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizze]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizze] ()
returns table
as
return 
Select p.Nome as [Nome Pizza], p.Prezzo as [Prezzo Pizza]
from Pizza p
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[CodiceIngrediente] [int] NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Costo] [decimal](3, 2) NOT NULL,
	[ScorteMagazzino] [int] NOT NULL,
 CONSTRAINT [PK_CodiceIngrediente] PRIMARY KEY CLUSTERED 
(
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Composizione]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Composizione](
	[CodicePizza] [int] NOT NULL,
	[CodiceIngrediente] [int] NOT NULL,
 CONSTRAINT [PK_Composizione] PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC,
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeConIngrediente]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeConIngrediente] (@NomeIngrediente varchar(30))
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
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeSenzaIngrediente]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeSenzaIngrediente] (@Nome_Ingrediente varchar(30))
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
GO
/****** Object:  View [dbo].[Menu]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create View [dbo].[Menu] ([Nome Pizza], [Prezzo], [Ingredienti])
as (	
select p.Nome, p.Prezzo, STRING_AGG(i.Nome, ',') as [Ingredienti]
from Pizza p join Composizione c on c.CodicePizza=p.CodicePizza
			   join Ingrediente i on c.CodiceIngrediente=i.CodiceIngrediente
			   group by p.Nome, p.Prezzo)
GO
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (1, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (1, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (2, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (2, 3)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 4)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 5)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 6)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 7)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 8)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 9)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 10)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 11)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 12)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 13)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 1)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 14)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 15)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 16)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 17)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 18)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 13)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 19)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 20)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 21)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 22)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 2)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 23)
INSERT [dbo].[Composizione] ([CodicePizza], [CodiceIngrediente]) VALUES (13, 1)
GO
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (1, N'Pomodoro', CAST(2.30 AS Decimal(3, 2)), 100)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (2, N'Mozzarella', CAST(1.50 AS Decimal(3, 2)), 70)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (3, N'Mozzarella Di Bufala', CAST(3.50 AS Decimal(3, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (4, N'Spianata piccante', CAST(2.70 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (5, N'Funghi', CAST(4.40 AS Decimal(3, 2)), 80)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (6, N'Carciofi', CAST(2.00 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (7, N'Cotto', CAST(3.60 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (8, N'Olive', CAST(1.70 AS Decimal(3, 2)), 15)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (9, N'Funghi Porcini', CAST(6.40 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (10, N'Stracchino', CAST(2.50 AS Decimal(3, 2)), 10)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (11, N'Speck', CAST(1.36 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (12, N'Rucola', CAST(1.70 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (13, N'Grana', CAST(3.50 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (14, N'Verdure di Stagione', CAST(3.70 AS Decimal(3, 2)), 35)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (15, N'Patate', CAST(2.56 AS Decimal(3, 2)), 25)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (16, N'Salsiccia', CAST(3.00 AS Decimal(3, 2)), 15)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (17, N'Pomodorini', CAST(4.50 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (18, N'Ricotta', CAST(3.50 AS Decimal(3, 2)), 10)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (19, N'Provola', CAST(4.40 AS Decimal(3, 2)), 5)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (20, N'Gorgonzola', CAST(2.40 AS Decimal(3, 2)), 5)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (21, N'Pomodoro fresco', CAST(3.10 AS Decimal(3, 2)), 15)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (22, N'Basilico', CAST(1.20 AS Decimal(3, 2)), 70)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (23, N'Bresaola', CAST(3.70 AS Decimal(3, 2)), 12)
GO
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (1, N'Margherita', CAST(5.50 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (2, N'Bufala', CAST(7.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (3, N'Diavola', CAST(6.60 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (4, N'Quattro Stagioni', CAST(7.15 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (5, N'Porcini', CAST(7.70 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (6, N'Dionisio', CAST(8.80 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (7, N'Ortolana', CAST(9.68 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (8, N'Patate e Salsiccia', CAST(6.60 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (9, N'Pomodorini', CAST(6.60 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (10, N'Quattro Formaggi', CAST(8.25 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (11, N'Caprese', CAST(8.80 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (12, N'Zeus', CAST(9.08 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (13, N'Ricci', CAST(9.90 AS Decimal(3, 2)))
GO
ALTER TABLE [dbo].[Composizione]  WITH CHECK ADD  CONSTRAINT [FK_CodiceIngrediente] FOREIGN KEY([CodiceIngrediente])
REFERENCES [dbo].[Ingrediente] ([CodiceIngrediente])
GO
ALTER TABLE [dbo].[Composizione] CHECK CONSTRAINT [FK_CodiceIngrediente]
GO
ALTER TABLE [dbo].[Composizione]  WITH CHECK ADD  CONSTRAINT [FK_CodicePizza] FOREIGN KEY([CodicePizza])
REFERENCES [dbo].[Pizza] ([CodicePizza])
GO
ALTER TABLE [dbo].[Composizione] CHECK CONSTRAINT [FK_CodicePizza]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD  CONSTRAINT [CHK_Ingrediente] CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente] CHECK CONSTRAINT [CHK_Ingrediente]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD  CONSTRAINT [CHK_Scorte] CHECK  (([ScorteMagazzino]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente] CHECK CONSTRAINT [CHK_Scorte]
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD  CONSTRAINT [CHK_PIZZA] CHECK  (([Prezzo]>(0)))
GO
ALTER TABLE [dbo].[Pizza] CHECK CONSTRAINT [CHK_PIZZA]
GO
/****** Object:  StoredProcedure [dbo].[AggiornaPrezzo]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiornaPrezzo]
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
GO
/****** Object:  StoredProcedure [dbo].[AssegnaIngredienteAPizza]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AssegnaIngredienteAPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[EliminaIngrediente]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[EliminaIngrediente]

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
GO
/****** Object:  StoredProcedure [dbo].[IncrementoPrezzo]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[IncrementoPrezzo]
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
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 17/12/2021 15:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciPizza] 
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
USE [master]
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  READ_WRITE 
GO
