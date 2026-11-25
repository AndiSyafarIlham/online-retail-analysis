-- Pertanyaan 3: ringkasan segmen pelanggan RFM
-- Dataset: Online Retail (UCI), tabel: sales

SELECT
    segmen,
    COUNT(*)                                                       AS pelanggan,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rfm_segmen), 1) AS pct_pelanggan,
    ROUND(SUM(monetary), 0)                                        AS revenue,
    ROUND(SUM(monetary) * 100.0 / (SELECT SUM(monetary) FROM rfm_segmen), 1) AS pct_revenue,
    ROUND(AVG(recency), 0)                                         AS rata2_recency,
    ROUND(AVG(frequency), 1)                                       AS rata2_frekuensi
FROM rfm_segmen
GROUP BY segmen
ORDER BY revenue DESC
