use library;

delete from autore;
delete from capitolo;
delete from info_pubblicazione;
delete from likes;
delete from modifica;
delete from parola_chiave;
delete from pubblicazione;
delete from recensione;
delete from ristampa;
delete from scrittura;
delete from sorgente;
delete from tag;
delete from utente;


insert into autore values (1, 'Hermann', 'Hesse'), (2, 'Gabriel', 'Garcia Marquez'), 
						  (3, 'George', 'Orwell'), (4, 'William', 'Goldinig'),
						  (5, 'Michail', 'Bulgakov'), (6, 'Chuck', 'Palaniuk'), 
                          (7, 'Philip', 'Roth');
                          
insert into pubblicazione values (1, '978-88-06-21803-4', 'Pastorale Americana', 'Einaudi'), 
								 (2, '978-88-04-66842-8', 'Il Maestro e Margherita', 'Mondadori'),
								 (3, '978-88-04-49246-7', 'Il signore delle mosche', 'Mondadori'),
								 (4, '978-0-14-081774-4', 'Nineteen Eighty-Four', 'Penguin Books'),
								 (5, '978-88-04-52136-5', 'Invisible Monsters', 'Mondadori'),
                                 (6, '978-0-099-43796-3', 'Lullaby', 'Vintage Books'),
                                 (7, '978-88-04-66824-4', 'L\'amore ai tempi del colera', 'Mondadori'),
                                 (8, null, 'Siddharta', 'Adelphi');
                          
insert into info_pubblicazione values (1, 1997, 458, 9, 'Italiano'),
									  (2, 1966, 521, 1, 'Italiano'),
                                      (3, 1954, 202, 1, 'Italiano'),
                                      (4, 1949, 329, 4, 'Inglese'),
                                      (5, 2000, 219, 1, 'Italiano'),
                                      (6, 2003, 260, 2, 'Inglese'),
                                      (7, 1985, 376, 1, 'Italiano'),
                                      (8, 1922, 169, 3, 'Italiano');
									
insert into scrittura values (1, 7), (2, 5), (3, 4), (4, 3), (5, 6), (6, 6), (7, 2), (8, 1);

insert into utente values (1, 'vindep@lib.com', '1234', 'Vincenzo', 'De Petris', 'Attivo'),
						  (2, 'dendip@lib.it', 'denis', 'Denis', 'Di Patrizio', 'Attivo'),
                          (3, 'fedfortu@lib.it', '0000', 'Federico', 'Fortunato', 'Passivo');
                          


