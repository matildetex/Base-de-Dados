USE [p10g5]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- adicionar comida e bebida
CREATE PROCEDURE [dbo].[AddComidaEBebida]
    @codigo INT,
    @nome VARCHAR(128),
    @tipo VARCHAR(32),
    @preco_compra FLOAT,
    @preco_venda FLOAT,
    @quantidade INT,
    @data_validade DATETIME
AS
BEGIN
    BEGIN TRY
        -- Verificar se o código existe na tabela GestaoNucleos.Produtos
        IF NOT EXISTS (SELECT 1 FROM GestaoNucleos.Produtos WHERE codigo = @codigo)
        BEGIN
            IF (CHARINDEX('Bebida', @tipo) > 0 OR CHARINDEX('Alimentacao', @tipo) > 0)
            BEGIN
                INSERT INTO GestaoNucleos.Produtos (codigo, nome, tipo, preco_compra, preco_venda, quantidade, data_validade)
                VALUES (@codigo, @nome, @tipo, @preco_compra, @preco_venda, @quantidade, @data_validade);
            END
            ELSE
            BEGIN
               PRINT 'Tipo Não existente, inserir tipo BEBIDA ou ALIMENTAÇÃO';
            END
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(MAX);
        SET @ErrorMessage = ERROR_MESSAGE();
        PRINT @ErrorMessage;
    END CATCH;

    -- Imprimir a mensagem após o bloco CATCH
    IF @@ERROR = 0
    BEGIN
        DECLARE @SuccessMessage NVARCHAR(MAX);
        SET @SuccessMessage = 'Ação concluída com sucesso.';
        PRINT @SuccessMessage;
    END
END;

-- adicionar evento monetario
CREATE PROCEDURE [dbo].[AddEventoMonetario] 
  @numero int, 
  @nome varchar(128), 
  @local varchar(64), 
  @tipo varchar(64), 
  @n_participantes int, 
  @n_trabalhadores int, 
  @area varchar(64), 
  @data datetime, 
  @lucro decimal(18, 2) 
AS
BEGIN
  BEGIN TRY
    DECLARE  @codigo_ev_mon varchar(64);
    DECLARE @random_number float;
    
    -- Inserir na tabela GestaoNucleos.Eventos
    INSERT INTO GestaoNucleos.Eventos(numero, nome, local, tipo, n_participantes, n_trabalhadores, area, data)
    VALUES (@numero, @nome, @local, @tipo, @n_participantes, @n_trabalhadores, @area, @data);
    
    -- Verificar se o número de evento existe na tabela GestaoNucleos.Eventos
    IF EXISTS (SELECT 1 FROM GestaoNucleos.Eventos WHERE numero = @numero)
    BEGIN
      -- Inserir na tabela GestaoNucleos.EventosMonetarios
      SET @random_number = RAND();
      SET @codigo_ev_mon = ROUND((@random_number * 900) + 100, 0);
      
      INSERT INTO GestaoNucleos.EventosMonetarios(numero, lucro, codigo_ev_mon)
      VALUES (@numero, @lucro, @codigo_ev_mon);
      
    END
    ELSE
    BEGIN
      -- Código de tratamento quando o número de evento não existe na tabela GestaoNucleos.Eventos
      RAISERROR('O número de evento fornecido não existe na tabela GestaoNucleos.Eventos.', 16, 1);
    END;
  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    SET @ErrorMessage = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
    SELECT ERROR_MESSAGE() AS ErrorMessage;
  END CATCH;
END;

--adicionar trabalhador
CREATE PROCEDURE [dbo].[AddTrabalhador] 
  @numero int,
  @n_CC varchar(64), 
  @nome varchar(128), 
  @morada varchar(256), 
  @telemovel int, 
  @email varchar(128), 
  @n_horas float
