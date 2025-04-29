--Trigger
--checkstadio
create or replace function atleastone() returns trigger as $$
begin
if(not exists (select * from partita where partita.stadio = new.nome) )
then raise exception 'Inserire una partita';
end if;
return new;
end $$
language plpgsql;

create constraint trigger checkstadio
after insert on stadio
deferrable initially deferred
for each row
execute procedure atleastone();

--check_gol
create or replace function controlla_gol() returns trigger as $$
declare numgol integer;
begin
    select count(*) into numgol
    from evento
    where evento.numeroazione=new.numeroazione and evento.partita=new.partita and evento.esitotiro='Gol';
    if(new.gol = true and numgol <> 1) then
        raise exception 'Controlla bene il campo esistotiro degli eventi!';
    end if;
    return new;
END $$ LANGUAGE plpgsql;

create trigger check_gol
after insert on azione
for each row
execute procedure controlla_gol();

--check_posticipazione
create or replace function controlla_data() returns trigger as $$
declare 
posticipata date;
data_partita date;
begin
    if(new.posticipata = true) then
        posticipata=new.dataposticipazione;
        data_partita=new.data;
        if(data_partita::timestamp > posticipata::timestamp) then
            raise exception 'La data di postecipazione deve essere successiva alla data della partita!';
        else
        return new;
        end if;
    else
        return new;
    end if;
END $$ LANGUAGE plpgsql;

create trigger check_posticipazione
after insert on partita
for each row
execute procedure controlla_data();

--check_numeventi
create or replace function controlla_numeventi() returns trigger as $$
declare num integer;
begin
    select count(*) into num
    from evento
    where evento.numeroazione=new.numeroazione and evento.partita=new.partita;
    if(num<1) then
        raise exception 'Una azione deve essere composta da almeno un evento';
    end if;
    return new;
END $$ LANGUAGE plpgsql;

create constraint trigger check_numeventi
after insert on azione
deferrable initially deferred
for each row
execute procedure controlla_numeventi();

--check_eventi
create or replace function controlla_eventi() returns trigger as $$
declare num integer;
begin
    select count(*) into num
    from evento
    where evento.numeroazione=old.numeroazione and evento.partita=old.partita;
    if(num<1) then
        raise exception 'Una azione deve essere composta da almeno un evento';
    end if;
    return old;
END $$ LANGUAGE plpgsql;

create trigger check_eventi
after delete on evento
for each row
execute procedure controlla_eventi();

--AtLeast7
CREATE OR REPLACE FUNCTION AtLeastSEVEN() returns trigger as $$
declare num bigint;
begin 
	select count(*) into num
	from partecipazione 
	where partecipazione.partita = new.giornata;
	
	if num<7 then
		RAISE EXCEPTION 'numero minimo di giocatori (7) non rispettato!';
	end if;
	
	if num>16 then
		RAISE EXCEPTION 'numero massimo di giocatori (16) non rispettato!';
	end if;

	return new;
END $$ LANGUAGE plpgsql;

create trigger AtLeast7
after insert on partita
for each row
execute procedure AtLeastSEVEN();

--check_presenza
drop function if exists controlla_presenza();
create or replace function controlla_presenza() returns trigger as $$
begin
	if(not exists (select * from partecipazione join evento on partecipazione.giocatore = new.giocatore
				   where partecipazione.partita = new.partita
				  )
	) then 
	  raise exception 'Il giocatore che ha effettuato questo evento non partecipa alla partita!';
	end if;
	return new;
end $$
language plpgsql;

create constraint trigger check_presenza
after insert on evento
deferrable initially deferred
for each row 
execute procedure controlla_presenza();

--check_delete_partecipazione
CREATE OR REPLACE FUNCTION elimina_presenza() returns trigger as $$
declare num bigint;
begin 
	select count(*) into num
	from partecipazione 
	where partita = old.giornata;
	
	if num<7 then
		RAISE EXCEPTION 'numero minimo di giocatori (7) non rispettato!';
	end if;
	return old;
END $$ LANGUAGE plpgsql;

create trigger check_delete_partecipazione
after delete on partecipazione
for each row
execute procedure elimina_presenza();

--check_tipo_evento
create or replace function check_evento() returns trigger as $$
begin
    case new.tipoevento
        when 'Passaggio' then
            if(new.esitotiro is null and new.zonafineconduzione is null and new.numerodribbling is null) then
                return new;
            else
                raise exception 'Controlla bene i campi';
               end if;
        when 'Tiro' then
            if(new.zonaarrivopassaggio is null and new.zonafineconduzione is null and new.numerodribbling is null and new.tipopassaggio is null) then
                return new;
            else
                raise exception 'Controlla bene i campi';
               end if;
        when 'Conduzione palla' then
            if(new.esitotiro is null and new.zonaarrivopassaggio is null and new.tipopassaggio is null and new.numerodribbling is not null ) then
                if(new.zonafineconduzione is null) then
                    return new;
                elseif (new.zonainizio <> new.zonafineconduzione) then
                    return new;
                end if;
            else
                raise exception 'Controlla bene i campi';
               end if;

    end case;
END $$ LANGUAGE plpgsql;

create trigger check_tipo_evento 
after insert on evento
for each row
execute procedure check_evento();

--check_azione
create or replace function controlla_azione() returns trigger as $$
declare myvar varchar(16);
begin
    select tipoevento into myvar
    from evento
    where evento.numeroazione = new.numeroazione and numeroevento = (select max(numeroevento)
                                                                     from evento
                                                                     where evento.numeroazione = new.numeroazione
                                                                    );
    if (myvar <> 'Tiro' and new.tipoazione = 'Conclusa') then
        raise exception 'ERRORE: l''ultimo evento di una azione conclusa deve essere un tiro';
    end if;
    return new;
END $$ LANGUAGE plpgsql;

create constraint trigger check_azione
after insert on azione
deferrable initially deferred
for each row
execute procedure controlla_azione();