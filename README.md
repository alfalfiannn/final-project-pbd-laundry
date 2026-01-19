# Sistem Basis Data Laundry & Dry Clean 🧺

*Final Project Mata Kuliah Pemrograman Basis Data* 

Repository ini berisi dokumentasi, rancangan, dan implementasi basis data untuk studi kasus **Sistem Informasi Laundry & Dry Clean**. Proyek ini bertujuan untuk mengelola data operasional laundry mulai dari manajemen kasir, pelanggan, layanan, hingga transaksi harian.

👥 Anggota Kelompok (Ceriaa)
Proyek ini dikerjakan oleh mahasiswa Kelas 24TIA5:

| NIM | Nama Lengkap | Peran |
| :--- | :--- | :--- |
| **240103153** | **Alfian Hafidz Affandi** | Implementasi SQL & Query |
| **240103163** | **Iman Septian** | Penyusunan Laporan & Dokumentasi |
| **240103180** | **Yoga Rafi Arifianto** | Penyusunan Poster |

---

## 📂 Struktur Repository
Sesuai ketentuan tugas, repository ini disusun dengan struktur sebagai berikut:

- **`/sql`**: Berisi file script database (`.sql`) yang siap dijalankan (DDL, DML, Query).
- **`/dokumen`**: Berisi Laporan Akhir (PDF) dan Poster Project (PDF).
- **`/assets`**: (Opsional) Menyimpan gambar ERD atau screenshot hasil query untuk ditampilkan di README ini.

---

## 📁 Struktur Database

Database bernama `db_laundry_ceria` terdiri dari tabel-tabel berikut:

* `customer` &rarr; menyimpan data pelanggan laundry (nama, alamat, no hp).
* `kasir` &rarr; menyimpan data karyawan/kasir yang menangani transaksi.
* `layanan` &rarr; menyimpan daftar jenis layanan laundry (kiloan/satuan) beserta harganya.
* `transaksi` &rarr; menyimpan data header nota transaksi (tanggal terima, tanggal selesai, total bayar).
* `detail_transaksi` &rarr; menyimpan rincian item layanan yang dipilih dalam satu transaksi.

Relasi database mencakup:

* **One to Many (1:N):**
    * Satu **Customer** melakukan banyak **Transaksi**.
    * Satu **Kasir** melayani banyak **Transaksi**.
    * Satu **Transaksi** memuat banyak **Detail Transaksi**.
* **Many to Many (M:N):**
    * Antara **Transaksi** dan **Layanan**, yang dihubungkan melalui tabel perantara `detail_transaksi`.

    ---

## 🧩 Diagram ERD 
Diagram berikut menggambarkan Entity Relationship Diagram (ERD) dari database db_laundry yang menunjukkan struktur tabel serta hubungan antar entitas dalam sistem Sistem Basis Data Laundry & Dry Clean.
<img width="940" height="585" alt="image" src="https://github.com/user-attachments/assets/e5e593da-65ed-44db-9f62-03097663fa81" />


## 🧾 Relasi Antar Tabel
Gambar berikut menunjukkan implementasi relasi antar tabel dalam  Sistem Basis Data Laundry & Dry Clean, termasuk relasi One to Many (1:N) dan Many to Many (M:N).
<img width="898" height="501" alt="image" src="https://github.com/user-attachments/assets/3ec1c678-a0f1-45af-aa17-aafa251f06c4" />

## 💻 Implementasi SQL
Berikut merupakan tangkapan layar implementasi perintah SQL yang digunakan untuk membuat database, tabel, serta relasi antar tabel pada Sistem Basis Data Laundry & Dry Clean.
<img width="1926" height="2572" alt="code implementasi" src="https://github.com/user-attachments/assets/4e92ff8f-6546-4d81-972c-306439a953f3" />


## 🛠️ Tools yang Digunakan
- **Database Engine:** MySQL / MariaDB
- **Tools Desain:** MySQL Workbench / Draw.io (untuk ERD)
- **Editor SQL:** VS Code / DBeaver / PHPMyAdmin

---

## 📝 Deskripsi & Fitur Proyek
Sistem ini dirancang menggunakan metode normalisasi hingga **3NF (Third Normal Form)** untuk memastikan integritas data. Fitur utama dalam basis data ini mencakup:

1.  **Manajemen Data Master:** CRUD untuk Kasir, Customer, dan Layanan Laundry.
2.  **Transaksi Laundry:** Pencatatan transaksi masuk (Header) dan rincian item cucian (Detail).
3.  **Laporan Keuangan:** Query agregasi untuk melihat total pendapatan per layanan.
4.  **Monitoring Status:** View khusus untuk memantau status pengerjaan laundry.
5.  **Integritas Data:** Penerapan *Constraints* (PK/FK) dan *Transaction Control Language* (TCL) untuk mencegah data korup saat input transaksi.

---

## 🚀 Cara Instalasi & Menjalankan (Setup Database)

Ikuti langkah berikut untuk memasang database ini di komputer lokal Anda:

1.  **Clone Repository**
    ```bash
    git clone [https://github.com/username-kalian/project-laundry-ceria.git](https://github.com/username-kalian/project-laundry-ceria.git)
    ```

2.  **Buka Aplikasi Database**
    Buka aplikasi manajemen database seperti **MySQL Workbench**, **PHPMyAdmin**, atau **DBeaver**.

3.  **Import File SQL**
    - Buka file yang berada di folder `/sql/laundry_db.sql`.
    - Jalankan seluruh script (Run All / Execute Script).
    - Script akan otomatis membuat database `db_laundry_ceria` dan mengisi data dummy.

4.  **Cek Instalasi**
    Jalankan query berikut untuk memastikan database berjalan:
    ```sql
    USE db_laundry_ceria;
    SELECT * FROM transaksi;
    ```

