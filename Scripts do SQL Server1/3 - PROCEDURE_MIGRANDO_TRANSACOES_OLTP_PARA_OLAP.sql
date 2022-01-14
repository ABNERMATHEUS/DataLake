USE  finances_v1_basic_desenv;

CREATE OR ALTER PROCEDURE MIGRANDO_TRANSACOES_OLTP_PARA_OLAP(
@ID_Carteira INT )
AS
BEGIN
			DECLARE @IDTRANSACOES INT,
					@DESCRICAO VARCHAR(50),
					@DATA DATETIME,
					@PAGO_OU_RECEBIDO BIT,
					@VALOR MONEY,
					@CATEGORIA VARCHAR(50),
					@IDCARTEIRA INT,
					@IDFORMAPAGAMENTO INT,
					@ID_USUARIO INT;

		SET @ID_USUARIO = (SELECT IdUsuario FROM Carteira WHERE IdCarteira =@ID_Carteira);

		DECLARE CURSOR_TRANSACAO CURSOR FOR (SELECT IdTransacoes,
													Descricao,
													Data,
													Pago_ou_Recebido,
													Valor,
													Categoria,
													IdCarteira,
													IdFormaPagamento
												FROM Transacoes
												WHERE IdCarteira = @ID_Carteira)
			OPEN CURSOR_TRANSACAO
				FETCH NEXT FROM CURSOR_TRANSACAO INTO @IDTRANSACOES,
													  @DESCRICAO,
													  @DATA,
													  @PAGO_OU_RECEBIDO,
													  @VALOR,
													  @CATEGORIA,
													  @IDCARTEIRA,
													  @IDFORMAPAGAMENTO

		  WHILE @@FETCH_STATUS = 0
			BEGIN
					  IF NOT EXISTS(SELECT * FROM modelo_estrela_desenv.dbo.Transacoes WHERE IdTransacoes = @IDTRANSACOES)
						
						INSERT INTO modelo_estrela_desenv.dbo.Transacoes(IdTransacoes,Descricao,Data,Pago_ou_Recebido,Valor,Categoria,IdCarteira,IdFormaPagamento,IdUsuario)VALUES(
							@IDTRANSACOES,
							@DESCRICAO,
							@DATA,
							@PAGO_OU_RECEBIDO,
							@VALOR,
							@CATEGORIA,
							@IDCARTEIRA,
							@IDFORMAPAGAMENTO,
							@ID_USUARIO
						);						
					  ELSE
						UPDATE modelo_estrela_desenv.dbo.Transacoes
							SET Descricao = @DESCRICAO,
								DATA = @DATA,
								Pago_ou_Recebido = @PAGO_OU_RECEBIDO,
								Valor = @VALOR,
								Categoria = @CATEGORIA,
								IdCarteira = @IDCARTEIRA,
								IdFormaPagamento = @IDFORMAPAGAMENTO															
						WHERE IdTransacoes = @IDTRANSACOES;	
					
					
					FETCH NEXT FROM CURSOR_TRANSACAO INTO   @IDTRANSACOES,
															@DESCRICAO,
															@DATA,
															@PAGO_OU_RECEBIDO,
															@VALOR,
															@CATEGORIA,
															@IDCARTEIRA,
															@IDFORMAPAGAMENTO
				END

			CLOSE CURSOR_TRANSACAO
				DEALLOCATE CURSOR_TRANSACAO;	
END;