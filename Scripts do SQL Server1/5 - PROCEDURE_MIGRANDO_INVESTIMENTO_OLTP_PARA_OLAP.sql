
USE  finances_v1_basic_desenv;

CREATE OR ALTER   PROCEDURE MIGRANDO_INVESTIMENTO_OLTP_PARA_OLAP
AS

	BEGIN
			DECLARE @ID_INVESTIMENTO INT,
					@IDCarteira INT,
					@NOME VARCHAR(100),
					@VALOR_APLICADO MONEY,
					@DATA_APLICACAO DATETIME,
					@UNIDADES INT,
					@ID_TIPO_INVESTIMENTO INT;

		DECLARE CURSOR_INVESTIMENTO CURSOR FOR (SELECT 
													IdInvestimento,
													IdCarteira,
													Nome,
													ValorAplicado,
													DataAplicacao,
													Unidades,
													IdTipoInvestimento
												FROM Investimento)
			OPEN CURSOR_INVESTIMENTO
				FETCH NEXT FROM CURSOR_INVESTIMENTO INTO  @ID_INVESTIMENTO,
														  @IDCarteira,
														  @NOME,
														  @VALOR_APLICADO,
														  @DATA_APLICACAO,
														  @UNIDADES,
														  @ID_TIPO_INVESTIMENTO

		  WHILE @@FETCH_STATUS = 0
			BEGIN
					  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.Investimento WHERE IdInvestimento = @ID_INVESTIMENTO)
						
						INSERT INTO modelo_estrela_desenv.dbo.Investimento(IdInvestimento,IdCarteira,Nome,ValorAplicado,DataAplicacao,Unidades,IdTipoInvestimento)VALUES(
							@ID_INVESTIMENTO,
							@IDCarteira,
							@NOME,
							@VALOR_APLICADO,
							@DATA_APLICACAO,
							@UNIDADES,
							@ID_TIPO_INVESTIMENTO
						);						
					  ELSE 
						UPDATE modelo_estrela_desenv.dbo.Investimento
							SET IdCarteira = @IDCarteira,
								Nome = @NOME,
								ValorAplicado = @VALOR_APLICADO,
								DataAplicacao = @DATA_APLICACAO,
								Unidades = @UNIDADES,
								IdTipoInvestimento= @ID_TIPO_INVESTIMENTO
						WHERE IdInvestimento = @ID_INVESTIMENTO 	
					
					
					FETCH NEXT FROM CURSOR_INVESTIMENTO INTO  @ID_INVESTIMENTO,
															  @IDCarteira,
															  @NOME,
															  @VALOR_APLICADO,
															  @DATA_APLICACAO,
															  @UNIDADES,
															  @ID_TIPO_INVESTIMENTO
				END

			CLOSE CURSOR_INVESTIMENTO
				DEALLOCATE CURSOR_INVESTIMENTO;	
END;
CREATE OR ALTER   PROCEDURE MIGRANDO_INVESTIMENTO_OLTP_PARA_OLAP
AS

	BEGIN
			DECLARE @ID_INVESTIMENTO INT,
					@IDCarteira INT,
					@NOME VARCHAR(100),
					@VALOR_APLICADO MONEY,
					@DATA_APLICACAO DATETIME,
					@UNIDADES INT,
					@ID_TIPO_INVESTIMENTO INT;

		DECLARE CURSOR_INVESTIMENTO CURSOR FOR (SELECT 
													IdInvestimento,
													IdCarteira,
													Nome,
													ValorAplicado,
													DataAplicacao,
													Unidades,
													IdTipoInvestimento
												FROM Investimento)
			OPEN CURSOR_INVESTIMENTO
				FETCH NEXT FROM CURSOR_INVESTIMENTO INTO  @ID_INVESTIMENTO,
														  @IDCarteira,
														  @NOME,
														  @VALOR_APLICADO,
														  @DATA_APLICACAO,
														  @UNIDADES,
														  @ID_TIPO_INVESTIMENTO

		  WHILE @@FETCH_STATUS = 0
			BEGIN
					  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.Investimento WHERE IdInvestimento = @ID_INVESTIMENTO)
						
						INSERT INTO modelo_estrela_desenv.dbo.Investimento(IdInvestimento,IdCarteira,Nome,ValorAplicado,DataAplicacao,Unidades,IdTipoInvestimento)VALUES(
							@ID_INVESTIMENTO,
							@IDCarteira,
							@NOME,
							@VALOR_APLICADO,
							@DATA_APLICACAO,
							@UNIDADES,
							@ID_TIPO_INVESTIMENTO
						);						
					  ELSE 
						UPDATE modelo_estrela_desenv.dbo.Investimento
							SET IdCarteira = @IDCarteira,
								Nome = @NOME,
								ValorAplicado = @VALOR_APLICADO,
								DataAplicacao = @DATA_APLICACAO,
								Unidades = @UNIDADES,
								IdTipoInvestimento= @ID_TIPO_INVESTIMENTO
						WHERE IdInvestimento = @ID_INVESTIMENTO 	
					
					
					FETCH NEXT FROM CURSOR_INVESTIMENTO INTO  @ID_INVESTIMENTO,
															  @IDCarteira,
															  @NOME,
															  @VALOR_APLICADO,
															  @DATA_APLICACAO,
															  @UNIDADES,
															  @ID_TIPO_INVESTIMENTO
				END

			CLOSE CURSOR_INVESTIMENTO
				DEALLOCATE CURSOR_INVESTIMENTO;	
END;