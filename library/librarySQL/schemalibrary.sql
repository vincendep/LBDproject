drop database if exists library;

create schema library;
use library;

create table pubblicazione(
	id int auto_increment primary key,
    isbn int unique check (isbn >= 0),
	titolo varchar(200) not null,
    editore	varchar(200) not null
);

create table capitolo(
	id_pubblicazione int not null,
    numero int not null check(numero > 0),
    titolo varchar(200),
    primary key(id_pubblicazione, numero),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade
);

create table autore(
	id int auto_increment primary key,
    nome varchar(200) not null,
    cognome varchar(200) not null
);

create table sorgente(
	id int auto_increment primary key,
    id_pubblicazione int not null,
    uri varchar(200) unique not null,
    tipo enum('Download', 'Immagine', 'Acquisto'),
    formato varchar(200) not null,
    descrizione varchar(200),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade
);

create table info_pubblicazione(
		id_pubblicazione int primary key,
        data_pubblicazione date not null,
        numero_pagine int not null,
        edizione int not null,
        lingua varchar(200) not null,
        foreign key(id_pubblicazione) references pubblicazione(id)
			on delete cascade
);

create table ristampa(
	id_pubblicazione int not null,
    numero int not null,
    data_ristampa date not null,
    primary key(id_pubblicazione, numero),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade
);

create table parola_chiave(
	id int auto_increment primary key,
    parola varchar(200) unique not null
);

create table tag(
	id_pubblicazione int not null,
    id_parola int not null,
    primary key(id_pubblicazione, id_parola),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade,
    foreign key(id_parola) references parola_chiave(id)
		on delete cascade
);
	
create table scrittura(
	id_pubblicazione int not null,
    id_autore int not null,
    primary key(id_pubblicazione, id_autore),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade,
    foreign key(id_autore) references autore(id)
		on delete cascade
);

create table utente(
	id int auto_increment primary key,
    email varchar(200) unique not null,
    password_utente varchar(200) not null,
    nome varchar(200) not null,
    cognome varchar(200) not null,
    tipo enum('Attivo', 'Passivo') default 'Passivo' not null
);

create table recensione(
	id_utente int not null,
    id_pubblicazione int not null,
    testo varchar(200) not null,
    data_recensione date,
    ora time,
    moderata enum('Si', 'No', 'In attesa') default 'In attesa',
    primary key(id_utente, id_pubblicazione),
    foreign key(id_utente) references utente(id),
    foreign key(id_pubblicazione) references pubblicazione(id)
);

create table likes(
	id_utente int not null,
    id_pubblicazione int not null,
    data_like date,
    primary key(id_utente, id_pubblicazione),
    foreign key(id_utente) references utente(id),
    foreign key(id_pubblicazione) references pubblicazione(id)
);

create table modifica(
	id int auto_increment primary key,
    id_utente int not null,
    id_pubblicazione int not null,
    data_modifica timestamp,
    descrizione varchar(200),
    tipo enum('Inserimento', 'Modifica', 'Approvazione') not null,
    foreign key(id_utente) references utente(id),
    foreign key(id_pubblicazione) references pubblicazione(id)
);


    