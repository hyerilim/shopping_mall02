package com.shop.mall.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.shop.mall.entity.CartItem;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
	
	// 장바구니에 들어갈 상품을 저장하거나 조회
	CartItem findByCartIdAndItemId(Long cartId, Long itemId);

}
