CREATE TABLE master_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    field1 VARCHAR(255) NOT NULL,
    field2 VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    jabatan_id INT NULL,
	status_id INT NULL,
    jurusan_id INT NULL,
    kelas_id INT,
    password VARCHAR(255) NOT NULL,
    nip VARCHAR(30) NULL,
	jenis_kelamin VARCHAR(20) NULL,
	no_hp VARCHAR(20) NULL,
    foto VARCHAR(255) NULL,
    email_verified BOOLEAN DEFAULT FALSE,
	email_verification_token VARCHAR(255),
	email_verification_expiry DATETIME,
    reset_password_token VARCHAR(255) NULL,
	reset_password_expiry DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_jabatan
		FOREIGN KEY (jabatan_id) REFERENCES master_data(id),
        
	CONSTRAINT fk_status
		FOREIGN KEY (status_id) REFERENCES master_data(id),
    
	CONSTRAINT fk_jurusan
		FOREIGN KEY (jurusan_id) REFERENCES master_data(id),
        
	CONSTRAINT fk_kelas
		FOREIGN KEY (kelas_id) REFERENCES master_data(id)
);

CREATE TABLE user_mata_pelajaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    mata_pelajaran_id INT NULL,
    course_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_mp 
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_mp_master
        FOREIGN KEY (mata_pelajaran_id) REFERENCES master_data(id)
        ON DELETE CASCADE
);

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,

    mata_pelajaran_id INT NOT NULL,
    guru_id INT NOT NULL,

    jurusan_id INT NOT NULL,
    kelas_id INT NOT NULL,
    tahun_ajar_id INT NOT NULL,

    semester VARCHAR(20) NOT NULL,

    kode_mapel VARCHAR(50) NOT NULL,
    deskripsi TEXT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_course_mapel
        FOREIGN KEY (mata_pelajaran_id) REFERENCES master_data(id),

    CONSTRAINT fk_course_jurusan
        FOREIGN KEY (jurusan_id) REFERENCES master_data(id),

    CONSTRAINT fk_course_kelas
        FOREIGN KEY (kelas_id) REFERENCES master_data(id),

    CONSTRAINT fk_course_tahun
        FOREIGN KEY (tahun_ajar_id) REFERENCES master_data(id),

    CONSTRAINT fk_course_guru
        FOREIGN KEY (guru_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE forum_diskusi (
    id INT AUTO_INCREMENT PRIMARY KEY,

    course_id INT NOT NULL,
    user_id INT NOT NULL,

    title VARCHAR(255) NOT NULL,
    description TEXT NULL,

    file_path TEXT NULL,
    file_name VARCHAR(255) NULL,

    link TEXT NULL,
    tanggal DATE NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_forum_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_forum_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE forum_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,

    forum_id INT NOT NULL,
    user_id INT NOT NULL,

    content TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comment_forum
        FOREIGN KEY (forum_id) REFERENCES forum_diskusi(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comment_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE materi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,

    nama VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,

    file_path VARCHAR(255) NULL,
    file_name VARCHAR(255) NULL,
    link TEXT NULL,

    tanggal DATE NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_materi_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_materi_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE materi_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,

    materi_id INT NOT NULL,
    user_id INT NOT NULL,

    content TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_materi_comment
        FOREIGN KEY (materi_id) REFERENCES materi(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_materi_comment_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE tugas (
    id INT AUTO_INCREMENT PRIMARY KEY,

    course_id INT NOT NULL,
    user_id INT NOT NULL,

    nama VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,

    file_path TEXT NULL,
    file_name VARCHAR(255) NULL,
    link TEXT NULL,

    tanggal DATE NOT NULL,
    deadline DATE NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tugas_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_tugas_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE tugas_pengumpulan (
    id INT AUTO_INCREMENT PRIMARY KEY,

    tugas_id INT NOT NULL,
    user_id INT NOT NULL,

    file_path TEXT NOT NULL,
    file_name VARCHAR(255),

    tanggal DATE NOT NULL,
    nilai INT DEFAULT 0,
    feedback TEXT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_pengumpulan_tugas
        FOREIGN KEY (tugas_id) REFERENCES tugas(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pengumpulan_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE tugas_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,

    tugas_id INT NOT NULL,
    user_id INT NOT NULL,

    content TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tugas_comment
        FOREIGN KEY (tugas_id) REFERENCES tugas(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_tugas_comment_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE kustomisasi (
    id INT AUTO_INCREMENT PRIMARY KEY,

    nama_aplikasi VARCHAR(100) DEFAULT 'SIMPEL',
    deskripsi VARCHAR(255) DEFAULT 'Sistem Pembelajaran Elektronik',

    nama_sekolah VARCHAR(255),
    kepala_sekolah VARCHAR(255),
    npsn VARCHAR(50),

    logo VARCHAR(255),

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE pengumuman (
    id INT AUTO_INCREMENT PRIMARY KEY,

    judul VARCHAR(255) NOT NULL,
    isi TEXT NOT NULL,

    tanggal_tampil DATE NOT NULL,

    created_by INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_pengumuman_user
        FOREIGN KEY (created_by) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE penilaian (
    id INT AUTO_INCREMENT PRIMARY KEY,

    course_id INT NOT NULL,
    siswa_id INT NOT NULL,

    tugas_1 INT DEFAULT 0,
    tugas_2 INT DEFAULT 0,
    tugas_3 INT DEFAULT 0,
    tugas_4 INT DEFAULT 0,
    tugas_5 INT DEFAULT 0,
    tugas_6 INT DEFAULT 0,
    tugas_7 INT DEFAULT 0,
    tugas_8 INT DEFAULT 0,
    tugas_9 INT DEFAULT 0,
    tugas_10 INT DEFAULT 0,
    tugas_11 INT DEFAULT 0,
    tugas_12 INT DEFAULT 0,
    tugas_13 INT DEFAULT 0,

    uts INT DEFAULT 0,
    uas INT DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_penilaian_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_penilaian_siswa
        FOREIGN KEY (siswa_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE bobot_penilaian (
    id INT AUTO_INCREMENT PRIMARY KEY,

    course_id INT NOT NULL,

    tugas INT DEFAULT 40,
    uts INT DEFAULT 30,
    uas INT DEFAULT 30,

    CONSTRAINT fk_bobot_course
        FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE CASCADE
);