/*
    FINAL PROJECT PEMROGRAMAN BASIS DATA
    Studi Kasus: Sistem Basis Data Laundry & Dry Clean
    Kelompok: Ceriaa
    Anggota: Alfian, Iman, Yoga
    
    Deskripsi:
    Script ini akan membuat database 'db_laundry_ceria', tabel-tabel yang diperlukan,
    mengisi data awal (seeding), melakukan query analisis wajib, dan mensimulasikan transaksi.
*/

-- ==========================================================
-- BAGIAN 1: DDL (DATA DEFINITION LANGUAGE)
-- ==========================================================
-- Bagian ini berfokus pada pembuatan struktur database.
-- Kita menggunakan DROP DATABASE agar saat script dijalankan ulang, kita mulai dari kondisi bersih.

DROP DATABASE IF EXISTS db_laundry_ceria;
CREATE DATABASE db_laundry_ceria;
USE db_laundry_ceria;

-- 1. Tabel Kasir
-- Menyimpan data karyawan kasir.
-- id_kasir menggunakan CHAR(5) karena kodenya tetap (misal: KSR01).
CREATE TABLE kasir (
    id_kasir CHAR(5) NOT NULL,
    nama_kasir VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_kasir)
) ENGINE=InnoDB;

-- 2. Tabel Customer
-- Menyimpan data pelanggan.
-- hp_customer menggunakan VARCHAR agar bisa menyimpan angka '0' di depan atau kode negara '+62'.
CREATE TABLE customer (
    id_customer CHAR(6) NOT NULL,
    nama_customer VARCHAR(50) NOT NULL,
    hp_customer VARCHAR(15),
    alamat_customer VARCHAR(100),
    PRIMARY KEY (id_customer)
) ENGINE=InnoDB;

-- 3. Tabel Layanan
-- Menyimpan daftar jasa laundry yang tersedia beserta harganya.
CREATE TABLE layanan (
    id_layanan CHAR(5) NOT NULL,
    jenis_laundry VARCHAR(100) NOT NULL,
    harga_barang INT NOT NULL, -- Harga per satuan (kg/pcs)
    keterangan VARCHAR(100),
    PRIMARY KEY (id_layanan)
) ENGINE=InnoDB;

