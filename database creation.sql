
-- 1. LOCATIONS


CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(100),
    risk_zone VARCHAR(20)
);


-- 2. INSURERS

CREATE TABLE insurer_info (
    insurer_id INTEGER PRIMARY KEY,
    insurer_name VARCHAR(100) NOT NULL,
    insurer_region VARCHAR(100),
    rating VARCHAR(10)
);



-- 3. INSURANCE PRODUCTS


CREATE TABLE insurance_products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    business_line VARCHAR(100)
);



-- 4. INSUREDS


CREATE TABLE insured_info (
    insured_id INTEGER PRIMARY KEY,
    insured_name VARCHAR(100) NOT NULL,
    industry VARCHAR(100),
    company_size VARCHAR(20),
    location_id INTEGER NOT NULL,

    CONSTRAINT fk_insured_location
        FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);



-- 5. EXCHANGE RATES


CREATE TABLE exchange_rates (
    rate_date DATE NOT NULL,
    currency VARCHAR(3) NOT NULL,
    rate_to_gbp NUMERIC(10,6) NOT NULL,

    PRIMARY KEY (rate_date, currency)
);



-- 6. POLICIES


CREATE TABLE policies (
    policy_id INTEGER PRIMARY KEY,
    insured_id INTEGER NOT NULL,
    insurer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,

    inception_date DATE NOT NULL,
    expiry_date DATE NOT NULL,

    policy_status VARCHAR(20),
    currency VARCHAR(3),
    written_premium NUMERIC(12,2),

    CONSTRAINT fk_policy_insured
        FOREIGN KEY (insured_id)
        REFERENCES insured_info(insured_id),

    CONSTRAINT fk_policy_insurer
        FOREIGN KEY (insurer_id)
        REFERENCES insurer_info(insurer_id),

    CONSTRAINT fk_policy_product
        FOREIGN KEY (product_id)
        REFERENCES insurance_products(product_id),

    CONSTRAINT fk_policy_location
        FOREIGN KEY (location_id)
        REFERENCES locations(location_id),

    CONSTRAINT fk_policy_exchange_rate
        FOREIGN KEY (inception_date, currency)
        REFERENCES exchange_rates(rate_date, currency)
);



-- 7. POLICY PAYMENTS


CREATE TABLE policy_payments (
    policy_payment_id INTEGER PRIMARY KEY,
    policy_id INTEGER NOT NULL,
    position_type VARCHAR(20) NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount NUMERIC(12,2),

    CONSTRAINT fk_policy_payment_policy
        FOREIGN KEY (policy_id)
        REFERENCES policies(policy_id)
);



-- 8. CLAIMS


CREATE TABLE claims (
    claim_id INTEGER PRIMARY KEY,
    policy_id INTEGER NOT NULL,
    insured_id INTEGER NOT NULL,
    insurer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,

    claim_date DATE NOT NULL,
    claim_status VARCHAR(20),
    claim_type VARCHAR(100),
    incurred_amount NUMERIC(12,2),

    CONSTRAINT fk_claim_policy
        FOREIGN KEY (policy_id)
        REFERENCES policies(policy_id),

    CONSTRAINT fk_claim_insured
        FOREIGN KEY (insured_id)
        REFERENCES insured_info(insured_id),

    CONSTRAINT fk_claim_insurer
        FOREIGN KEY (insurer_id)
        REFERENCES insurer_info(insurer_id),

    CONSTRAINT fk_claim_product
        FOREIGN KEY (product_id)
        REFERENCES insurance_products(product_id),

    CONSTRAINT fk_claim_location
        FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);



-- 9. CLAIM PAYMENTS


CREATE TABLE claim_payments (
    claim_payment_id INTEGER PRIMARY KEY,
    claim_id INTEGER NOT NULL,
    position_type VARCHAR(20) NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount NUMERIC(12,2),

    CONSTRAINT fk_claim_payment_claim
        FOREIGN KEY (claim_id)
        REFERENCES claims(claim_id)
);