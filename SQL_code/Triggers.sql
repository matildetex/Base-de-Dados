--Trigger para garantir que nenhum trabalhador, trabalha mais de 40 horas

CREATE TRIGGER Trg_ControlarHorarioTrabalhadores
ON GestaoNucleos.Trabalhadores
FOR INSERT
AS
BEGIN
    DECLARE @n_CC varchar(64), @n_horas float;

    SELECT @n_CC = n_CC, @n_horas = n_horas
    FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM GestaoNucleos.Trabalhadores
        WHERE n_CC = @n_CC AND n_horas + @n_horas > 40
    )
    BEGIN
        RAISERROR ('O trabalhador atingiu o limite de 40 horas de trabalho.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE GestaoNucleos.Trabalhadores
    SET n_horas = n_horas + @n_horas
    WHERE n_CC = @n_CC;
END;

--Trigger para garantir que o numero de CC da Pessoa tem 8 digitos

CREATE TRIGGER Trg_Pessoa_Insert_Update
ON GestaoNucleos.Pessoa
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(n_CC) <> 8)
    BEGIN
        RAISERROR ('O número de dígitos em n_CC deve ser igual a 8.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;
