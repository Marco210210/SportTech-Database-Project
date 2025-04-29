1)
select cognome, count(distinct numeroevento) as Numeropassaggi
from Evento e 
	join azione az on(e.numeroazione = az.numeroazione) 
		and az.tipoazione = 'Conclusa' and e.tipoevento = 'Passaggio'
	join giocatore g1  on(g1.numerotesserino = e.giocatore)
group by g1.cognome
having count(distinct numeroevento)>10


2)
select passaggi_ricevuti.zona,numero_passaggi_ricevuti,numero_passaggi_effettuati
from (select zonaarrivopassaggio as zona, count(*) as numero_passaggi_ricevuti
from evento
where tipoevento='Passaggio' and (zonaarrivopassaggio <> 'F' or zonaarrivopassaggio is not null)
group by zonaarrivopassaggio
order by numero_passaggi_ricevuti  desc) as passaggi_ricevuti
join (select zonainizio as zona, count(*) as numero_passaggi_effettuati
from evento
where tipoevento='Passaggio'  and zonainizio <> 'F'
group by zonainizio
order by numero_passaggi_effettuati  desc) as passaggi_effettuati on passaggi_ricevuti.zona =passaggi_effettuati.zona
order by passaggi_ricevuti.zona

3)
select *
from azione
where gol = true and partita in (
	select giornata 
	from partita 
	where giornata like 'SA%'
)

select *
from azione
where gol = true and partita in (
	select giornata 
	from partita 
	where giornata like 'EL%'
)

select *
from azione
where gol = true and partita in (
	select giornata 
	from partita 
	where giornata like 'CL%'
)

select *
from azione
where gol = true and partita in (
	select giornata 
	from partita 
	where giornata like 'CI%'
)
order by partita

4)
select cognome,sum(numerodribling) as driblingtot
from evento join giocatore on evento.giocatore = giocatore.numerotesserino
where tipoevento = 'Conduzione palla' and numerodribling > 0
group by cognome
order by driblingtot desc

5)
select verticalizzazioni.giornata,numero_verticalizzazioni,numero_passaggi_verso_esterno
from(select giornata,count(*) as numero_verticalizzazioni
from partita join evento on partita.giornata = evento.partita
where tipoevento = 'Passaggio' and (zonaarrivopassaggio = 'E2' or zonaarrivopassaggio ='E3' or zonaarrivopassaggio = 'D2' or zonaarrivopassaggio ='D3') and zonainizio <>'F'
group by giornata) as verticalizzazioni
join
(select giornata,count(*) as numero_passaggi_verso_esterno
from partita join evento on partita.giornata = evento.partita
where tipoevento = 'Passaggio' and (zonaarrivopassaggio like '%1' or zonaarrivopassaggio like '%4') and zonainizio <>'F'
group by giornata) as esterno on verticalizzazioni.giornata = esterno.giornata
order by giornata asc

6)
select cognome,evento.*
from evento join giocatore on evento.giocatore = giocatore.numerotesserino
where evento.numeroazione = numeroazione and evento.partita = partita