AS
BEGIN
  BEGIN TRY
    
    -- Verificar se o número de evento existe na tabela GestaoNucleos.Eventos
    IF EXISTS (SELECT 1 FROM GestaoNucleos.Eventos WHERE numero = @numero)
    BEGIN
      INSERT INTO GestaoNucleos.Pessoa(n_CC, nome, morada, telemovel, email)
      VALUES (@n_CC, @nome, @morada, @telemovel, @email);
      
      IF EXISTS (SELECT 1 FROM GestaoNucleos.Pessoa WHERE n_CC = @n_CC)
      BEGIN
        INSERT INTO GestaoNucleos.Event_tem_Trab(evento_numero, n_CC)
        VALUES (@numero, @n_CC);
        
        INSERT INTO GestaoNucleos.Trabalhadores(n_CC, n_horas)
        VALUES (@n_CC, @n_horas);
      END
    END
    ELSE
    BEGIN
      PRINT 'Evento nao existe, impossível introduzir trabalhador';
    END;
      
  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    SET @ErrorMessage = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
    SELECT ERROR_MESSAGE() AS ErrorMessage;
  END CATCH;
END;
GO

-- eliminar trabalhador
CREATE PROCEDURE [dbo].[DelTrabalhador]     
@numero int,    
@n_CC varchar(64)     
AS  
BEGIN    
    BEGIN TRY            
    -- Verificar se o trabalhador existe na tabela GestaoNucleos.Pessoa      
        IF EXISTS (SELECT 1 FROM GestaoNucleos.Pessoa WHERE n_CC = @n_CC)      
        BEGIN        
            -- Verificar se o número de evento existe na tabela GestaoNucleos.Eventos        
            IF EXISTS (SELECT 1 FROM GestaoNucleos.Eventos WHERE numero = @numero)        
            BEGIN         
            -- Verificar se o trabalhador está associado ao número do evento na tabela GestaoNucleos.Event_tem_Trab         
                IF EXISTS (SELECT 1 FROM GestaoNucleos.Event_tem_Trab WHERE evento_numero = @numero AND n_CC = @n_CC)          
                BEGIN            
                    DELETE FROM GestaoNucleos.Event_tem_Trab           
                    WHERE evento_numero = @numero AND n_CC = @n_CC;                        
                    DELETE FROM GestaoNucleos.Trabalhadores            
                    WHERE n_CC = @n_CC;          
                END          
                ELSE          
                BEGIN            
                    PRINT 'O trabalhador não está associado ao evento especificado.';          
                END        
            END        
            ELSE        
            BEGIN          
                PRINT 'O evento especificado não existe, impossível retirar o trabalhador.';        
            END      
        END      
        ELSE      
        BEGIN        
            PRINT 'O CC do trabalhador não existe na base de dados.';      
        END;            
    END TRY    
    BEGIN CATCH      
        DECLARE @ErrorMessage NVARCHAR(4000);      
        SET @ErrorMessage = ERROR_MESSAGE();      
        RAISERROR(@ErrorMessage, 16, 1);      
        SELECT ERROR_MESSAGE() AS ErrorMessage;    
    END CATCH;  
END;    

-- detalhes trabalhadores
CREATE PROCEDURE [dbo].[DetalhesTrabalhador] 
  @nome varchar(128)
AS
BEGIN
  BEGIN TRY
    IF EXISTS (SELECT 1 FROM GestaoNucleos.Pessoa WHERE nome = @nome)
    BEGIN
      SELECT Pessoa.n_CC, Pessoa.nome, Eventos.nome, Trabalhadores.n_horas 
      FROM GestaoNucleos.Pessoa
      JOIN GestaoNucleos.Trabalhadores ON Pessoa.n_CC = Trabalhadores.n_CC
      JOIN GestaoNucleos.Event_tem_Trab ON Trabalhadores.n_CC = Event_tem_Trab.n_CC
      JOIN GestaoNucleos.Eventos ON Event_tem_Trab.evento_numero = Eventos.numero
      WHERE Pessoa.nome = @nome;
    END
    ELSE
    BEGIN
      PRINT 'O nome do trabalhador não existe na base de dados.';
    END;
  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    SET @ErrorMessage = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
    SELECT ERROR_MESSAGE() AS ErrorMessage;
  END CATCH;
END;

-- detalhes de pulseiras
CREATE PROCEDURE [dbo].[GetPulseiraDetails]
AS
BEGIN
    SELECT p.id AS PulseiraID, em.codigo_ev_mon AS CodigoEventMonet
    FROM GestaoNucleos.Pulseiras p
    INNER JOIN GestaoNucleos.EventosMonetarios em ON p.evento_numero = em.numero;
