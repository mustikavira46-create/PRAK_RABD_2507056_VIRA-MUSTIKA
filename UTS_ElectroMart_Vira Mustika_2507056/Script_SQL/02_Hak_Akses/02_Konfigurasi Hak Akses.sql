-- Tugas 2.  Konfigurasi Hak Akses Berbasis Role (Pertemuan 2)
-- membuat role dengan CREATE ROLE
create role 'bag_admin', 'bag_penjualan', 'bag_gudang', 'bag_manajer';

-- memberikan hak akses menggunakan GRANT
-- 1. role admin
grant all privileges  on electromart.* to 'bag_admin';
-- 2. role penjualan
grant select on electromart.produk to 'bag_penjualan';
grant select on electromart.pelanggan to 'bag_penjualan';
grant select, insert on electromart.penjualan to 'bag_penjualan';
grant select, insert on electromart.detail_penjualan to 'bag_penjualan';
-- 3. role gudang
grant select on electromart.produk to 'bag_gudang';
grant update (stok) on electromart.produk to 'bag_gudang';
grant select, insert on electromart.log_stok to 'bag_gudang';
-- 4. role manajer
grant select on electromart.produk to 'bag_manajer';
grant select on electromart.penjualan to 'bag_manajer';
grant select on electromart.detail_penjualan to 'bag_manajer';

-- mencabut hak akses menggunakan REVOKE
revoke insert on electromart.log_stok from 'bag_gudang';

-- membuat akun pengguna untuk setiap role 	
-- 1. user admin
create user 'admin'@'localhost' identified by 'admin890';
-- 2. user penjualan	
create user 'penjualan'@'localhost' identified by 'penjualan890';
-- 3. user gudang	
create user 'gudang'@'localhost' identified by 'gudang890';
-- 4. user manajer	
create user 'manajer'@'localhost' identified by 'manajer890';

-- menghubungkan pengguna/user dengan role yang sesuai
grant 'bag_admin' to 'admin'@'localhost';
grant 'bag_penjualan' to 'penjualan'@'localhost';
grant 'bag_gudang' to 'gudang'@'localhost';
grant 'bag_manajer' to 'manajer'@'localhost';

show grants for 'admin'@'localhost';
show grants for 'penjualan'@'localhost';
show grants for 'gudang'@'localhost';
show grants for 'manajer'@'localhost';

set default role all to 
  'admin'@'localhost', 
  'penjualan'@'localhost', 
  'gudang'@'localhost', 
  'manajer'@'localhost';

flush privileges;

-- 

select user, host from mysql.user;

-- menghapus data uji coba hak akses	
delete from detail_penjualan where id_penjualan = 'TRX005';
delete from penjualan where id_penjualan = 'TRX005';