-- Pertanyaan 2b: produk teratas berdasarkan revenue bersih
-- Dataset: Online Retail (UCI), tabel: sales

WITH jual AS (
    SELECT Description AS produk,
           SUM(Quantity) AS qty_jual,
           SUM(Revenue)  AS rev_kotor
    FROM sales
    GROUP BY Description
),
ret AS (
    SELECT Desc_up AS produk,
           SUM(qty_retur)   AS qty_retur,
           SUM(nilai_retur) AS nilai_retur
    FROM retur
    GROUP BY Desc_up
)
SELECT
    j.produk,
    j.qty_jual,
    ROUND(j.rev_kotor, 0)                              AS rev_kotor,
    COALESCE(r.qty_retur, 0)                           AS qty_retur,
    ROUND(COALESCE(r.nilai_retur, 0), 0)               AS nilai_retur,
    ROUND(j.rev_kotor - COALESCE(r.nilai_retur, 0), 0) AS rev_bersih
FROM jual j
LEFT JOIN ret r ON j.produk = r.produk
ORDER BY rev_bersih DESC
LIMIT 10
