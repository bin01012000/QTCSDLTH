--2
create function tongSoLuongSinhVien(@ml char(8))
returns int
as
begin
	declare @sl int = 0
	select @sl = count(SINHVIEN.MALOP) from SINHVIEN where SINHVIEN.MALOP = @ml group by SINHVIEN.MALOP
	return @sl
end

print dbo.tongSoLuongSinhVien('HTTT2')

--3

declare @tensv varchar(10), @mamh char(8)
declare cau3 cursor for
select SINHVIEN.TEN, DIEM.MAMH from SINHVIEN join DIEM on SINHVIEN.MASV = DIEM.MASV where DIEM.LAN='1' and DIEM.DIEM < 5
open cau3
fetch next from cau3 into @tensv,@mamh
while @@FETCH_STATUS = 0
begin
	print 'Tên sinh viên : ' + @tensv
	print 'Mã môn học : ' + @mamh
	fetch next from cau3 into @tensv,@mamh
end
close cau3
deallocate cau3


--4
alter table LOP
add SLSV int


go
alter trigger autoUpdateSLSV on SINHVIEN
for insert
as
begin
	declare @sl int, @ml char(8)
	select @ml = MALOP from inserted
	select @sl = count(MALOP) from SINHVIEN where MALOP = @ml
	update LOP set LOP.SLSV = @sl where MALOP = @ml
end

insert into SINHVIEN values('SV9','NGO HOANG','HUY','2000-01-01','nu','TIEN GIANG','123 ALO OLA',0,'MMT2')
select * from LOP
select * from SINHVIEN

--5
go
create trigger xoaSinhVien on SINHVIEN
instead of delete
as
begin 
	declare @masv char(8)
	select @masv =MASV from deleted
	if not exists(select * from SINHVIEN where SINHVIEN.MASV = @masv)
	begin
		print 'Ma sinh vien nay khong co trong danh sach'
		rollback tran
		return
	end
	else
	begin
		if exists(select * from DIEM where DIEM.MASV = @masv)
		begin
			print 'Khong duoc xoa vi sinh vien nay da co diem'
			rollback tran
			return
		end
		else
		begin
			delete from SINHVIEN where SINHVIEN.MASV = @masv
			return
		end
	end
end


delete from SINHVIEN where SINHVIEN.MASV = 'SV9'

--6
go
alter trigger capNhatSoTiet on MONHOC
instead of update
as 
begin
	if update(SOTIET_LT)
	begin
		if exists(select SOTIET_LT from inserted where SOTIET_LT <= 0 or SOTIET_LT > 120)
		begin
			raiserror('Khong hop le',16,1)
			rollback tran
			return
		end
		if exists(select SOTIET_LT from inserted where SOTIET_LT < SOTIET_TH)
		begin
			raiserror('Nhap sai',16,1)
			rollback tran
			return
		end
		else
		begin
			declare @mamh char(8),@sotiet int
			select @mamh = MAMH,@sotiet = SOTIET_LT from inserted
			update MONHOC set MONHOC.SOTIET_LT = @sotiet where MONHOC.MAMH = @mamh
			return
		end
	end
end

update MONHOC set SOTIET_LT = -1 where MAMH ='MAV'