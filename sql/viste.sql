drop view if exists golstagione;
create view golstagione as
select cognome,count(distinct numeroevento) as gol
from evento join giocatore on evento.giocatore = giocatore.numerotesserino
where evento.esitotiro = 'Gol'
group by cognome
order by gol desc;

drop view if exists golCL;
create view golCL as
select cognome,competizione,count(distinct numeroevento) as gol
from evento join partita on evento.partita = partita.giornata and evento.esitotiro = 'Gol' and partita.competizione = 'UEFA Champions League'
join giocatore on evento.giocatore = giocatore.numerotesserino
group by cognome,competizione;

drop view if exists golEL;
create view golEL as
select cognome,competizione,count(distinct numeroevento) as gol
from evento join partita on evento.partita = partita.giornata and evento.esitotiro = 'Gol' and partita.competizione = 'UEFA Europa League'
join giocatore on evento.giocatore = giocatore.numerotesserino
group by cognome,competizione;

drop view if exists golcoppaitalia;
create view golcoppaitalia as
select cognome,competizione,count(distinct numeroevento) as gol
from evento join partita on evento.partita = partita.giornata and evento.esitotiro = 'Gol' and partita.competizione = 'Coppa Italia'
join giocatore on evento.giocatore = giocatore.numerotesserino
group by cognome,competizione;


drop view if exists golseriea;
create view golseriea as
select cognome,competizione,count(distinct numeroevento) as gol
from evento join partita on evento.partita = partita.giornata and evento.esitotiro = 'Gol' and partita.competizione = 'Serie A'
join giocatore on evento.giocatore = giocatore.numerotesserino
group by cognome,competizione;

