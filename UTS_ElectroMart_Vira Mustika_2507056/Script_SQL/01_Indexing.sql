-- 1. single column index
-- a. index kategori produk
create index idx_kategori_produk on produk (kategori);
show index from produk; -- melihat index pada tabel produk
select * from produk where kategori = 'Aksesoris';
-- perbandingan memakai index dan tanpa index
explain select * from produk where kategori = 'Aksesoris';
explain select * from produk ignore index (idx_kategori_produk) where kategori = 'Aksesoris';

-- b. index nama pelanggan
create index idx_nama_pelanggan on pelanggan (nama_pelanggan);
show index from pelanggan; -- melihat index pada tabel pelanggan
select * from pelanggan where nama_pelanggan = 'Budi Santoso';
-- perbandingan memakai index dan tanpa index
explain select * from pelanggan where nama_pelanggan = 'Budi Santoso';
explain select * from pelanggan ignore index (idx_nama_pelanggan) where nama_pelanggan = 'Budi Santoso';

-- 2. composite index
-- index penjualan pegawai berdasarkan tanggal
create index idx_id_pegawai_tanggal on penjualan (id_pegawai, tanggal);
show index from penjualan; -- melihat index pada tabel penjualan
select * from penjualan where id_pegawai = 'PGW002' and tanggal between '2026-11-01 00:00:00' and '2026-11-05 23:59:59';
-- perbandingan memakai index dan tanpa index
explain select * from penjualan where id_pegawai = 'PGW002' and tanggal between '2026-11-01 00:00:00' and '2026-11-05 23:59:59';
explain select * from penjualan ignore index (idx_id_pegawai_tanggal) where id_pegawai = 'PGW002' and tanggal between '2026-11-01 00:00:00' and '2026-11-05 23:59:59';
