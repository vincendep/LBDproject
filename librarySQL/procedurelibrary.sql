use library;
delimiter $

/*
Description: Modifica il tipo di un utente
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @email = email dell'utente
Param: @stato = nuovo stato
*/ 
drop procedure if exists query1$
create procedure query1(email varchar(200), stato enum('Attivo', 'Passivo'))
begin
update utente u set tipo = stato
where u.email = email;
end$


/*
Description: Visualizza le ultime 10 pubblicazioni inserite
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query2$
create procedure query2()
begin
select p.titolo, p.isbn, m.data_ora as data_inserimento  
from pubblicazione p, modifica m
where p.id = m.id_pubblicazione 
	and m.tipo = 'Inserimento'
order by m.data_ora
limit 10;
end$


/*
Description: Visualizza le pubblicazioni modificate negli ultimi 30 giorni
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query3$
create procedure query3()
begin
select p.titolo, p.isbn, to_days(curdate()) - to_days(m.data_ora) as days_ago, m.descrizione
from pubblicazione p, modifica m
where p.id = m.id_pubblicazione 
	and m.tipo = 'Modifica' 
    and to_days(curdate()) - to_days(m.data_ora) <= 30;
end$


/*
Description: Visualizza gli utenti piu collaborativi
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query4$
create procedure query4()
begin
select u.email as username, count(*) as inserimenti 
from utente u, modifica m
where u.id = m.id_utente
	and m.tipo = 'Inserimento'
group by u.id
order by inserimenti
limit 50;
end$


/*
Description: Visualizza le pubblicazioni inserite da un utente
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @email = email dell'utente
*/ 
drop procedure if exists query5$
create procedure query5(email varchar(200))
begin
select p.titolo, email as inserita_da, m.data_ora
from pubblicazione p, modifica m, utente u
where m.tipo = 'Inserimento'
	and p.id = m.id_pubblicazione
    and u.id = m.id_utente
    and u.email = email;
end$


/*
Description: Visualizza il catalogo
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query6$
create procedure query6()
begin
select p.titolo, group_concat(a.cognome separator ', ') as autori, p.editore, i.anno_pubblicazione
from pubblicazione p, info_pubblicazione i, autore a, scrittura s
where p.id = i.id_pubblicazione
	and p.id = s.id_pubblicazione
    and a.id = s.id_autore
group by p.id
order by p.titolo;
end$


/*
Description: Visualizza i dati completi di una pubblicazione specificato il suo ID
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @id = ID pubblicazione
*/
drop procedure if exists query7$
create procedure query7(id integer)
begin
select p.id, p.titolo, group_concat(a.cognome separator ' ,') as autori, p.editore, p.isbn, i.edizione, i.anno_pubblicazione, i.numero_pagine, i.lingua
from pubblicazione p join scrittura s on p.id = s.id_pubblicazione 
	join autore a on a.id = s.id_autore 
	join info_pubblicazione i on i.id_pubblicazione = p.id
where p.id = id
group by p.id;
end$


/*
Description: Ricerca di pubblicazione per isbn, titolo, autore e parole chiavi
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @isbn = isbn pubblicazione
Param: @titolo: titolo pubblicazione
Param: @autore: autore pubblicazione
Param: @parola: parola chiave
*/
drop procedure if exists query8$
create procedure query8(isbn varchar(200), titolo varchar(200), autore varchar(200), parola varchar(200))
begin
select p.titolo, a.cognome as autore, p.editore, p.isbn 
from pubblicazione p join scrittura s on p.id = s.id_pubblicazione
	join autore a on s.id_autore = a.id
    left outer join tag t on p.id = t.id_pubblicazione
    left outer join parola_chiave pa on pa.id = t.id_parola
where (p.isbn = isbn or p.titolo = titolo or a.cognome = autore or pa.parola = parola)
group by p.titolo, p.editore, p.isbn;
end$


/*
Description: Inserisce una recensione relativa ad una pubblicazione
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @email = email dell'utente
Param: @pubblicazione = ID pubblicazione
Param: @testo = testo della recensione
*/
drop procedure if exists query9$
create procedure query9(email varchar(200), pubblicazione int unsigned, testo varchar(200))
begin
insert into recensione (id_utente, id_pubblicazione, testo) 
values ((select u.id from utente u where u.email = email), pubblicazione, testo);
end$
 

/*
Description: Approva una recensione
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @email = email dell'utente
Param: @pubblicazione = ID pubblicazione
*/
drop procedure if exists query10$
create procedure query10(utente varchar(200), pubblicazione int unsigned)
begin
update recensione r set moderata = 'Si'
where r.id_utente in (select u.id from utente u where u.email = utente) 
and r.id_pubblicazione = pubblicazione;
end$


/*
Description: Inserisce il like di un utente ad una pubblicazione
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @utente = email dell'utente
Param: @pubblicazione = ID della pubblicazione
*/
drop procedure if exists query11$
create procedure query11(utente varchar(200), pubblicazione int unsigned)
begin
insert into likes (id_pubblicazione, id_utente) values ((pubblicazione), (select u.id from utente u where u.email = utente));
end$


/*
Description: Visualizza le pubblicazioni più piaciute
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query12$
create procedure query12()
begin
select p.titolo, count(*) as numeroLike
from pubblicazione p, likes l
where p.id = l.id_pubblicazione
group by p.id
order by numeroLike
limit 50;
end$


/*
Description: Visualizza le recensioni relative ad una pubblicazione
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @pubblicazione = titolo pubblicazione
*/drop procedure if exists query13$
create procedure query13(pubblicazione varchar(200))
begin
select * from recensione r
where r.id_pubblicazione in (select p.id from pubblicazione p where p.titolo = pubblicazione);
end$


