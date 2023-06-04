# Base-de-Dados
Projeto Final de Base de Dados (2º ano, 2º Semestre)- Sistema de Gestão de Núcleos<br />
---
To Do:<br />
---
-Normalização no relatório<br />
-Adicionar Triggers no ficheiro Triggers<br />
-ORGANIZAR README<br />

## Index
Eventos com determinado número<br />
Eventos com determinado nome<br />
Trabalhadores que trabalham para determinado evento<br />
Os produtos associados a determinado Evento Monetário<br />

## Views
Nome, numero, local, data, codigo_event_monet, lucro, numero de trabalhadores e numero de participantes<br />

## Procedures<br />
- Adicionar Evento Monetário<br />
- Adicionar Evento Não Monetário<br />
- Ver Relatório Geral<br />
- Verificar Pagamento<br />
- Adicionar Trabalhador<br />
- Eliminar trabalhador<br />
- Ver detalhes trabalhador<br />
- Editar Trabalhador (Editar Detalhes)<br />
- Ver externos<br />
- Ver pulseira por evento<br />
- Ver Produtos em stock (comida)<br />
- Ver Produtos em stock (bebida)<br />
- Ver membros [em progresso]<br />
- Ver Lucro Total (dinheiro entra, sai e final)<br />
- Pulseiras adicionar número random [ver se funfa]<br />
- Adicionar Produto (Bebida ou Comida) [ver se funfa]<br />


## Triggers<br />
- CC (8 digitos)<br />
- 40 horas do trabalhador<br /><br />

[NAO CONSIGO ELEMINAR O 2]<br />

## UDFS<br />
- ContarAlimentacao<br />
- ContarBebidas<br />
- HorasTrabalhadores (?)<br /><br />


## NOT FOUND:<br />
- GetPulseiraDetails (SP)<br />
- SearchTrabalhadorInfo (SP)<br /><br />

## Interface<br />
-> login<br />
-> acesso à base de dados -> RF pode realizar X operações e membro do núcleo pode realizar Y operações<br /><br />
Operações RF:<br />
-> Ver eventos<br />
-> Inserir trabalhadores<br />
-> Ver evento (incluindo lucro)<br />
-> 
