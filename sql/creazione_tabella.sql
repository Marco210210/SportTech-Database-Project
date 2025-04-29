DROP TABLE if EXISTS Giocatore CASCADE;
DROP TABLE if EXISTS Partecipazione CASCADE;
DROP TABLE if EXISTS Partita CASCADE;
DROP TABLE if EXISTS Stadio CASCADE;
DROP TABLE if EXISTS Azione CASCADE;
DROP TABLE if EXISTS Evento CASCADE;
DROP TABLE if EXISTS Competizione CASCADE;

CREATE TABLE Giocatore(
	NumeroTesserino varchar(6) PRIMARY KEY,
	Nome varchar(30) NOT NULL,
	Cognome varchar(30) NOT NULL,
	NumeroMaglia integer NOT NULL UNIQUE,
	Altezza integer NOT NULL,
	Peso integer NOT NULL,
	DataDiNascita date NOT NULL,
	Nazionalità varchar(30) NOT NULL,
	PiedeForte varchar(2) NOT NULL,
CONSTRAINT TipoPiede CHECK (PiedeForte in ('SX', 'DX'))
);

CREATE TABLE Stadio(
	Nome varchar(30) PRIMARY KEY,
	Nazione varchar(30) NOT NULL,
	Città varchar(30) NOT NULL,
	Capienza integer NOT NULL
);

CREATE TABLE Competizione(
	Nome varchar(30) PRIMARY KEY
);