-- 4. Tabel Transaksi (Header)
-- Mencatat informasi utama transaksi (nota).
-- Tabel ini memiliki Foreign Key ke Customer dan Kasir.
CREATE TABLE transaksi (
    id_transaksi VARCHAR(10) NOT NULL,
    tanggal_terima DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    total_bayar INT DEFAULT 0, -- Total keseluruhan nota
    id_customer CHAR(6),
    id_kasir CHAR(5),
    PRIMARY KEY (id_transaksi),
    -- Constraint Foreign Key untuk menjaga integritas data
    CONSTRAINT fk_transaksi_customer FOREIGN KEY (id_customer) REFERENCES customer(id_customer) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_transaksi_kasir FOREIGN KEY (id_kasir) REFERENCES kasir(id_kasir) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Tabel Detail Transaksi
-- Mencatat rincian barang apa saja yang dilaundry dalam satu nota.
-- Tabel ini menghubungkan Transaksi (Header) dengan Layanan.
CREATE TABLE detail_transaksi (
    id_transaksi VARCHAR(10) NOT NULL,
    id_layanan CHAR(5) NOT NULL,
    jumlah_barang INT NOT NULL, -- Jumlah dalam Kg atau Pcs
    subtotal INT NOT NULL, -- Hasil perhitungan trigger/aplikasi (harga x jumlah)
    -- Primary Key Komposit: Kombinasi id_transaksi dan id_layanan harus unik.
    -- Artinya, dalam satu nota tidak boleh ada input layanan yang sama berulang kali.
    PRIMARY KEY (id_transaksi, id_layanan),
    CONSTRAINT fk_detail_transaksi FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_layanan FOREIGN KEY (id_layanan) REFERENCES layanan(id_layanan) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ==========================================================
-- BAGIAN 2: DML (DATA MANIPULATION LANGUAGE - SEED DATA)
-- ==========================================================
-- Mengisi data awal agar database bisa digunakan untuk uji coba query.

-- Insert Data Kasir
INSERT INTO kasir (id_kasir, nama_kasir) VALUES 
('KSR01', 'Budi Santoso'),
('KSR02', 'Rina Wati');

-- Insert Data Customer
INSERT INTO customer (id_customer, nama_customer, hp_customer, alamat_customer) VALUES 
('CUST01', 'Ibu Sulis', '082349989', 'Perumahan Elok Permai'),
('CUST02', 'Pak Andi', '081234567', 'Jl. Merpati No. 10');

-- Insert Data Layanan
INSERT INTO layanan (id_layanan, jenis_laundry, harga_barang, keterangan) VALUES 
('LYN01', 'Pakaian Pria (Kg)', 10000, 'Cuci + Setrika Kiloan'),
('LYN02', 'Pakaian Wanita (Kg)', 5000, 'Cuci + Setrika Kiloan'),
('LYN03', 'Celana Panjang (Pcs)', 5000, 'Cuci + Setrika Satuan'),
('LYN04', 'Baju Anak (Kg)', 10000, 'Cuci + Setrika Kiloan'),
('LYN05', 'Bed Cover Besar (Pcs)', 15000, 'Cuci Kering Satuan');

-- Insert Data Transaksi (Header)
-- Pastikan ID Customer dan ID Kasir yang dimasukkan sudah ada di tabel induknya.
INSERT INTO transaksi (id_transaksi, tanggal_terima, tanggal_selesai, total_bayar, id_customer, id_kasir) VALUES 
('TX01', '2025-04-20', '2025-04-30', 30000, 'CUST01', 'KSR01'),
('TX02', '2025-05-01', '2025-05-03', 15000, 'CUST02', 'KSR02');

-- Insert Data Detail Transaksi (Rincian Item)
-- Subtotal diisi manual untuk contoh ini (Harga di tabel layanan x jumlah_barang)
INSERT INTO detail_transaksi (id_transaksi, id_layanan, jumlah_barang, subtotal) VALUES 
('TX01', 'LYN01', 2, 20000), -- TX01: 2kg Pakaian Pria @10k
('TX01', 'LYN02', 1, 5000),  -- TX01: 1kg Pakaian Wanita @5k
('TX01', 'LYN03', 1, 5000),  -- TX01: 1pcs Celana Panjang @5k
('TX02', 'LYN05', 1, 15000); -- TX02: 1pcs Bed Cover @15k


-- ==========================================================
-- BAGIAN 3: QUERY WAJIB (SESUAI KETENTUAN FINAL PROJECT)
-- ==========================================================

-- 1. Query JOIN (Menampilkan Detail Nota Lengkap)
-- Tujuan: Menggabungkan 5 tabel untuk melihat rincian lengkap sebuah transaksi:
-- Siapa pelanggannya, siapa kasirnya, kapan transaksinya, dan apa saja item yang dicuci.
SELECT 
    t.id_transaksi AS 'No Nota',
    t.tanggal_terima AS 'Tgl Terima',
    c.nama_customer AS 'Pelanggan',
    k.nama_kasir AS 'Kasir',
    l.jenis_laundry AS 'Item Laundry',
    dt.jumlah_barang AS 'Qty',
    CONCAT('Rp ', FORMAT(l.harga_barang, 0)) AS 'Harga Satuan',
    CONCAT('Rp ', FORMAT(dt.subtotal, 0)) AS 'Subtotal'
FROM detail_transaksi dt
INNER JOIN transaksi t ON dt.id_transaksi = t.id_transaksi
INNER JOIN customer c ON t.id_customer = c.id_customer
INNER JOIN kasir k ON t.id_kasir = k.id_kasir
INNER JOIN layanan l ON dt.id_layanan = l.id_layanan
ORDER BY t.id_transaksi;


-- 2. Query AGREGASI & GROUP BY
-- Tujuan: Menghitung total pendapatan (omset) berdasarkan jenis layanan.
-- Ini berguna untuk analisis bisnis, layanan mana yang paling menghasilkan.
SELECT 
    l.jenis_laundry AS 'Jenis Layanan',
    SUM(dt.jumlah_barang) AS 'Total Qty Terjual',
    CONCAT('Rp ', FORMAT(SUM(dt.subtotal), 0)) AS 'Total Pendapatan'
FROM detail_transaksi dt
JOIN layanan l ON dt.id_layanan = l.id_layanan
GROUP BY l.id_layanan, l.jenis_laundry
ORDER BY SUM(dt.subtotal) DESC;


-- 3. Query HAVING
-- Tujuan: Menampilkan pelanggan "Premium" (yang total transaksinya di atas Rp 20.000).
-- HAVING digunakan karena kita memfilter hasil dari fungsi agregasi SUM().
SELECT 
    c.nama_customer AS 'Nama Pelanggan',
    COUNT(t.id_transaksi) AS 'Jumlah Nota',
    CONCAT('Rp ', FORMAT(SUM(t.total_bayar), 0)) AS 'Total Belanja'
FROM transaksi t
JOIN customer c ON t.id_customer = c.id_customer
GROUP BY c.id_customer, c.nama_customer
HAVING SUM(t.total_bayar) > 20000;


-- 4. SUBQUERY (WHERE clause)
-- Tujuan: Menampilkan daftar layanan laundry yang harganya DI ATAS rata-rata harga semua layanan.
SELECT 
    id_layanan,
    jenis_laundry, 
    harga_barang
FROM layanan
WHERE harga_barang > (
    -- Subquery untuk menghitung rata-rata harga terlebih dahulu
    SELECT AVG(harga_barang) FROM layanan
);


-- 5. VIEW
-- Tujuan: Membuat tabel virtual "Laporan Status Cucian" untuk memudahkan pengecekan harian oleh staf.
-- View ini menambahkan kolom status pengerjaan otomatis berdasarkan tanggal hari ini (CURDATE).

DROP VIEW IF EXISTS v_status_cucian_harian; -- Hapus dulu jika ada

CREATE VIEW v_status_cucian_harian AS
SELECT 
    t.id_transaksi AS 'No Nota',
    t.tanggal_terima,
    t.tanggal_selesai,
    c.nama_customer,
    t.total_bayar,
    -- Logika CASE: Jika tanggal selesai kurang dari hari ini, maka 'Selesai'.
    -- Jika sama dengan atau lebih dari hari ini, maka 'Dalam Proses'.
    CASE 
        WHEN t.tanggal_selesai < CURDATE() THEN 'Siap Diambil / Selesai'
        ELSE 'Dalam Proses Pengerjaan'
    END AS status_pengerjaan
FROM transaksi t
JOIN customer c ON t.id_customer = c.id_customer;

-- Cara memanggil View yang telah dibuat:
SELECT * FROM v_status_cucian_harian;


-- ==========================================================
-- BAGIAN 4: TCL (TRANSACTION CONTROL LANGUAGE)
-- ==========================================================

/* SKENARIO TRANSAKSI:
   Pelanggan Ibu Sulis (CUST01) datang lagi membawa cucian baru.
   Kasir Budi (KSR01) melayani.
   Cucian: 3 Kg Pakaian Pria (LYN01 @10000) = Rp 30.000.
   Total Nota: Rp 30.000.

   PENTING: Dalam sistem nyata, data Header (transaksi) dan Detail (detail_transaksi) 
   harus masuk bersamaan. Jika salah satu gagal, semua harus dibatalkan (ROLLBACK) 
   agar data tidak korup (misal: ada nota tapi tidak ada rincian barangnya).
*/

-- Memulai blok transaksi
START TRANSACTION;

-- 1. Insert Header Transaksi Baru (TX03)
INSERT INTO transaksi (id_transaksi, tanggal_terima, tanggal_selesai, total_bayar, id_customer, id_kasir) 
VALUES ('TX03', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 30000, 'CUST01', 'KSR01');

-- 2. Insert Detail Transaksi untuk TX03
-- Jika terjadi error pada tahap ini (misal salah id_layanan), seluruh transaksi akan di-rollback oleh sistem aplikasi.
INSERT INTO detail_transaksi (id_transaksi, id_layanan, jumlah_barang, subtotal) 
VALUES ('TX03', 'LYN01', 3, 30000);


-- Jika semua perintah INSERT di atas berhasil tanpa error, 
-- Simpan perubahan secara permanen ke database.
COMMIT;

-- Cek hasil transaksi yang baru dimasukkan
SELECT * FROM transaksi WHERE id_transaksi = 'TX03';
SELECT * FROM detail_transaksi WHERE id_transaksi = 'TX03';