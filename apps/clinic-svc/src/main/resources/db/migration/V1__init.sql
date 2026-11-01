CREATE TABLE pat_patients (
    id          uuid PRIMARY KEY,
    clinic_id   uuid NOT NULL,
    owner_id    uuid,
    name        varchar(120) NOT NULL,
    species_id  varchar(50) NOT NULL,
    sex         varchar(10),
    birth_date  date,
    created_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
)