END
GO

-- trabalhadores externos
CREATE PROCEDURE [dbo].[ObterExternos]
    @id_RF int
AS
BEGIN
    SELECT Externo.n_CC, Externo.salario_hora, SUM((Trabalhadores.n_horas*Externo.salario_hora)) AS total
    FROM GestaoNucleos.Externo
	JOIN GestaoNucleos.Trabalhadores
	ON Externo.n_CC=Trabalhadores.n_CC
	WHERE id_RF = @id_RF
	GROUP BY Externo.n_CC, Externo.salario_hora;
END;

-- relatórios
CREATE PROCEDURE [dbo].[Relatorios]
    @FilterNome VARCHAR(100) = NULL
AS
    SELECT Eventos.numero, Eventos.nome, Eventos.local, Eventos.n_trabalhadores, Eventos.n_participantes, Eventos.data, EventosMonetarios.lucro
    FROM GestaoNucleos.Eventos
    JOIN GestaoNucleos.EventosMonetarios ON GestaoNucleos.Eventos.numero = GestaoNucleos.EventosMonetarios.numero
    WHERE (@FilterNome IS NULL OR Eventos.nome LIKE '%' + @FilterNome + '%')
GO

-- procurar info Trabalhadores
CREATE PROCEDURE [dbo].[SearchTrabalhadorInfo]
  @searchName varchar(128)
AS
BEGIN
  SELECT T.n_CC, P.nome, T.n_horas
  FROM GestaoNucleos.Trabalhadores T
  INNER JOIN GestaoNucleos.Pessoa P ON T.n_CC = P.n_CC
  WHERE P.nome LIKE '%' + @searchName + '%';
END;
GO


-- ver bebidas
CREATE PROCEDURE [dbo].[VerBebidas]
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM GestaoNucleos.Produtos WHERE tipo LIKE '%Bebida%')
		BEGIN
			SELECT 
				nome,
				tipo,
				quantidade
			FROM GestaoNucleos.Produtos
			WHERE tipo LIKE '%Bebida%'
		END
		ELSE
		BEGIN
			PRINT 'Nao existem bebidas na tabela de produtos.'
		END;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		SET @ErrorMessage = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END;
GO

-- ver comidas
CREATE PROCEDURE [dbo].[VerComida]
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM GestaoNucleos.Produtos WHERE tipo LIKE '%Alimentação%')
		BEGIN
			SELECT 
				nome,
				tipo,
				quantidade
			FROM GestaoNucleos.Produtos
			WHERE tipo LIKE '%Alimentação%'
		END
		ELSE
		BEGIN
			PRINT 'Nao existem bens consumíveis (Alimentação) na tabela de produtos.'
		END;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		SET @ErrorMessage = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END;


-- verificar pagamento / sponsor
CREATE PROCEDURE [dbo].[VerificarPagamentoEventoNaoMonetario] 
  @evento_numero int,
  @sponsor_CC varchar(64)
AS
BEGIN
  BEGIN TRY
    -- Verificar se o patrocinador já efetuou o pagamento para o evento não monetário
    IF EXISTS (SELECT 1 FROM GestaoNucleos.EventosNaoMonetarios WHERE numero = @evento_numero AND Sponsor_CC = @sponsor_CC)
      PRINT 'O patrocinador efetuou o pagamento para o evento não monetário.';
    ELSE
      PRINT 'O patrocinador ainda não efetuou o pagamento para o evento não monetário.';
  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    SET @ErrorMessage = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
    SELECT ERROR_MESSAGE() AS ErrorMessage;
  END CATCH;
END;
GO

-- ver lucro total
CREATE PROCEDURE [dbo].[VerLucroTotal]
    @numero int
