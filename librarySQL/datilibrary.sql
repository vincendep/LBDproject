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
						  (5, 'Michail', 'Bulgakov'), (6, 'Chuck', 'Palahniuk'), 
                          (7, 'Philip', 'Roth'),(8, 'Paolo', 'Atzeni'),
                          (9, 'Stefano', 'Ceri'),(10, 'Stefano', 'Paraboschi');
                          
insert into pubblicazione values (1, '978-88-06-21803-4', 'Pastorale Americana', 'Einaudi'), 
								 (2, '978-88-04-66842-8', 'Il Maestro e Margherita', 'Mondadori'),
								 (3, '978-88-04-49246-7', 'Il signore delle mosche', 'Mondadori'),
								 (4, '978-0-14-081774-4', 'Nineteen Eighty-Four', 'Penguin Books'),
								 (5, '978-88-04-52136-5', 'Invisible Monsters', 'Mondadori'),
                                 (6, '978-0-099-43796-3', 'Lullaby', 'Vintage Books'),
                                 (7, '978-88-04-66824-4', 'L\'amore ai tempi del colera', 'Mondadori'),
                                 (8,                null, 'Siddharta', 'Adelphi'),
                                 (9, '978-88-38-69445-5', 'Basi di dati', 'McGraw-Hill Education'),
                                 (10, '978-88-04-52438-0', 'Soffocare', 'Mondadori');

insert into capitolo values (3, 1, 'Il suono della conciglia'),
							(3, 2, 'Fuoco sulla montagna'),
                            (3, 3, 'Capanne sulla spiaggia'),
                            (3, 4, 'Facce dipinte e capelli lunghi'),
							(3, 5, 'Una bestia dal mare'),
							(3, 6, 'Una bestia dal cielo'),
                            (3, 7, 'Ombre e grandi alberi'),
                            (3, 8, 'Un dono per le tenebre'),
                            (3, 9, 'Una visione di morte'),
                            (3, 10, 'La conchiglia e gli occhiali'),
                            (3, 11, 'Il castello'),
                            (3, 12, 'Il grido dei cacciatori');


insert into info_pubblicazione values (1, 1997, 458, 9, 'Italiano'),
									  (2, 1966, 521, 1, 'Italiano'),
                                      (3, 1954, 202, 1, 'Italiano'),
                                      (4, 1949, 329, 4, 'Inglese'),
                                      (5, 2000, 219, 1, 'Italiano'),
                                      (6, 2003, 260, 2, 'Inglese'),
                                      (7, 1985, 376, 1, 'Italiano'),
                                      (8, 1922, 169, 3, 'Italiano'),
                                      (9, 2014, 766, 4, 'Italiano');
									
insert into scrittura values (1, 7), (2, 5), (3, 4), (4, 3), (5, 6), (6, 6), (7, 2), (8, 1), (9, 9),(9, 8),(9, 10), (10, 6);

insert into utente values (1, 'vindep@lib.com', '1234', 'Vincenzo', 'De Petris', 'Attivo'),
						  (2, 'dendip@lib.it', 'denis', 'Denis', 'Di Patrizio', 'Attivo'),
                          (3, 'fedfortu@lib.it', '0000', 'Federico', 'Fortunato', 'Passivo');
                          
insert into likes (id_utente,id_pubblicazione) values (1, 2), (1, 5), (1, 7), (1, 9);

insert into parola_chiave values (1, 'Om'), (2, 'Buddha'), (3, 'America'), (4, 'Diavolo'), (5, 'Vietnam');

insert into tag values (8, 1),(8, 2),(1, 3),(2, 4),(1, 5);

insert into ristampa values (7, 36, 2016), (7, 37, 2016), (7, 38, 2016), (7, 39, 2016);

                          
insert into modifica (id_utente, id_pubblicazione, tipo) values (1, 1, 'Inserimento'), 
																(1, 2, 'Inserimento'),
                                                                (1, 3, 'Inserimento'),
                                                                (1, 4, 'Inserimento'),
                                                                (1, 5, 'Inserimento'),
                                                                (1, 6, 'Inserimento'),
                                                                (1, 7, 'Inserimento'),
                                                                (1, 8, 'Inserimento'),
                                                                (1, 9, 'Inserimento'),
                                                                (1, 3, 'Modifica');

insert into recensione (id_utente, id_pubblicazione, testo) values (1, 1, 'Bello'), (1, 4, 'Cosi Cosi'), (1, 5, 'Magnifico');

insert into sorgente values (1, 1, 'wwww.pastoraleamericana.lib', 'Download', '.zip', 'fulltext');