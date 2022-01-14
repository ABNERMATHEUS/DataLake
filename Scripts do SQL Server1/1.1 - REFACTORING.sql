USE finances_v1_basic_desenv


--ALTERA??O DE COLUNAS NAS TABELAS DO BANCO DE DADOS
BEGIN
		BEGIN TRAN
            --- EXCLUIR COLUNA NOMETIPOINVESTIMENTO NA TABELA INVESTIMENTO
            ALTER TABLE Investimento DROP COLUMN NomeTipoInvestimento;

            --- ADICIONAR COLUNA CPF NA TABELA USU?RIO
            ALTER TABLE Usuario ADD CPF VARCHAR(14) DEFAULT NULL;


            --ADICIONAR O CAMPO DESCRI??O NA TABELA CARTEIRA
            ALTER TABLE Carteira ADD Descricao VARCHAR(128) DEFAULT NULL;

            -- ALTERAR O NOME DA TABELA MEIOPAGAMENTO PARA FormaPagamento
            EXEC sp_rename 'MeioPagamento', 'FormaPagamento';

        COMMIT
END;


--CRIANDO TABELA DE TABELA DE TRANSACOES
BEGIN
	BEGIN TRAN
        CREATE TABLE dbo.Transacoes
            (
            IdTransacoes int NOT NULL IDENTITY (1, 1),
            Descricao varchar(50) NOT NULL,
            Data datetime NOT NULL,
            Pago_ou_Recebido tinyint NOT NULL,
            Valor money NOT NULL,
            Categoria varchar(50) NOT NULL,
            IdCarteira int NOT NULL,
            IdFormaPagamento int NULL
            )  ON [PRIMARY]

            ALTER TABLE dbo.Transacoes ADD CONSTRAINT
                PK_Transacoes PRIMARY KEY CLUSTERED
                (
                IdTransacoes
                ) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


            ALTER TABLE dbo.Transacoes ADD CONSTRAINT
                FK_Transacoes_Carteira FOREIGN KEY
                (
                IdCarteira
                ) REFERENCES dbo.Carteira
                (
                IdCarteira
                ) ON UPDATE  NO ACTION
                 ON DELETE  NO ACTION

            ALTER TABLE dbo.Transacoes SET (LOCK_ESCALATION = TABLE)

			ALTER TABLE dbo.FormaPagamento SET (LOCK_ESCALATION = TABLE)
			ALTER TABLE dbo.Transacoes ADD CONSTRAINT
					FK_Transacoes_FormaPagamento FOREIGN KEY
					(
					IdFormaPagamento
					) REFERENCES dbo.FormaPagamento
					(
					IdFormaPagamento
					) ON UPDATE  NO ACTION 
					 ON DELETE  NO ACTION 
			ALTER TABLE dbo.Transacoes SET (LOCK_ESCALATION = TABLE)

			COMMIT
END;

-- INSERINDO REGISTROS NA TABELA DE TRANSACOES
BEGIN

    DECLARE
    @DESCRICAO          VARCHAR(500),
    @DATA               DATETIME,
    @PAGO_RECEBIDO      BIT,
    @VALOR              MONEY,
    @CATEGORIA          VARCHAR(500),
    @IDCARTEIRA         INT,
    @ID_FORMAPAGAMENTO  INT;

    DECLARE CURSOR_PAGAR_RECEBER CURSOR FOR (SELECT
                                                PAG.Descricao,
                                                PAG.Data,
                                                PAG.PAGO AS Pago_ou_Recebido,
                                                PAG.Valor,
                                                PAG.Categoria,
                                                PAG.IdCarteira,
                                                PAG.IdFormaPagamento

                                            FROM Pagar AS PAG
                                            UNION ALL
                                            SELECT
                                                REC.Descricao,
                                                REC.Data,
                                                REC.Recebido AS Pago_ou_Recebido,
                                                REC.Valor,
                                                REC.Categoria,
                                                REC.IdCarteira,
                                                NULL AS IdFormaPagamento
                                            FROM Receber AS REC)

    OPEN CURSOR_PAGAR_RECEBER
        FETCH NEXT FROM CURSOR_PAGAR_RECEBER INTO   @DESCRICAO,
                                                    @DATA,
                                                    @PAGO_RECEBIDO,
                                                    @VALOR,
                                                    @CATEGORIA,
                                                    @IDCARTEIRA,
                                                    @ID_FORMAPAGAMENTO;

    WHILE @@FETCH_STATUS = 0
        BEGIN
             INSERT INTO Transacoes (Descricao,Data,Pago_ou_Recebido,Valor,Categoria,IdCarteira,IdFormaPagamento)
                    VALUES(
                    @DESCRICAO,
                    @DATA,
                    @PAGO_RECEBIDO,
                    @VALOR,
                    @CATEGORIA,
                    @IDCARTEIRA,
                    @ID_FORMAPAGAMENTO
                    );

	        FETCH NEXT FROM CURSOR_PAGAR_RECEBER INTO   @DESCRICAO,
                                                    @DATA,
                                                    @PAGO_RECEBIDO,
                                                    @VALOR,
                                                    @CATEGORIA,
                                                    @IDCARTEIRA,
                                                    @ID_FORMAPAGAMENTO;
        END

    CLOSE CURSOR_PAGAR_RECEBER;
    DEALLOCATE CURSOR_PAGAR_RECEBER;
END;



-- APAGANDO TABELA PAGAR E TABELA RECEBER
BEGIN
    BEGIN TRANSACTION
	    DROP TABLE PAGAR;
	    DROP TABLE Receber;
	COMMIT;
END;


