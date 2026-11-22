-- memeriksa user dan role yang aktif
select current_user(), current_role();

-- menguji hak akses role penjualan (harus berhasil)
-- 1. melihat tabel produk dan pelanggan
select * from produk;
select * from pelanggan;

-- melihat tabel selain produk dan pelanggan
select * from pegawai;

-- 2. menambahkan data penjualan
insert into penjualan values
('TRX005', '2026-11-04 03:00:00', 'PLG003', 'PGW001', 85000, 5000, 80000);
select * from penjualan;

-- 3. menambahkan data detail_penjualan
insert into detail_penjualan 
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values 
('TRX005', 'PRD008', 1, 85000, 85000);

-- menguji hak akses penjualan (harus COMMAND DENIED)
-- menguapdate stok produk
update produk set stok = 50 where id_produk = 'PRD001';

-- menghapus data pelanggan
delete from pelanggan where id_pelanggan = 'PLG001';

-- melihat tabel log_stok
select * from log_stok;

-- mengedit tabel produk
alter table produk add column tes varchar (10);
