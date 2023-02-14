package com.shop.mall.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.dto.CartDetailDto;
import com.shop.mall.dto.CartItemDto;
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
	
}
