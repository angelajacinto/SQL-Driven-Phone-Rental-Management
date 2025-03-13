-- Provides a summarized report of customer rentals, including:
-- 1. Total rental days per phone model
-- 2. The financial year in which rentals occurred
-- 3. Total rental cost paid by each customer
-- 4. Handles cases where the phone record no longer exists
CREATE VIEW CustomerSummary AS
SELECT
    rentalContract.customerId,
    PhoneModel.modelName,
    SUM(julianday(rentalContract.dateBack) - julianday(rentalContract.dateOut)) AS daysRented,
    CASE
        -- If rental starts from July onward, assign next financial year
        WHEN strftime('%m', rentalContract.dateOut) >= '07' THEN
            strftime('%Y', rentalContract.dateOut) || '/' || strftime('%y', rentalContract.dateOut, '+1 year')
        -- Otherwise, assign the current financial year
        ELSE
            strftime('%Y', rentalContract.dateOut, '-1 year') || '/' || strftime('%y', rentalContract.dateOut)
    END AS taxYear,
    SUM(PhoneModel.baseCost + (julianday(rentalContract.dateBack) - julianday(rentalContract.dateOut)) * PhoneModel.dailyCost) AS rentalCost
FROM rentalContract
INNER JOIN Phone ON rentalContract.IMEI = phone.IMEI
LEFT JOIN PhoneModel ON phone.modelNumber = PhoneModel.modelNumber
WHERE rentalContract.dateBack IS NOT NULL -- Only consider completed rentals
GROUP BY rentalContract.customerId, PhoneModel.modelName, taxYear

UNION ALL

-- Handles cases where the phone was removed from inventory
SELECT
    rentalContract.customerId,
    NULL AS modelName,    -- No phone model available (phone deleted)
    SUM(julianday(rentalContract.dateBack) - julianday(rentalContract.dateOut)) AS daysRented,
    CASE
        WHEN strftime('%m', rentalContract.dateOut) >= '07' THEN
            strftime('%Y', rentalContract.dateOut) || '/' || strftime('%y', rentalContract.dateOut, '+1 year')
        ELSE
            strftime('%Y', rentalContract.dateOut, '-1 year') || '/' || strftime('%y', rentalContract.dateOut)
    END AS taxYear,
    SUM(COALESCE(PhoneModel.baseCost, 0) + (julianday(rentalContract.dateBack) - julianday(rentalContract.dateOut)) * COALESCE(PhoneModel.dailyCost, 0)) AS rentalCost
FROM rentalContract
LEFT JOIN Phone ON rentalContract.IMEI = Phone.IMEI
LEFT JOIN PhoneModel ON Phone.modelNumber = PhoneModel.modelNumber
WHERE rentalContract.dateBack IS NOT NULL AND Phone.IMEI IS NULL   -- Only consider deleted phones
GROUP BY rentalContract.customerId, taxYear;
