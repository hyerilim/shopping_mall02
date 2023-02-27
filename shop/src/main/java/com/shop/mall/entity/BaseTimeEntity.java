package com.shop.mall.entity;

import java.time.LocalDateTime;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import jakarta.persistence.Column;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

@EntityListeners(value= {AuditingEntityListener.class})			// Auditing을 적용하기 위해서 @EntityListeners 추가
@MappedSuperclass												// 공통 매칭 정보가 필요할 때 사용하는 어노테이션, 부모 클래스를 상속 받는 자식 클래스에 매핑 정보만 제공
@Getter
@Setter
public abstract class BaseTimeEntity {
	
	@CreatedDate		// 엔티티가 생성되어 저장될 때 시간을 자동으로 저장		
	@Column(updatable = false)
	private LocalDateTime regTime;
	
	@LastModifiedDate		// 엔티티의 값을 변경할 때 시간을 자동으로 저장
	@Column(insertable = false)
	private LocalDateTime updateTime;
	
}
