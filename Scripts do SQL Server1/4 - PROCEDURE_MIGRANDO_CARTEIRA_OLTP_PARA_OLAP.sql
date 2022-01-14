USE finances_v1_basic_desenv

CREATE OR ALTER PROCEDURE MIGRANDO_CARTEIRA_OLTP_PARA_OLAP
AS
	BEGIN
			DECLARE @ID_CARTEIRA INT, 
					@NOME VARCHAR(500),
					@ID_USUARIO INT, 
					@DESCRICAO VARCHAR(128);

		DECLARE CURSOR_INVESTIMENTO CURSOR FOR (SELECT 
													IdCarteira,
													Nome,
													IdUsuario,
													Descricao
												FROM Carteira)
			OPEN CURSOR_INVESTIMENTO
				FETCH NEXT FROM CURSOR_INVESTIMENTO INTO @ID_CARTEIRA, 
														 @NOME,
														 @ID_USUARIO, 
														 @DESCRICAO;

		  WHILE @@FETCH_STATUS = 0
			BEGIN
					  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.Carteira WHERE IdCarteira = @ID_CARTEIRA)
						
						INSERT INTO modelo_estrela_desenv.dbo.Carteira(IdCarteira,Nome,Descricao)VALUES(
							 @ID_CARTEIRA, 
							@NOME,
							@DESCRICAO
						);						
					  ELSE 
						UPDATE modelo_estrela_desenv.dbo.Carteira
							SET IdCarteira = @ID_CARTEIRA,
								Nome = @NOME,
								Descricao = @DESCRICAO								
						WHERE IdCarteira = @ID_CARTEIRA;	
					
					
					
					EXECUTE MIGRANDO_TRANSACOES_OLTP_PARA_OLAP @ID_CARTEIRA;
					FETCH NEXT FROM CURSOR_INVESTIMENTO INTO   @ID_CARTEIRA, 
															   @NOME,
															   @ID_USUARIO,
															   @DESCRICAO
				END

			CLOSE CURSOR_INVESTIMENTO
				DEALLOCATE CURSOR_INVESTIMENTO;	
END;