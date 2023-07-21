-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Jul 2023 pada 15.39
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_apotek`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cek_ketersediaan_obat` ()   BEGIN
  -- Deklarasi variabel untuk menyimpan data obat
  DECLARE done INT DEFAULT FALSE;
  DECLARE TKodeObat VARCHAR(5);
  DECLARE TNamaObat VARCHAR(255);
  DECLARE TJumlahStok INT;
  
  -- Deklarasi cursor untuk mengambil data obat
  DECLARE cur CURSOR FOR SELECT KodeObat, NamaObat, JumlahStok FROM obat;
    
  -- Handler untuk mengatasi cursor kosong atau selesai
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  -- Membuat tabel sementara untuk menyimpan hasil
  DROP TEMPORARY TABLE IF EXISTS hasil_cek_obat;
  CREATE TEMPORARY TABLE hasil_cek_obat (
    KodeObat VARCHAR(5),
    NamaObat VARCHAR(255),
    Ketersediaan VARCHAR(10)
  );
  
  -- Membuka cursor
  OPEN cur;
  
  -- Loop untuk membaca data dari cursor
  read_loop: LOOP
    -- Membaca data obat dari cursor ke dalam variabel
    FETCH cur INTO TKodeObat,TNamaObat,TJumlahStok;
    
    -- Menghentikan loop jika cursor sudah selesai
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    -- Memeriksa ketersediaan obat dan menambahkan ke tabel sementara
    IF TJumlahStok > 0 THEN
      INSERT INTO hasil_cek_obat (KodeObat, NamaObat, Ketersediaan)
      VALUES (TKodeObat, TNamaObat, 'Tersedia');
    ELSE
      INSERT INTO hasil_cek_obat (KodeObat, NamaObat, Ketersediaan)
      VALUES (KodeObat, NamaObat, 'Habis');
    END IF;
    
  END LOOP;
  
  -- Menutup cursor
  CLOSE cur;
  
  -- Menampilkan hasil dari tabel sementara
  SELECT * FROM hasil_cek_obat;
  
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `tambah_data_pengiriman` (`paramId` VARCHAR(5), `paramKode_Obat` VARCHAR(5), `paramKodeSupplier` VARCHAR(5), `paramJumlah` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
  INSERT INTO pengiriman (IDPengiriman, Tanggal, KodeObat, KodeSupplier, Jumlah)
  VALUES (paramId, CURDATE(), paramKode_Obat, paramKodeSupplier, paramJumlah);

  RETURN 'Data berhasil ditambahkan';
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `tambah_pembeli` (`paramId` VARCHAR(5), `paramNama` VARCHAR(255), `paramAlamat` VARCHAR(255), `paramKota` VARCHAR(100), `paramNomorTelepon` VARCHAR(20)) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    -- Menambah data ke tabel transaksi
    INSERT INTO pembeli (IDPembeli, NamaPembeli, Alamat, Kota, NomorTelepon)
    VALUES (paramId, paramNama, paramAlamat, paramKota, paramNomorTelepon);
    
    RETURN 'Data berhasil ditambahkan';
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `tambah_transaksi` (`paramId` VARCHAR(5), `paramKode_Obat` VARCHAR(5), `paramJumlah` INT) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
	DECLARE id_transaksi INT;
    -- Menambah data ke tabel transaksi
    INSERT INTO Transaksi (Tanggal, IDPembeli, KodeObat, Jumlah)
    VALUES (CURDATE(), paramId, paramKode_Obat, paramJumlah);
  
    RETURN 'Data berhasil ditambahkan!';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jadwal`
--

CREATE TABLE `jadwal` (
  `IDJadwal` int(11) NOT NULL,
  `IDKaryawan` varchar(5) DEFAULT NULL,
  `Nama` varchar(255) DEFAULT NULL,
  `Hari` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jadwal`
--

INSERT INTO `jadwal` (`IDJadwal`, `IDKaryawan`, `Nama`, `Hari`) VALUES
(1, 'K0001', 'Joni Costangen', 'Senin'),
(2, 'K0002', 'Aldo Seblak', 'Selasa'),
(3, 'K0003', 'Andi Gorengan', 'Rabu'),
(4, 'K0004', 'Zahra Putri', 'Kamis'),
(5, 'K0005', 'Ilham Benu', 'Jumat'),
(6, 'K0006', 'Maria Rodriguez', 'Sabtu'),
(7, 'K0007', 'Ahmad Khan', 'Minggu');

-- --------------------------------------------------------

--
-- Struktur dari tabel `karyawan`
--

CREATE TABLE `karyawan` (
  `IdKaryawan` varchar(5) NOT NULL,
  `Alamat` varchar(255) DEFAULT NULL,
  `Nama` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `karyawan`
--

INSERT INTO `karyawan` (`IdKaryawan`, `Alamat`, `Nama`) VALUES
('K0001', 'Jl. ABC No. 123, Jakarta', 'Joni Costangen'),
('K0002', 'Jl. XYZ No. 456, Bandung', 'Aldo Seblak'),
('K0003', 'Jl. QRS No. 789, Surabaya', 'Andi Gorengan'),
('K0004', 'Jl. MNO No. 321, Medan', 'Zahra Putri'),
('K0005', 'Jl. DEF No. 567, Semarang', 'Ilham Benu'),
('K0006', 'Jl. UVW No. 890, Palembang', 'Maria Rodriguez'),
('K0007', 'Jl. HIJ No. 246, Makassar', 'Ahmad Khan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_pengiriman`
--

CREATE TABLE `log_pengiriman` (
  `IDLogPengiriman` int(11) NOT NULL,
  `IDPengiriman` varchar(5) DEFAULT NULL,
  `KodeSupplier` varchar(5) DEFAULT NULL,
  `KodeObat` varchar(5) DEFAULT NULL,
  `Stok` int(11) DEFAULT NULL,
  `Tanggal` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_pengiriman`
--

INSERT INTO `log_pengiriman` (`IDLogPengiriman`, `IDPengiriman`, `KodeSupplier`, `KodeObat`, `Stok`, `Tanggal`) VALUES
(1, 'D0001', 'S0001', 'O0001', 100, '2023-06-01'),
(2, 'D0002', 'S0002', 'O0002', 50, '2023-06-02'),
(3, 'D0003', 'S0003', 'O0003', 70, '2023-06-03'),
(4, 'D0004', 'S0004', 'O0004', 60, '2023-06-04'),
(5, 'D0005', 'S0005', 'O0005', 40, '2023-06-05'),
(6, 'D0006', 'S0001', 'O0006', 80, '2023-06-06'),
(7, 'D0007', 'S0002', 'O0007', 30, '2023-06-07'),
(8, 'D0008', 'S0003', 'O0008', 20, '2023-06-08'),
(9, 'D0009', 'S0004', 'O0009', 45, '2023-06-09'),
(10, 'D0010', 'S0005', 'O0010', 55, '2023-06-10'),
(11, 'D0011', 'S0002', 'O0008', 20, '2023-07-21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_transaksi`
--

CREATE TABLE `log_transaksi` (
  `IDLogTransaksi` int(11) NOT NULL,
  `IDTransaksi` int(11) DEFAULT NULL,
  `IDKaryawan` varchar(5) DEFAULT NULL,
  `IDPembeli` varchar(5) DEFAULT NULL,
  `KodeObat` varchar(5) DEFAULT NULL,
  `Tanggal` date DEFAULT NULL,
  `Jumlah` int(11) DEFAULT NULL,
  `Harga` decimal(10,2) DEFAULT NULL,
  `TotalHarga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_transaksi`
--

INSERT INTO `log_transaksi` (`IDLogTransaksi`, `IDTransaksi`, `IDKaryawan`, `IDPembeli`, `KodeObat`, `Tanggal`, `Jumlah`, `Harga`, `TotalHarga`) VALUES
(1, 1, 'K0006', 'P0003', 'O0001', '2023-06-01', 5, '10000.00', '50000.00'),
(2, 2, 'K0007', 'P0001', 'O0006', '2023-06-02', 3, '15000.00', '45000.00'),
(3, 3, 'K0001', 'P0002', 'O0001', '2023-06-03', 2, '20000.00', '40000.00'),
(4, 4, 'K0003', 'P0004', 'O0004', '2023-06-04', 1, '25000.00', '25000.00'),
(5, 5, 'K0006', 'P0005', 'O0010', '2023-06-05', 4, '30000.00', '120000.00'),
(6, 7, 'K0004', 'P0001', 'O0007', '2023-07-20', 5, '28000.00', '140000.00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `obat`
--

CREATE TABLE `obat` (
  `KodeObat` varchar(5) NOT NULL,
  `NamaObat` varchar(255) DEFAULT NULL,
  `Deskripsi` varchar(255) DEFAULT NULL,
  `Harga` decimal(10,2) DEFAULT NULL,
  `JumlahStok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `obat`
--

INSERT INTO `obat` (`KodeObat`, `NamaObat`, `Deskripsi`, `Harga`, `JumlahStok`) VALUES
('O0001', 'Paracetamol', 'Obat pereda nyeri dan penurun panas', '15000.00', 93),
('O0002', 'Amoxicillin', 'Antibiotik untuk infeksi bakteri', '25000.00', 50),
('O0003', 'Loratadine', 'Antihistamin untuk alergi', '18000.00', 70),
('O0004', 'Ibuprofen', 'Obat pereda nyeri dan peradangan', '20000.00', 59),
('O0005', 'Metformin', 'Obat diabetes tipe 2', '30000.00', 40),
('O0006', 'Aspirin', 'Obat pereda nyeri dan pengencer darah', '22000.00', 77),
('O0007', 'Omeprazole', 'Obat untuk masalah lambung', '28000.00', 25),
('O0008', 'Simvastatin', 'Obat penurun kolesterol', '32000.00', 40),
('O0009', 'Metronidazole', 'Antibiotik untuk infeksi parasit', '24000.00', 45),
('O0010', 'Glibenclamide', 'Obat diabetes tipe 2', '26000.00', 51);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembeli`
--

CREATE TABLE `pembeli` (
  `IDPembeli` varchar(5) NOT NULL,
  `NamaPembeli` varchar(255) DEFAULT NULL,
  `Alamat` varchar(255) DEFAULT NULL,
  `Kota` varchar(100) DEFAULT NULL,
  `NomorTelepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pembeli`
--

INSERT INTO `pembeli` (`IDPembeli`, `NamaPembeli`, `Alamat`, `Kota`, `NomorTelepon`) VALUES
('P0001', 'John Doe', 'Jl. ABC No. 123', 'Jakarta', '081234567890'),
('P0002', 'Jane Smith', 'Jl. XYZ No. 456', 'Surabaya', '087654321098'),
('P0003', 'Michael Johnson', 'Jl. QRS No. 789', 'Bandung', '085678905432'),
('P0004', 'Sarah Lee', 'Jl. MNO No. 321', 'Medan', '089876543210'),
('P0005', 'Robert Wang', 'Jl. DEF No. 567', 'Semarang', '082345678901');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengiriman`
--

CREATE TABLE `pengiriman` (
  `IDPengiriman` varchar(5) NOT NULL,
  `Tanggal` date DEFAULT NULL,
  `KodeObat` varchar(5) DEFAULT NULL,
  `KodeSupplier` varchar(5) DEFAULT NULL,
  `Jumlah` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengiriman`
--

INSERT INTO `pengiriman` (`IDPengiriman`, `Tanggal`, `KodeObat`, `KodeSupplier`, `Jumlah`) VALUES
('D0001', '2023-06-01', 'O0001', 'S0001', 100),
('D0002', '2023-06-02', 'O0002', 'S0002', 50),
('D0003', '2023-06-03', 'O0003', 'S0003', 70),
('D0004', '2023-06-04', 'O0004', 'S0004', 60),
('D0005', '2023-06-05', 'O0005', 'S0005', 40),
('D0006', '2023-06-06', 'O0006', 'S0001', 80),
('D0007', '2023-06-07', 'O0007', 'S0002', 30),
('D0008', '2023-06-08', 'O0008', 'S0003', 20),
('D0009', '2023-06-09', 'O0009', 'S0004', 45),
('D0010', '2023-06-10', 'O0010', 'S0005', 55),
('D0011', '2023-07-21', 'O0008', 'S0002', 20);

--
-- Trigger `pengiriman`
--
DELIMITER $$
CREATE TRIGGER `after_pengiriman_insert` AFTER INSERT ON `pengiriman` FOR EACH ROW BEGIN
  -- Masukkan data ke tabel log_pengiriman
  INSERT INTO log_pengiriman (IDPengiriman,KodeSupplier,KodeObat,Stok,Tanggal)
  VALUES (NEW.IDPengiriman, NEW.KodeSupplier, NEW.KodeObat,  NEW.Jumlah, New.Tanggal);
  
  -- Update jumlah stok pada tabel obat
  UPDATE obat
  SET JumlahStok = JumlahStok + NEW.Jumlah
  WHERE KodeObat = NEW.KodeObat;
  
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `KodeSupplier` varchar(5) NOT NULL,
  `NamaSupplier` varchar(255) DEFAULT NULL,
  `Alamat` varchar(255) DEFAULT NULL,
  `Kota` varchar(100) DEFAULT NULL,
  `NomorTelepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`KodeSupplier`, `NamaSupplier`, `Alamat`, `Kota`, `NomorTelepon`) VALUES
('S0001', 'TONI', 'Jl. Abdul Muis', 'Jakarta', '081234512345'),
('S0002', 'AGUNG', 'Jl. Ahmad Yani', 'Surabaya', '080987654321'),
('S0003', 'KIPLI', 'Jl. Jendral Sudirman', 'Bandung', '081234567890'),
('S0004', 'MUKLIS', 'Jl. Brigjen Katamso', 'Medan', '085678567890'),
('S0005', 'FAISHAL', 'Jl. Wahidin', 'Semarang', '081234123456');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `IDTransaksi` int(11) NOT NULL,
  `Tanggal` date DEFAULT NULL,
  `IDPembeli` varchar(5) DEFAULT NULL,
  `KodeObat` varchar(5) DEFAULT NULL,
  `Jumlah` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`IDTransaksi`, `Tanggal`, `IDPembeli`, `KodeObat`, `Jumlah`) VALUES
(1, '2023-06-01', 'P0003', 'O0001', 5),
(2, '2023-06-02', 'P0001', 'O0006', 3),
(3, '2023-06-03', 'P0002', 'O0001', 2),
(4, '2023-06-04', 'P0004', 'O0004', 1),
(5, '2023-06-05', 'P0005', 'O0010', 4),
(7, '2023-07-20', 'P0001', 'O0007', 5);

--
-- Trigger `transaksi`
--
DELIMITER $$
CREATE TRIGGER `after_insert_transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
	-- Mendapatkan hari ini
	DECLARE hari_ini VARCHAR(10);
    DECLARE karyawan_hari_ini VARCHAR(5);
    DECLARE harga_obat DECIMAL(10,2);
	SET hari_ini = DAYNAME(CURDATE());
	
    -- Percabangan CASE untuk menentukan idkaryawan sesuai hari kerja mereka
    SET karyawan_hari_ini = (
    	CASE hari_ini
    		WHEN 'Monday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Senin')
        	WHEN 'Tuesday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Selasa')
        	WHEN 'Wednesday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Rabu')
        	WHEN 'Thursday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Kamis')
        	WHEN 'Friday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Jumat')
        	WHEN 'Saturday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Sabtu')
        	WHEN 'Sunday' THEN (SELECT IDKaryawan FROM jadwal WHERE Hari = 'Minggu')
    	END
    );
	
 	-- Percabangan CASE untuk menyesuaikan harga obat dengan inputan kode obat   
    SET harga_obat = (
    	CASE New.KodeObat
    		WHEN 'O0001' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0001')
        	WHEN 'O0002' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0002')
        	WHEN 'O0003' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0003')
        	WHEN 'O0004' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0004')
        	WHEN 'O0005' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0005')
       		WHEN 'O0006' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0006')
        	WHEN 'O0007' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0007')
        	WHEN 'O0008' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0008')
        	WHEN 'O0009' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0009')
        	WHEN 'O0010' THEN (SELECT harga FROM obat WHERE KodeObat = 'O0010')
    	END
    );
    
	-- Insert data ke tabel log_transaksi
  	INSERT INTO log_transaksi (IDTransaksi, IDKaryawan, IDPembeli, KodeObat,Tanggal, Jumlah, Harga, TotalHarga)
  	VALUES (NEW.IDTransaksi, karyawan_hari_ini, NEW.IDPembeli, New.KodeObat,NEW.Tanggal, NEW.Jumlah, harga_obat, (NEW.Jumlah * harga_obat));
	
  	-- Update jumlah stok obat pada tabel Obat
  	UPDATE Obat
  	SET JumlahStok = JumlahStok - NEW.Jumlah
  	WHERE KodeObat = NEW.KodeObat; 	
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`IDJadwal`),
  ADD KEY `IDKaryawan` (`IDKaryawan`);

--
-- Indeks untuk tabel `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`IdKaryawan`);

--
-- Indeks untuk tabel `log_pengiriman`
--
ALTER TABLE `log_pengiriman`
  ADD PRIMARY KEY (`IDLogPengiriman`),
  ADD KEY `KodeSupplier` (`KodeSupplier`),
  ADD KEY `IDPengiriman` (`IDPengiriman`),
  ADD KEY `KodeObat` (`KodeObat`);

--
-- Indeks untuk tabel `log_transaksi`
--
ALTER TABLE `log_transaksi`
  ADD PRIMARY KEY (`IDLogTransaksi`),
  ADD KEY `IDTransaksi` (`IDTransaksi`),
  ADD KEY `IDKaryawan` (`IDKaryawan`),
  ADD KEY `IDPembeli` (`IDPembeli`),
  ADD KEY `KodeObat` (`KodeObat`);

--
-- Indeks untuk tabel `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`KodeObat`),
  ADD KEY `idx_NamaObat` (`NamaObat`),
  ADD KEY `idx_KodeObat_Harga` (`KodeObat`,`Harga`);

