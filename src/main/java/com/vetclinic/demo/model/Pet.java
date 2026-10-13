package com.vetclinic.demo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity 
@Table(name = "pets")
public class Pet {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "full_name", nullable = false, length = 50)
    private String name;
    @Column(name = "species", nullable = false)
    private String species;
    @Column(name = "breed")
    private String breed;
    @Column(name = "weight")
    private int weight;
    @Column(name = "sex")
    private String sex;
    @Column(name = "owner")
    private String owner;
}
