-- Tugas 6. Implementasi SQL View

-- view_produk
create view view_produk as
select 	
	id_produk 'ID produk',
	nama_produk 'Nama Produk',
	kategori 'Kategori',
	harga 'Harga Produk'
from produk;

-- view_transaksi
create view view_transaksi as
select 
    p.id_penjualan,
    p.tanggal,
    pl.nama_pelanggan,
    pg.nama_pegawai,
    p.total_harga,
    p.diskon,
    p.total_bayar
from penjualan p
join pelanggan pl on p.id_pelanggan = pl.id_pelanggan
join pegawai pg on p.id_pegawai = pg.id_pegawai;

-- view_laporan_penjualan
create view view_laporan_penjualan as
select 
    pr.kategori,
    count(distinct dp.id_penjualan) as jumlah_transaksi,
    sum(dp.jumlah) as total_unit_terjual,
    sum(dp.subtotal) as total_penjualan
from detail_penjualan dp
join produk pr on dp.id_produk = pr.id_produk
group by pr.kategori;

-- view_stok_rendah
create view view_stok_rendah as
select id_produk, nama_produk, kategori, harga, stok
from produk
where stok < 10
with check option;


-- pengujian view
select * from view_produk;
select * from view_transaksi;
select * from view_laporan_penjualan;
select * from view_stok_rendah;

-- Hapus salah satu view sebagai bukti pengelolaan view
drop view if exists view_stok_rendah;

