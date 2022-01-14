
USE  finances_v1_basic_desenv;


CREATE OR ALTER   PROCEDURE MIGRANDO_RELATORIO_OLTP_PARA_OLAP
AS

	BEGIN
			DECLARE @ID_RELATORIO INT,
					@ID_USUARIO INT,
					@DATA_GERACAP DATETIME,
					@TIPO_RELATORIO VARCHAR(150);

		DECLARE CURSOR_RELATORIO CURSOR FOR (SELECT 
													IdRelatorio,
													IdUsuario,
													DataGeracao,
													TipoRelatorio
												FROM Relatorio)
			OPEN CURSOR_RELATORIO
				FETCH NEXT FROM CURSOR_RELATORIO INTO  @ID_RELATORIO,
														  @ID_USUARIO,
														  @DATA_GERACAP,
														  @TIPO_RELATORIO

		  WHILE @@FETCH_STATUS = 0
			BEGIN
					  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.Relatorio WHERE IdRelatorio = @ID_RELATORIO)
						
						INSERT INTO modelo_estrela_desenv.dbo.Relatorio(IdRelatorio,
																		IdUsuario,
																		DataGeracao,
																		TipoRelatorio)
					VALUES(
							@ID_RELATORIO,
							@ID_USUARIO,
							@DATA_GERACAP,
							@TIPO_RELATORIO
						);						
					  ELSE 
						UPDATE modelo_estrela_desenv.dbo.Relatorio
							SET IdUsuario=@ID_USUARIO,
								DataGeracao = @DATA_GERACAP,
								TipoRelatorio = @TIPO_RELATORIO
						WHERE IdRelatorio = @ID_RELATORIO
					
					
					FETCH NEXT FROM CURSOR_RELATORIO INTO  @ID_RELATORIO,
															  @ID_USUARIO,
															  @DATA_GERACAP,
															  @TIPO_RELATORIO
				END

			CLOSE CURSOR_RELATORIO
				DEALLOCATE CURSOR_RELATORIO;	
END;