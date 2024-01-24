--TAO CO SO DU LIEU
create database Btap2_QLDA

--SU DUNG CO SO DU LIEU
use Btap2_QLDA

--TAO CAC BANG
create table NHANVIEN
(
	MANV varchar(8) not null,
	HONV varchar(50) not null,
    TENLOT varchar(50),
    TENNV varchar(50) not null,
    NGSINH datetime,
    PHAI varchar(5), 
    DCHI varchar(100),
    MLUONG float not null,
    MA_NQL varchar(8),
    PHONG varchar(4)
)

create table THANNHAN
(
	MATN varchar(8) not null,
	MANV varchar(8) not null,
    TENTN varchar(50) not null,
    PHAI varchar(5),
    NGSINH datetime,
    QUANHE varchar(30)
)

create table PHANCONG
(
	MANV varchar(8) not null,
	MADA varchar(6) not null,
	THOIGIAN float
)

create table PHONGBAN
(
	MAPHG varchar(4) not null,
	TENPHG nvarchar(100) not null,
    TRPHG varchar(8),
    NGNC datetime
)

create table DIADIEM_PHG
(
	MAPHG varchar(4) not null,
	DIADIEM varchar(30) not null,
)

create table DEAN
(
	MADA varchar(6) not null,
	MAPHG varchar(4) not null,
	TENDA varchar(50),
    DDIEM_DA varchar(100),
    NGBD_DK datetime,
    NGKT_DK datetime
)

--TAO KHOA CHINH
alter table NHANVIEN add constraint PK_MANV primary key (MANV)
-- alter table THANNHAN add constraint PK_MATN primary key (MATN)
alter table PHONGBAN add constraint PK_MAPHG primary key (MAPHG)
alter table DIADIEM_PHG add constraint PK_DIADIEM_PHG primary key (MAPHG,DIADIEM)
alter table PHANCONG add constraint PK_PHANCONG primary key (MANV,MADA)
alter table DEAN add constraint PK_MADA primary key (MADA)

--TAO KHOA NGOAI
alter table NHANVIEN add constraint FK_NHANVIEN_PHONGBAN foreign key (PHONG) references PHONGBAN(MAPHG)
alter table NHANVIEN add constraint FK_NHANVIEN_NHANVIEN foreign key (MA_NQL) references NHANVIEN(MANV)
alter table PHONGBAN add constraint FK_PHONGBAN_NHANVIEN foreign key (TRPHG) references NHANVIEN(MANV)
alter table DIADIEM_PHG add constraint FK_DIADIEMPHG_PHONGBAN foreign key (MAPHG) references PHONGBAN(MAPHG)
alter table THANNHAN add constraint FK_THANNHAN_NHANVIEN foreign key (MANV) references NHANVIEN(MANV)
alter table PHANCONG add constraint FK_PHANCONG_NHANVIEN foreign key (MANV) references NHANVIEN(MANV)
alter table PHANCONG add constraint FK_PHANCONG_DEAN foreign key (MADA) references DEAN(MADA)
alter table DEAN add constraint FK_DEAN_PHONGBAN foreign key (MAPHG) references PHONGBAN(MAPHG)

----------------------------------------------------------------------------------------------------------------
--NHAP DU LIEU
--NHAP DU LIEU TABLE: NHANVIEN
BEGIN
    ALTER TABLE NHANVIEN NOCHECK CONSTRAINT ALL -- Tắt kiểm tra ràng buộc dữ liệu

    insert into NHANVIEN values ('001','Vuong','Ngoc', 'Quyen', 10-22-1957, 'Nu', '450 Trung Vuong, Ha Noi', 3000000, null, 'QL')
    insert into NHANVIEN values ('002','Nguyen','Thanh', 'Tung', 01-09-1955, 'Nam', '731 Tran Hung Dao, Q1, TpHCM', 2500000, '001', 'NC')
    insert into NHANVIEN values ('003','Le','Thi', 'Nhan', 12-18-1960, 'Nu', '291 Ho Van Hue, QPN, TpHCM', 2500000, '001', 'DH')
    insert into NHANVIEN values ('004','Dinh','Ba', 'Tien', 01-09-1968, 'Nam', '638 Nguyen Van Cu, Q5, TpHCM', 2200000, '002', 'NC')
    insert into NHANVIEN values ('005','Bui','Thuy', 'Vu', 07-19-1972, 'Nam', '332 Nguyen Thai Hoc, Q1, TpHCM', 2200000, '003', 'DH')
    insert into NHANVIEN values ('006','Nguyen','Manh', 'Hung', 09-15-1973, 'Nam', '978 Ba Ria, Vung Tau', 2000000, '002', 'NC')
    insert into NHANVIEN values ('007','Tran','Thanh', 'Tam', 07-31-1975, 'Nu', '543 Mai Thi Luu, Q1, TpHCM', 2200000, '002', 'NC')
    insert into NHANVIEN values ('008','Tran','Hong', 'Van', 07-04-1976, 'Nu', '980 Le Hong Phong, Q10, TpHCM', 1800000, '004', 'NC')

    ALTER TABLE NHANVIEN CHECK CONSTRAINT ALL -- Bật kiểm tra ràng buộc dữ liệu
END

