package com.shop.mall.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shop.mall.entity.Order;

public interface OrderRepository extends JpaRepository<Order, Long> {
	
	@Query("select o from Order o " +
            "where o.member.loginId = :loginId " +
            "order by o.orderDate desc"
    )
    List<Order> findOrders(@Param("loginId") String loginId, Pageable pageable);

    @Query("select count(o) from Order o " +
            "where o.member.loginId = :loginId"
    )
    Long countOrder(@Param("loginId") String loginId);

}
