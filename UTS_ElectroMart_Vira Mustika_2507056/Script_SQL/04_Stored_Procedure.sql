-- Tugas 4. Stored Procedure
-- 1. Membuat SP_Tampil Produk
delimiter //
create procedure sp_tampil_produk()
begin
	select * from produk;
end//
delimiter ;

-- memanggil sp_tampil_produk
call sp_tampil_produk();

-- 2. Membuat SP_Tambah_Produk
delimiter //
create procedure sp_tambah_produk(
	in p_id_produk varchar (10),
	in p_nama_produk varchar (100),
	in p_kategori varchar (50),
	in p_harga decimal (12,2),
	in p_stok int
	)
begin
	insert into produk values (p_id_produk, p_nama_produk, p_kategori, p_harga, p_stok);
	select * from produk;
end//
delimiter ;

-- memanggil sp_tambah_produk dengan data yang berbeda
call sp_tambah_produk('PRD011', 'Webcam HD Logitech C270', 'Aksesoris', 450000, 15);
call sp_tambah_produk('PRD012', 'Monitor LG 24 Inch IPS', 'Monitor', 1850000, 8);

-- membuat sp_ubah_harga
delimiter //
create procedure sp_ubah_harga (
	in p_id varchar(10),
    in p_harga_baru decimal(12,2)	
)
begin
	update produk set harga = p_harga_baru where id_produk = p_id;
end//
delimiter ;

-- memanggil sp_ubah_harga
call sp_ubah_harga('PRD011', 425000);
call sp_ubah_harga('PRD012', 1790000);

call sp_tampil_produk;

-- hapus procedure
drop procedure sp_ubah_harga;

-- memeriksa procedure yang tersedia
show procedure status where db = 'electromart';