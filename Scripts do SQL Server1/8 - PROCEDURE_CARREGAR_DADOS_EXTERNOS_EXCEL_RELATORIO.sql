USE finances_v1_basic_desenv;

CREATE OR ALTER PROCEDURE CARREGAR_DADOS_EXTERNOS_EXCEL_RELATORIO
AS

BEGIN
create table #tempRelatorio
    (Id INT,
	TipoRelatorio VARCHAR(500),
	 DataGeracao VARCHAR(500),
	 IdUsuario VARCHAR(500))

BULK INSERT #tempRelatorio
FROM 'C:\Relatorio.csv'
WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter 
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

DECLARE @TipoRelatorio VARCHAR(500),@DATAGERACAO VARCHAR(500),@ID_USUARIO VARCHAR(500);
DECLARE C_CURSOR CURSOR FOR(SELECT TipoRelatorio,DataGeracao,IdUsuario FROM #tempRelatorio)
OPEN C_CURSOR
        FETCH NEXT FROM C_CURSOR INTO			 @TipoRelatorio,
                                                 @DATAGERACAO,
                                                 @ID_USUARIO
		

		WHILE @@FETCH_STATUS = 0
        BEGIN
			INSERT INTO Relatorio (IdUsuario,DataGeracao,TipoRelatorio)
			VALUES(
			CAST(@ID_USUARIO AS INT),
			CAST(@DATAGERACAO AS DATETIME),
			TRIM(@TipoRelatorio)
			);
         
		         
	FETCH NEXT FROM C_CURSOR INTO @TipoRelatorio,
                                  @DATAGERACAO,
                                  @ID_USUARIO
         END                        
    CLOSE C_CURSOR
        DEALLOCATE C_CURSOR
DROP TABLE #tempRelatorio
END;
