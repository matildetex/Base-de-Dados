use p10g5;

DROP SCHEMA IF EXISTS [GestaoNucleos]
GO

DROP TABLE IF EXISTS GestaoNucleos.Membro
DROP TABLE IF EXISTS GestaoNucleos.RF_paga_Externo
DROP TABLE IF EXISTS GestaoNucleos.Externo
DROP TABLE IF EXISTS GestaoNucleos.Trabalhadores
DROP TABLE IF EXISTS GestaoNucleos.Sponsor
DROP TABLE IF EXISTS GestaoNucleos.Event_tem_Trab
DROP TABLE IF EXISTS GestaoNucleos.ResponsavelFinanceiro
DROP TABLE IF EXISTS GestaoNucleos.Pessoa
DROP TABLE IF EXISTS GestaoNucleos.EventMonet_tem_Produtos
DROP TABLE IF EXISTS GestaoNucleos.Produtos
DROP TABLE IF EXISTS GestaoNucleos.EventosNaoMonetarios
DROP TABLE IF EXISTS GestaoNucleos.Pulseiras
DROP TABLE IF EXISTS GestaoNucleos.EventosMonetarios
DROP TABLE IF EXISTS GestaoNucleos.Eventos

CREATE TABLE GestaoNucleos.Eventos
(
    [numero]          int          NOT NULL,
    [nome]            varchar(128) NOT NULL,
    [local]           varchar(64)  NOT NULL,
    [tipo]            varchar(64),
    [n_participantes] int          NOT NULL,
    [n_trabalhadores] int          NOT NULL,
    [area]            varchar(64)  NOT NULL,
    [data]            datetime     NOT NULL,
    PRIMARY KEY (numero)
);

CREATE TABLE GestaoNucleos.EventosMonetarios
(
    [numero]        int         NOT NULL,
    [codigo_ev_mon] varchar(64) NOT NULL,
    [lucro]         float       NOT NULL,
    PRIMARY KEY (numero),
    FOREIGN KEY (numero) REFERENCES GestaoNucleos.Eventos (numero)
);

CREATE TABLE GestaoNucleos.Pulseiras
(
    [id]            int NOT NULL,
    [evento_numero] int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (evento_numero) REFERENCES GestaoNucleos.EventosMonetarios (numero)
);

CREATE TABLE GestaoNucleos.EventosNaoMonetarios
(
    [numero]     int         NOT NULL,
    [Sponsor_CC] varchar(64) NOT NULL
    PRIMARY KEY (numero),
    FOREIGN KEY (numero) REFERENCES GestaoNucleos.Eventos (numero)
);

CREATE TABLE GestaoNucleos.Produtos
(
    [codigo]        int         NOT NULL,
    [nome]          varchar(128),
    [tipo]          varchar(32) NOT NULL,
    [preco_compra]  float       NOT NULL,
    [preco_venda]   float       NOT NULL,
    [quantidade]    int         NOT NULL,
    [data_validade] datetime,
    PRIMARY KEY (codigo),
);

CREATE TABLE GestaoNucleos.EventMonet_tem_Produtos
(
    [numero]             int         NOT NULL,
    [codigo]             int         NOT NULL,
    [n_CC]               varchar(64) NOT NULL,
    [dinheiro_investido] float       NOT NULL,
    PRIMARY KEY (numero),
    FOREIGN KEY (numero) REFERENCES GestaoNucleos.Eventos (numero),
    FOREIGN KEY (codigo) REFERENCES GestaoNucleos.Produtos (codigo),
);

CREATE TABLE GestaoNucleos.Pessoa
(
    [n_CC]      varchar(64)  NOT NULL,
    [nome]      varchar(128) NOT NULL,
    [morada]    varchar(256),
    [telemovel] int          NOT NULL,
    [email]     varchar(128),
    PRIMARY KEY (n_CC),
);

CREATE TABLE GestaoNucleos.ResponsavelFinanceiro
(
    [n_CC]     varchar(64) NOT NULL,
    [id]       int         NOT NULL,
    [data_in]  datetime    NOT NULL,
    [data_out] datetime,
    PRIMARY KEY (n_CC),
    FOREIGN KEY (n_CC) REFERENCES GestaoNucleos.Pessoa (n_CC)
);

CREATE TABLE GestaoNucleos.Event_tem_Trab
(
    [evento_numero] int         NOT NULL,
    [n_CC]          varchar(64) NOT NULL,
    PRIMARY KEY (evento_numero, n_CC),
    FOREIGN KEY (evento_numero) REFERENCES GestaoNucleos.Eventos (numero),
    FOREIGN KEY (n_CC) REFERENCES GestaoNucleos.Pessoa (n_CC)
);

CREATE TABLE GestaoNucleos.Sponsor
(
    [n_CC] varchar(64) NOT NULL,
    [type] varchar(64) NOT NULL,
    PRIMARY KEY (n_CC)
);

CREATE TABLE GestaoNucleos.Trabalhadores
(
    [n_CC]    varchar(64) NOT NULL,
    [n_horas] float       NOT NULL,
    PRIMARY KEY (n_CC, n_horas),
    FOREIGN KEY (n_CC) REFERENCES GestaoNucleos.Pessoa (n_CC)
);

CREATE TABLE GestaoNucleos.Externo
(
    [n_CC]         varchar(64) NOT NULL,
    [salario_hora] float       NOT NULL,
    [id_RF]        int         NOT NULL,
    PRIMARY KEY (n_CC),
    FOREIGN KEY (n_CC) REFERENCES GestaoNucleos.Pessoa (n_CC),
);

CREATE TABLE GestaoNucleos.RF_paga_Externo
(
    [n_CC_externo] varchar(64) NOT NULL,
    [n_CC_RF] varchar(64) NOT NULL,
    PRIMARY KEY (n_CC_externo, n_CC_RF),
    FOREIGN KEY (n_CC_externo) REFERENCES GestaoNucleos.Externo (n_CC),
    FOREIGN KEY (n_CC_RF) REFERENCES GestaoNucleos.ResponsavelFinanceiro (n_CC)
);

CREATE TABLE GestaoNucleos.Membro
(
    [n_CC]            varchar(64) NOT NULL,
    [n_mecanografico] int         NOT NULL,
    FOREIGN KEY (n_CC) REFERENCES GestaoNucleos.Pessoa (n_CC)
);

ALTER TABLE GestaoNucleos.EventMonet_tem_Produtos
ADD FOREIGN KEY (n_CC)         REFERENCES           GestaoNucleos.ResponsavelFinanceiro(n_CC);

ALTER TABLE GestaoNucleos.EventosNaoMonetarios
ADD FOREIGN KEY (Sponsor_CC)         REFERENCES           GestaoNucleos.Sponsor(n_CC);