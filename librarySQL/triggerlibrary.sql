delimiter $

drop trigger if exists checkModifica$ 
create trigger checkModifica before insert on modifica for each row
begin
	if ((select u.tipo from utente u where u.id = new.id_utente) = 'Passivo')
    then
    signal sqlstate '45000' set message_text = 'Un utente passivo non può apportare modifiche alla library';
    end if;
end$

delimiter ;