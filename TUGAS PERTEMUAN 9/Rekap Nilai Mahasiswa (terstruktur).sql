-- Bersihkan objek lama jika sudah ada
DROP MATERIALIZED VIEW IF EXISTS mv_rekap_ipk_jurusan;
DROP VIEW IF EXISTS v_rekap_ipk_jurusan;
DROP TABLE IF EXISTS grade_report, course, student CASCADE;

-- Buat Tabel Utama
CREATE TABLE student (
    student_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    major VARCHAR(50) NOT NULL
);

CREATE TABLE course (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL
);

CREATE TABLE grade_report (
    report_id SERIAL PRIMARY KEY,
    student_id VARCHAR(10) REFERENCES student(student_id),
    course_id VARCHAR(10) REFERENCES course(course_id),
    semester VARCHAR(20) NOT NULL,
    grade NUMERIC(3,2) NOT NULL
);

-- Isi 1.000 baris data student (termasuk major 'cs')
INSERT INTO student (student_id, name, major)
SELECT 
    'S' || LPAD(i::text, 4, '0'),
    'Mahasiswa ' || i,
    CASE (i % 4)
        WHEN 0 THEN 'cs'
        WHEN 1 THEN 'is'
        WHEN 2 THEN 'it'
        ELSE 'se'
    END
FROM generate_series(1, 1000) AS i;

-- Isi 50 baris data course
INSERT INTO course (course_id, course_name, credits)
SELECT 
    'C' || LPAD(i::text, 3, '0'),
    'Mata Kuliah ' || i,
    (i % 3) + 2
FROM generate_series(1, 50) AS i;

-- Isi 50.000 baris data grade_report
INSERT INTO grade_report (student_id, course_id, semester, grade)
SELECT 
    'S' || LPAD(((i % 1000) + 1)::text, 4, '0'),
    'C' || LPAD(((i % 50) + 1)::text, 3, '0'),
    'Semester ' || ((i % 8) + 1),
    ROUND((2.00 + ((i % 201) / 100.0))::numeric, 2)
FROM generate_series(1, 50000) AS i;

-- Perbarui statistik optimizer agar estimasi EXPLAIN ANALYZE akurat
ANALYZE student;
ANALYZE course;
ANALYZE grade_report;

SELECT 
    (SELECT COUNT(*) FROM student) AS jumlah_siswa,
    (SELECT COUNT(*) FROM course) AS jumlah_kursus,
    (SELECT COUNT(*) FROM grade_report) AS rapor;


-- Buat Standard View v_rekap_ipk_jurusan yang menghitung jumlah nilai yang masuk (COUNT) dan rata-rata nilai (AVG) per major (jurusan) dan semester
create view v_rekap_ipk_jurusan as
select
	s.major,
	g.semester,
	count(g.grade) as jumlah_nilai,
	round(avg(g.grade), 2) as rata_rata_ipk
from student s
join grade_report g on s.student_id = g.student_id
join course c on g.course_id = c.course_id
group by s.major, g.semester;


explain analyze
SELECT * FROM v_rekap_ipk_jurusan WHERE major = 'cs';


CREATE MATERIALIZED VIEW mv_rekap_ipk_jurusan AS
SELECT 
    s.major,
    g.semester,
    COUNT(g.grade) AS jumlah_nilai,
    ROUND(AVG(g.grade), 2) AS rata_rata_ipk
FROM student s
JOIN grade_report g ON s.student_id = g.student_id
JOIN course c ON g.course_id = c.course_id
GROUP BY s.major, g.semester;

-- Tambahkan indeks pada kolom major dan perbarui statistik
CREATE INDEX idx_mv_major ON mv_rekap_ipk_jurusan(major);
ANALYZE mv_rekap_ipk_jurusan;

-- Jalankan ulang untuk perbandingan setelah optimasi
EXPLAIN ANALYZE
SELECT * FROM mv_rekap_ipk_jurusan WHERE major = 'cs';