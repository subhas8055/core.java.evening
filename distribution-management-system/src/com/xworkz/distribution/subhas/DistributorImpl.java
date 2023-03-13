package com.xworkz.distribution.subhas;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import com.xworkz.distribution.distributor.dto.SalesPersonDTO;


public class DistributorImpl  implements Distributor{
	
	public List<SalesPersonDTO> list = new ArrayList<SalesPersonDTO>();
	SalesPersonDTO sale =new SalesPersonDTO();
	@Override
	public boolean save(SalesPersonDTO s) throws Exception {
		System.out.println("inside save ()");
			boolean isAdded= false;
			if( s!=null && s.getId()>=1 && s.getName()!=null ) {
				System.out.println("hi");
				list.add(s);
				isAdded= true;
			}
			else {
				System.out.println("not added");
			}
		return false;
	}

	@Override
	public List<SalesPersonDTO> getAll() {
		System.out.println("inside get()");
		Iterator<SalesPersonDTO> i=list.iterator();
		while(i.hasNext()){			
			System.out.println(i.next());
		}
		
		
//      System.out.println("inside get() after sort");
//		Collections.sort(list);
//		Iterator<SalesPersonDTO> i2=list.iterator();
//		while(i2.hasNext()){			
//			System.out.println(i2.next());
//		}
		return list;
	}
	
	


}