-- CRIANDO TABELA TIPO INVESTIMENTO
BEGIN
      BEGIN TRAN
			CREATE TABLE dbo.TipoInvestimento
                (
                IdTipoInvestimento int NOT NULL IDENTITY (1, 1),
                Nome varchar(50) NOT NULL
                )  ON [PRIMARY]

            ALTER TABLE dbo.TipoInvestimento ADD CONSTRAINT
                PK_TipoInvestimento PRIMARY KEY CLUSTERED
                (
                IdTipoInvestimento
                ) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

            ALTER TABLE dbo.TipoInvestimento SET (LOCK_ESCALATION = TABLE);
            COMMIT
END;

-- INSERIR DADOS NA TABELA TIPO INVESTIMENTO
INSERT INTO TipoInvestimento(Nome) VALUES ('Previdencia Privada');
INSERT INTO TipoInvestimento(Nome) VALUES ('Renda Variavel');
INSERT INTO TipoInvestimento(Nome) VALUES ('Poupanca');

--ADICIONANDO COLUNAS NOVAS NA TABELA INVESTIMENTO
BEGIN
BEGIN TRAN
        ALTER TABLE dbo.Investimento ADD
            Nome varchar(50) NULL,
            ValorAplicado money NULL,
            DataAplicacao datetime NULL,
            Unidades int NULL,
            IdTipoInvestimento int NULL

        ALTER TABLE dbo.Investimento ADD CONSTRAINT
            FK_Investimento_TipoInvestimento FOREIGN KEY
            (
            IdTipoInvestimento
            ) REFERENCES dbo.TipoInvestimento
            (
            IdTipoInvestimento
            ) ON UPDATE  NO ACTION
             ON DELETE  NO ACTION

        ALTER TABLE dbo.Investimento
            DROP COLUMN Descricao;

        ALTER TABLE dbo.Investimento SET (LOCK_ESCALATION = TABLE);
        COMMIT
END;




--- SELECT PARA GENERALIZAR BANCO TABELA INVETIMENTO DAS OUTRAS E INSERIR NA TABELA INVESTIMENTO
BEGIN
    DECLARE
    @IDINVESTIMENTO INT,
    @NOME VARCHAR(500),
    @VALOR_APLICADO MONEY,
    @DATA_APLICACAO DATETIME,
	@ID_CARTEIRA INT,
	@TIPO VARCHAR(100),
	@UNIDADES INT,
	@ID_TIPOINVESTIMENTO INT;
    DECLARE CURSOR_INVESTIMENTO CURSOR FOR (SELECT  POU.IdInvestimento,
                                                    POU.Nome,
                                                    NULL AS Valor,
                                                    NULL AS DataAplicacao,
													'Poupanca' AS TIPO,
													NULL AS UNIDADES
                                                    FROM Poupanca AS POU

                                                     UNION ALL

                                                    SELECT
                                                    PREV.IdInvestimento,
                                                    PREV.Nome,
                                                    PREV.Valor,
                                                    PREV.DataAplicacao,
													'Previdencia Privada' AS TIPO,
													NULL AS UNIDADES
                                                    FROM PrevidenciaPrivada AS PREV

                                                    UNION ALL

                                                    SELECT
                                                    REND.IdInvestimento,
                                                    REND.Papel,
                                                    REND.ValorAplicado,
                                                    REND.DataAplicacao,
													'Renda Variavel' AS TIPO,
													REND.Unidades AS UNIDADES
                                                    FROM RENDAVARIAVEL AS REND)
    OPEN CURSOR_INVESTIMENTO
        FETCH NEXT FROM CURSOR_INVESTIMENTO INTO @IDINVESTIMENTO,
                                                 @NOME,
                                                 @VALOR_APLICADO,
                                                 @DATA_APLICACAO,
												 @TIPO,
												 @UNIDADES

    WHILE @@FETCH_STATUS = 0
        BEGIN
         
		 -- BUSCAR O ID_CARTEIRA        
			SET @ID_CARTEIRA = (SELECT DISTINCT INV.IdCarteira FROM
					Poupanca AS POU,
					Investimento AS INV
					WHERE INV.IdInvestimento = POU.IdInvestimento
					AND INV.IdInvestimento = @IDINVESTIMENTO);		
		
		-- BUSCANDO O TIPO 
		   SET @ID_TIPOINVESTIMENTO = (SELECT IdTipoInvestimento FROM TipoInvestimento Where Nome = @TIPO); 
		
		-- INSERIR NA TABELA INVESTIMENTO
			INSERT INTO Investimento(IdCarteira,Nome,ValorAplicado,DataAplicacao,Unidades,IdTipoInvestimento)
			VALUES(
			@ID_CARTEIRA,
			@NOME,
			@VALOR_APLICADO,
			@DATA_APLICACAO,
			@UNIDADES,
			@ID_TIPOINVESTIMENTO
			);
        
	FETCH NEXT FROM CURSOR_INVESTIMENTO INTO @IDINVESTIMENTO,
											@NOME,
											@VALOR_APLICADO,
											@DATA_APLICACAO,
											@TIPO,
											@UNIDADES
         END                        
    CLOSE CURSOR_INVESTIMENTO
        DEALLOCATE CURSOR_INVESTIMENTO

		BEGIN
			DROP TABLE Poupanca;
			DROP TABLE PrevidenciaPrivada;
			DROP TABLE RendaVariavel;

			DELETE FROM Investimento
			WHERE Nome IS NULL 
			AND ValorAplicado IS NULL
			AND DataAplicacao IS NULL
			AND Unidades IS NULL			
		END
END;

PRINT'BANCO REFATORADO COM SUCESSO!'