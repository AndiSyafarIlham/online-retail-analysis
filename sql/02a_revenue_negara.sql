-- Pertanyaan 2a: negara dengan revenue terbesar
-- Dataset: Online Retail (UCI), tabel: sales

SELECT
    Country,
    ROUND(SUM(Revenue), 0)                                      AS revenue,
    COUNT(DISTINCT InvoiceNo)                                   AS jml_order,
    ROUND(SUM(Revenue) * 100.0 / (SELECT SUM(Revenue) FROM sales), 2) AS pct_revenue
FROM sales
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10
