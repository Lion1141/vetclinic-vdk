-- V1__init.sql

CREATE TABLE clinics (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    address     VARCHAR(500) NOT NULL,
    phone       VARCHAR(50),
    email       VARCHAR(255),
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_clinics_name ON clinics(name);
