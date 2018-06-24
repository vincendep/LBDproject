drop database if exists library;

create schema library;
use library;

create table pubblicazione(
	id int unsigned auto_increment not null primary key,
    isbn varchar(200) unique,
	titolo varchar(200) not null,
    editore	varchar(200) not null
);

create table capitolo(
	id_pubblicazione int unsigned not null,
    numero int not null,
    titolo varchar(200),
    primary key(id_pubblicazione, numero),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade
);

create table autore(
	id int unsigned auto_increment not null primary key,
    nome varchar(200) not null,
    cognome varchar(200) not null
);

create table sorgente(
	id int unsigned auto_increment not null primary key,
    id_pubblicazione int unsigned not null,
    uri varchar(200) unique not null,
    tipo enum('Download', 'Immagine', 'Acquisto'),
    formato varchar(200),
    descrizione varchar(200),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade
);

create table info_pubblicazione(
		id_pubblicazione int unsigned primary key,
        anno_pubblicazione year not null,
        numero_pagine int not null,
        edizione int not null,
        lingua varchar(200) not null,
        foreign key(id_pubblicazione) references pubblicazione(id)
			on delete cascade
);

create table ristampa(
	id_pubblicazione int unsigned not null,
    numero int not null,
    anno_ristampa year not null,
    primary key(id_pubblicazione, numero),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade
);

create table parola_chiave(
	id int unsigned auto_increment not null primary key,
    parola varchar(200) unique not null
);

create table tag(
	id_pubblicazione int unsigned not null,
    id_parola int unsigned not null,
    primary key(id_pubblicazione, id_parola),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade,
    foreign key(id_parola) references parola_chiave(id)
		on delete cascade
);
	
create table scrittura(
	id_pubblicazione int unsigned not null,
    id_autore int unsigned not null,
    primary key(id_pubblicazione, id_autore),
    foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade,
    foreign key(id_autore) references autore(id)
		on delete cascade
);

create table utente(
	id int unsigned auto_increment not null primary key,
    email varchar(200) unique not null,
    password_utente varchar(200) not null,
    nome varchar(200) not null,
    cognome varchar(200) not null,
    tipo enum('Attivo', 'Passivo') default 'Passivo' not null
);

create table recensione(
	id_utente int unsigned not null,
    id_pubblicazione int unsigned not null,
    testo varchar(200) not null,
    data_ora datetime default current_timestamp,
    moderata enum('Si', 'No', 'In attesa') default 'In attesa',
    primary key(id_utente, id_pubblicazione),
    foreign key(id_utente) references utente(id) on delete cascade,
    foreign key(id_pubblicazione) references pubblicazione(id) on delete cascade
);

create table likes(
	id_utente int unsigned not null,
    id_pubblicazione int unsigned not null,
    data_ora datetime default current_timestamp,
    primary key(id_utente, id_pubblicazione),
    foreign key(id_utente) references utente(id) on delete cascade,
    foreign key(id_pubblicazione) references pubblicazione(id) on delete cascade
);

create table modifica(
	id int unsigned auto_increment not null primary key,
    id_utente int unsigned not null,
    id_pubblicazione int unsigned not null,
    data_ora datetime default current_timestamp,
    descrizione varchar(200),
    tipo enum('Inserimento', 'Modifica', 'Cancellazione') not null,
    foreign key(id_utente) references utente(id),
    foreign key(id_pubblicazione) references pubblicazione(id)
);


    