CREATE TABLE Partita(
	Giornata varchar(4) PRIMARY KEY,
	Competizione varchar(30) NOT NULL,
	Data date NOT NULL,
	MinutiGiocati integer NOT NULL,
	SquadraCasa varchar(30) NOT NULL,
	SquadraOspite varchar(30) NOT NULL,
	Risultato varchar(5) NOT NULL,
	Posticipata boolean NOT NULL,
	DataPosticipazione date,
	Stadio varchar(30) NOT NULL,
CONSTRAINT fk_stadio FOREIGN KEY (Stadio) REFERENCES Stadio(Nome) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT fk_competizione FOREIGN KEY (Competizione) REFERENCES Competizione(Nome) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Partecipazione(
	Giocatore varchar(6),
	Partita varchar(4),
	Ruolo varchar(3) NOT NULL,
	MinutoIngresso varchar(6) NOT NULL,
	MinutoUscita varchar(6) NOT NULL,
CONSTRAINT fk_partita FOREIGN KEY (Partita) REFERENCES Partita(Giornata) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,     
CONSTRAINT fk_giocatore FOREIGN KEY (Giocatore) REFERENCES Giocatore(NumeroTesserino) ON UPDATE CASCADE ON DELETE RESTRICT,
Primary Key(Giocatore, Partita),
CONSTRAINT TipoRuolo CHECK (Ruolo in ('POR','TD','DC','TS','CDC','AD','ED','CC','ES','AS','COC','ATT'))
);


CREATE TABLE Azione(
	NumeroAzione integer,
	Partita varchar(4),
	TipoAzione varchar(8) NOT NULL,
	Zona varchar(2),
	TipoFermata varchar(21),
	Gol boolean NOT NULL, 
	GiocatoreFermata varchar(30),
CONSTRAINT fk_partita FOREIGN KEY (Partita) REFERENCES Partita(Giornata) ON UPDATE CASCADE ON DELETE RESTRICT,     
Primary Key(NumeroAzione,Partita),
CONSTRAINT TipoAzione CHECK (TipoAzione in ('Fermata', 'Conclusa')),
CONSTRAINT TipoFermata CHECK (TipoFermata in ('Errore tecnico', 'Intervento avversario', 'Fuorigioco','Fallo avversario')),
CONSTRAINT TipoZona CHECK (Zona in ('A1', 'A2', 'A3','A4','B1','B2','B3','B4','C1','C2','C3','C4','D1','D2','D3','D4','E1','E2','E3','E4','F')),
CONSTRAINT check_tipo_azione check ((tipoazione='Conclusa' and tipofermata is NULL and zona is NULL and giocatorefermata is NULL) or (tipoazione='Fermata' and tipofermata is not NULL and zona is not NULL and giocatorefermata is not NULL))
);


CREATE TABLE Evento(
	NumeroEvento SERIAL,
	NumeroAzione integer,
	Partita varchar(4),
	Giocatore varchar(6) NOT NULL,
	ZonaInizio varchar(2) NOT NULL,
	TipoEvento varchar(16) NOT NULL,
	EsitoTiro varchar(6),
	ZonaFineConduzione varchar(2),
	NumeroDribbling integer,
	ZonaArrivoPassaggio varchar(2),
	TipoPassaggio varchar(7),
CONSTRAINT fk_giocatore FOREIGN KEY (Giocatore) REFERENCES Giocatore(NumeroTesserino) ON UPDATE CASCADE ON DELETE RESTRICT,     
Primary Key(NumeroAzione,NumeroEvento),
CONSTRAINT TipoEvento CHECK (TipoEvento in ('Tiro', 'Conduzione palla', 'Passaggio')),
CONSTRAINT TipoZonaIniz CHECK (ZonaInizio in ('A1', 'A2', 'A3','A4','B1','B2','B3','B4','C1','C2','C3','C4','D1','D2','D3','D4','E1','E2','E3','E4','F')),
CONSTRAINT TipoZonaFine CHECK (ZonaFineConduzione in ('A1', 'A2', 'A3','A4','B1','B2','B3','B4','C1','C2','C3','C4','D1','D2','D3','D4','E1','E2','E3','E4')),
CONSTRAINT TipoZonaArrivo CHECK (ZonaArrivoPassaggio in ('A1', 'A2', 'A3','A4','B1','B2','B3','B4','C1','C2','C3','C4','D1','D2','D3','D4','E1','E2','E3','E4','F')),
CONSTRAINT TipoPassaggio CHECK (TipoPassaggio in ('Rimessa', 'Angolo', 'Lungo', 'Corto', 'Cross')),
CONSTRAINT TipoEsitoTiro CHECK (EsitoTiro in ('Gol', 'Parata', 'Fuori'))
);

--Inserimento dati
begin transaction;
INSERT INTO Giocatore (numerotesserino, nome, cognome, numeromaglia, altezza, peso, datadinascita, nazionalità, piedeforte) VALUES
('000001', 'Alex', 'Meret', '1', '190', '90', '22041997', 'Italia', 'SX'),
('000002', 'David', 'Ospina', '25', '182', '95', '31081988', 'Colombia', 'DX'),
('000003', 'Amir', 'Rrahmani', '13', '192', '95', '24021994', 'Albania', 'SX'),
('000004', 'Kalidou', 'Koulibaly', '26', '187', '98', '20061991', 'Senegal', 'SX'),
('000005', 'Mario', 'Rui', '6', '186', '70', '27051991', 'Portogallo', 'SX'),
('000006', 'Giovanni', 'Di Lorenzo', '22', '183', '90', '04051993', 'Italia', 'DX'),
('000007', 'Zambo', 'Anguissa', '99', '184', '90', '16111995', 'Camerun', 'DX'),
('000008', 'Stanislav', 'Lobotka', '68', '170', '75', '25111994', 'Slovacchia', 'DX'),
('000009', 'Matteo', 'Politano', '21', '171', '73', '03051993', 'Italia', 'SX'),
('000010', 'Dries', 'Mertens', '14', '169', '70', '06051987', 'Belgio', 'DX'),
('000011', 'Lorenzo', 'Insigne', '24', '163', '72', '04061991', 'Italia', 'DX'),
('000012', 'Victor', 'Osimhen', '9', '186', '80', '29121998', 'Nigeria', 'DX'),
('000013', 'Davide', 'Marfella', '12', '182', '83', '15091999', 'Italia', 'DX'),
('000014', 'Juan', 'Jesus', '5', '185', '94', '10061991', 'Brasile', 'SX'),
('000015', 'Faouzi', 'Ghoulam', '31', '184', '79', '01021991', 'Algerino', 'SX'),
('000016', 'Alessandro', 'Zanoli', '59', '188', '85', '03102000', 'Italia', 'DX'),
('000017', 'Eljif', 'Elmas', '7', '182', '80', '24091999', 'Macedonia', 'DX'),
('000018', 'Diego', 'Demme', '4', '170', '70', '21111991', 'Germania', 'DX'),
('000019', 'Piotr', 'Zielinski', '20', '180', '83', '20051994', 'Polonia', 'DX'),
('000020', 'Hirving', 'Lozano', '11', '175', '70', '30071995', 'Messico', 'DX'),
('000021', 'Adam', 'Ounas', '33', '172', '71', '11111996', 'Algerino', 'SX'),
('000022', 'Andrea', 'Petagna', '36', '190', '95', '30061995', 'Italia', 'SX'),
('000023', 'Fabian', 'Ruiz', '8', '189', '87', '03041996', 'Spagnolo', 'SX'),
('000024', 'Axel', 'Tuanzebe', '3', '185', '80', '14111997', 'Inglese', 'DX'),
('000025', 'Kevin', 'Malcuit', '2', '178', '76', '31071991', 'Francese', 'DX');

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

INSERT INTO stadio (nome, nazione, città, capienza) VALUES
('Diego Armando Maradona','Italia','Napoli','54726'),
('San Siro','Italia','Milano','80018'),
('Luigi Ferraris','Italia','Genova','36599'),
('Pepsi Arena','Polonia','Varsavia','31800'),
('Olimpico','Italia','Roma','72698'),
('Arechi','Italia','Salerno','37800'),
('Camp Nou','Spagna','Barcelona','99354');

INSERT INTO competizione (nome) VALUES
('Serie A'),
('Coppa Italia'),
('UEFA Europa League'),
('UEFA Champions League');

INSERT INTO partecipazione (giocatore, partita, minutoingresso, minutouscita, ruolo) VALUES
('000002','SA1', '0-1T','95-2T', 'POR'),
('000006','SA1', '0-1T','95-2T', 'TD'),
('000003','SA1', '0-1T','95-2T', 'DC'),
('000004','SA1', '0-1T','95-2T', 'DC'),
('000005','SA1', '0-1T','95-2T', 'TS'),
('000008','SA1', '0-1T','60-2T', 'CC'),
('000007','SA1', '0-1T','60-2T', 'CC'),
('000023','SA1', '0-1T','95-2T', 'CC'),
('000009','SA1', '0-1T','55-2T', 'AD'),
('000011','SA1', '0-1T','95-2T', 'AS'),
('000012','SA1', '0-1T','95-2T', 'ATT'),

('000010','SA1', '60-2T','95-2T', 'COC'),
('000018','SA1', '60-2T','95-2T', 'CC'),
('000020','SA1', '55-2T','95-2T', 'AD'),

('000001','SA2', '0-1T','97-2T', 'POR'),
('000006','SA2', '0-1T','97-2T', 'TD'),
('000003','SA2', '0-1T','97-2T', 'DC'),
('000004','SA2', '0-1T','45-1T', 'DC'),
('000005','SA2', '0-1T','97-2T', 'TS'),
('000008','SA2', '0-1T','97-2T', 'CC'),
('000007','SA2', '0-1T','97-2T', 'CC'),
('000023','SA2', '0-1T','60-2T', 'CC'),
('000010','SA2', '0-1T','60-2T', 'AD'),
('000011','SA2', '0-1T','97-2T', 'AS'),
('000012','SA2', '0-1T','97-2T', 'ATT'),

('000019','SA2', '60-2T','97-2T', 'COC'),
('000020','SA2', '60-2T','97-2T', 'AD'),
('000014','SA2', '45-1T','97-2T', 'DC'),

('000002','SA3', '0-1T','80-2T', 'POR'),
('000006','SA3', '0-1T','60-2T', 'TD'),
('000003','SA3', '0-1T','90-2T', 'DC'),
('000004','SA3', '0-1T','90-2T', 'DC'),
('000005','SA3', '0-1T','90-2T', 'TS'),
('000008','SA3', '0-1T','90-2T', 'CC'),
('000007','SA3', '0-1T','45-2T', 'CC'),
('000023','SA3', '0-1T','90-2T', 'CC'),
('000009','SA3', '0-1T','90-2T', 'AD'),
('000011','SA3', '0-1T','90-2T', 'AS'),
('000012','SA3', '0-1T','90-2T', 'ATT'),

('000016','SA3', '60-2T','90-2T', 'TD'),
('000019','SA3', '45-2T','90-2T', 'COC'),
('000001','SA3', '80-2T','90-2T', 'POR'),

('000002','EL1', '0-1T','95-2T', 'POR'),
('000006','EL1', '0-1T','60-2T', 'TD'),
('000003','EL1', '0-1T','95-2T', 'DC'),
('000004','EL1', '0-1T','95-2T', 'DC'),
('000005','EL1', '0-1T','95-2T', 'TS'),
('000008','EL1', '0-1T','60-2T', 'CC'),
('000017','EL1', '0-1T','60-2T', 'CC'),
('000010','EL1', '0-1T','95-2T', 'COC'),
('000009','EL1', '0-1T','95-2T', 'AD'),
('000011','EL1', '0-1T','60-2T', 'AS'),
('000012','EL1', '0-1T','95-2T', 'ATT'),

('000019','EL1', '60-2T','95-2T', 'CC'),
('000020','EL1', '60-2T','95-2T', 'AS'),
('000007','EL1', '60-2T','95-2T', 'CC'),

('000002','EL2', '0-1T','97-2T', 'POR'),
('000006','EL2', '0-1T','97-2T', 'TD'),
('000014','EL2', '0-1T','97-2T', 'DC'),
('000004','EL2', '0-1T','97-2T', 'DC'),
('000005','EL2', '0-1T','47-2T', 'TS'),
('000008','EL2', '0-1T','97-2T', 'CDC'),
('000019','EL2', '0-1T','97-2T', 'CC'),
('000023','EL2', '0-1T','46-2T', 'CC'),
('000009','EL2', '0-1T','97-2T', 'AD'),
('000011','EL2', '0-1T','60-2T', 'AS'),
('000012','EL2', '0-1T','97-2T', 'ATT'),

('000016','EL2', '46-2T','95-2T', 'TS'),
('000017','EL2', '60-1T','95-2T', 'AS'),
('000001','EL2', '80-2T','95-2T', 'POR'),
('000010','EL2', '46-2T','95-2T', 'COC'),


('000002','EL3', '0-1T','91-2T', 'POR'),
('000006','EL3', '0-1T','91-2T', 'TD'),
('000003','EL3', '0-1T','91-2T', 'DC'),
('000004','EL3', '0-1T','91-2T', 'DC'),
('000025','EL3', '0-1T','46-2T', 'TS'),
('000008','EL3', '0-1T','60-2T', 'CC'),
('000019','EL3', '0-1T','60-2T', 'COC'),
('000023','EL3', '0-1T','91-2T', 'CC'),
('000020','EL3', '0-1T','91-2T', 'AD'),
('000011','EL3', '0-1T','91-2T', 'AS'),
('000012','EL3', '0-1T','91-2T', 'ATT'),

('000010','EL3', '60-2T','91-2T', 'COC'),
('000007','EL3', '60-2T','91-2T', 'CDC'),
('000005','EL3', '46-2T','95-2T', 'TS'),


('000001','CI1', '0-1T','30-1T', 'POR'),
('000006','CI1', '0-1T','97-2T', 'TD'),
('000003','CI1', '0-1T','97-2T', 'DC'),
('000004','CI1', '0-1T','97-2T', 'DC'),
('000005','CI1', '0-1T','97-2T', 'TS'),
('000008','CI1', '0-1T','97-2T', 'CC'),
('000019','CI1', '0-1T','60-2T', 'CC'),
('000023','CI1', '0-1T','97-2T', 'CC'),
('000020','CI1', '0-1T','97-2T', 'AD'),
('000011','CI1', '0-1T','97-2T', 'AS'),
('000022','CI1', '0-1T','45-2T', 'ATT'),

('000017','CI1', '60-2T','97-2T', 'CC'),
('000012','CI1', '45-2T','97-2T', 'ATT'),
('000002','CI1', '30-1T','97-2T', 'POR'),

('000002','CI2', '0-1T','104-2S', 'POR'),
('000006','CI2', '0-1T','122-2S', 'TD'),
('000003','CI2', '0-1T','122-2S', 'DC'),
('000014','CI2', '0-1T','122-2S', 'DC'),
('000005','CI2', '0-1T','122-2S', 'TS'),
('000008','CI2', '0-1T','122-2S', 'CC'),
('000007','CI2', '0-1T','60-2S', 'CC'),
('000023','CI2', '0-1T','60-2T', 'CC'),
('000009','CI2', '0-1T','122-2S', 'AD'),
('000011','CI2', '0-1T','122-2S', 'AS'),
('000012','CI2', '0-1T','122-2S', 'ATT'),

('000017','CI2', '60-2T','122-2S', 'CC'),
('000018','CI2', '60-2T','122-2S', 'CC'),
('000001','CI2', '104-2S','122-2S', 'POR' ),
('000019','CI2', '60-2T','122-2S', 'CC'),


('000002','CI3', '0-1T','93-2T', 'POR'),
('000006','CI3', '0-1T','93-2T', 'TD'),
('000003','CI3', '0-1T','93-2T', 'DC'),
('000004','CI3', '0-1T','60-2T', 'DC'),
('000005','CI3', '0-1T','60-2T', 'TS'),
('000008','CI3', '0-1T','93-2T', 'CC'),
('000007','CI3', '0-1T','60-2T', 'CC'),
('000023','CI3', '0-1T','45-2T', 'CC'),
('000019','CI3', '0-1T','60-2T', 'COC'),
('000011','CI3', '0-1T','93-2T', 'ATT'),
('000012','CI3', '0-1T','45-2T', 'ATT'),

('000009','CI3', '60-2T','93-2T', 'AD'),
('000014','CI3', '60-2T','93-2T', 'DC'),
('000022','CI3', '45-2T','93-2T', 'ATT'),
('000017','CI3', '45-2T','93-2T', 'CC');

INSERT INTO partita (giornata, competizione, data, minutigiocati, squadracasa, squadraospite, risultato, posticipata, dataposticipazione, stadio) VALUES
('SA1', 'Serie A', '22082021', '95', 'Napoli', 'Venezia', '2-0', FALSE, NULL,'Diego Armando Maradona'),
('SA2', 'Serie A', '29082021', '97', 'Genoa', 'Napoli', '1-2', FALSE,NULL,'Luigi Ferraris'),
('SA3', 'Serie A', '11092021', '90', 'Napoli', 'Juventus', '2-1', FALSE,NULL,'Diego Armando Maradona'),
('EL1', 'UEFA Europa League', '21102021', '95', 'Legia Varsavia', 'Napoli', '0-1', FALSE,NULL,'Pepsi Arena'),
('EL2', 'UEFA Europa League', '09112021', '97', 'Napoli', 'Leicester', '0-0', FALSE,NULL,'Diego Armando Maradona'),
('EL3', 'UEFA Europa League', '07122021', '91', 'Barcellona', 'Napoli', '3-2', FALSE,NULL,'Camp Nou'),
('CI1', 'Coppa Italia', '30092021', '97', 'Salernitana', 'Napoli', '0-2', FALSE,NULL,'Arechi'),
('CI2', 'Coppa Italia', '30112021', '122', 'Inter', 'Napoli', '0-1', FALSE,NULL,'San Siro'),
('CI3', 'Coppa Italia', '28102021', '93', 'Napoli', 'Roma', '1-2', TRUE,'28032022','Olimpico');

INSERT INTO evento(numeroazione, partita, giocatore, zonainizio, tipoevento, esitotiro, zonafineconduzione, numerodribbling, zonaarrivopassaggio, tipopassaggio) VALUES
('1','SA1','000002','A2', 'Passaggio', NULL,NULL,NULL,'B4','Corto'),
('1','SA1','000007','B4', 'Conduzione palla',NULL,'C4','2',NULL,NULL),
('1','SA1','000007','C4', 'Conduzione palla',NULL,'D4','1',NULL,NULL),
('2','SA1','000005','F', 'Passaggio',NULL,NULL,NULL,'C1','Rimessa'),
('2','SA1','000023','C1', 'Passaggio',NULL,NULL,NULL,'D1','Corto'),
('2','SA1','000011','D1', 'Passaggio',NULL,NULL,NULL,'D2','Corto'),
('3','SA1','000004','B2', 'Passaggio',NULL,NULL,NULL,'B3','Corto'),
('3','SA1','000008','B3', 'Conduzione palla',NULL,'C3','1',NULL,NULL),
('3','SA1','000008','C3', 'Passaggio',NULL,NULL,NULL,'D2','Lungo'),
('3','SA1','000010','D2', 'Passaggio',NULL,NULL,NULL,'E3','Cross'),
('3','SA1','000012','E3', 'Tiro', 'Gol',NULL,NULL,NULL,NULL),
('4','SA1','000002','A3', 'Passaggio',NULL,NULL,NULL,'B4','Lungo'),
('4','SA1','000006','B4', 'Conduzione palla',NULL,'C4','0',NULL,NULL),
('4','SA1','000006','C4', 'Passaggio',NULL,NULL,NULL,'D4','Corto'),
('5','SA1','000011','D4', 'Passaggio',NULL,NULL,NULL,'E4','Corto'),
('5','SA1','000020','E4', 'Conduzione palla',NULL,'E3','1',NULL,NULL),
('5','SA1','000020','E3', 'Passaggio',NULL,NULL,NULL,'D2','Lungo'),
('5','SA1','000011','D2', 'Tiro','Gol',NULL,NULL,NULL,NULL),

('1','SA2','000012','C2', 'Passaggio',NULL,NULL,NULL,'C3','Corto'),
('1','SA2','000020','C3', 'Conduzione palla',NULL,'D3','2',NULL,NULL),
('1','SA2','000020','D3', 'Passaggio',NULL,NULL,NULL,'D3','Corto'),
('1','SA2','000019','D3', 'Conduzione palla',NULL,'E3','2',NULL,NULL),
('1','SA2','000019','E3', 'Tiro','Gol',NULL,NULL,NULL,NULL),
('2','SA2','000001','A2', 'Passaggio',NULL,NULL,NULL,'A2','Corto'),
('2','SA2','000004','A2', 'Passaggio',NULL,NULL,NULL,'C3','Cross'),
('2','SA2','000007','C3', 'Conduzione palla',NULL,'C2','0',NULL,NULL),
('3','SA2','000001','A2', 'Passaggio',NULL,NULL,NULL,'B1','Lungo'),
('3','SA2','000005','B1', 'Passaggio',NULL,NULL,NULL,'B2','Corto'),
('3','SA2','000004','B2', 'Passaggio',NULL,NULL,NULL,NULL,'Corto'),
('4','SA2','000005','F', 'Passaggio',NULL,NULL,NULL,'C1','Rimessa'),
('4','SA2','000011','C1', 'Conduzione palla',NULL,'D1','1',NULL,NULL),
('4','SA2','000011','D1', 'Conduzione palla',NULL,'E1','1',NULL,NULL),
('4','SA2','000011','E1', 'Passaggio',NULL,NULL,NULL,'E2','Corto'),
('4','SA2','000012','E2', 'Tiro','Parata',NULL,NULL,NULL,NULL),
('5','SA2','000001','A3', 'Passaggio',NULL,NULL,NULL,'B3','Corto'),
('5','SA2','000003','B3', 'Passaggio',NULL,NULL,NULL,'D3','Cross'),
('5','SA2','000010','D3', 'Tiro','Gol',NULL,NULL,NULL,NULL),

('1','SA3','000006','F', 'Passaggio',NULL,NULL,NULL,'C4','Rimessa'),
('1','SA3','000009','C4', 'Conduzione palla',NULL,'D4','0',NULL,NULL),
('1','SA3','000009','D4', 'Conduzione palla',NULL,'D3','2',NULL,NULL),
('1','SA3','000009','D3', 'Tiro','Fuori',NULL,NULL,NULL,NULL),
('2','SA3','000002','A2', 'Passaggio',NULL,NULL,NULL,'C3','Cross'),
('2','SA3','000007','C3', 'Passaggio',NULL,NULL,NULL,'D2','Cross'),
('2','SA3','000019','D2', 'Passaggio',NULL,NULL,NULL,'C2','Corto'),
('2','SA3','000008','C2', 'Passaggio',NULL,NULL,NULL,'C1','Corto'),
('2','SA3','000005','C1', 'Passaggio',NULL,NULL,NULL,'D1','Corto'),
('3','SA3','000011','D1', 'Passaggio',NULL,NULL,NULL,'C2','Lungo'),
('3','SA3','000023','C2', 'Conduzione palla',NULL,'D3','0',NULL,NULL),
('3','SA3','000023','D3', 'Passaggio',NULL,NULL,NULL,'E4','Cross'),
('4','SA3','000011','F', 'Passaggio',NULL,NULL,NULL,'E2','Angolo'),
('4','SA3','000004','E2', 'Tiro','Gol',NULL,NULL,NULL,NULL),
('5','SA3','000019','F', 'Passaggio',NULL,NULL,NULL,'E1','Angolo'),
('5','SA3','000011','E1', 'Conduzione palla',NULL,'E2','2',NULL,NULL),
('5','SA3','000011','E2', 'Tiro','Gol',NULL,NULL,NULL,NULL),

('1','EL1','000002','A2', 'Passaggio',NULL,NULL,NULL,'C1','Cross'),
('1','EL1','000017','C1', 'Conduzione palla',NULL,'D1','0',NULL,NULL),
('1','EL1','000017','D1', 'Passaggio',NULL,NULL,NULL,'D3','Cross'),
('1','EL1','000012','D3', 'Conduzione palla',NULL,'E3','1',NULL,NULL),
('1','EL1','000012','E3', 'Tiro','Parata',NULL,NULL,NULL,NULL),
('2','EL1','000006','F', 'Passaggio',NULL,NULL,NULL,'B4','Rimessa'),
('2','EL1','000008','B4', 'Conduzione palla',NULL,'C4','0',NULL,NULL),
('2','EL1','000008','C4', 'Passaggio',NULL,NULL,NULL,'C3','Corto'),
('2','EL1','000017','C3', 'Passaggio',NULL,NULL,NULL,'F','Cross'),
('3','EL1','000002','A2', 'Passaggio',NULL,NULL,NULL,'C4','Cross'),
('3','EL1','000006','C4', 'Passaggio',NULL,NULL,NULL,'C3','Corto'),
('3','EL1','000007','C3', 'Passaggio',NULL,NULL,NULL,'E1','Cross'),
('4','EL1','000019','F', 'Passaggio',NULL,NULL,NULL,'D1','Angolo'),
('4','EL1','000017','D1', 'Passaggio',NULL,NULL,NULL,'E2','Corto'),
('4','EL1','000011','E2', 'Tiro','Parata',NULL,NULL,NULL,NULL),
('5','EL1','000011','F', 'Passaggio',NULL,NULL,NULL,'E3','Angolo'),
('5','EL1','000012','E3', 'Tiro','Gol',NULL,NULL,NULL,NULL),

('1','EL2','000019','F', 'Passaggio',NULL,NULL,NULL,'E4','Angolo'),
('1','EL2','000009','E4', 'Conduzione palla',NULL,'E3','2',NULL,NULL),
('1','EL2','000009','E3', 'Tiro','Parata',NULL,NULL,NULL,NULL),
('2','EL2','000011','F', 'Passaggio',NULL,NULL,NULL,'D3','Angolo'),
('2','EL2','000019','D3', 'Tiro','Fuori',NULL,NULL,NULL,NULL),
('3','EL2','000019','C3', 'Passaggio',NULL,NULL,NULL,'D2','Lungo'),
('3','EL2','000023','D2', 'Passaggio',NULL,NULL,NULL,'D2','Corto'),
('3','EL2','000011','D2', 'Passaggio',NULL,NULL,NULL,'E2','Corto'),
('3','EL2','000012','E2', 'Tiro','Fuori',NULL,NULL,NULL,NULL),
('4','EL2','000002','A2', 'Passaggio',NULL,NULL,NULL,'D1','Cross'),
('4','EL2','000011','D1', 'Conduzione palla',NULL,'D2','2',NULL,NULL),
('4','EL2','000011','D2', 'Passaggio',NULL,NULL,NULL,'E2','Corto'),
('4','EL2','000010','E2', 'Tiro','Fuori',NULL,NULL,NULL,NULL),
('5','EL2','000006','F', 'Passaggio',NULL,NULL,NULL,'D4','Rimessa'),
('5','EL2','000009','D4', 'Conduzione palla',NULL,'E4','0',NULL,NULL),
('5','EL2','000009','E4', 'Conduzione palla',NULL,'E3','2',NULL,NULL),
('5','EL2','000009','E3', 'Tiro','Parata',NULL,NULL,NULL,NULL),

('1','EL3','000002','A2', 'Passaggio',NULL,NULL,NULL,'B1','Lungo'),
('1','EL3','000005','B1', 'Passaggio',NULL,NULL,NULL,'B2','Corto'),
('1','EL3','000004','B2', 'Passaggio',NULL,NULL,NULL,'D3','Cross'),
('2','EL3','000006','F', 'Passaggio',NULL,NULL,NULL,'B4','Rimessa'),
('2','EL3','000008','B4', 'Conduzione palla',NULL,'B3','0',NULL,NULL),
('2','EL3','000008','B3', 'Passaggio',NULL,NULL,NULL,NULL,'Corto'),
('3','EL3','000019','C1', 'Passaggio',NULL,NULL,NULL,'C2','Corto'),
('3','EL3','000023','C2', 'Conduzione palla',NULL,'D2','1',NULL,NULL),
('3','EL3','000023','D2', 'Passaggio',NULL,NULL,NULL,'E2','Corto'),
('3','EL3','000011','E2', 'Conduzione palla',NULL,NULL,'1',NULL,NULL),
('4','EL3','000011','D4', 'Passaggio',NULL,NULL,NULL,'E4','Corto'),
('4','EL3','000020','E4', 'Conduzione palla',NULL,'E3','1',NULL,NULL),
('4','EL3','000020','E3', 'Passaggio',NULL,NULL,NULL,'D2','Lungo'),
('4','EL3','000012','D2', 'Tiro','Gol',NULL,NULL,NULL,NULL),
('5','EL3','000002','A3', 'Passaggio',NULL,NULL,NULL,'B3','Corto'),
('5','EL3','000003','B3', 'Passaggio',NULL,NULL,NULL,'D3','Cross'),
('5','EL3','000010','D3', 'Passaggio',NULL,NULL,NULL,'E3','Corto'),
('5','EL3','000012','E3', 'Tiro','Gol',NULL,NULL,NULL,NULL),


('1','CI1','000012','C2', 'Passaggio',NULL,NULL,NULL,'C3','Corto'),
('1','CI1','000020','C3', 'Conduzione palla',NULL,'D3','2',NULL,NULL),
('1','CI1','000020','D3', 'Passaggio',NULL,NULL,NULL,'D3','Corto'),
('1','CI1','000019','D3', 'Tiro','Gol',NULL,NULL,NULL,NULL),
('2','CI1','000005','F', 'Passaggio',NULL,NULL,NULL,'C1','Rimessa'),
('2','CI1','000011','C1', 'Conduzione palla',NULL,'D1','1',NULL,NULL),
('2','CI1','000011','D1', 'Conduzione palla',NULL,'E1','1',NULL,NULL),
('2','CI1','000011','E1', 'Passaggio',NULL,NULL,NULL,'D2','Corto'),
('2','CI1','000012','D2', 'Tiro','Parata',NULL,NULL,NULL,NULL),
('3','CI1','000019','F', 'Passaggio',NULL,NULL,NULL,'E1','Angolo'),
('3','CI1','000017','E1', 'Passaggio',NULL,NULL,NULL,'E2','Corto'),
('3','CI1','000011','E2', 'Tiro','Parata',NULL,NULL,NULL,NULL),
('4','CI1','000002','A2', 'Passaggio',NULL,NULL,NULL,'B1','Lungo'),
('4','CI1','000005','B1', 'Passaggio',NULL,NULL,NULL,'B2','Corto'),
('4','CI1','000004','B2', 'Passaggio',NULL,NULL,NULL,'D3','Cross'),
('4','CI1','000012','D3', 'Tiro','Fuori',NULL,NULL,NULL,NULL),
('5','CI1','000011','F', 'Passaggio',NULL,NULL,NULL,'E2','Angolo'),
('5','CI1','000012','E2', 'Tiro','Gol',NULL,NULL,NULL,NULL),

('1','CI2','000002','A2', 'Passaggio',NULL,NULL,NULL,'B1','Lungo'),
('1','CI2','000005','B1', 'Passaggio',NULL,NULL,NULL,'C4','Cross'),
('1','CI2','000007','C4', 'Conduzione palla',NULL,'D4','1',NULL,NULL),
('1','CI2','000007','D4', 'Passaggio',NULL,NULL,NULL,NULL,'Corto'),
('2','CI2','000005','F', 'Passaggio',NULL,NULL,NULL,'C1','Rimessa'),
('2','CI2','000023','C1', 'Passaggio',NULL,NULL,NULL,'D1','Corto'),
('2','CI2','000011','D1', 'Passaggio',NULL,NULL,NULL,'E2','Cross'),
('3','CI2','000011','F', 'Passaggio',NULL,NULL,NULL,'E2','Angolo'),
('3','CI2','000012','E2', 'Tiro','Gol',NULL,NULL,NULL,NULL),
('4','CI2','000002','B2', 'Passaggio',NULL,NULL,NULL,'C3','Lungo'),
('4','CI2','000007','C3', 'Passaggio',NULL,NULL,NULL,'D1','Cross'),
('4','CI2','000019','D1', 'Passaggio',NULL,NULL,NULL,'E1','Corto'),
('4','CI2','000011','E1', 'Passaggio',NULL,NULL,NULL,'D1','Corto'),
('4','CI2','000005','D1', 'Passaggio',NULL,NULL,NULL,'D1','Corto'),
('4','CI2','000011','D1', 'Conduzione palla',NULL,'E1','0',NULL,NULL),
('5','CI2','000006','B4', 'Passaggio',NULL,NULL,NULL,'B3','Corto'),
('5','CI2','000009','B3', 'Conduzione palla',NULL,'C3','0',NULL,NULL),
('5','CI2','000009','C3', 'Passaggio',NULL,NULL,NULL,'D2','Corto'),
('5','CI2','000017','D2', 'Passaggio',NULL,NULL,NULL,'F','Cross'),

('1','CI3','000005','F', 'Passaggio',NULL,NULL,NULL,'D1','Rimessa'),
('1','CI3','000011','D1', 'Conduzione palla',NULL,'E1','0',NULL,NULL),
('1','CI3','000011','E1', 'Conduzione palla',NULL,'E2','2',NULL,NULL),
('1','CI3','000011','E2', 'Passaggio',NULL,NULL,NULL,'E3','Corto'),
('1','CI3','000012','E3', 'Tiro','Gol',NULL,NULL,NULL,NULL),
('2','CI3','000019','F', 'Passaggio',NULL,NULL,NULL,'E2','Angolo'),
('2','CI3','000017','E2', 'Passaggio',NULL,NULL,NULL,'D2','Corto'),
('2','CI3','000023','E2', 'Tiro','Fuori',NULL,NULL,NULL,NULL),
('3','CI3','000002','A2', 'Passaggio',NULL,NULL,NULL,'C3','Cross'),
('3','CI3','000007','C3', 'Passaggio',NULL,NULL,NULL,'D2','Cross'),
('3','CI3','000003','D2', 'Passaggio',NULL,NULL,NULL,'C2','Corto'),
('3','CI3','000008','C2', 'Passaggio',NULL,NULL,NULL,'C1','Corto'),
('3','CI3','000005','C1', 'Passaggio',NULL,NULL,NULL,'C2','Corto'),
('4','CI3','000002','A3', 'Passaggio',NULL,NULL,NULL,'B4','Lungo'),
('4','CI3','000006','B4', 'Passaggio',NULL,NULL,NULL,'C3','Corto'),
('4','CI3','000023','C3', 'Conduzione palla',NULL,'D3','1',NULL,NULL),
('4','CI3','000023','D3', 'Passaggio',NULL,NULL,NULL,NULL,'Corto'),
('5','CI3','000011','F', 'Passaggio',NULL,NULL,NULL,'E3','Angolo'),
('5','CI3','000003','E3', 'Tiro','Parata',NULL,NULL,NULL,NULL);

INSERT INTO azione(numeroazione, partita, tipoazione, zona, tipofermata, gol, giocatorefermata) VALUES
('1','SA1','Fermata','D4','Intervento avversario',FALSE,'000007'),
('2','SA1','Fermata','D2','Fuorigioco',FALSE,'000012'),
('3','SA1','Conclusa',NULL,NULL,TRUE,NULL),
('4','SA1','Fermata','D4','Fallo avversario',FALSE,'000020'),
('5','SA1','Conclusa',NULL,NULL,TRUE,NULL),

('1','SA2','Conclusa',NULL,NULL,TRUE,NULL),
('2','SA2','Fermata','C2','Fallo avversario',FALSE,'000008'),
('3','SA2','Fermata','B2','Intervento avversario',FALSE,'000004'),
('4','SA2','Conclusa',NULL,NULL,FALSE,NULL),
('5','SA2','Conclusa',NULL,NULL,TRUE,NULL),

('1','SA3','Conclusa',NULL,NULL,FALSE,NULL),
('2','SA3','Fermata','D1','Fallo avversario',FALSE,'000011'),
('3','SA3','Fermata','E4','Fuorigioco',FALSE,'000020'),
('4','SA3','Conclusa',NULL,NULL,TRUE,NULL),
('5','SA3','Conclusa',NULL,NULL,TRUE,NULL),

('1','EL1','Conclusa',NULL,NULL,FALSE,NULL),
('2','EL1','Fermata','C3','Errore tecnico',FALSE,'000017'),
('3','EL1','Fermata','E1','Fuorigioco',FALSE,'000011'),
('4','EL1','Conclusa',NULL,NULL,FALSE,NULL),
('5','EL1','Conclusa',NULL,NULL,TRUE,NULL),

('1','EL2','Conclusa',NULL,NULL,FALSE,NULL),
('2','EL2','Conclusa',NULL,NULL,FALSE,NULL),
('3','EL2','Conclusa',NULL,NULL,FALSE,NULL),
('4','EL2','Conclusa',NULL,NULL,FALSE,NULL),
('5','EL2','Conclusa',NULL,NULL,FALSE,NULL),

('1','EL3','Fermata','D3','Fuorigioco',FALSE,'000020'),
('2','EL3','Fermata','B3','Intervento avversario',FALSE,'000008'),
('3','EL3','Fermata','E2','Intervento avversario',FALSE,'000011'),
('4','EL3','Conclusa',NULL,NULL,TRUE,NULL),
('5','EL3','Conclusa',NULL,NULL,TRUE,NULL),

('1','CI1','Conclusa',NULL,NULL,TRUE,NULL),
('2','CI1','Conclusa',NULL,NULL,FALSE,NULL),
('3','CI1','Conclusa',NULL,NULL,FALSE,NULL),
('4','CI1','Conclusa',NULL,NULL,FALSE,NULL),
('5','CI1','Conclusa',NULL,NULL,TRUE,NULL),

('1','CI2','Fermata','D4','Intervento avversario',FALSE,'000007'),
('2','CI2','Fermata','E2','Fuorigioco',FALSE,'000012'),
('3','CI2','Conclusa',NULL,NULL,TRUE,NULL),
('4','CI2','Fermata','E1','Fallo avversario',FALSE,'000011'),
('5','CI2','Fermata','D2','Errore tecnico',FALSE,'000017'),

('1','CI3','Conclusa',NULL,NULL,TRUE,NULL),
('2','CI3','Conclusa',NULL,NULL,FALSE,NULL),
('3','CI3','Fermata','C2','Fallo avversario',FALSE,'000008'),
('4','CI3','Fermata','D3','Intervento avversario',FALSE,'000023'),
('5','CI3','Conclusa',NULL,NULL,FALSE,NULL);
commit;