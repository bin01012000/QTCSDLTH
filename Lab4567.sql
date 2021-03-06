use master
go
if exists (select name from sysdatabases where name='QuanLyLuong')
	drop database QuanLyLuong
go
create database QuanLyLuong
go
use QuanLyLuong
go

create table NhanVien
(
MaNhanVien nvarchar (50),
TenNhanVien nvarchar (30),
NgaySinh datetime,
LuongCoBan float,
MaPhongBan nvarchar (50),
MaTD nvarchar (50),
SDT char(20),
primary key (MaNhanVien)
);
Create table TrinhDo
(	
MaTD nvarchar (50),
LuongCB Float,
primary key (MaTD)
);

create table PhongBan
(
MaPhongBan nvarchar (50),
TenPhongBan nvarchar (30),
MaTruongPhong nvarchar (50),
SDT char(20),
primary key (MaPhongBan),
);

create table DeAn
(
MaDeAn nvarchar (50),
TenDeAn nvarchar (50),
NganSach float,
MaPhongBan nvarchar (50),
primary key (MaDeAn)
);

create table ThamGia 
(
MaNhanVien nvarchar (50),
MaDeAn nvarchar (50),
NhiemVu nvarchar (50),
ThoiGian int,--số ngày hoàn thành
primary key (MaNhanVien, MaDeAn)
);

CREATE TABLE BangLuong(
        MSBL numeric(18, 0) NOT NULL,
        MaNhanVien nvarchar(50) NULL,
        SoNgayCong numeric(18, 0) NULL,
        TienTamUng money NULL,--số tiền tạm ứng
        TienHoanTra money NULL,--Số tiền đã hoàn trả
        NgayMuon datetime NULL,--ngày nhận tạm ứng
        NgayHetHan datetime NULL,--Hạn chót trả tiền
        NgayTinhLuong datetime NULL,--ngày tháng tính bảng lương
        LuongThucLanh money NULL,--số tiền lãnh được sau khi tính lương tương ứng với số ngày công đã làm và hoàn trả tạm ứng
		primary key (MSBL)
);

insert into TrinhDo values( 'TC',2500000 )
insert into TrinhDo values( 'CD',3500000 )
insert into TrinhDo values( 'KS',4500000 )
insert into TrinhDo values( 'ThS',5500000 )
insert into TrinhDo values( 'TS',6500000 )

insert into PhongBan values ('PB1', N'Tổ chức hành chính', 'NV03','1151155555');
insert into PhongBan values ('PB2', N'Công tác sinh viên', 'NV05','1159999911');
insert into PhongBan values ('PB3', N'Đào tạo', 'NV01','115111111');

insert into NhanVien values ('NV01', N'Đặng Cao Trí', '02/13/1978', 3000000, 'PB1','KS','115111111');
insert into NhanVien values ('NV02', N'Hoàng Nhật Nam', '06/28/1957', 2500000, 'PB1','KS','2222222222');
insert into NhanVien values ('NV03', N'Lê Minh Trí', '03/30/1967', 2500000, 'PB2','CD','3333333333');
insert into NhanVien values ('NV04', N'Trương Thế Khải', '08/06/1980', 2500000, 'PB2','CD','4444444444');
insert into NhanVien values ('NV05', N'Vũ Bình Nguyên', '10/11/1981', 3500000, 'PB3','TC','555555555');
insert into NhanVien values ('NV06', N'Trần Ngọc Thuy Dương', '02/01/1968', 8000000, 'PB3','CD','6666666666');
insert into NhanVien values ('NV07', N'Nguyễn Thị Thanh', '05/09/1971', 5500000, 'PB1','TS','77777777777');
insert into NhanVien values ('NV08', N'Lê Mai Nguyên', '11/09/1978', 4500000, 'PB3','TS','8888888888');
insert into NhanVien values ('NV09', N'Dương Hà Anh', '05/13/1983', 3000000, 'PB1','ThS','999999999');
insert into NhanVien values ('NV10', N'Lương Thanh Minh', '02/28/1980', 2500000, 'PB2','ThS','333333666');

