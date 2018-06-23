use library;
delimiter $

-- modifica il livello di un utente
drop procedure if exists query1$
create procedure query1(email varchar(200), stato enum('Attivo', 'Passivo'))
begin
update utente u set tipo = stato
where u.email = email;
end$

-- visualizza le pubblicazioni inserite da un utente
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

-- visualizza i dati completi di una pubblicazione specificato il suo ID
drop procedure if exists query7$
create procedure query7(id integer)
begin
select p.id, p.titolo, concat_ws(", ", a.cognome) as autori, p.editore, p.isbn, i.edizione, i.data_pubblicazione, i.numero_pagine, i.lingua
from pubblicazione p join scrittura s on p.id = s.id_pubblicazione 
	join autore a on a.id = s.id_autore 
	join info_pubblicazione i on i.id_pubblicazioen = p.id
group by p.id, p.titolo, p.editore, p.isbn, i.edizione, i.data_pubblicazione, i.numero_pagine, i.lingua;
end$

-- ricerca pubblicazione per ISBN, titolo, autore e parola chiave
drop procedure if exists query8$
create procedure query8(isbn int, titolo varchar(200), autore varchar(200), parola varchar(200))
begin
select p.titolo, autore, p.editore, p.isbn 
from pubblicazione p join scrittura s on p.id = s.id_pubblicazione 
	join autore a on a.id = s.id_autore 
    join tag t on t.id_pubblicazione = p.id 
    join parola_chiave pa on pa.id = t.id_parola
where p.isbn = isbn
	or p.titolo = titolo
    or a.cognome = autore
    or pa.parola = parola;
end$

-- inserisce una recensione relativa ad una pubblicazione
drop procedure if exists query9$
create procedure query9(email varchar(200), titolo varchar(200), testo varchar(200))
begin
insert into recensione (id_utente, id_pubblicazione, testo) 
values ((select u.id from utente u where u.email = email), (select p.id from pubblicazione p where p.titolo = titolo), testo);
end$
 
-- approva una recensione
drop procedure if exists query10$
create procedure query10(id int)
begin
update recensione r set moderata = 'Si'
where r.id = id;
end$

-- inserisce un like ad una pubblicazione
drop procedure if exists query11$
create procedure query11(id_pub int, id_ute int)
begin
insert into likes (id_pubblicazione, id_utente) values (id_pub, id_ute);
end$

-- estrare l'elenco delle recensioni approvate per una pubblicazione
drop procedure if exists query13$
create procedure query13(id_pub int)
begin
select * from recensione r
where r.id_pubblicazione = id_pub;
end$

-- estrae i log di modifica di una pubblicazione
drop procedure if exists query15$
create procedure query15(id_pub integer)
begin
select * from modifica m
where m.id_pubblicazione = id_pub and tipo = 'Modifica';
end$

-- data una pubblicazione restituisce tutte le pubblicazione aventi lo stesso autore
drop procedure if exists query18$
create procedure query18(id_pub int)
begin
select p.titolo, a.cognome as autore
from pubblicazione p join scittura s on p.id = s.id_pubblicazione join autore a on a.id = s.id_scrittore
where a.id = (select a.id from scrittura s where s.id_pubblicazione = id_pub);
end$ 


