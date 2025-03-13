-- The trigger automatically updates the rentalCost whenever dateBack is updated in rentalContract
CREATE TRIGGER rentalCostUpdate
AFTER UPDATE OF dateBack ON rentalContract
FOR EACH ROW
WHEN NEW.dateBack IS NOT NULL AND OLD.dateBack IS NULL -- Trigger activates when dateBack is first set (when a phone is returned)
AND NEW.dateBack >= NEW.dateOut                        -- to avoid recalculation if dateBack is updated more than once
BEGIN                                                  
    UPDATE rentalContract
    SET rentalCost = (
        SELECT PhoneModel.baseCost + (
            -- Computation of rental duration
            CAST(julianday(NEW.dateBack) - julianday(NEW.dateOut) + 1 AS INTEGER) - 1 -- +1 ensures 1 day rentals are still charged base cost
        ) * PhoneModel.dailyCost                                                      -- -1 ensures that only extra days are charged the daily cost
        FROM PhoneModel
        INNER JOIN Phone ON Phone.modelNumber = PhoneModel.modelNumber
        WHERE Phone.IMEI = NEW.IMEI
    )
    WHERE customerId = NEW.customerId AND IMEI = NEW.IMEI;
END;
