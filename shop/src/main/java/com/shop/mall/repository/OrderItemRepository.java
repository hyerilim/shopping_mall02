package com.shop.mall.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.OrderItem;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

}
