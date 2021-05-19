--2a
go
alter trigger ktXoa
on NhanVien
for delete
as
	declare @manv nvarchar(50)
	select @manv = MaNhanVien from deleted
	--print ('Đã xóa thông tin thành công!')
	print ('Đã xóa ' + @manv + ' thành công')


insert into NhanVien
values('NV14',N'Lý Tài','02/28/1980',2500000,'PB3','CD', '0123456');

delete from NhanVien
where NhanVien.MaNhanVien = 'NV11'


--2b
go
alter trigger ktSua
on NhanVien
for update
as
	declare @manv nvarchar(50)
	select @manv = MaNhanVien from inserted
	print('Sửa thông tin '+@manv+' thành công')


update NhanVien
set MaNhanVien = 'NV13'
where MaNhanVien = 'NV12'

--3a
go
create trigger inBangSua
on NhanVien
for update
as
	select MaNhanVien from inserted




update NhanVien
set MaPhongBan = 'PB3'
where MaPhongBan = 'PB1'


--3b

go
create trigger inBangSuaA
on NhanVien
for update
as
	select MaNhanVien,PhongBan.TenPhongBan from inserted join PhongBan on PhongBan.MaPhongBan = inserted.MaPhongBan



update NhanVien
set MaPhongBan = 'PB1'
where MaPhongBan = 'PB4'

update NhanVien
set MaPhongBan = 'PB4'
where MaPhongBan = 'PB1'


insert into PhongBan
values('PB4','Do Te','NV01','152121554')
--3c

go
alter trigger inBangSuaB
on NhanVien
for update
as
	declare @tenpbcu nvarchar(30)
	select @tenpbcu =  TenPhongBan from deleted join PhongBan on deleted.MaPhongBan = PhongBan.MaPhongBan
	select MaNhanVien, @tenpbcu as 'Tên phòng ban cũ' from deleted

--3d
go
create trigger inBangSuaC
on NhanVien
for update
as
	declare @tenpbcu nvarchar(30)
	select @tenpbcu =  TenPhongBan from deleted join PhongBan on deleted.MaPhongBan = PhongBan.MaPhongBan
	select MaNhanVien, @tenpbcu as 'Tên phòng ban cũ',PhongBan.TenPhongBan as'Tên phòng ban mới' from inserted join PhongBan on inserted.MaPhongBan = PhongBan.MaPhongBan


--4
alter table PhongBan
add soluongNV int


declare soluong cursor for
select MaPhongBan from NhanVien
open soluong
declare @mapb nvarchar(50)
fetch next from soluong into @mapb
while @@FETCH_STATUS = 0
begin	
	update PhongBan set PhongBan.soluongNV = PhongBan.soluongNV + 1 where PhongBan.MaPhongBan = @mapb
	fetch next from soluong into @mapb
end
close soluong
deallocate soluong




go
alter trigger autoUpdate
on NhanVien
for insert,delete,update
as
	declare @soluong int = 0
	if update(MaPhongBan)
	begin
	if exists(select * from inserted)
		begin
					declare soluong cursor for
					select MaPhongBan from inserted
					open soluong
					declare @mapb nvarchar(50)
					fetch next from soluong into @mapb
					while @@FETCH_STATUS = 0
					begin	
						update PhongBan set PhongBan.soluongNV = PhongBan.soluongNV + 1 where PhongBan.MaPhongBan = @mapb
						fetch next from soluong into @mapb
					end
					close soluong
					deallocate soluong
		end
	if exists(select * from deleted)
		begin
					declare soluong cursor for
					select MaPhongBan from deleted
					open soluong
					declare @mapb2 nvarchar(50)
					fetch next from soluong into @mapb2
					while @@FETCH_STATUS = 0
					begin	
						update PhongBan set PhongBan.soluongNV = PhongBan.soluongNV - 1 where PhongBan.MaPhongBan = @mapb2
						fetch next from soluong into @mapb2
					end
					close soluong
					deallocate soluong
		end
		end
update NhanVien set NhanVien.MaPhongBan = 'PB1' where NhanVien.MaPhongBan = 'PB2'
	