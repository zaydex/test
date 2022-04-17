create database test
use test

--Задание 1
/*
1. Написать update запросы для предотвращения возможных ограничений 
и оптимизации изначальных таблиц. В комментариях укажите 
почему такие изменения нужны.
2. Разбить таблицы на меры и измерения.
3. Написать MDX скрипт создания OLAP куба из представленных таблиц.
4. Написать 5 M﻿DX произвольных запросов на отображение сводных данных. 
Как минимум два запроса должны затрагивать данные из четырех таблиц.
*/
create table [Bicycle]
(
[Id]			int IDENTITY(1,1)	not null,
[Brand]			varchar(50)			not null,
[RentPrice]		int					not null, -- цена аренды
primary key(Id)
)

create table [Client]
(
[Id]			int IDENTITY(1,1)	not null,
[Name]			varchar(20)			not null,
[Passport]		varchar(50)			not null,
[Country]		varchar(50)			not null,
primary key(Id)
)

create table [Staff]
(
[Id]			int IDENTITY(1,1)	not null,
[Name]			varchar(20)			not null,
[Passport]		varchar(50)			not null,
[Date]			date				not null, -- дата начала работы
primary key(Id)
)

create table [Detail] -- запчасти велосипеда
(
[Id]			int IDENTITY(1,1)	not null,
[Brand]			varchar(50)			not null,
[Type]			varchar(50)			not null, -- тип детали (цепь, звезда, etc.)
[Name]			varchar(50)			not null, -- название детали
[Price]			int					not null,
primary key(Id)
)

create table [DetailForBicycle] -- список деталей подходящих к велосипедам
(
[BicycleId]		int					not null,
[DetailId]		int					not null,
FOREIGN KEY ([BicycleId])	REFERENCES [Bicycle]	([Id]), 
FOREIGN KEY ([DetailId])	REFERENCES [Detail]		([Id]) 
)

create table [ServiceBook] -- сервисное обслуживание велосипедов
(
[BicycleId]		int					not null,
[DetailId]		int					not null,
[StaffId]		int					not null,
[Date]			date				not null,
[Price]			int					not null, -- цена работы
FOREIGN KEY ([BicycleId])	REFERENCES [Bicycle]	([Id]), 
FOREIGN KEY ([StaffId])		REFERENCES [Staff]		([Id]), 
FOREIGN KEY ([DetailId])	REFERENCES [Detail]		([Id]) 
)

create table [RentBook] -- аренда велосипеда клиентом
(
[Id]			int IDENTITY(1,1)	not null,
[Date]			date				not null, -- дата аренды
[Time]			int					not null, -- время на сколько взята аренда в часах
[Paid]			bit					not null, -- 1 оплатил; 0 не оплатил
[BicycleId]		int					not null,
[ClientId]		int					not null,
[StaffId]		int					not null,
FOREIGN KEY ([BicycleId])	REFERENCES [Bicycle]	([Id]), 
FOREIGN KEY ([StaffId])		REFERENCES [Staff]		([Id]), 
FOREIGN KEY ([ClientId])	REFERENCES [Client]		([Id]) 
)

--1) Не знаю как использовать update запросы, только если не изменение данных внутри таблицы
--3) Не знаю что такое MDX и OLAP
--4) Сделал простые запросы через select
select top 20 * from Bicycle
order by RentPrice

select * from Client
GROUP BY [Name], Passport
order by country

select * from ServiceBook

select brand, rentprice, client.[name], paid
from Bicycle, Client, RentBook
order by RentPrice

select Bicycle.brand, detail.[name], detailid, staff.[name]
from Bicycle, Detail, DetailForBicycle, Staff
group by staff.[name], Bicycle.brand, detail.[name], detailid
order by staff.[name]

--use master
--drop database test