-- Cau a
CREATE PROC proc_tongTienPhieuDatHang
@maPDH varchar(20)
AS
    BEGIN
        DECLARE @tongTien float
        SELECT @tongTien = SUM(cthd.DONGGIA) FROM PHIEUDATHANG phd, CTDATHANG cthd
            WHERE phd.SOPHIEUDH = cthd.SOPHIEUDH AND phd.SOPHIEUDH = @maPDH
        PRINT @tongTien
        RETURN @tongTien
    END
GO

-- Cau b
CREATE TRIGGER trg_SLGiao ON dbo.CTGIAOHANG
INSTEAD OF INSERT
AS
    BEGIN
        DECLARE @maHH varchar(20), @maGiaoHang varchar(20), @slGiao int
        DECLARE @maDatHang varchar(20)

        -- Lấy ra thông tin giao hàng, thông tin lấy ra từ bảng CTGiaoHang
        SELECT @maHH = MAHH FROM inserted
        SELECT @maGiaoHang = SOPHIEUGIAO FROM inserted
        SELECT @slGiao = SLGIAO FROM inserted
        
        -- Lấy ra mã đặt hàng từ phiếu giao hàng, lấy ra từ bảng PhieuGiaoHang
        SELECT @maDatHang = SOPHIEUDH FROM PHIEUGIAOHANG WHERE SOPHIEUGH = @maGiaoHang
        
        -- Kiểm tra hàng hóa được insert trong bảng GIao hàng có thỏa với dữ liệu trong Đặt hàng hay không
        IF EXISTS(SELECT * FROM CTDATHANG WHERE MAHH = @maHH AND SOPHIEUDH = @maDatHang AND SLDAT >= @slGiao)
            BEGIN
                INSERT INTO dbo.CTGIAOHANG
                VALUES(@maHH, @maGiaoHang, @slGiao)
                RETURN
            END
        ELSE
            BEGIN
                ROLLBACK TRANSACTION
                PRINT N'Số lượng giao không được lớn hơn số lượng hàng hóa được đặt tương ứng'
                RETURN
            END
    END
GO

-- Cau c
BEGIN
    -- T1
    BEGIN TRANSACTION
    SET TRANSACTION ISOLATION LEVEL
    READ UNCOMMITTED
    EXECUTE proc_ThemSuaHH 'HH004', 'Mắm tôm', 'KF315', '912'
    COMMIT TRANSACTION
    WAITFOR DELAY '00:00:10.000'
    
    -- T2
    BEGIN TRANSACTION
    SET TRANSACTION ISOLATION LEVEL
    READ UNCOMMITTED
    EXECUTE proc_ThemSuaHH 'HH004', 'Mắm tôm', 'KF315', '40000'
    COMMIT TRANSACTION
    WAITFOR DELAY '00:00:10.000'
    
    -- T2
    BEGIN TRANSACTION
    SET TRANSACTION ISOLATION LEVEL
    READ UNCOMMITTED
    EXECUTE proc_ThemSuaHH 'HH009', 'Mắm tôm nhĩ', 'KF315', '2937'
    COMMIT TRANSACTION
    WAITFOR DELAY '00:00:10.000'
    
    -- T1
    BEGIN TRANSACTION
    SET TRANSACTION ISOLATION LEVEL
    READ UNCOMMITTED
    EXECUTE proc_ThemSuaHH 'HH012', 'Mắm thái', 'KF315', '555'
    COMMIT TRANSACTION
    WAITFOR DELAY '00:00:10.000'
END