AS
BEGIN
    BEGIN TRY
        SELECT
            SUM(EventosMonetarios.lucro) + SUM((Produtos.preco_venda - Produtos.preco_compra) * Produtos.quantidade) AS 'Lucro'
        FROM
            GestaoNucleos.Eventos
            JOIN GestaoNucleos.EventosMonetarios ON Eventos.numero = EventosMonetarios.numero
            JOIN GestaoNucleos.Pulseiras ON EventosMonetarios.numero = Pulseiras.evento_numero
            JOIN GestaoNucleos.EventMonet_tem_Produtos ON EventosMonetarios.numero = EventMonet_tem_Produtos.numero
            JOIN GestaoNucleos.Produtos ON EventMonet_tem_Produtos.codigo = Produtos.codigo
        WHERE
            Eventos.numero = @numero
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;

-- ver membros
CREATE PROCEDURE [dbo].[VerMembros]   
AS  
BEGIN    
    BEGIN TRY   
        DECLARE @n_CC varchar(64)      
        IF NOT EXISTS (SELECT * FROM GestaoNucleos.Trabalhadores WHERE n_CC IN (SELECT n_CC FROM GestaoNucleos.Membro))      
        BEGIN
            SET @n_CC = (SELECT TOP 1 n_CC FROM GestaoNucleos.Membro);         
            INSERT INTO GestaoNucleos.Trabalhadores (n_CC, n_horas)         
            VALUES(@n_CC, 0);            
        END
        SELECT DISTINCT Pessoa.nome, Membro.n_mecanografico, Trabalhadores.n_horas      
        FROM GestaoNucleos.Pessoa      
        JOIN GestaoNucleos.Membro ON Pessoa.n_CC = Membro.n_CC     
        JOIN GestaoNucleos.Trabalhadores ON Membro.n_CC = Trabalhadores.n_CC;    
    END TRY    
    BEGIN CATCH      
        DECLARE @ErrorMessage NVARCHAR(4000);      
        SET @ErrorMessage = ERROR_MESSAGE();      
        RAISERROR(@ErrorMessage, 16, 1);      
        SELECT ERROR_MESSAGE() AS ErrorMessage;    
    END CATCH;  
END;
GO

-- ver pulseiras por evento
CREATE PROCEDURE [dbo].[VerPulseiraPorEvento] 
@evento_numero int
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM GestaoNucleos.Eventos WHERE numero = @evento_numero)
		BEGIN
			SELECT Pulseiras.evento_numero, Eventos.nome, COUNT(Pulseiras.id) AS 'nº pulseiras vendidas'
			FROM GestaoNucleos.Eventos
			JOIN GestaoNucleos.Pulseiras
			ON Eventos.numero=Pulseiras.evento_numero
			WHERE Eventos.numero=@evento_numero
			GROUP BY  Pulseiras.evento_numero, Eventos.nome
		END
		ELSE
		BEGIN
			PRINT 'Evento nao existe';
		END
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		SET @ErrorMessage = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	  END CATCH;
END

-- adicionar evento não monetário
CREATE PROCEDURE [GestaoNucleos].[AddEventoNaoMonetario]     
    @nome varchar(128),
    @local varchar(64),
    @tipo varchar(64),
    @area varchar(64),
    @n_participantes int,
    @n_trabalhadores int,
    @data datetime,
    @Sponsor_CC varchar(64),
    @numero int OUTPUT
AS  
BEGIN    
    BEGIN TRY            
        -- Declare a variable to store the next event number
        DECLARE @nextEventNumber int;

        -- Retrieve the maximum event number from the Eventos table and increment it by 1
        SELECT @nextEventNumber = ISNULL(MAX(numero), 0) + 1 FROM GestaoNucleos.Eventos;

        -- Check if the Sponsor_CC value exists in the Sponsor table
        IF EXISTS (SELECT 1 FROM GestaoNucleos.Sponsor WHERE n_CC = @Sponsor_CC)
        BEGIN
            -- Insert a new event into the Eventos table with the generated event number
            INSERT INTO GestaoNucleos.Eventos (numero, nome, local, tipo, area, n_participantes, n_trabalhadores, data)
            VALUES (@nextEventNumber, @nome, @local, @tipo, @area, @n_participantes, @n_trabalhadores, @data);

            -- Insert a new event into the EventosNaoMonetarios table with the generated event number
            INSERT INTO GestaoNucleos.EventosNaoMonetarios (numero, Sponsor_CC)
            VALUES (@nextEventNumber, @Sponsor_CC);

            -- Set the value of @numero to the generated event number
            SET @numero = @nextEventNumber;
        END
        ELSE
        BEGIN
            -- Raise an error if the Sponsor_CC value doesn't exist in the Sponsor table
            RAISERROR('Invalid Sponsor_CC value.', 16, 1);
        END        
    END TRY    
    BEGIN CATCH      
        DECLARE @ErrorMessage NVARCHAR(4000);      
        SET @ErrorMessage = ERROR_MESSAGE();      
        RAISERROR(@ErrorMessage, 16, 1);      
        SELECT ERROR_MESSAGE() AS ErrorMessage;    
    END CATCH;  
