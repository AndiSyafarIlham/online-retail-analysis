-- Pertanyaan 4: produk dengan persentase retur tertinggi
-- Dataset: Online Retail (UCI), tabel: sales

WITH jual AS (
    SELECT Description AS produk, SUM(Quantity) AS qty_jual
    FROM sales GROUP BY Description
    HAVING SUM(Quantity) >= 500
),
ret AS (
    SELECT Desc_up AS produk, SUM(qty_retur) AS qty_retur, COUNT(*) AS kali_retur
    FROM retur GROUP BY Desc_up
)
SELECT j.produk, j.qty_jual, r.qty_retur,
       ROUND(r.qty_retur * 100.0 / j.qty_jual, 1) AS retur_pct,
       r.kali_retur
FROM jual j JOIN ret r ON j.produk = r.produk
ORDER BY retur_pct DESC
LIMIT 8
