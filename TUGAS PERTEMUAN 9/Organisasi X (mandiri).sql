create table divisi (
	id_divisi varchar (10) primary key,
	nama_divisi varchar (50) not null
	);

create table barang (
	id_barang varchar (10) primary key,
	nama_barang varchar (50) not null,
	kategori varchar (30)
	);

create table transaksi_pengadaan (
	id_transaksi serial primary key,
	id_divisi varchar (10) references divisi(id_divisi),
	id_barang varchar (10) references barang(id_barang),
	jumlah int not null,
	total_biaya numeric (12,2) not null,
	tgl_transaksi date not null
	);

INSERT INTO divisi VALUES 
('D01', 'IT & Infrastruktur'), 
('D02', 'Operasional'), 
('D03', 'Pemasaran'), 
('D04', 'HRD');

INSERT INTO barang (id_barang, nama_barang, kategori)
SELECT 
    'B' || LPAD(i::text, 4, '0'),
    'Barang Ke-' || i,
    CASE WHEN i % 2 = 0 THEN 'Elektronik' ELSE 'ATK' END
FROM generate_series(1, 500) AS i;

INSERT INTO transaksi_pengadaan (id_divisi, id_barang, jumlah, total_biaya, tgl_transaksi)
SELECT 
    'D0' || ((i % 4) + 1),
    'B' || LPAD(((i % 500) + 1)::text, 4, '0'),
    (i % 10) + 1,
    ((i % 10) + 1) * 50000,
    CURRENT_DATE - (i % 365)
FROM generate_series(1, 100000) AS i;

ANALYZE divisi;
ANALYZE barang;
ANALYZE transaksi_pengadaan;

SELECT 
    (SELECT COUNT(*) FROM divisi) AS jumlah_divisi,
    (SELECT COUNT(*) FROM barang) AS jumlah_barang,
    (SELECT COUNT(*) FROM transaksi_pengadaan) AS jumlah_transaksi;

create view v_rekap_pengadaan as
select
	d.nama_divisi,
	b.kategori,
	count(t.id_transaksi) as total_transaksi,
	sum(t.total_biaya) as total_pengeluaran
from divisi d
join transaksi_pengadaan t on d.id_divisi = t.id_divisi
join barang b on t.id_barang = b.id_barang
group by d.nama_divisi, b.kategori;

explain analyze select * from v_rekap_pengadaan where nama_divisi = 'IT & Infrastruktur';

create materialized view mv_rekap_pengadaan as
select
	d.nama_divisi,
	b.kategori,
	count(t.id_transaksi) as total_transaksi,
	sum(t.total_biaya) as total_pengeluaran
from divisi d
join transaksi_pengadaan t on d.id_divisi = t.id_divisi
join barang b on t.id_barang = b.id_barang
group by d.nama_divisi, b.kategori;

explain analyze select * from mv_rekap_pengadaan where nama_divisi = 'IT & Infrastruktur';
