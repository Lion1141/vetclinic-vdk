package ru.vetapp.contracts.dto;

import java.io.Serializable;

/**
 * Base DTO with common fields for all entities.
 */
public abstract class BaseDto implements Serializable {

    private Long id;

    public BaseDto() {
    }

    public BaseDto(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
