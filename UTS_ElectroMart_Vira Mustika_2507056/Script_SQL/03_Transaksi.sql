-- Tugas 3. Pengelolaan Transaksi
-- skenario A: Pelanggan membeli satu unit laptop dan dua unit mouse
-- sistem harus mencatat transaksi dan detail_penjualan dalam satu proses transaksi

-- memulai transaksi
start transaction;

-- menginput data transaksi
insert into penjualan
values
	('TRX005', '2026-11-04 15:15:00', 'PLG003', 'PGW001', 15000000.00, 0.00, 15000000.00);

-- menginput detail transaksi
insert into detail_penjualan
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values
	('TRX005', 'PRD001', 1, 14500000.00, 14500000.00),
	('TRX005', 'PRD002', 2, 250000.00, 500000.00);
	
-- mengupdate stok produk
update produk set stok = stok-1 where id_produk = 'PRD001';
update produk set stok = stok-2 where id_produk = 'PRD002';
	
-- mencatat log stok	
insert into log_stok
(id_produk, jumlah_perubahan, tipe_transaksi, keterangan, tanggal)
values
	('PRD001', -1, 'KELUAR', 'Pengurangan stok dari TRX005','2026-11-04 15:15:00');

-- commit
commit;

-- cek keberhasilan
select * from penjualan where id_penjualan = 'TRX005';
select * from detail_penjualan where id_penjualan = 'TRX005';
select id_produk, nama_produk, stok from produk where id_produk in ('PRD001', 'PRD002');

-- skenario B: Pelanggan melakukan pembelian produk yang jumlahnya melebihi stok tersedia
-- memulai transaski
start transaction;

-- menginput transaksi
insert into penjualan
values
	('TRX007', '2026-12-01 10:15:00', 'PLG004', 'PGW003', 4800000.00, 0.00, 4800000.00);
select * from penjualan;

insert into detail_penjualan
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values
	('TRX007', 'PRD003', 4, 4800000.00, 4800000.00);
select * from detail_penjualan;

-- update stok
update produk set stok = stok-4 where id_produk = 'PRD003';
select * from produk;

-- membatalkan transaksi
rollback;

-- cek
select * from penjualan;
select * from detail_penjualan;
select * from produk;

-- skenario C: Pembatalan sebagian transaksi
-- memulai transaksi
start transaction;

-- menginput transaksi
insert into penjualan
values
	('TRX008', '2026-11-09 16:45:00', 'PLG002', 'PGW001', 95000, 0, 95000);
select * from penjualan where id_penjualan = 'TRX008';

insert into detail_penjualan
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values
	('TRX008', 'PRD007', 1, 95000, 95000);
select * from detail_penjualan where id_penjualan = 'TRX008';

-- update stok
update produk set stok = stok -1 where id_produk = 'PRD007';
select * from produk;

-- membuat savepoint
savepoint penjualan_item_1;

-- menginput transaksi kedua
insert into penjualan
values
	('TRX009', '2026-11-09 16:45:00', 'PLG002', 'PGW001', 4499000, 0, 4499000);
select * from penjualan where id_penjualan = 'TRX009';

insert into detail_penjualan 
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values
	('TRX009', 'PRD010', 1, 4499000, 4499000);
select * from detail_penjualan where id_penjualan = 'TRX009';

-- update stok
update produk set stok = stok -1 where id_produk = 'PRD010';
select * from produk;

rollback to savepoint penjualan_item_1;

-- cek
select * from produk;
select * from penjualan;
select * from detail_penjualan;

-- commit
commit;

-- menghapus savepoint yang sudah tidak digunakan
release savepoint penjualan_item_1;