--
-- Indeks untuk tabel `pembeli`
--
ALTER TABLE `pembeli`
  ADD PRIMARY KEY (`IDPembeli`);

--
-- Indeks untuk tabel `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD PRIMARY KEY (`IDPengiriman`),
  ADD KEY `KodeObat` (`KodeObat`),
  ADD KEY `KodeSupplier` (`KodeSupplier`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`KodeSupplier`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`IDTransaksi`),
  ADD KEY `IDPembeli` (`IDPembeli`),
  ADD KEY `KodeObat` (`KodeObat`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `log_pengiriman`
--
ALTER TABLE `log_pengiriman`
  MODIFY `IDLogPengiriman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `log_transaksi`
--
ALTER TABLE `log_transaksi`
  MODIFY `IDLogTransaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `IDTransaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `jadwal`
--
ALTER TABLE `jadwal`
  ADD CONSTRAINT `jadwal_ibfk_1` FOREIGN KEY (`IDKaryawan`) REFERENCES `karyawan` (`IdKaryawan`);

--
-- Ketidakleluasaan untuk tabel `log_pengiriman`
--
ALTER TABLE `log_pengiriman`
  ADD CONSTRAINT `log_pengiriman_ibfk_1` FOREIGN KEY (`KodeSupplier`) REFERENCES `supplier` (`KodeSupplier`),
  ADD CONSTRAINT `log_pengiriman_ibfk_2` FOREIGN KEY (`IDPengiriman`) REFERENCES `pengiriman` (`IDPengiriman`),
  ADD CONSTRAINT `log_pengiriman_ibfk_3` FOREIGN KEY (`KodeObat`) REFERENCES `obat` (`KodeObat`);

