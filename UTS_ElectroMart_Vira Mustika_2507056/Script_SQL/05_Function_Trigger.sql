-- Tugas 5. Function dan Trigger

-- 1. Membuat function hitung_total()
delimiter //
create function hitung_total (
	p_harga decimal (12,2),
	p_jumlah int
	)
returns decimal (12,2)
deterministic 
begin
	return p_harga*p_jumlah;
end//
delimiter ;

-- 2. Membuat function hitung_diskon()
delimiter //
create function hitung_diskon (
	p_total decimal (12,2)
	)
returns decimal (12,2)
deterministic
begin
	if p_total >= 1000000 then
		return p_total * 0.10;
	else
		return 0;
	end if;
end //
delimiter ;

-- 3. Membuat trigger validasi_penjualan
delimiter //
create trigger validasi_penjualan
before insert on detail_penjualan
for each row
begin
	declare v_stok int;
	declare v_harga decimal (12,2);

	select stok, harga into v_stok, v_harga
	from produk
	where id_produk = new.id_produk;
	
	-- validasi produk tidak terdaftar
	if v_stok is null then
		signal sqlstate '45000'
		set message_text =
			'Produk tidak ditemukan di sistem';
	end if;
	
	-- validasi jumlah pembelian
	if new.jumlah <= 0 then
		signal sqlstate '45000'
		set message_text =
			'Jumlah pembelian tidak boleh nol';
	end if;
	
	-- validasi harga
	if new.harga_satuan <= 0 then 
		set new.harga_satuan = v_harga;
	end if;
	
	-- validasi jumlah pembelian yang melebihi stok
	if new.jumlah > v_stok then
		signal sqlstate '45000'
		set message_text =
			'Stok produk tidak mencukupi';
	end if;
	
	-- otomatis menghitung subtotal
	set new.subtotal = hitung_total (new.harga_satuan, new.jumlah);
end//
delimiter ;

-- Membuat trigger update_stok_penjualan
delimiter //
create trigger update_stok_penjualan
after insert on detail_penjualan
for each row
begin
	declare v_total decimal (12,2);
	declare v_diskon decimal (12,2);

	-- 1. mengurangi stok pada tabel produk
	update produk set stok = stok - new.jumlah where id_produk = new.id_produk;
	
	-- 2. mencatat perubahan persediaan
	insert into log_stok
	(id_produk, jumlah_perubahan, tipe_transaksi, keterangan, tanggal)
	values
	(new.id_produk, new.jumlah, 'KELUAR', concat('Penjualan'), now());
	
	-- 3. menghitung total_harga, diskon, dan total_bayar pada tabel penjualan
	select sum(subtotal) into v_total from detail_penjualan where id_penjualan = new.id_penjualan;
	
	set v_diskon = hitung_diskon(v_total);
	
	update penjualan set
		total_harga = v_total,
		diskon = v_diskon,
		total_bayar = v_total - v_diskon
	where
		id_penjualan = new.id_penjualan;
	
end//
delimiter ;

-- Mengecek daftar Stored Function pada database electromart
show function status where db = 'electromart';

-- Mengecek daftar Trigger pada database electromart
show triggers from electromart;

-- PENGUJIAN SISTEM
select id_produk, nama_produk, harga, stok from produk where id_produk in ('PRD001', 'PRD007');

-- menginput transaksi untuk pengujian
insert into penjualan
values 
    ('TRX010', 'PLG001', 'PGW001', 0, 0, 0),
    ('TRX011', 'PLG002', 'PGW001', 0, 0, 0);

-- pengembalian produk dengan jumlah yang tersedia



-- pembelian dengan jumlah melibihi stok
insert into detail_penjualan
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
value
('TRX011', 'PRD001', 999, 12000000, 0);

-- pembelian dengan nol atau negatif
insert into detail_penjualan (id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values ('TRX011', 'PRD007', 0, 95000, 0);

-- pembelian produk yang tidak terdaftar
insert into detail_penjualan (id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values ('TRX011', 'PRD999', 1, 50000, 0);

-- transaksi yang memnuhi syarat diskon
insert into detail_penjualan
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values
('TRX010', 'PRD001', 1, 12000000, 0);

-- transaksi yang tidak memenuhi syarat diskon
insert into detail_penjualan
(id_penjualan, id_produk, jumlah, harga_satuan, subtotal)
values
('TRX011', 'PRD007', 2, 95000, 0);

-- bukti perhitungan total transaksi dan diskon pada tabel penjualan
select * from penjualan where id_penjualan in ('TRX010', 'TRX011');

-- bukti sub total otomatis pada detail_penjualan
select * from detail_penjualan where id_penjualan in ('TRX010', 'TRX011');

-- bukti stok berkurang otomatis pada tabel produk
select id_produk, nama_produk, harga, stok from produk where id_produk in ('PRD001', 'PRD007');

-- bukti pencatatan perubahan stok pada log_stok
select * from log_stok order by id_log desc limit 5;
















