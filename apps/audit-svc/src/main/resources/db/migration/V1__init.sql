-- V1__init.sql

CREATE TABLE audit_events (
    id          BIGSERIAL PRIMARY KEY,
    event_type  VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id   VARCHAR(100) NOT NULL,
    user_id     VARCHAR(100),
    description TEXT,
    payload     JSONB,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_events_type ON audit_events(event_type);
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id);
CREATE INDEX idx_audit_events_created ON audit_events(created_at);
