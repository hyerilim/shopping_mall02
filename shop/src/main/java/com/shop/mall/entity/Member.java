package com.shop.mall.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="member")
@Getter
@Setter
@ToString
public class Member {
	
	@Id
    @Column(name="member_id")
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long id;

    private String name;

    @Column(unique = true)
    private String email;

    private String password;

    private String address;

    //@Enumerated(EnumType.STRING)
    //private Role role;

}
