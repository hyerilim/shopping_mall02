package com.shop.mall.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.shop.mall.dto.CartDetailDto;
import com.shop.mall.dto.CartItemDto;
import com.shop.mall.dto.CartOrderDto;
import com.shop.mall.dto.OrderDto;
import com.shop.mall.entity.Cart;
import com.shop.mall.entity.CartItem;
import com.shop.mall.entity.Item;
import com.shop.mall.entity.Member;
import com.shop.mall.repository.CartItemRepository;
import com.shop.mall.repository.CartRepository;
import com.shop.mall.repository.ItemRepository;
import com.shop.mall.repository.MemberRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class CartService {

	private final ItemRepository itemRepository;
	private final MemberRepository memberRepository;
	private final CartRepository cartRepository;
	private final CartItemRepository cartItemRepository;
	private final OrderService orderService;
	
	public Long addCart(CartItemDto cartItemDto, String loginId) {
		
		Item item = itemRepository.findById(cartItemDto.getItemId())
				.orElseThrow(EntityNotFoundException::new);
		Member member = memberRepository.findByLoginId(loginId);
		
		Cart cart = cartRepository.findByMemberId(member.getId());
		if(cart==null) {
			cart = Cart.createCart(member);
			cartRepository.save(cart);
		}
		
		CartItem savedCartItem = cartItemRepository.findByCartIdAndItemId(cart.getId(), item.getId());
		
		if(savedCartItem != null) {
			savedCartItem.addCount(cartItemDto.getCount());
			return savedCartItem.getId();
		} else {
			CartItem cartItem = CartItem.createCartItem(cart, item, cartItemDto.getCount());
			cartItemRepository.save(cartItem);
			return cartItem.getId();
		}
	}
	
	// 로그인 정보를 이용하여 장바구니에 들어있는 상품을 조회
	@Transactional(readOnly = true)
	public List<CartDetailDto> getCartList(String loginId) {
	
		List<CartDetailDto> cartDetailDtoList = new ArrayList<>();
		
		Member member = memberRepository.findByLoginId(loginId);
		Cart cart = cartRepository.findByMemberId(member.getId());
		
		if(cart == null) {
			return cartDetailDtoList;
		}
	
		cartDetailDtoList = cartItemRepository.findCartDetailDtoList(cart.getId());
		
		return cartDetailDtoList;
	}
	
	
	@Transactional(readOnly = true)
	public boolean validateCartItem(Long cartItemId, String loginId) {
		Member curMember = memberRepository.findByLoginId(loginId);
		CartItem cartItem = cartItemRepository.findById(cartItemId).orElseThrow(EntityNotFoundException::new);
		
		Member savedMember = cartItem.getCart().getMember();
		
		if(!StringUtils.pathEquals(curMember.getLoginId(), savedMember.getLoginId())) {
			return false;
		}
		
		return true;
	}
	
	
	public void updateCartItemCount(Long cartItemId, int count) {
		CartItem cartItem = cartItemRepository.findById(cartItemId).orElseThrow(EntityNotFoundException::new);
		
		cartItem.updateCount(count);
	}
	
	
	public void deleteCartItem(Long cartItemId) {
		CartItem cartItem = cartItemRepository.findById(cartItemId).orElseThrow(EntityNotFoundException::new);
	
		cartItemRepository.delete(cartItem);
	}
	
	
	// orderDto 리스트 생성 및 주문 로직 호출, 주문한 상품은 장바구니에서 제거하는 로직 구현
    public Long orderCartItem(List<CartOrderDto> cartOrderDtoList, String loginId) {
    	List<OrderDto> orderDtoList = new ArrayList<>();
    	
    	for(CartOrderDto cartOrderDto : cartOrderDtoList) {
    		CartItem cartItem = cartItemRepository.findById(cartOrderDto.getCartItemId()).orElseThrow(EntityNotFoundException::new);
    		
    		OrderDto orderDto = new OrderDto();
    		orderDto.setItemId(cartItem.getItem().getId());
    		orderDto.setCount(cartItem.getCount());
    		orderDtoList.add(orderDto);
    	}
    	
    	Long orderId = orderService.orders(orderDtoList, loginId);

    	for(CartOrderDto cartOrderDto : cartOrderDtoList) {
    		CartItem cartItem = cartItemRepository.findById(cartOrderDto.getCartItemId())
    												.orElseThrow(EntityNotFoundException::new);
    		cartItemRepository.delete(cartItem);
    	}
    	return orderId;
    }
	
}
