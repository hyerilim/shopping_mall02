package com.shop.mall.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.dto.OrderDto;
import com.shop.mall.dto.OrderHistDto;
import com.shop.mall.dto.OrderItemDto;
import com.shop.mall.entity.Item;
import com.shop.mall.entity.ItemImg;
import com.shop.mall.entity.Member;
import com.shop.mall.entity.Order;
import com.shop.mall.entity.OrderItem;
import com.shop.mall.repository.ItemImgRepository;
import com.shop.mall.repository.ItemRepository;
import com.shop.mall.repository.MemberRepository;
import com.shop.mall.repository.OrderRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {

    private final ItemRepository itemRepository;

    private final MemberRepository memberRepository;

    private final OrderRepository orderRepository;

    private final ItemImgRepository itemImgRepository;

    public Long order(OrderDto orderDto, String loginId){

        Item item = itemRepository.findById(orderDto.getItemId())
                .orElseThrow(EntityNotFoundException::new);

        Member member = memberRepository.findByLoginId(loginId);

        List<OrderItem> orderItemList = new ArrayList<>();
        OrderItem orderItem = OrderItem.createOrderItem(item, orderDto.getCount());
        orderItemList.add(orderItem);
        Order order = Order.createOrder(member, orderItemList);
        orderRepository.save(order);

        return order.getId();
    }

    
    // 구매 내역
    @Transactional(readOnly = true)
    public Page<OrderHistDto> getOrderList(String loginId, Pageable pageable) {

        List<Order> orders = orderRepository.findOrders(loginId, pageable);
        Long totalCount = orderRepository.countOrder(loginId);

        List<OrderHistDto> orderHistDtos = new ArrayList<>();

        for (Order order : orders) {
            OrderHistDto orderHistDto = new OrderHistDto(order);
            List<OrderItem> orderItems = order.getOrderItems();
            for (OrderItem orderItem : orderItems) {
                ItemImg itemImg = itemImgRepository.findByItemIdAndRepimgYn
                        (orderItem.getItem().getId(), "Y");
                OrderItemDto orderItemDto =
                        new OrderItemDto(orderItem, itemImg.getImgUrl());
                orderHistDto.addOrderItemDto(orderItemDto);
            }

            orderHistDtos.add(orderHistDto);
        }

        return new PageImpl<OrderHistDto>(orderHistDtos, pageable, totalCount);
    }
}
