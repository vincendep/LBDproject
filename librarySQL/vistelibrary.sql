drop view if exists readableScrittura;
create view readableScrittura as
select p.titolo, group_concat(a.cognome separator ', ') as autori, p.editore, p.isbn
from pubblicazione p join scrittura s on p.id = s.id_pubblicazione join autore a on a.id = s.id_autore
group by p.id;


drop view if exists readableRecensione;
create view readableRecensione as
select u.email as utente, p.titolo as pubblicazione, r.testo, r.data_ora as data_inserimento, moderata as approvata
from utente u join recensione r on u.id = r.id_utente join pubblicazione p on p.id = r.id_pubblicazione;


drop view if exists readableTag;
create view readableTag as
select p.titolo, group_concat(pa.parola separator ', ') as tag
from pubblicazione p join tag t on p.id = t.id_pubblicazione join parola_chiave pa on pa.id = t.id_parola
group by p.id;


drop view if exists readableLikes;
create view readableLikes as
select u.email as utente, p.titolo, l.data_ora
from utente u join likes l on u.id = l.id_utente join pubblicazione p on p.id = l.id_pubblicazione
order by u.email;

drop view if exists readableModifica;
create view readableModifica as
select p.titolo as pubblicazione, u.email as utente, m.data_ora, m.tipo, m.descrizione
from pubblicazione p join modifica m on p.id = m.id_pubblicazione join utente u on u.id = m.id_utente;


drop view if exists pubblicazioneCompleta;
create view pubblicazioneCompleta as
select p.titolo, group_concat(a.cognome separator ', ') as autori, p.editore,
	i.anno_pubblicazione, i.edizione, i.numero_pagine, i.lingua, p.isbn
from pubblicazione p join info_pubblicazione i on p.id = i.id_pubblicazione
	join scrittura s on s.id_pubblicazione = p.id
    join autore a on a.id = s.id_autore
group by p.isbn;