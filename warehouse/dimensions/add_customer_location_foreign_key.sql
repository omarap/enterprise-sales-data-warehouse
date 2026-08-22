ALTER TABLE warehouse.dim_customer
ADD CONSTRAINT fk_dim_customer_location
    FOREIGN KEY (location_key)
    REFERENCES warehouse.dim_location(location_key);