package com.shop.mall.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.repository.query.Param;

import com.shop.mall.entity.Item;

public interface ItemRepository extends JpaRepository<Item, Long>, QuerydslPredicateExecutor<Item>, ItemRepositoryCustom {

	List<Item> findByItemNm(String itemNm);
	
	List<Item> findByItemNmOrItemDetail(String itemNm, String itemDetail);
	
	List<Item> findByPriceLessThan(Integer price);
	
	List<Item> findByPriceLessThanOrderByPriceDesc(Integer price);
	
	@Query("select i from Item i where i.itemDetail like %:itemDetail% order by i.price desc")
	List<Item> findByItemDetail(@Param("itemDetail") String itemDetail);

}