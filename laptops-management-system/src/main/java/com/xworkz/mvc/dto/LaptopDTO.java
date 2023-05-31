package com.xworkz.mvc.dto;


import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString
@AllArgsConstructor
@Entity
@Table(name="laptop")
@NamedQueries({
@NamedQuery(name="getAllLaptop" ,query ="select lap from LaptopDTO lap"),
@NamedQuery(name="getAllLaptopByName", query ="select lap from LaptopDTO lap where name=:name"),
@NamedQuery(name="getAllLaptopByRam", query ="select lap from LaptopDTO lap where ram=:ram"),
@NamedQuery(name="getAllLaptopByColor", query ="select lap from LaptopDTO lap where color=:color"),
@NamedQuery(name="getLaptopById", query ="select lap from LaptopDTO lap where id=:id"),
@NamedQuery(name="updateById", query ="update LaptopDTO lap set name=:name,ram=:ram,color=:color where id=:id"),
@NamedQuery(name="deleteLaptopById", query ="delete from LaptopDTO lap where id=:id"),
@NamedQuery(name="getAllLaptopByAll", query ="select lap from LaptopDTO lap where name=:name and ram=:ram and color=:color"),

})

public class LaptopDTO {
	@Id
	@Column(name="id")
	private int id;
	@Column(name="name")
	private String name;
	@Column(name="color")
	private String color;
	@Column(name="ram")
	private String ram;

}