insert into DeAn values ('DA01', N'Đào tạo cán bộ tại nước ngoài', 10000000000, 'PB3');
insert into DeAn values ('DA02', N'Nâng cấp phòng máy thực hành', 500000000, 'PB2');
insert into DeAn values ('DA03', N'Mở hệ đào tạo ITECH', 100000000, 'PB1');

insert into ThamGia values ('NV05', 'DA01', N'Chỉ trì dự án', 12);
insert into ThamGia values ('NV06', 'DA01', N'Thư ký', 12);
insert into ThamGia values ('NV03', 'DA02', N'Chỉ trì dự án', 36);
insert into ThamGia values ('NV04', 'DA02', N'Thư ký', 36);
insert into ThamGia values ('NV01', 'DA03', N'Chỉ trì dự án', 12);
insert into ThamGia values ('NV02', 'DA03', N'Thư ký', 12);

insert into BangLuong values ( 1, 'NV01', 24, 1000000, 500000  ,getdate() ,getdate() + 30 ,Getdate(),NULL );
insert into BangLuong values ( 2, 'NV02', 24, 0, 0  ,NULL ,NULL ,Getdate(),NULL  );
insert into BangLuong values ( 3, 'NV03', 24, 0, 0  ,NULL ,NULL ,Getdate(),NULL  );
insert into BangLuong values ( 4, 'NV04', 24, 0, 0  ,NULL ,NULL ,Getdate(),NULL  );
insert into BangLuong values ( 5, 'NV05', 24, 0, 0  ,NULL ,NULL ,Getdate() ,NULL );
insert into BangLuong values ( 6, 'NV06', 24, 0, 0  ,NULL ,NULL ,Getdate(),NULL  );
insert into BangLuong values ( 7, 'NV07', 24, 3000000, 2000000  ,Getdate() ,getdate() + 30 ,Getdate() ,NULL );
insert into BangLuong values ( 8, 'NV08', 24, 0, 0  ,NULL ,NULL ,Getdate(),NULL  );
insert into BangLuong values ( 9, 'NV09', 24, 0, 0  ,NULL ,NULL ,Getdate()+ 31,NULL  );
insert into BangLuong values ( 10, 'NV10', 24, 0, 0  ,NULL ,NULL ,Getdate()+ 31 ,NULL );
insert into BangLuong values ( 11, 'NV01', 24, 2000000, 1000000  ,getdate() - 15,getdate() + 15 ,Getdate()+31,NULL  );
insert into BangLuong values ( 12, 'NV02', 24, 0, 0  ,NULL ,NULL ,Getdate()+31 ,NULL );
insert into BangLuong values ( 13, 'NV03', 24, 0, 0  ,NULL ,NULL ,Getdate()+31 ,NULL );
insert into BangLuong values ( 14, 'NV04', 24, 0, 0  ,NULL ,NULL ,Getdate()+31,NULL  );

alter table NhanVien add constraint FK_NhanVien_PhongBan
foreign key (MaPhongBan) references PhongBan (MaPhongBan);

alter table PhongBan add constraint FK_PhongBan_NhanVien
foreign key (MaTruongPhong) references NhanVien(MaNhanVien);

alter table DeAn add constraint FK_DeAn_PhongBan
foreign key (MaPhongBan) references PhongBan(MaPhongBan);

alter table ThamGia add constraint FK_ThamGia_NhanVien
foreign key (MaNhanVien) references NhanVien(MaNhanVien);

alter table ThamGia add constraint FK_ThamGia_DeAn
foreign key (MaDeAn) references DeAn(MaDeAn);

ALTER TABLE BangLuong  ADD  CONSTRAINT FK_BangLuong_NhanVien 
FOREIGN KEY(MaNhanVien) REFERENCES NhanVien (MaNhanVien)

ALTER TABLE NhanVien  ADD  CONSTRAINT FK_TrinhDo_NhanVien 
FOREIGN KEY(MaTD) REFERENCES TrinhDo (MaTD)
