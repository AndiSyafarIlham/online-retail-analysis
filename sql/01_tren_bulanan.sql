-- Pertanyaan 1: tren penjualan per bulan
-- Dataset: Online Retail (UCI), tabel: sales

WITH bulanan AS (
    SELECT
        Bulan,
        ROUND(SUM(Revenue), 0)       AS revenue,
        COUNT(DISTINCT InvoiceNo)    AS jml_order
    FROM sales
    GROUP BY Bulan
)
SELECT
    Bulan,
    revenue,
    jml_order,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY Bulan)) * 100.0
          / LAG(revenue) OVER (ORDER BY Bulan), 1) AS growth_pct
FROM bulanan
ORDER BY Bulan
