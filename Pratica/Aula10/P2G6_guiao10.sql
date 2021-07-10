-- a

GO
CREATE PROCEDURE RemoveFuncionario 
	@in_ssn int --parametros de entrada e saida
AS
BEGIN
	BEGIN TRANSACTION
		UPDATE Company.department SET Mgr_ssn=null WHERE Mgr_ssn = @in_ssn;
		UPDATE Company.employee SET Super_ssn=null WHERE Super_ssn = @in_ssn;
		DELETE FROM Company.dependent WHERE Essn = @in_ssn;
		DELETE FROM Company.works_on WHERE Essn = @in_ssn;
		DELETE FROM Company.employee WHERE Ssn = @in_ssn;
	COMMIT;
END
GO

-- b

CREATE PROCEDURE FuncionariosGestores
	 @OldSsn int out,
	 @Year int out
AS
BEGIN
	SELECT Ssn, Fname, Lname, Dname, Mgr_start_date
	FROM department INNER JOIN employee ON Mgr_ssn=Ssn
	ORDER BY Mgr_start_date;
	SELECT TOP(1) @OldSsn=Ssn, @Year=DATEDIFF(year, GETDATE(),  Mgr_start_date)
	FROM department INNER JOIN
	employee ON Mgr_ssn=Ssn
	ORDER BY Mgr_start_date;
END
GO

-- c

CREATE TRIGGER FuncionarioGereDep ON employee
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @total as real
	SELECT @total=count(Mgr_ssn) FROM department GROUP BY Dnumber;
	IF @total > 1
		BEGIN
			RAISERROR ('Funcionario j� � gestor de um departamento',16,1);
			ROLLBACK TRAN;
		END
END
GO

-- d

CREATE TRIGGER LimiteVencimento ON employee
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @salary as int
	DECLARE @ssn as int
	DECLARE @dno as int
	SELECT @ssn, @salary=Salary, @dno=Dno FROM inserted;

	UPDATE employee SET Salary = gestor.Salary - 1
	FROM
		(SELECT Salary, Ssn FROM employee, department WHERE Dno=@dno and Dno=Dnumber and Ssn=Mgr_ssn) AS gestor
	WHERE @salary>=gestor.Salary and gestor.Ssn=@ssn;
END
GO

-- e

CREATE FUNCTION alineaE (@ssn int) RETURNS @ProjectInfo TABLE (proj_name VARCHAR(40), localizacao VARCHAR(40))
AS
BEGIN
	INSERT @ProjectInfo (proj_name, localizacao)
		SELECT Pname, Plocation FROM employee JOIN works_on ON Ssn=Essn JOIN project ON Pno=Pnumber WHERE Ssn=@ssn
	RETURN;
END

-- f

CREATE FUNCTION alineaF (@dno int) RETURNS @Employees TABLE (e_name VARCHAR(40), e_ssn DECIMAL(9,0), e_salary DECIMAL(11,2))
AS
BEGIN
	INSERT @Employees (e_name, e_ssn, e_salary)
		SELECT CONCAT(Fname,' ',Minit,'. ',Lname,Ssn,Salary) FROM employee WHERE Dno=@dno AND Salary > (SELECT AVG(Salary) FROM employee WHERE Dno=@dno)
	RETURN;
END

-- g

CREATE FUNCTION dbo.employeeDeptHighAverage (@dno int) RETURN @ProjectsPerDeptInfo TABLE (pname VARCHAR(40), pnumber INT, plocation VARCHAR(60), dnum INT, budget DECIMAL(8,2), totalbudget DECIMAL(8,2))
AS
BEGIN
	DECLARE @pnumber INT;
	DECLARE @pname VARCHAR(40);
	DECLARE @plocation VARCHAR(60);
	DECLARE @budget DECIMAL(8,2);
	DECLARE @totalbudget DECIMAL(8,2);
	DECLARE @totalhours DECIMAL(7,1);

	DECLARE C CURSOR FAST_FORWARD
	FOR SELECT Pname, Pnumber, Plocation FROM project WHERE Dnum = @dno;

	SET @totalbudget = 0;

	OPEN C;
	FETCH NEXT FROM C INTO @pname, @pnumber, @plocation;
	WHILE @@FETCH_STATUS = 0 BEGIN
		SELECT @budget = SUM(Hours / 40 * Salary) FROM works_on JOIN employee ON Essn=Ssn WHERE Pno = @pnumber;

		SET @totalbudget += @budget;

		INSERT @ProjectsPerDeptInfo (pname, pnumber, plocation, dnum, budget, totalbudget) VALUES (@pname, @pnumber, @plocation, @dnum, @budget, @totalbudget);

		FETCH NEXT FROM C INTO @pname, @pnumber, @plocation;
	END

