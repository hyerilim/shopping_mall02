//package com.shop.mall.config;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.data.domain.AuditorAware;
//import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
//
//@Configuration	// JPA의 Auditing 기능을 활성화합니다.
//public class AuditConfig {
//	
//	@Bean
//	public AuditorAware<String> auditorProvider(){		// 등록자와 수정자를 처리해주는 AuditorAware
//		return new AuditorAwareImpl();
//	}
//}
