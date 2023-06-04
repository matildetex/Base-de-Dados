-- Nome, numero, local, data, codigo_event_monet, lucro, numero de trabalhadores e numero de participantes
CREATE VIEW INFO_EVENTO AS
	SELECT GestaoNucleos.Eventos.numero, nome, local, data, codigo_ev_mon, lucro
	FROM GestaoNucleos.Eventos JOIN GestaoNucleos.EventosMonetarios ON GestaoNucleos.Eventos.numero=GestaoNucleos.EventosMonetarios.numero;