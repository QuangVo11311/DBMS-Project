use QLBongDa
go

-------Phan 10 Cursor
---Cau58 
declare point cursor
for 
	select mact,hoten,vitri
	from cauthu
open point
declare @ma numeric(18,0), @ten nvarchar(100),@vtri nvarchar(50)
/*	duyet cac dong	*/
fetch next from point into @ma,@ten,@vtri
while @@FETCH_STATUS=0
begin
	print N'Mã Cầu thủ '+ cast(@ma as varchar(50))
	print N'Tên Cầu thủ '+@ten
	print N'Vị trí trên sân '+@vtri
	print ''
	fetch next from point into @ma,@ten,@vtri
end
/*	dong con tro va giai phong vung nho	*/
close point
deallocate point


---Cau59 
declare point cursor
for 
	select maclb,tenclb,tensan
	from caulacbo join SANVD ON CAULACBO.MASAN=SANVD.MASAN	
open point
declare @madb varchar(5), @tendb nvarchar(100),@san nvarchar(50)
/*	duyet cac dong	*/
fetch next from point into @madb,@tendb,@san
while @@FETCH_STATUS=0
begin
	print N'Mã Đội Bóng '+ @madb
	print N'Tên Đội Bóng '+@tendb
	print N'Sân nhà '+@san
	print ''
	fetch next from point into @madb,@tendb,@san
end
/*	dong con tro va giai phong vung nho	*/
close point
deallocate point

---Cau60 
declare point cursor
for 
	select CAULACBO.TENCLB, slnb
	from CAULACBO LEFT join 	
	(	select MACLB, COUNT(mact)	slnb 
		from Cauthu join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
		where tenqg!=N'Việt nam'
		group by CAUTHU.MACLB
	) ct on caulacbo.maclb=ct.maclb
	order by tenclb
open point
declare @tenclb  nvarchar(50), @slnb int
/*	duyet cac dong	*/
fetch next from point into @tenclb,@slnb
while @@FETCH_STATUS=0
begin
	print N'Tên đội bóng '+ @tenclb
	if(@slnb !=0)
	begin
		print N'Số lượng ngoại binh '+  cast(@slnb as varchar(50))
	end
	else
	begin
		print N'Không có ngoại binh '
	end	
	print ''
	fetch next from point into @tenclb,@slnb
end
/*	dong con tro va giai phong vung nho	*/
close point
deallocate point

---Cau61
declare pt cursor
for 
	select CAULACBO.TENCLB, slnb
	from CAULACBO LEFT join 	
	(	select HLV_CLB.MACLB, count(HLV_CLB.MAHLV) slnb
		from HUANLUYENVIEN  h join HLV_CLB on h.MAHLV=HLV_CLB.MAHLV
		where maqg in ( select maqg from quocgia where tenqg!=N'Việt nam')
		group by HLV_CLB.MACLB
	) ct on caulacbo.maclb=ct.maclb
	order by tenclb
open pt
declare @clb  nvarchar(50)
declare @hlvnn int
/*	duyet cac dong	*/
fetch next from pt into @clb,@hlvnn
while @@FETCH_STATUS=0
begin
	print N'Tên đội bóng '+ @clb
	if(@hlvnn !=0)
	begin
		print N'Số lượng huấn luyện viên nước ngoài '+  cast(@hlvnn as varchar(50))
	end
	else
	begin
		print N'Không có huấn luyện viên nước ngoài '
	end	
	print ''
	fetch next from pt into @clb,@hlvnn
end
/*	dong con tro va giai phong vung nho	*/
close pt
deallocate pt

----------#######----------
---Cau62



----Phan 11 FUNCTION
---Cau63
--63a 
CREATE FUNCTION func_TongSoTrai(@mact numeric ) 
RETURNS table 
AS  	
	RETURN 
	(
	select cauthu.mact,tsbanthang
	from cauthu left join (select mact, sum(sotrai)tsbanthang
		from thamgia group by mact) bt
			on cauthu.mact=bt.mact
	where cauthu.mact=@mact
	) 

drop function func_TongSoTrai
select * from dbo.func_TongSoTrai(8)


--63b
CREATE proc proc_VuaPhaLuoi
AS
begin
	declare @bangthongke table(
		mact varchar(5),
		sotrai int	)	
	declare VuaPhaLuoi cursor
	for
	select CAUTHU.MACT from CAUTHU
	open VuaPhaLuoi
	declare @MACT varchar(10) 
	while 0=0
	begin
		fetch next from VuaPhaLuoi into @MACT
		if @@FETCH_STATUS<>0 break
		begin
			insert into @bangthongke
			select *
			from func_TongSoTrai(@MACT)
		end
	end	
	close VuaPhaLuoi
	deallocate VuaPhaLuoi
	
	select top 1 *
	from @bangthongke
	order BY sotrai desc
