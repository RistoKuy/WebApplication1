CREATE DATABASE IF NOT EXISTS `web_enterprise`
USE `web_enterprise`;

CREATE TABLE `user` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `nama` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(30) NOT NULL,
  `is_admin` TINYINT(1) NOT NULL DEFAULT 0
);

CREATE TABLE `item` (
  `id_brg` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `nama_brg` varchar(100) NOT NULL,
  `deskripsi` varchar(255) NOT NULL,
  `harga` varchar(30) NOT NULL,
  `gambar_brg` varchar(100) NOT NULL,
  `stok` int(10) NOT NULL
);

CREATE TABLE `order` (
  `id_order` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_brg` int(10) NOT NULL,
  `gambar_brg` varchar(100) NOT NULL,
  `nama_brg` varchar(100) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `harga` varchar(30) NOT NULL,
  `total_harga` varchar(30) NOT NULL,
  `metode_pengiriman` varchar(50) NOT NULL,
  `metode_pembayaran` varchar(50) NOT NULL,
  `tgl_order` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `invoice` (
  `id_invoice` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_order` int(10) NOT NULL,
  `firebase_uid` varchar(50) NOT NULL,
  `nama_penerima` varchar(50) NOT NULL,
  `alamat` TEXT NOT NULL,
  `no_telp` varchar(15) NOT NULL,
  `total_harga` varchar(30) NOT NULL,
  `status_pembayaran` varchar(20) NOT NULL DEFAULT 'pending',
  `tgl_invoice` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER pesanan_penjualan 
AFTER INSERT ON item
FOR EACH ROW 
BEGIN 
    UPDATE tb_barang 
    SET stok = stok - NEW.stok 
    WHERE id_brg = NEW.id_brg; 
END; //

DELIMITER ;