/*
Description: Visualizza le recensioni in attesa di approvazione
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query14$
create procedure query14()
begin
select r.* from recensione r
where r.moderata = 'In attesa'
order by r.id_utente;
end$


/*
Description: Estrae i log di modifica relativi ad una pubblicazione
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @pubblicazione = titolo della pubblicazione
*/
drop procedure if exists query15$
create procedure query15(pubblicazione varchar(200))
begin
select * from modifica m
where m.id_pubblicazione in (select p.id from pubblicazione p where p.titolo = pubblicazione) and tipo = 'Modifica';
end$


/*
Description: Visualizza i link di download
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query16$
create procedure query16()
begin
select p.titolo as pubblicazione, s.uri, s.descrizione, s.formato
from pubblicazione p, sorgente s 
where p.id = s.id_pubblicazione
	and s.tipo = 'Download'
order by p.titolo;
end$


/*
Description: Visualizza le pubblicazioni con l'ultima ristampa
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists query17$
create procedure query17()
begin
select p.titolo, p.isbn, p.editore, max(r.numero) as ultima_ristampa from pubblicazione p left outer join ristampa r on p.id = r.id_pubblicazione
group by p.id;
end$


/*
Description: Visualizza tutte le pubblicazioni aventi gli stessi autore di una pubblicazione data
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @pubblicazione = titolo della pubblicazione
*/
drop procedure if exists query18$
create procedure query18(pubblicazione varchar(200))
begin
select p.titolo, group_concat(a.cognome separator ' ,') as autori
from pubblicazione p join scrittura s on (p.id = s.id_pubblicazione) join autore a on (a.id = s.id_autore)
where a.id in (select s.id_autore from scrittura s where s.id_pubblicazione = (select p.id from pubblicazione p where p.titolo = pubblicazione))
group by p.titolo;
end$ 

/*
Description: Inserisce una pubblicazione e aggiorna Modifica
Author: Vincenzo De Petris
Create Date: 26/06/18
Param: @email = email dell'utente che inserisce la pubblicazione
Param: @isbn = isbn pubblicazione
Param: @titolo = titolo pubblicazione
Param: @editore = editore pubblicazione
*/
drop procedure if exists inserisciPubblicazione$
create procedure inserisciPubblicazione(email varchar(200), isbn int, titolo varchar(200), editore varchar(200))
begin 
declare id_p int unsigned;
declare id_u int unsigned;

select u.id from utente u where u.email = email into id_u;

if (found_rows() > 0) then 
	begin
	insert into pubblicazione(isbn, titolo, editore) values (isbn, titolo, editore);
    set id_p = last_insert_id();
    insert into modifica(id_utente, id_pubblicazione, tipo) values (id_u, id_p, 'Inserimento');
	end;
end if;
end$

/*
Description: Inserisce una pubblicazione ed il suo autore se non è gia presente
Author: Vincenzo De Petris
Create Date: 27/06/18
Param: @email = email dell'utente che inserisce la pubblicazione
Param: @isbn = isbn pubblicazione
Param: @titolo = titolo pubblicazione
Param: @editore = editore pubblicazione
Param: @n_autore = nome autore
Param: @c_autore = cognome autore
*/
drop procedure if exists inserisciPubblicazione2$
create procedure inserisciPubblicazione2(titolo varchar(200), isbn varchar(200), editore varchar(200), n_autore varchar(200), c_autore varchar(200)) 
begin

declare idAut int unsigned;
declare idPub int unsigned;

insert into pubblicazione(titolo, isbn, editore) values (titolo, isbn, editore);
select id from autore a where a.nome = n_autore and a.cognome = c_autore into idAut;

if(found_rows() > 0) then 
	insert into scrittura(id_pubblicazione, id_autore) values (last_insert_id(), idAut);
else 
begin
	set idPub = last_insert_id();
	insert into autore(nome, cognome) values (c_nome, c_cognome);
    insert into scrittura(id_pubblicazione, id_autore) values (idPub, last_insert_id());
end;
end if;
end$

/*
Description: Elimina le recensioni non approvate
Author: Vincenzo De Petris
Create Date: 27/06/18
*/
drop procedure if exists eliminaRecensioni$
create procedure eliminaRecensioni()
begin
delete from recensione where moderata = 'No';
end$

/*
Description: Verifica se la parola è presente ed inserisce il tag
Author: Vincenzo De Petris
Create Date: 27/06/18
Param: @id_pubblicazione = id pubblicazione
Param: @parola = parola chiave
*/
drop procedure if exists aggiungiTag$
create procedure aggiungiTag(id_pubblicazione int unsigned, parola varchar(200))
begin

declare idParola int unsigned;

select id from parola_chiave p where p.parola = parola into idParola;
if (found_rows() > 0)
then
	insert into tag(id_pubblicazione, id_parola) values (id_pubblicazione, idParola);
else
begin
	insert into parola_chiave(parola) values (parola);
    insert into tag(id_parola, id_pubblicazione) values (last_insert_id(), id_pubblicazione);
end;
end if;
end$


/*
Description: Visualizza l'elenco dei capitoli di una pubblicazione data
Author: Vincenzo De Petris
Create Date: 27/06/18
Param: @titolo = titolo pubblicazione
*/
drop procedure if exists visualizzaCapitoli$
create procedure visualizzaCapitoli(titolo varchar(200))
begin
select p.titolo as pubblicazione,  c.numero as numero_capitolo, c.titolo as titolo_capitolo
from pubblicazione p join capitolo c on p.id = c.id_pubblicazione
where p.titolo = titolo
order by p.titolo, c.numero;  
end$


delimiter ;