-- memeriksa user dan role yang aktif
select current_user(), current_role();

-- menguji hak akses bagian gudang (berhasil)
-- 1. melihat tabel produk
select * from produk;
-- 2. memperbarui stok
update produk set stok = 30 where id_produk = 'PRD006';
select * from produk;
-- mengembalikan stok 
update produk set stok = 2 where id_produk = 'PRD006';

-- menguji hak akses bagian gudang (harus COMMAND DENIED)
-- 3. mengupdate harga produk
update produk set harga = 98000 where id_produk = 'PRD004';

-- 4. menambah produk baru
insert into produk values ('PRD001', 'Laptop Asus ZenBook 14', 'Laptop', 14500000, 15);

-- 5. menghapus produk
delete from produk where id_produk = 'PRD002';

-- 6. melihat tabel penjualan
select * from penjualan;