END;
GO

-- editar detalhes trabalhador
CREATE PROCEDURE [GestaoNucleos].[EditarDetalhes] (
    @n_CC varchar(64),
    @nome varchar(128) = NULL,
    @morada varchar(256) = NULL,
    @telemovel int = NULL,
    @email varchar(128) = NULL,
    @n_horas float = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update Pessoa table
    IF (@nome IS NOT NULL)
    BEGIN
        UPDATE GestaoNucleos.Pessoa
        SET nome = @nome
        WHERE n_CC = @n_CC;
    END

    IF (@morada IS NOT NULL)
    BEGIN
        UPDATE GestaoNucleos.Pessoa
        SET morada = @morada
        WHERE n_CC = @n_CC;
    END

    IF (@telemovel IS NOT NULL)
    BEGIN
        UPDATE GestaoNucleos.Pessoa
        SET telemovel = @telemovel
        WHERE n_CC = @n_CC;
    END

    IF (@email IS NOT NULL)
    BEGIN
        UPDATE GestaoNucleos.Pessoa
        SET email = @email
        WHERE n_CC = @n_CC;
    END

    -- Update Trabalhadores table
    IF (@n_horas IS NOT NULL)
    BEGIN
        UPDATE GestaoNucleos.Trabalhadores
        SET n_horas = @n_horas
        WHERE n_CC = @n_CC;
    END
END
GO

--Adicionar um número x (escolhido pelo utilizador) de Pulseiras
CREATE PROCEDURE dbo.AddPulseira
	@eventonumero int,
	@numero_pulseiras int
AS
BEGIN
	BEGIN TRY
		DECLARE @contador int = 0
		DECLARE @random_number float
		DECLARE @codigo_ev_mon int
		
		WHILE (@contador < @numero_pulseiras)
		BEGIN
			SET @random_number = RAND();
			SET @codigo_ev_mon = ROUND((@random_number * 2000) + 10000, 0);
			
			INSERT INTO GestaoNucleos.Pulseiras (id, evento_numero)
			VALUES (@codigo_ev_mon, @eventonumero);

			SET @contador = @contador + 1;
		END;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		SET @ErrorMessage = ERROR_MESSAGE();
		RAISERROR(@ErrorMessage, 16, 1);
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END;

--Adicionar Comida e Bebida ao Armazém
CREATE PROCEDURE AddComidaEBebida
    @codigo INT,
    @nome VARCHAR(128),
    @tipo VARCHAR(32),
    @preco_compra FLOAT,
    @preco_venda FLOAT,
    @quantidade INT,
    @data_validade DATETIME
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM GestaoNucleos.Produtos WHERE codigo = @codigo)
        BEGIN
            IF (CHARINDEX('Bebida', @tipo) > 0 OR CHARINDEX('Alimentacao', @tipo) > 0)
            BEGIN
                INSERT INTO GestaoNucleos.Produtos (codigo, nome, tipo, preco_compra, preco_venda, quantidade, data_validade)
                VALUES (@codigo, @nome, @tipo, @preco_compra, @preco_venda, @quantidade, @data_validade);
            END
            ELSE
            BEGIN
               PRINT 'Tipo Não existente, inserir tipo BEBIDA ou ALIMENTAÇÃO';
            END
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(MAX);
        SET @ErrorMessage = ERROR_MESSAGE();
        PRINT @ErrorMessage;
    END CATCH
END;
