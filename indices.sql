-- INDEX ON MEDICINE BARCODE SINCE PHARMACISTS WILL BE LOOKING FOR MEDICINE BY BARCODE OFTEN
CREATE INDEX idx_inventory_barcode ON pharmacy.inventory(barcode);
