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
  `id_user` int(10) NOT NULL,
  `id_brg` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `tanggal` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`id_user`) REFERENCES `user`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`id_brg`) REFERENCES `item`(`id_brg`) ON DELETE CASCADE
);