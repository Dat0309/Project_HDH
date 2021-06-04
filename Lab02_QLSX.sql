/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Nguyễn Trần Quang Bảo
   MSSV: 1911133
   Ngày: 04/03/2021
*/	
CREATE DATABASE Lab02_QLSX
GO
USE Lab02_QLSX
GO



CREATE TABLE ToSanXuat(
MaTSX CHAR (4) PRIMARY KEY,
TenTSX NVARCHAR(4) NOT NULL UNIQUE
)

CREATE TABLE CongNhan(
MaCN char(5) primary key,
Ho nvarchar(20) not null,
Ten nvarchar (5) not null,
Phai nvarchar(3) not null,
NgaySinh datetime,
MaTSX CHAR(4) REFERENCES ToSanXuat(MaTSX)
)
GO

CREATE TABLE SanPham(
MaSP CHAR (5) PRIMARY KEY,
TenSP NVARCHAR(20) NOT NULL UNIQUE,
DVT NVARCHAR(3)NOT NULL,
TienCong INTEGER NOT NULL CHECK	(TienCong>0)
)
GO

CREATE TABLE ThanhPham(
MaCN CHAR(5) REFERENCES CongNhan(MaCN),
MaSP CHAR(5)REFERENCES SanPham(MaSP),
Ngay DATETIME,
SoLuong INTEGER CHECK (SoLuong>0)
)
GO	
--nhập dữ liệu

INSERT INTO ToSanXuat VALUES('TS01',N'Tổ 1')
INSERT INTO ToSanXuat VALUES('TS02',N'Tổ 2')

GO

SET DATEFORMAT dmy
INSERT INTO CongNhan VALUES ('CN001',N'Nguyễn Trường',N'An',N'Nam','12/05/1981','TS01')
INSERT INTO CongNhan VALUES ('CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01')
INSERT INTO CongNhan VALUES ('CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02')
INSERT INTO CongNhan VALUES ('CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02')
INSERT INTO CongNhan VALUES ('CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01')
GO

INSERT INTO SanPham VALUES('SP001',N'Nồi đất','Cái',10000)
INSERT INTO SanPham VALUES('SP002',N'Chén','Cái',2000)
INSERT INTO SanPham VALUES('SP003',N'Bình gốm nhỏ','Cái',20000)
INSERT INTO SanPham VALUES('SP004',N'Bình gốm lớn','Cái',25000)
GO

SET DATEFORMAT DMY
INSERT INTO ThanhPham VALUES ('CN001','SP001','01/02/2007',10)
INSERT INTO ThanhPham VALUES ('CN002','SP001','01/02/2007',5)
INSERT INTO ThanhPham VALUES ('CN003','SP002','10/01/2007',50)
INSERT INTO ThanhPham VALUES ('CN004','SP003','12/01/2007',10)
INSERT INTO ThanhPham VALUES ('CN005','SP002','12/01/2007',100)
INSERT INTO ThanhPham VALUES ('CN002','SP004','13/02/2007',10)
INSERT INTO ThanhPham VALUES ('CN001','SP003','14/02/2007',15)
INSERT INTO ThanhPham VALUES ('CN003','SP001','15/01/2007',20)
INSERT INTO ThanhPham VALUES ('CN003','SP004','14/02/2007',15)
INSERT INTO ThanhPham VALUES ('CN004','SP002','30/01/2007',100)
INSERT INTO ThanhPham VALUES ('CN005','SP003','01/02/2007',50)
INSERT INTO ThanhPham VALUES ('CN001','SP001','20/02/2007',30)

SELECT * FROM dbo.SanPham
SELECT * FROM dbo.CongNhan
SELECT * FROM dbo.ToSanXuat
SELECT * FROM dbo.ThanhPham

--câu 2
--1) Liệt kê các công nhân theo tổ sản xuất gồm các thông tin: TenTSX, HoTen, NgaySinh, Phai
-- (xếp theo thứ tự tăng dần của tên tổ sản xuất, Tên của công nhân)
SELECT Ho+''+Ten AS HoTen,b.NgaySinh,b.Phai
FROM dbo.ToSanXuat a,dbo.CongNhan b
WHERE a.MaTSX=b.MaTSX
ORDER BY a.TenTSX,b.Ten

--2) Liệt kê các thành phẩm mà công nhân Nguyễn Trường An đã làm được gồm
-- các thông tin sau: TenSP, Ngay, SoLuong, ThanhTien (xếp theo thứ tự tăng dần của ngày).

SELECT c.TenSP,b.SoLuong,b.Ngay,c.TienCong*b.SoLuong AS ThanhTien
FROM dbo.CongNhan a,dbo.ThanhPham b,dbo.SanPham c
WHERE a.MaCN=b.MaCN AND b.MaSP=c.MaSP AND ho=N'Nguyễn Trường' AND ten =N'An'
ORDER BY Ngay

--3) Liệt kê các nhân viên không sản xuất sản phẩm 'Bình gốm lớn'

Select A.MaCN, ho + ' ' + ten AS HoTen, A.Phai, A.NgaySinh, A.MaTSX
From CongNhan A, dbo.SanPham B, dbo.ThanhPham C
WHERE a.MaCN = c.MaCN AND b.MaSP = c.MaSP 
GROUP BY a.MaCN, A.Ho, A.Ten, A.Phai, A.NgaySinh, A.MaTSX
HAVING A.MaCN NOT IN (SELECT f.MaCN
					FROM dbo.SanPham d, dbo.ThanhPham f
					WHERE d.MaSP = f.MaSP AND d.TenSP = N'Bình gốm lớn'
					GROUP BY f.MaCN)

