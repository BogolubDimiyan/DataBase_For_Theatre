use master
go

if exists(select name from sys.databases where name='Theatre_db')
begin
	Alter database Theatre_db set Single_User with rollback immediate;
	Drop database Theatre_db;
end

create database Theatre_db
On primary
(
	name = 'Theatre_inform',
	Filename='C:\Users\Дан\Desktop\theatre\Information.mdf',
	Size = 500MB, MaxSize = 2GB, FileGrowth = 100MB
),
(
	name = 'Theatre_inform1',
	Filename='C:\Users\Дан\Desktop\theatre\Information1.ndf',
	Size = 500MB, MaxSize = 2GB, FileGrowth = 100MB
)

Log On
(
	name = 'Theatredb_transactions',
	Filename='C:\Users\Дан\Desktop\theatre\Transactions.ldf',
	SIZE = 200MB, MAXSIZE = 700MB, FILEGROWTH = 50MB
);

--В случае ошибки: Поиск каталога для файла "C:\Users\Дан\Desktop\theatre\Information.mdf" не удался, вызвав ошибку операционной системы 5(Отказано в доступе.).
--самое быстрое решение прописать в коммандной строке: icacls "C:\Users\Дан\Desktop\theatre" /grant "NT Service\MSSQLSERVER":(OI)(CI)F заменив путь к папке на свой

use Theatre_db
go

if OBJECT_ID('ticket', 'U') is not null
	drop table ticket;

if OBJECT_ID('performance', 'U') is not null
	drop table performance;

if OBJECT_ID('client', 'U') is not null
	drop table client;

if OBJECT_ID('Theatre', 'U') is not null
	drop table Theatre;


create table Theatre 
(
	TheatreDepartment_id int constraint TheatreDepartmentID primary key identity,
	TheatreDepartment_name varchar(110) not null,
	TheatreDepartment_city varchar(20) not null,
	TheatreDepartment_street varchar(40) not null,
	TheatreDepartment_build int not null,
	TheatreDepartment_build_corpus int
)

create table client
(
	Client_id int constraint ClientID primary key identity,
	Client_name varchar(20) not null,
	Client_SurName varchar(20) not null,
	Client_lastName varchar(20),
	Client_Phone varchar(11) not null,
	Client_Email varchar(50) not null,
	Client_BirthDate date not null
)

create table performance
(
	Performance_id int constraint PerformanceID primary key identity,
	Performance_name varchar(50) not null,
	Performance_description varchar(1000) not null,
	Performance_hall int not null,
	Performance_datetime Datetime not null,
	Performance_cost money not null,
	TheatreDepartment_id int

	constraint fk_performance_TheatreDepartment foreign key (TheatreDepartment_id) references Theatre(TheatreDepartment_id)
)

create table ticket
(
	Ticket_id int constraint ticketID primary key identity,
	Client_id int,
	Performance_id int

	constraint fk_ticket_client Foreign key (Client_id) references client(Client_id),
	constraint fk_ticket_performance Foreign key (Performance_id) references Performance(Performance_id)
)