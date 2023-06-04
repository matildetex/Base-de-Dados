-- Eventos com determinado número
DROP INDEX IF EXISTS num_event ON GestaoNucleos.Eventos;
CREATE INDEX num_event ON GestaoNucleos.Eventos(numero);

-- Eventos com determinado nome
DROP INDEX IF EXISTS nome_event ON GestaoNucleos.Eventos;
CREATE INDEX nome_event ON GestaoNucleos.Eventos(nome);

-- Trabalhadores que trabalham para determinado evento
-- (já existe) CREATE INDEX num_event ON GestaoNucleos.Eventos(numero);
DROP INDEX IF EXISTS event_traba ON GestaoNucleos.Event_tem_Trab;
CREATE INDEX event_traba ON GestaoNucleos.Event_tem_Trab(n_CC);

-- Os produtos associados a determinado código de Evento Monetário
-- (já existe) CREATE INDEX num_event ON GestaoNucleos.Eventos(numero);
DROP INDEX IF EXISTS cod_event ON GestaoNucleos.EventMonet_tem_Produtos;
DROP INDEX IF EXISTS cod_produto ON GestaoNucleos.Produtos;
CREATE INDEX cod_event ON GestaoNucleos.EventMonet_tem_Produtos(codigo);
CREATE INDEX cod_produto ON GestaoNucleos.Produtos(codigo);