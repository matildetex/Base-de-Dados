IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ContarBebidas') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION dbo.ContarBebidas;
GO

CREATE FUNCTION dbo.ContarBebidas ()
RETURNS INT
AS
BEGIN
    DECLARE @countProdutosBebidas INT;

    SELECT @countProdutosBebidas = COUNT(*)
    FROM GestaoNucleos.Produtos
    WHERE tipo LIKE '%Bebida%';

    RETURN @countProdutosBebidas;
END;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ContarAlimentacao') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION dbo.ContarAlimentacao;
GO

CREATE FUNCTION dbo.ContarAlimentacao ()
RETURNS INT
AS
BEGIN
    DECLARE @countProdutosAlimentacao INT;

    SELECT @countProdutosAlimentacao = COUNT(*)
    FROM GestaoNucleos.Produtos
    WHERE tipo LIKE '%Alimentação%';

    RETURN @countProdutosAlimentacao;
END;
GO
