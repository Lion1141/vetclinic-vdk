-- V1__init.sql

CREATE TABLE sync_records (
    id              BIGSERIAL PRIMARY KEY,
    source_service  VARCHAR(50) NOT NULL,
    entity_type     VARCHAR(50) NOT NULL,
    entity_id       VARCHAR(100) NOT NULL,
    payload         JSONB NOT NULL,
    status          VARCHAR(20) DEFAULT 'PENDING',
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sync_records_status ON sync_records(status);
CREATE INDEX idx_sync_records_entity ON sync_records(entity_type, entity_id);
