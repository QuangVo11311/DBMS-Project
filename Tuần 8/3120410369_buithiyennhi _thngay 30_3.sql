--1a
CREATE PROCEDURE tr_matruong @matr nvarchar(50)
AS
BEGIN 
IF EXISTS (
SELECT MATR TENTR COUNT(SOBD)
FROM TRUONG TR, THISINH TS
 WHERE TR.MATR= @matr and TR.MATR=TS.MATR )
 end 
 go 
--1b 
create function tr_matruong(@matr int) (@tentruong int) (@
return table 
as
begin 
if exists ( select * COUNT(SOBD)
			from TRUONG TR, THISINH TS, KETQUA KQ , MONTHI M
			WHERE TR.MATR=@matr and TR.MATR=TS.MATR AND TS.SOBD=KQ.SOBD 
			AND KQ.DIEM <=1 
			HAVING KQ.DIEM <=1 )
			
END 
GO 
--1C 
CREATE TRIGGER tg_taorangbuoc ON dbo.THISINH
AFTER UPDATE, INSERT
AS
    IF(NOT EXISTS (SELECT * FROM THISINH TS WHERE YEAR(GETDATE)-YEAR(TS.NGAYSINH)>18 AND TS.NAMDUTHI = YEAR(GETDATE)))
    BEGIN
        RAISERROR('THI SINH KHONG HOP LE',16,1)
        ROLLBACK TRAN
    END
GO