--
-- Ketidakleluasaan untuk tabel `log_transaksi`
--
ALTER TABLE `log_transaksi`
  ADD CONSTRAINT `log_transaksi_ibfk_1` FOREIGN KEY (`IDTransaksi`) REFERENCES `transaksi` (`IDTransaksi`),
  ADD CONSTRAINT `log_transaksi_ibfk_2` FOREIGN KEY (`IDKaryawan`) REFERENCES `karyawan` (`IdKaryawan`),
  ADD CONSTRAINT `log_transaksi_ibfk_3` FOREIGN KEY (`IDPembeli`) REFERENCES `pembeli` (`IDPembeli`),
  ADD CONSTRAINT `log_transaksi_ibfk_4` FOREIGN KEY (`KodeObat`) REFERENCES `obat` (`KodeObat`);

--
-- Ketidakleluasaan untuk tabel `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD CONSTRAINT `pengiriman_ibfk_1` FOREIGN KEY (`KodeObat`) REFERENCES `obat` (`KodeObat`),
  ADD CONSTRAINT `pengiriman_ibfk_2` FOREIGN KEY (`KodeSupplier`) REFERENCES `supplier` (`KodeSupplier`);

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`IDPembeli`) REFERENCES `pembeli` (`IDPembeli`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`KodeObat`) REFERENCES `obat` (`KodeObat`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