--NHAP DU LIEU TABLE: THANNHAN
BEGIN
    ALTER TABLE THANNHAN NOCHECK CONSTRAINT ALL -- Tắt kiểm tra ràng buộc dữ liệu

    insert into THANNHAN values ('1', '003', 'Tran Minh Tien', 'Nam', 12-11-1990, 'Con')
    insert into THANNHAN values ('2', '003', 'Tran Ngoc Linh', 'Nu', 03-10-1993, 'Con')
    insert into THANNHAN values ('3', '003', 'Tran Minh Long', 'Nam', 10-10-1957, 'Vo Chong')
    insert into THANNHAN values ('1', '001', 'Le Nhat Minh', 'Nam', 04-27-1955, 'Vo Chong')
    insert into THANNHAN values ('1', '002', 'Le Hoai Thuong', 'Nu', 12-05-1960, 'Vo Chong')
    insert into THANNHAN values ('1', '004', 'Le Thi Phung', 'Nu', 12-23-1972, 'Vo Chong')
    insert into THANNHAN values ('1', '005', 'Tran Thu Hong', 'Nu', 04-11-1978, 'Vo Chong')
    insert into THANNHAN values ('2', '005', 'Tran Manh Tam', 'Nam', 01-13-2003, 'Con')


    ALTER TABLE THANNHAN CHECK CONSTRAINT ALL -- Bật kiểm tra ràng buộc dữ liệu
END


--NHAP DU LIEU TABLE: PHONGBAN
BEGIN
    ALTER TABLE PHONGBAN NOCHECK CONSTRAINT ALL -- Tắt kiểm tra ràng buộc dữ liệu

    insert into PHONGBAN values ('QL', 'Quan Ly', '001', 05-22-2000)    
    insert into PHONGBAN values ('DH', 'Dieu Hanh', '003', 10-10-2002)    
    insert into PHONGBAN values ('NC', 'Nghien Cuu', '002', 03-15-2002)

    ALTER TABLE PHONGBAN CHECK CONSTRAINT ALL -- Bật kiểm tra ràng buộc dữ liệu
END

--NHAP DU LIEU TABLE: DIADIEM_PHG
BEGIN
    ALTER TABLE DIADIEM_PHG NOCHECK CONSTRAINT ALL -- Tắt kiểm tra ràng buộc dữ liệu

    insert into DIADIEM_PHG values ('NC','HANOI') 
    insert into DIADIEM_PHG values ('NC','TPHCM')    
    insert into DIADIEM_PHG values ('QL','TPHCM')    
    insert into DIADIEM_PHG values ('DH','HANOI')    
    insert into DIADIEM_PHG values ('DH','TPHCM')    
    insert into DIADIEM_PHG values ('DH','NHATRANG')    

    ALTER TABLE DIADIEM_PHG CHECK CONSTRAINT ALL -- Bật kiểm tra ràng buộc dữ liệu
END

--NHAP DU LIEU TABLE: DEAN
BEGIN
    ALTER TABLE DEAN NOCHECK CONSTRAINT ALL -- Tắt kiểm tra ràng buộc dữ liệu

    insert into DEAN values ('TH001', 'NC', 'Tin hoc hoa 1', 'HANOI', 02-01-2003, 02-01-2004) 
    insert into DEAN values ('TH002', 'NC', 'Tin hoc hoa 2', 'TPHCM', 02-01-2003, 02-01-2004) 
    insert into DEAN values ('DT001', 'DH', 'Dao tao 1', 'NHATRANG', 02-01-2003, 02-01-2004) 
    insert into DEAN values ('DT002', 'DH', 'Dao tao 2', 'HANOI', 02-01-2003, 02-01-2004) 

    ALTER TABLE DEAN CHECK CONSTRAINT ALL -- Bật kiểm tra ràng buộc dữ liệu
END

--NHAP DU LIEU TABLE: PHANCONG
BEGIN
    ALTER TABLE PHANCONG NOCHECK CONSTRAINT ALL -- Tắt kiểm tra ràng buộc dữ liệu

    insert into PHANCONG values ('001','TH001', 30.0)
    insert into PHANCONG values ('001','TH002', 12.5)
    insert into PHANCONG values ('002','TH001', 10.0)
    insert into PHANCONG values ('002','TH002', 10.0)
    insert into PHANCONG values ('002','DT001', 10.0)
    insert into PHANCONG values ('002','DT002', 10.0)
    insert into PHANCONG values ('003','TH001', 37.5)
    insert into PHANCONG values ('004','DT001', 22.5)
    insert into PHANCONG values ('004','DT002', 10.0)
    insert into PHANCONG values ('006','DT001', 30.5)
    insert into PHANCONG values ('007','TH001', 20.0)
    insert into PHANCONG values ('007','TH002', 10.0)
    insert into PHANCONG values ('008','TH001', 10.0)
    insert into PHANCONG values ('008','DT002', 12.5)

    ALTER TABLE PHANCONG CHECK CONSTRAINT ALL -- Bật kiểm tra ràng buộc dữ liệu
END

-- DROP DATABASE Btap2_QLDA

SELECT * FROM NHANVIEN
SELECT * FROM THANNHAN
SELECT * FROM PHONGBAN
SELECT * FROM DIADIEM_PHG
SELECT * FROM DEAN
SELECT * FROM PHANCONG