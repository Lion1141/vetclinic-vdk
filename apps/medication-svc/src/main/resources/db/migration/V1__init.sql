-- V1__init.sql

CREATE TABLE medications (
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    description   TEXT,
    dosage        VARCHAR(100),
    unit          VARCHAR(20),
    quantity      INTEGER NOT NULL DEFAULT 0,
    created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_medications_name ON medications(name);
