package com.xworkz.distribution.subhas;

import java.util.List;

import com.xworkz.distribution.distributor.dto.SalesPersonDTO;

public interface Distributor {
 public boolean save(SalesPersonDTO s) throws Exception;
 public List<SalesPersonDTO> getAll();
}
