drop database if exists empresa;
create database if not exists empresa;
use empresa;

create table if not exists TCENTR(
    NUMCE int unique not null,
    NOMCE varchar(45) not null,
    SENAS varchar(45) not null,
    primary key (NUMCE));

create table if not exists TEMPLE(
    NUMEM int unique not null,
    NUMDE int,
    EXTEL varchar(12) not null,
    FECNA date not null,
    FECIN date not null,
    SALAR float not null,
    COMIS double not null,
    NUMHI smallint not null,
    NOMEM varchar(45) not null,
    primary key(NUMEM));
    
create table if not exists TDEPTO(
	NUMDE int unique not null,
	NUMCE int,
    DIREC int,
    TIDIR char not null,
    PRESU double not null,
    DEPDE int,
    NOMDE varchar(20) not null,
    primary key(NUMDE));
        
alter table TEMPLE add foreign key (NUMDE) references TDEPTO (NUMDE); 
alter table TDEPTO add foreign key (NUMCE) references TCENTR (NUMCE) ; 
alter table TDEPTO add foreign key (DEPDE) references TDEPTO (NUMDE) ; 
