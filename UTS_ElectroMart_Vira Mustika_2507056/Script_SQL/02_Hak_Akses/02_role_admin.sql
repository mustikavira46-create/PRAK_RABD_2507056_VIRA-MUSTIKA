-- memeriksa user dan role yang aktif
select current_user(), current_role();
-- menguji hak akses role admin
-- 1. melihat tabel SELECT
select * from pegawai;
-- 2. menambahkan produk INSERT
insert into produk values ('PRD015', 'Keyboard Mechanical Logitech', 'Aksesoris', 850000, 25);
select * from produk;
-- 3. mengaupdate stok UPDATE
update produk set stok = 15 where id_produk = 'PRD011';
select * from produk;
-- 4. menghapus produk DELETE
delete from produk where id_produk = 'PRD015';
select * from produk;
-- 5. membuat tabel CREATE
create table uji_hak_akses_admin (
	id int primary key
	);
select * from uji_hak_akses_admin;
-- 6. menghapus tabel DROP
drop table uji_hak_akses_admin;
select * from uji_hak_akses_admin;