CLOSE C;
DEALLOCATE C;

RETURN;
END

-- h

CREATE TRIGGER delete_dep ON department
AFTER INSERT, UPDATE
AS
    SET NOCOUNT ON;
    DECLARE @dno INT
    DECLARE @dname VARCHAR(20)
    DECLARE @mgr_ssn INT
    DECLARE @mgr_start_date DATE
    SELECT @dname=Dname, @mgr_ssn=Mgr_ssn, @mgr_start_date=Mgr_start_date 
    FROM department WHERE Dnumber=@dno;
    DELETE * FROM department WHERE Dnumber=@dno;
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Company' AND TABLE_NAME = 'departments_deleted'))
        BEGIN
            INSERT INTO departments_deleted VALUES @dno, @dname, @mgr_ssn, @mgr_start_date;
        END
    ELSE
        CREATE TABLE departments_deleted(
            Dname VARCHAR(20),
            Dnumber INT NOT NULL,
            Mgr_ssn INT,
            Mgr_start_date DATE,
            FOREIGN KEY(Mgr_ssn) REFERENCES employee(Ssn),
            PRIMARY KEY(Dnumber));
        INSERT INTO departments_deleted VALUES @dno, @dname, @mgr_ssn, @mgr_start_date;
GO

-- i

	As Stored Procedures s�o um conjunto de instru��es SQL guardadas com um determinado nome.
	S�o "single execution plan", ou seja, s�o executadas uma vez e ficam guardadas na mem�ria cache.
	Podem ter argumentos de entrada, par�metros de sa�da e podem retornar "record sets".
	As SPs devem ser utilizadas em situa��es onde � preciso usar fun��es n�o deterministicas (por exemplo GETDATE()), blocos TRY/CATCH ou em situa��es que seja necess�rio o encapsulamento em transa��es.
	Para alterar objetos da base de dados utilizamos as SPs, porque as UDFs n�o podem alterar valores fora do seu alcance.
	Uma SP pode chamar UDFs, mas o contr�rio n�o � poss�vel.

	As User Defined Functions (UDFs) t�m os mesmos benef�cios das Stored Procedures, s�o compilados e otimizados.
	Estas podem ser usadas para incorporar l�gica complexa dentro de uma consulta.
	T�m os mesmos benef�cios das vistas, podem ser utilizadas como fontes de dados nas consultas, e para al�m disso, as UDFs, ao contr�rios das views, aceitam par�metros.
	As UDFs s�o utilizadas quando � necess�rio que seja devolvida uma tabela.

	Vantagens das SPs:
		- s�o extens�veis
		- bom desempenho 
		- integridade de dados
		- seguran�a

	Vantagens das UDFs:
		- s�o extens�veis
		- bom desempenho

	Exemplos de situa��es

		Onde devem ser usadas UDFs:
		- Obter um mecanismo parametriz�vel para a gera��o de views 
		- Juntar tabelas que resultaram de v�rias fun��es ou opera��es

		Onde devem ser usadas SPs:
		- Realizar opera��es de DML (INSERT, UPDATE ou DELETE) em tabelas 
			(n�o locais) da BD
		- Usar fun��es n�o deterministicas
		- Impedir que um erro interrompa necessariamente a execu��o do todas as intru��es seguintes desse bloco, usar SP (com TRY/CATCH)


