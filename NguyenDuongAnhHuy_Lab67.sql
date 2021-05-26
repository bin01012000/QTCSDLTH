--5a
go
create trigger kiemTraThemMoi
on PhongBan
for insert
as
begin
	declare @tenpb nvarchar(50)
	select @tenpb = TenPhongBan from inserted
	if exists(select * from inserted)
		print 'Ten phong ban da co trong csdl'
end

--5b
go
create trigger kiemTraThemMoi2
on PhongBan
instead of insert
as
begin
	declare @tenpb nvarchar(50)
	select @tenpb = TenPhongBan from inserted
	if exists(select * from inserted)
	begin
		rollback
		print 'Da co ten phong ban nay trong csdl'
	end
	else
	begin
		insert into PhongBan select * from inserted
	end
end


--4
alter table PhongBan
add soluongNV int

go
create trigger c4
on NhanVien
for insert,update,delete
as
begin
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
				close soluong
				deallocate soluong
			end
		end
	end
end

--lab7_2
declare tinhluongall cursor for
select MSBL,NhanVien.LuongCoBan,NhanVien.MaNhanVien,TienTamUng,TienHoanTra,SoNgayCong from BangLuong full join NhanVien on BangLuong.MaNhanVien = NhanVien.MaNhanVien
open tinhluongall
declare @msbl numeric, @lcb float,@manv nvarchar(50),@ttu money, @tht money, @snc numeric
fetch next from tinhluongall into @msbl, @lcb,@manv,@ttu,@tht,@snc
while @@FETCH_STATUS = 0
begin
	update BangLuong
	set LuongThucLanh = @lcb  * @snc / 24 - @ttu + @tht where MaNhanVien = @manv 
	fetch next from tinhluongall into @msbl, @lcb,@manv,@ttu,@tht,@snc
end
close tinhluongall
deallocate tinhluongall


select * from BangLuong

go
create trigger c72
on BangLuong
instead of update
as
begin
	if update(SoNgayCong)
	begin
		if exists(select month(NgayTinhLuong), year(NgayTinhLuong) from inserted where MONTH(NgayTinhLuong) < MONTH(getdate()) and YEAR(NgayTinhLuong) < year(getdate()))
		begin
			raiserror( ' Khong cho phep cap nhat ngay cong thang cu da tinh luong ',16,1)
			rollback tran
		end
		if exists(select month(NgayTinhLuong), year(NgayTinhLuong) from inserted where MONTH(NgayTinhLuong) = MONTH(getdate()) and YEAR(NgayTinhLuong) = year(getdate()))
		begin
			if(select SoNgayCong from inserted) < 0
			begin
				raiserror ('So ngay cong <0, khong hop le',16,1)
				rollback tran
				return
			end
			else
			begin
				declare @msbl nvarchar(50),@snc int
				select @msbl = MSBL,@snc = SoNgayCong from inserted
				update BangLuong
				set SoNgayCong = @snc where MSBL = @msbl
				return
			end
		end
	end
end

--Lab7_4
go
create trigger c74
on NhanVien
instead of delete
as
begin
	declare @manv nvarchar(50)
	select @manv = MaNhanVien from deleted
	if not exists(select * from NhanVien where MaNhanVien = @manv)
	begin
		raiserror ('Ma nhan vien nay khong ton tai',16,1)
		rollback tran
		return
	end
	else
	begin
		if not exists(select * from BangLuong join deleted on BangLuong.MaNhanVien = deleted.MaNhanVien where BangLuong.MaNhanVien = @manv)
		begin
			delete from NhanVien
			where MaNhanVien = @manv
			return
		end
		else
		begin
			raiserror ('da co trong bang luong',16,1)
			rollback tran
			return
		end
	end
end


--Lab7_5
go
alter trigger c75
on NhanVien
instead of update
as
begin
	declare @lcbc float
	
	if update(LuongCoBan)
	begin
		declare @manv nvarchar(50),@lcb float, @lcbc float
		select @manv = MaNhanVien,@lcb = LuongCoBan from inserted
		if (@lcbc > @lcb)
		begin
			print 'Luong moi thap hon luong cu'
		end
		update BangLuong
		set LuongThucLanh = ((@lcb * SoNgayCong) / 24 - TienTamUng + TienHoanTra) where BangLuong.MaNhanVien = @manv
	end
end

update NhanVien
set LuongCoBan = 10000 where MaNhanVien ='NV01'

select * from BangLuong
select * from NhanVien