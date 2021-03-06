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
    constraint capitolo_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade on update cascade
);

create table autore(
	id int unsigned auto_increment not null primary key,
    nome varchar(200) not null,
    cognome varchar(200) not null,
    constraint noOmonini unique(nome, cognome)
);

create table sorgente(
	id int unsigned auto_increment not null primary key,
    id_pubblicazione int unsigned not null,
    uri varchar(200) unique not null,
    tipo enum('Download', 'Immagine', 'Acquisto'),
    formato varchar(200),
    descrizione varchar(200),
    constraint sorgente_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade on update cascade
);

create table info_pubblicazione(
		id_pubblicazione int unsigned primary key,
        anno_pubblicazione year not null,
        numero_pagine int not null,
        edizione int not null,
        lingua varchar(200) not null,
        constraint infoPubblicazione_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id)
			on delete cascade on update cascade
);

create table ristampa(
	id_pubblicazione int unsigned not null,
    numero int not null,
    anno_ristampa year not null,
    primary key(id_pubblicazione, numero),
    constraint ristampa_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade on update cascade
);

create table parola_chiave(
	id int unsigned auto_increment not null primary key,
    parola varchar(200) unique not null
);

create table tag(
	id_pubblicazione int unsigned not null,
    id_parola int unsigned not null,
    primary key(id_pubblicazione, id_parola),
    constraint tag_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade on update cascade,
    constraint tag_parolaChiave foreign key(id_parola) references parola_chiave(id)
		on delete cascade on update cascade
);
	
create table scrittura(
	id_pubblicazione int unsigned not null,
    id_autore int unsigned not null,
    primary key(id_pubblicazione, id_autore),
    constraint scrittura_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id)
		on delete cascade on update cascade,
    constraint scrittura_autore foreign key(id_autore) references autore(id)
		on delete cascade on update cascade
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
    constraint recensione_utente foreign key(id_utente) references utente(id) 
		on delete cascade on update cascade,
    constraint recensione_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id) 
		on delete cascade on update cascade
);

create table likes(
	id_utente int unsigned not null,
    id_pubblicazione int unsigned not null,
    data_ora datetime default current_timestamp,
    primary key(id_utente, id_pubblicazione),
    constraint likes_utente foreign key(id_utente) references utente(id) 
		on delete cascade on update cascade,
    constraint likes_pubblicazione foreign key (id_pubblicazione) references pubblicazione(id) 
		on delete cascade on update cascade
);

create table modifica(
	id int unsigned auto_increment not null primary key,
    id_utente int unsigned,
    id_pubblicazione int unsigned,
    data_ora datetime default current_timestamp,
    descrizione varchar(200),
    tipo enum('Inserimento', 'Modifica') not null,
    constraint modifica_utente foreign key(id_utente) references utente(id) 
		on delete set null on update cascade,
    constraint modifica_pubblicazione foreign key(id_pubblicazione) references pubblicazione(id) 
		on delete set null on update cascade
);

drop user if exists 'libraryAdmin'@'localhost';
create user 'libraryAdmin'@'localhost' identified by 'admin';
grant all on library.* to 'libraryAdmin'@'localhost';

drop user if exists 'libraryActiveUser'@'localhost';
create user 'libraryActiveUser'@'localhost' identified by 'active';
grant select, insert on library.* to 'libraryActiveUser'@'localhost';

drop user if exists 'libraryPassiveUser'@'localhost';
create user 'libraryPassiveUser'@'localhost' identified by 'passive';
grant select on library.* to 'libraryPassiveUser'@'localhost';
grant insert on library.likes  to 'libraryPassiveUser'@'localhost';
grant insert on library.recensione  to 'libraryPassiveUser'@'localhost';
    