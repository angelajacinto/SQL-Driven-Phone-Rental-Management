-- Stores different phone models that the company rents out
-- where each model is identified by modelNumber
CREATE TABLE PhoneModel (
  modelNumber TEXT PRIMARY KEY,
  modelName TEXT NOT NULL, -- NOT NULL prevents missing data
  storage INTEGER NOT NULL CHECK(storage > 0), -- Ensures that storage values are valid
  colour TEXT NOT NULL,
  baseCost REAL NOT NULL CHECK(baseCost >= 0), -- Prevents negative values
  dailyCost REAL NOT NULL CHECK(dailyCost >= 0)
);


-- Stores customer information whewre each customer is uniquely identified by customerId
CREATE TABLE Customer (
  customerId INTEGER PRIMARY KEY,
  customerName TEXT NOT NULL,
  customerEmail TEXT UNIQUE NOT NULL CHECK(customerEmail LIKEm %@%.%) -- UNIQUE ensures there are no duplicate accounts
);                                                                    -- %@%.% ensures valid email following standard email pattern


-- Stores individual phones and linking them to the PhoneModel table
-- IMEI validation is done by a pre-defined length and the use of the 
-- Luhn algorithm to prevent typos and invalid numbers
CREATE TABLE Phone (
    modelNumber TEXT,
    -- modelName TEXT, TAKE OUT because of redundauncy 
    IMEI TEXT PRIMARY KEY CHECK (LENGTH(IMEI) = 15 AND (
        (
            SUM(
                (SUBSTR(IMEI, 1, 1) + SUBSTR(IMEI, 3, 1) + SUBSTR(IMEI, 5, 1) +
                SUBSTR(IMEI, 7, 1) + SUBSTR(IMEI, 9, 1) + SUBSTR(IMEI, 11, 1) +
                SUBSTR(IMEI, 13, 1) + SUBSTR(IMEI, 15, 1)) +
                (
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 2, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 2, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 2, 1) * 2)
                        END
                    ) +
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 4, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 4, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 4, 1) * 2)
                        END
                    ) +
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 6, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 6, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 6, 1) * 2)
                        END
                    ) +
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 8, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 8, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 8, 1) * 2)
                        END
                    ) +
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 10, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 10, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 10, 1) * 2)
                        END
                    ) +
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 12, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 12, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 12, 1) * 2)
                        END
                    ) +
                    SUM(
                        CASE 
                            WHEN (SUBSTR(IMEI, 14, 1) * 2) > 9 
                            THEN (SUBSTR(IMEI, 14, 1) * 2) - 9
                            ELSE (SUBSTR(IMEI, 14, 1) * 2)
                        END
                    )
                )
            )
        ) % 10 = 0
    ))

    FOREIGN KEY (modelNumber) REFERENCES PhoneModel(modelNumber) ON DELETE CASCADE
);


-- Tracks rental transactions between customers and phones
-- Ensures rentals are linked to valid customers and phones
CREATE TABLE rentalContract (
    rentalId INTEGER PRIMARY KEY AUTO, -- Adds a unique identifire for each rental
    customerId INTEGER NOT NULL,
    IMEI  TEXT NOT NULL,
    dateOut DATE NOT NULL,
    dateBack DATE CHECK(dateBack >= dateOut), -- Constraint prevents invalid rentals
    rentalCost REAL NOT NULL CHECK(rentalCost >= 0),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId),
    FOREIGN KEY (IMEI) REFERENCES Phone(IMEI) ON DELETE SET NULL -- If the referenced IMEI in the Phone table
);                                                               -- is deleted, IMEI is set to NULL instead of deletion
