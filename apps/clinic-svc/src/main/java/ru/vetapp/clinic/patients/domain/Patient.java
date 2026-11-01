package ru.vetapp.clinic.patients.domain;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import ru.vetapp.clinic.patients.domain.enums.SexEnum;

@Entity
@Table(name = "pat_patients")
public class Patient {

    @Id
    @Column(name = "id", nullable=false)
    @GeneratedValue(strategy = GenerationType.UUID)
    @NotNull 
    private Integer patId;

    @Column(name ="patient_name", nullable=false)
    @NotBlank
    private String name;

    @Column(name = "species_id")
    private Integer speciesId;

    @Column(name = "sex")
    private SexEnum sex;

    @Column(name = "birth_date")
    private LocalDate birthDate;

}
