package com.shop.mall.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shop.mall.dto.CartDetailDto;
import com.shop.mall.dto.CartItemDto;
import com.shop.mall.dto.CartOrderDto;
import com.shop.mall.service.CartService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CartController {

	private final CartService cartService;
	
	@PostMapping(value = "/cart")
    public @ResponseBody ResponseEntity<?> cart(@RequestBody @Valid CartItemDto cartItemDto, BindingResult bindingResult, Principal principal){

        if(bindingResult.hasErrors()){
            StringBuilder sb = new StringBuilder();
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();

            for (FieldError fieldError : fieldErrors) {
                sb.append(fieldError.getDefaultMessage());
            }

            return new ResponseEntity<String>(sb.toString(), HttpStatus.BAD_REQUEST);
        }

        String email = principal.getName();
        Long cartItemId;
        
        System.out.println(email);

        try {
            cartItemId = cartService.addCart(cartItemDto, email);
        } catch(Exception e){
            return new ResponseEntity<String>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity<Long>(cartItemId, HttpStatus.OK);
    }
	
	
	@GetMapping(value="/cart")
	public String cartrHist(Principal principal, Model model) {
		List<CartDetailDto> cartDetailList = cartService.getCartList(principal.getName());
		
		model.addAttribute("cartItems", cartDetailList);
		return "jsp/cart/cartList";
	}
	
	
	//???????????? ????????? ????????? ?????????????????? ????????? ??????
	@PatchMapping(value = "/cartItem/{cartItemId}")
	public @ResponseBody ResponseEntity<?> updateCartItem(
			@PathVariable("cartItemId") Long cartItemId, int count, Principal principal) {
		
		if(count <= 0) {
			return new ResponseEntity<String> ("?????? 1??? ?????? ???????????????", HttpStatus.FORBIDDEN);
		} else if(!cartService.validateCartItem(cartItemId, principal.getName())) {
			return new ResponseEntity<String> ("?????? ????????? ????????????.", HttpStatus.FORBIDDEN);
		}

		cartService.updateCartItemCount(cartItemId, count);
		return new ResponseEntity<Long>(cartItemId, HttpStatus.OK);
	}
	
	// ???????????? ????????? ???????????? ??????
	// HTTP ??????????????? DELETE??? ?????? ????????? ????????? ??????
	@DeleteMapping(value="/cartItem/{cartItemId}")
	public @ResponseBody ResponseEntity<?> deleteCartItem(
			@PathVariable("cartItemId") Long cartItemId, Principal principal) {
		
		if(!cartService.validateCartItem(cartItemId, principal.getName())) {
			return new ResponseEntity<String>("?????? ????????? ????????????.", HttpStatus.FORBIDDEN);
		}
		
		cartService.deleteCartItem(cartItemId);
		return new ResponseEntity<Long>(cartItemId, HttpStatus.OK);
	}
	
	//
	@PostMapping(value="/cart/orders")
	public @ResponseBody ResponseEntity<?> orderCartItem(
			@RequestBody CartOrderDto cartOrderDto, Principal principal){
		
		List<CartOrderDto> cartOrderDtoList = cartOrderDto.getCartOrderDtoList();
		
		if(cartOrderDtoList == null || cartOrderDtoList.size()==0) {
			return new ResponseEntity<String>("????????? ????????? ???????????????", HttpStatus.FORBIDDEN);
		}
		
		for(CartOrderDto cartOrder : cartOrderDtoList) {
			if(!cartService.validateCartItem(cartOrder.getCartItemId(), principal.getName())) {
				return new ResponseEntity<String>("?????? ????????? ????????????.", HttpStatus.FORBIDDEN);
			}
		}
		
		Long orderId = cartService.orderCartItem(cartOrderDtoList, principal.getName());
		
		return new ResponseEntity<Long>(orderId, HttpStatus.OK);
	}
	
}
