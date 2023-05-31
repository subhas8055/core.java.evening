package com.xworkz.mobiles.dto;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name="mobile")

public class MobilesDTO {
	@Id
	@Column(name="id")
private int id;
	@Column(name="brand")
private String brand;
	@Column(name="color")
private String color;
	@Column(name="ram")
private String ram;
	@Column(name="price")
private int price;

}
