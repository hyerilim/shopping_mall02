//package com.shop.mall.test;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//
//import com.shop.mall.constant.ItemSellStatus;
//import com.shop.mall.dto.CartItemDto;
//import com.shop.mall.entity.CartItem;
//import com.shop.mall.entity.Item;
//import com.shop.mall.entity.Member;
//import com.shop.mall.repository.CartItemRepository;
//import com.shop.mall.repository.ItemRepository;
//import com.shop.mall.repository.MemberRepository;
//import com.shop.mall.service.CartService;
//
//import jakarta.persistence.EntityNotFoundException;
//
//@SpringBootTest
//class CartServiceTest {
//
//    @Autowired
//    ItemRepository itemRepository;
//
//    @Autowired
//    MemberRepository memberRepository;
//
//    @Autowired
//    CartService cartService;
//
//    @Autowired
//    CartItemRepository cartItemRepository;
//
//    public Item saveItem(){
//        Item item = new Item();
//        item.setItemNm("테스트 상품");
//        item.setPrice(10000);
//        item.setItemDetail("테스트 상품 상세 설명");
//        item.setItemSellStatus(ItemSellStatus.SELL);
//        item.setStockNumber(100);
//        return itemRepository.save(item);
//    }
//
//    public Member saveMember(){
//        Member member = new Member();
//        member.setEmail("test@test.com");
//        return memberRepository.save(member);
//    }
//
//    @Test
//    @DisplayName("장바구니 담기 테스트")
//    public void addCart(){
//        Item item = saveItem();
//        Member member = saveMember();
//
//        CartItemDto cartItemDto = new CartItemDto();
//        cartItemDto.setCount(5);
//        cartItemDto.setItemId(item.getId());
//
//        Long cartItemId = cartService.addCart(cartItemDto, member.getEmail());
//        CartItem cartItem = cartItemRepository.findById(cartItemId)
//                .orElseThrow(EntityNotFoundException::new);
//
//        assertEquals(item.getId(), cartItem.getItem().getId());
//        assertEquals(cartItemDto.getCount(), cartItem.getCount());
//    }
//
//}
