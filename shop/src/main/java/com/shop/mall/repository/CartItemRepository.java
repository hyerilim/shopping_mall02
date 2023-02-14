package com.shop.mall.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shop.mall.dto.CartDetailDto;
import com.shop.mall.entity.CartItem;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
	
	// 장바구니에 들어갈 상품을 저장하거나 조회
	CartItem findByCartIdAndItemId(Long cartId, Long itemId);
	
	// 장바구니 리스트
	@Query("select new com.shop.mall.dto.CartDetailDto(ci.id, i.itemNm, i.price, ci.count, im.imgUrl) " +
            "from CartItem ci, ItemImg im " +
            "join ci.item i " +
            "where ci.cart.id = :cartId " +
            "and im.item.id = ci.item.id " +
            "and im.repimgYn = 'Y' " +
            "order by ci.regTime desc"
            )
	List<CartDetailDto> findCartDetailDtoList(@Param("cartId") Long cartId);

}
