package com.shop.mall.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.Item;

public interface ItemRepository extends JpaRepository<Item, Long> {

}
