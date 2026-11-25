-- Membuat view retur bersih dan view RFM
-- Dataset: Online Retail (UCI), tabel: sales

DROP VIEW IF EXISTS retur;
CREATE VIEW retur AS
SELECT *, UPPER(TRIM(Description)) AS Desc_up,
       -Quantity AS qty_retur, -Quantity * UnitPrice AS nilai_retur
FROM cancel
WHERE StockCode NOT IN ('POST','D','M','DOT','CRUK','BANK CHARGES','AMAZONFEE','S','B','PADS');


DROP VIEW IF EXISTS rfm_base;
DROP VIEW IF EXISTS rfm_skor;
DROP VIEW IF EXISTS rfm_segmen;

CREATE VIEW rfm_base AS
SELECT CustomerID,
    CAST(julianday((SELECT DATE(MAX(InvoiceDate), '+1 day') FROM sales))
         - julianday(DATE(MAX(InvoiceDate))) AS INTEGER) AS recency,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    ROUND(SUM(Revenue), 2)    AS monetary
FROM sales
WHERE punya_customer_id = 1
GROUP BY CustomerID;

CREATE VIEW rfm_skor AS
SELECT *,
    NTILE(5) OVER (ORDER BY recency DESC)        AS r_skor,
    NTILE(5) OVER (ORDER BY frequency, monetary) AS f_skor,
    NTILE(5) OVER (ORDER BY monetary)            AS m_skor
FROM rfm_base;

CREATE VIEW rfm_segmen AS
SELECT *,
    CASE
        WHEN r_skor >= 4 AND f_skor >= 4 THEN 'Champions'
        WHEN r_skor >= 3 AND f_skor >= 3 THEN 'Loyal'
        WHEN r_skor >= 4 AND f_skor <= 2 THEN 'Pelanggan Baru'
        WHEN r_skor <= 2 AND f_skor >= 3 THEN 'Berisiko Pergi'
        WHEN r_skor <= 2 AND f_skor <= 2 THEN 'Hilang'
        ELSE 'Perlu Perhatian'
    END AS segmen
FROM rfm_skor;