end

drop proc proc_VuaPhaLuoi
proc_VuaPhaLuoi


---Cau64
--64a
CREATE FUNCTION func_timTongSoTranDau(@mact numeric ) 
RETURNS table 
AS  	
	RETURN 
	(
	--select MATRAN,NGAYTD, TENSAN,C1.TENCLB as Doi1, C2.TENCLB as Doi2,KETQUA
	select count(*) as SoTran
	from (	SELECT * FROM TRANDAU 
			WHERE MACLB1=(select maclb from cauthu where mact=@mact)
				or MACLB2=(select maclb from cauthu where mact=@mact)
		) TD 
		/*	JOIN CAULACBO C1 ON TD.MACLB1=C1.MACLB
			JOIN CAULACBO C2 ON TD.MACLB2=C2.MACLB
			JOIN SANVD ON TD.MASAN=SANVD.MASAN*/
	) 

drop function func_timTongSoTranDau
select * from dbo.func_timTongSoTranDau(1)

--64b
create proc proc_timTongSoTran(@matd varchar)
as
begin
	SELECT HOTEN, (SELECT * FROM dbo.func_timTongSoTranDau(@matd)) SoTranThamGia
	FROM CAUTHU
	WHERE MACT=@matd
end

drop procedure proc_timTongSoTran
proc_timTongSoTran 1

---Cau65
--65a
CREATE FUNCTION func_TiSoBanThang(@matd numeric ) 
RETURNS table 
AS  	
	RETURN 
	(
	select maclb1, CAST( LEFT(KETQUA,CHARINDEX('-',KETQUA)-1) AS INT) as SoBanThangDoi1,
			maclb2, CAST(RIGHT(KETQUA,LEN(KETQUA)-CHARINDEX('-',KETQUA))AS INT) AS SoBanThangDoi2	
	from  trandau
	where matran=@matd
	)
	
--drop function func_TiSoBanThang
select * from dbo.func_TiSoBanThang(1)

--65b
CReate procedure proc_ThongTinTranDau(@matd varchar(10))
as
begin
	select maclb1, maclb2,CAST( SoBanThangDoi1 as varchar(5))+'-'+ cast(SoBanThangDoi2 as varchar(5)) as TiSoBanThang
	from dbo.func_TiSoBanThang(@matd)
end	

drop procedure proc_ThongTinTranDau
proc_ThongTinTranDau 1

---Cau66
--66a
CREATE FUNCTION func_DSCauThuThamGiaTranDau(@matd numeric ) 
RETURNS table 
AS  	
	RETURN 
	(
	select *
	from cauthu 
	where maclb in(
		select maclb1	from trandau	where matran=@matd
		union
		select maclb2 	from trandau	where matran=@matd	)
	)
	
--drop function func_DSCauThuThamGiaTranDau
select * from dbo.func_DSCauThuThamGiaTranDau(1)

--66b
CReate procedure proc_DSCauThuThamGiaTranDau(@matd varchar(10))
as
begin
	select *
	from cauthu 
	where maclb in(
		select maclb1	from trandau	where matran=@matd
		union
		select maclb2 	from trandau	where matran=@matd	)		
end	

drop procedure proc_DSCauThuThamGiaTranDau
proc_DSCauThuThamGiaTranDau 1


---Cau67
--67a
CREATE FUNCTION func_DSCauThu(@madb varchar(10) ) 
RETURNS table 
AS  	
	RETURN 
	(
	select mact,hoten,vitri,ngaysinh,diachi,tenclb,so  
	from   ( select * from cauthu where maclb=@madb) ct
		join (select * from caulacbo where maclb=@madb) db
		on ct.maclb=db.maclb
	)	
--drop function func_DSCauThu
select * from dbo.func_DSCauThu('BBD')		
		

--67b
CReate procedure proc_DSCauThu(@madb varchar(10))
as
begin
	select mact,hoten,vitri,ngaysinh,diachi,tenclb,so  
	from   ( select * from cauthu where maclb=@madb) ct
		join (select * from caulacbo where maclb=@madb) db
		on ct.maclb=db.maclb
		
	return
end	

drop procedure proc_DSCauThu
proc_DSCauThu 'BBD'