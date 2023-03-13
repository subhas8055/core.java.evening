package com.xworkz.apps;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class Stall {
	private int id;
	private String name;
	private String location;
	private String owner;
	
	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return this.id;
	}
	
		@Override
		public String toString() {
			return "Stall [id=" + id + ", name=" + name + ", location=" + location + ", owner=" + owner + "]";
		}
		@Override
		public boolean equals(Object obj) {
			Stall stall = new Stall();
			if( this.id == stall.id && this.name.equals(stall.name)) {
				return true;
			}
			return false;
		}


}
