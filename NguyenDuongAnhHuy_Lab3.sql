--Cau5_Lab2--
go
alter proc spSuaMaSV @MASVCU char(8), @MASVMOI char(8)
as
begin
	if exists(select SINHVIEN.MASV from SINHVIEN where  @MASVCU = SINHVIEN.MASV)
		begin
		select * into #temp_SV from SINHVIEN where @MASVCU = SINHVIEN.MASV
		update #temp_SV set #temp_SV.MASV = @MASVMOI
		insert into SINHVIEN
		select * from #temp_SV
		drop table #temp_SV
		if exists(select DIEM.MASV from DIEM where  @MASVCU = DIEM.MASV)
			begin
				select * into #temp_Diem from DIEM where @MASVCU = DIEM.MASV
				delete from DIEM where @MASVCU = DIEM.MASV
				update #temp_Diem 
				set #temp_Diem.MASV = @MASVMOI
				insert into DIEM 
		select * from #temp_Diem
		drop table #temp_Diem
			end
		else
			begin
				print'Khong ton tai trong bang diem'
			end	
		delete from SINHVIEN where @MASVCU = SINHVIEN.MASV
		
		
		end
	else
		begin
			print'Khong thay'
		end
end


exec spSuaMaSv SV20,SV1




--cau 4_Lab3 --
create proc sp_ThemMH
@MaMH char(8),
@TenMH char(30),
@SoTiet_LT int,
@SoTiet_TH int
as 
begin
	if(exists (select* from MONHOC mh where mh.TENMH = @TENMH))
	begin
		print N'Ten mon hoc ' +@TenMH + N'da ton tai '
		return 0
	end 
	insert into MONHOC (MaMH , TenMH , SoTiet_LT ,SoTiet_TH )
	values (@MaMH , @TenMH , @SoTiet_LT , @SoTiet_TH)
	return 0
end

exec sp_ThemMH 'T06' , 'toan' , '5' ,'3'
select * from Monhoc



--cau 5_Lab3 --
create proc sp_SuaDiem
@masv char(30),
@mamh char(8),
@lan int ,
@diemsua float 
as
begin
	if(@diemsua < 0 )
		print ' Sai gia tri diem thi '
	else
	begin
		if exists (select * from DIEM where MASV = @masv  and MAMH = @mamh and LAN = @lan)
		begin
			update DIEM
			set DIEM.DIEM = @diemsua
			where masv = @masv and MAMH = @mamh and lan = @LAN
			end
		else
			print 'thong tin sai '
	end
end
