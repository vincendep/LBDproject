-- visualizza le ultime 10 pubblicazioni inserite
drop view if exists query2;
create view query2 as
select p.titolo, p.isbn, m.data_ora as data_inserimento  
from pubblicazione p, modifica m
where p.id = m.id_pubblicazione 
	and m.tipo = 'Inserimento'
order by m.data_ora
limit 10;

-- visualizza le pubblicazioni modificate negli ultimi 30 giorni
drop view if exists query3;
create view query3 as
select p.titolo, p.isbn, m.data_ora
from pubblicazione p, modifica m
where p.id = m.id_pubblicazione 
	and m.tipo = 'Modifica' 
    and m.data_ora >= (curdate() - interval 1 month);
    
-- visualizza gli utenti che hanno inserito piu pubblicazioni
drop view if exists query4;
create view query4 as
select u.email as username, count(*) as inserimenti 
from utente u, modifica m
where u.id = m.id_utente
	and m.tipo = 'Inserimento'
group by u.id
order by inserimenti
limit 50;

-- visualizza pubblicazioni e autori ordinati per titolo
drop view if exists query6;
create view query6 as
select p.titolo, group_concat(a.cognome separator ', ') as autori, p.editore, i.anno_pubblicazione
from pubblicazione p, info_pubblicazione i, autore a, scrittura s
where p.id = i.id_pubblicazione
	and p.id = s.id_pubblicazione
    and a.id = s.id_autore
group by p.id
order by p.titolo;

-- visualizza il numero di like ricevuti dalle 50 pubblicazioni piu piaciute
drop view if exists query12;
create view query12 as
select p.titolo, count(*) as numeroLike
from pubblicazione p, likes l
where p.id = l.id_pubblicazione
group by p.id
order by numeroLike
limit 50;

-- visualizza le recensioni in attesa di approvazione
drop view if exists query14;
create view query14 as
select r.* from recensione r
where r.moderata = 'In attesa'
order by r.id_utente;

-- visualizza i link di download delle pubblicazioni
drop view if exists query16;
create view query16 as
select p.titolo as pubblicazione, s.uri, s.descrizione, s.formato
from pubblicazione p, sorgente s 
where p.id = s.id_pubblicazione
	and s.tipo = 'Download'
order by p.titolo;

-- visualizza il catalogo insieme all'ultima ristampa di ogni pubblicazione
drop view if exists query17;
create view query17 as
select p.titolo, p.isbn, p.editore, max(r.numero) as ultima_ristampa from pubblicazione p left outer join ristampa r on p.id = r.id_pubblicazione
group by p.id;