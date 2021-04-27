--3C--
alter proc spDiemLop
@MALOP char (8)
as
begin
	if exists(Select * from SINHVIEN INNER JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV WHERE SINHVIEN.MALOP = @MALOP)
	begin
		Select SINHVIEN.MASV, SINHVIEN.HO + SINHVIEN.TEN as 'HO TEN',DIEM.MAMH, DIEM.DIEM
		from SINHVIEN INNER JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV WHERE SINHVIEN.MALOP = @MALOP
	end
	else
	begin
		if exists(select SINHVIEN.MALOP from SINHVIEN where SINHVIEN.MALOP=@MALOP)
		begin
			print 'Khong co diem cua sinh vien '
		end
		else
		begin
			print 'Khong ton tai ma lop'
		end
	end
end
exec spDiemLop CNPM1

--4A--
go
create proc spSoNguyenTo @n int
as
declare @i int
set @i = 2
begin
	if(@n < 2)
		begin 
			print ' khong phai la snt '
		end
	else
		begin
			while(@i < @n -1 )
				begin 
					if(@n % @i = 0)
					begin
						print ' Khong phai la snt '
						return 0
					end	
					set @i = @i + 1
				end
		end
	print ' la so nguyen to '
end

exec spSoNguyenTo 4


--4B--
go
create proc SpTenMon @MaMon char(8)
as
begin
	if exists(select MONHOC.TENMH from MONHOC where MONHOC.MAMH = @MaMon)
		begin
			select MONHOC.TENMH from MONHOC where MONHOC.MAMH = @MaMon
		end
	else
	begin
	print ' Khong ton tai '
	end
end
exec SpTenMon 'MKTCT'