--4) Liệt kê thông tin các công nhân có sản xuất cả 'Nồi đất' và 'Bình gốm nhỏ'

SELECT A.MaCN,ho+' '+ten AS HoTen,a.Phai,A.NgaySinh,A.MaTSX
FROM dbo.CongNhan A,dbo.SanPham b, dbo.ThanhPham c
WHERE  a.MaCN=c.MaCN AND b.MaSP=c.MaSP AND TenSP=N'Nồi đất'
GROUP BY A.MaCN,A.Ho,A.Ten,A.Phai,A.NgaySinh,A.MaTSX
HAVING a.MaCN IN (SELECT f.MaCN
				FROM dbo.SanPham d,dbo.ThanhPham f
				WHERE d.MaSP=f.MaSP AND TenSP=N'Bình gốm nhỏ'
				GROUP BY f.MaCN)

--5) Thông kê số lượng công nhân theo từng tổ sản xuất

SELECT b.MaTSX,COUNT(a.MaCN) AS SoLuongCongNhan
FROM dbo.CongNhan a,dbo.ToSanXuat b
WHERE a.MaTSX=b.MaTSX
GROUP BY b.MaTSX,TenTSX

--6) Tổng số lượng thành phẩm theo từng loại mà mỗi nhân viên làm được (Ho,
-- Ten, TenSP, TongSLThanhPham, TongThanhTien)

SELECT a.MaCN, Ho + ' ' + Ten AS HoTen, B.TenSP, SUM(C.SoLuong) AS TongSLThanhPham, SUM(B.TienCong  * C.SoLuong) AS TongThanhTien
FROM dbo.CongNhan A, dbo.SanPham B, dbo.ThanhPham C
WHERE a.MaCN = C.MaCN AND b.MaSP = c.MaSP
GROUP BY a.MaCN, Ho + ' ' + Ten, B.TenSP

--7) Tổng số tiền công đã trả cho công nhân trong tháng 1 năm 2007

SELECT SUM(b.SoLuong*a.TienCong) AS ThanhTien
FROM dbo.SanPham a, dbo.ThanhPham b
WHERE a.MaSP = b.MaSP AND MONTH(b.Ngay) = '01' AND YEAR(b.Ngay) = 2007

--8)
SELECT b.MaSP, SUM(SoLuong) AS SL 
FROM dbo.SanPham a,dbo.ThanhPham b
WHERE a.MaSP = b.MaSP AND MONTH(b.Ngay) = 02 AND YEAR(b.Ngay) = 2007
GROUP BY b.MaSP
HAVING SUM(SoLuong)>=ALL
(
	SELECT Sum(SoLuong)
	FROM dbo.ThanhPham
	WHERE MONTH(Ngay)='02' AND YEAR(Ngay) = 2007
	GROUP BY MaSP
)
--9)
SELECT  TenSP,SUM(c.SoLuong) AS TongSLSanPham,Ho+N''+Ten AS HoTen
FROM dbo.CongNhan a,dbo.SanPham b,dbo.ThanhPham c	
WHERE a.MaCN=c.MaCN AND b.MaSP=c.MaSP AND TenSP=N'Chén' 
GROUP BY Ho,Ten,TenSP
HAVING MAX(SoLuong)>=ALL(SELECT MAX(SoLuong)
						FROM dbo.ThanhPham A,dbo.SanPham B
						WHERE B.TenSP=N'Chén'
						GROUP BY MaCN)
--10)
SELECT A.MaCN, ho + ' ' + ten AS HoTen, A.Phai, A.NgaySinh,B.TenSP,SUM(B.TienCong*C.SoLuong) AS Tien
From CongNhan A, dbo.SanPham B, dbo.ThanhPham C
WHERE a.MaCN = c.MaCN AND b.MaSP = c.MaSP AND MONTH(ngay)='02'AND A.MaCN='CN002' --AND YEAR(ngay) = 2006
GROUP BY a.MaCN, A.Ho, A.Ten, A.Phai, A.NgaySinh,B.TenSP
--11)
SELECT a.MaCN, Ho+' '+Ten AS HoTen,COUNT(B.MaSP)AS SoLuongSanPham
FROM dbo.CongNhan a,dbo.ThanhPham b,dbo.SanPham c
WHERE a.MaCN=b.MaCN AND b.MaSP=c.MaSP
GROUP BY a.MaCN, Ho,Ten
HAVING COUNT(b.MaSP)>=3
--12)
UPDATE dbo.SanPham
SET TienCong=TienCong+1000
WHERE TenSP=N'Bình gốm nhỏ'
SELECT *FROM dbo.SanPham

UPDATE dbo.SanPham
SET TienCong=TienCong+1000
WHERE TenSP=N'Bình gốm lớn'
SELECT * FROM dbo.SanPham

--13)
INSERT INTO CongNhan VALUES ('CN006',N'LêThị',N'Lan',N'Nữ',NULL,'TS02')
SELECT*FROM dbo.CongNhan

-- Câu 3 Thủ tục và Hàm
-- A: Viết các hàm sau
-- a. Tính tổng số công nhân của một tổ sản xuất cho trước
	