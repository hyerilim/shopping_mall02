package com.shop.mall.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class OrderItem {
    @Id
    @GeneratedValue
    @Column(name="order_item_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name="order_id")
    private Order order;

    private int orderPrice; //주문 가격

    private int count;// 수량

    private LocalDateTime regTime;

    private LocalDateTime updateTime;

}
