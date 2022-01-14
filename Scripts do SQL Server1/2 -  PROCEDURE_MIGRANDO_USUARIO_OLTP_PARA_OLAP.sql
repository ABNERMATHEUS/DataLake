
USE finances_v1_basic_desenv;

CREATE OR ALTER PROCEDURE MIGRANDO_USUARIO_OLTP_PARA_OLAP
AS
	BEGIN
			DECLARE @ID_USUARIO INT, 
					@NOME VARCHAR(500),
					@EMAIL VARCHAR(500), 
					@SENHA VARCHAR(128),
					@CPF VARCHAR(128),
					@SOBRENOME VARCHAR(128);

		DECLARE CURSOR_INVESTIMENTO CURSOR FOR (SELECT 
													IdUsuario,
													Nome,
													Email,
													Senha,
													CPF,
													Sobrenome
												FROM Usuario)
			OPEN CURSOR_INVESTIMENTO
				FETCH NEXT FROM CURSOR_INVESTIMENTO INTO @ID_USUARIO, 
														 @NOME,
														 @EMAIL, 
														 @SENHA,
														 @CPF,
														 @SOBRENOME

		  WHILE @@FETCH_STATUS = 0
			BEGIN
				
					  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.Usuario WHERE IdUsuario = @ID_USUARIO)						
						INSERT INTO modelo_estrela_desenv.dbo.Usuario(IdUsuario,CPF,Email,Nome,Senha,Sobrenome)VALUES(
							 @ID_USUARIO, 
							 @CPF,
							 @EMAIL, 
							 @NOME,
							 @SENHA,
							 @SOBRENOME
						);						
					  ELSE 
						UPDATE modelo_estrela_desenv.dbo.Usuario
							SET IdUsuario = @ID_USUARIO,
								Nome = @NOME,
								Email = @EMAIL,
								Senha = @SENHA,
								Sobrenome = @SOBRENOME
						WHERE IdUsuario = @ID_USUARIO;	
					
					
					FETCH NEXT FROM CURSOR_INVESTIMENTO INTO   @ID_USUARIO, 
															   @NOME,
															   @EMAIL, 
															   @SENHA,
															   @CPF,
															   @SOBRENOME
				END

			CLOSE CURSOR_INVESTIMENTO
				DEALLOCATE CURSOR_INVESTIMENTO;	
END;