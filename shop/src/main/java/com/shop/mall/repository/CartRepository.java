package com.shop.mall.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.Cart;

public interface CartRepository extends JpaRepository<Cart, Long> {
	
	// 로그인한 회원의 Cart 엔티티 찾기
	Cart findByMemberId(Long memberId);
}
