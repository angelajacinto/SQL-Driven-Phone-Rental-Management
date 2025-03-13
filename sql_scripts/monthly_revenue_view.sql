-- Calculates total revenue per month where the revenue formula is: baseCost + (rental days * dailyCost)

CREATE VIEW MonthlyRevenue AS
SELECT strftime('%Y-%m', r.dateOut) AS month,
SUM(pm.baseCost + (julianday(r.dateBack) - julianday(r.dateOut)) * pm.dailyCost) AS revenue
FROM rentalContract r
LEFT JOIN Phone p ON r.IMEI = p.IMEI
LEFT JOIN PhoneModel pm ON p.modelNumber = pm.modelNumber
WHERE r.dateBack IS NOT NULL
GROUP BY month
ORDER BY month DESC;
