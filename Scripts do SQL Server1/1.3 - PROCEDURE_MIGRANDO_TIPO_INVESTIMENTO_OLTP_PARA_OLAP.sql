
USE finances_v1_basic_desenv;

CREATE OR ALTER PROCEDURE MIGRANDO_TIPO_INVESTIMENTO_OLTP_PARA_OLAP
AS
BEGIN
SET IDENTITY_INSERT modelo_estrela_desenv.dbo.TipoInvestimento ON;
-- MIGRANDO TIPO_INVESTIMENTO
DECLARE @NOME_INVESTIMENTO VARCHAR(500)
		,@ID_TIPO_INVESTIMENTO INT;

	DECLARE CURSOR_INVESTIMENTO CURSOR FOR (SELECT IdTipoInvestimento, Nome from TipoInvestimento)
		OPEN CURSOR_INVESTIMENTO
			FETCH NEXT FROM CURSOR_INVESTIMENTO INTO @ID_TIPO_INVESTIMENTO,@NOME_INVESTIMENTO

	  WHILE @@FETCH_STATUS = 0
	  BEGIN
			
				  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.TipoInvestimento WHERE IdTipoInvestimento = @ID_TIPO_INVESTIMENTO)
					INSERT INTO modelo_estrela_desenv.dbo.TipoInvestimento(IdTipoInvestimento,Nome)VALUES(@ID_TIPO_INVESTIMENTO,@NOME_INVESTIMENTO);	
				  ELSE 
					UPDATE modelo_estrela_desenv.dbo.TipoInvestimento
						SET Nome = @NOME_INVESTIMENTO
					WHERE IdTipoInvestimento = @ID_TIPO_INVESTIMENTO 					
				FETCH NEXT FROM CURSOR_INVESTIMENTO INTO @ID_TIPO_INVESTIMENTO,@NOME_INVESTIMENTO
		END
		CLOSE CURSOR_INVESTIMENTO
			DEALLOCATE CURSOR_INVESTIMENTO
SET IDENTITY_INSERT modelo_estrela_desenv.dbo.TipoInvestimento OFF;
END