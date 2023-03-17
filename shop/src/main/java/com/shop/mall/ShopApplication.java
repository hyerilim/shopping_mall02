package com.shop.mall;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

import com.shop.mall.config.AuditorAwareImpl;

@SpringBootApplication
@EnableJpaAuditing
@Configuration
public class ShopApplication {

	@Bean
	public AuditorAware<String> auditorProvider(){		// 등록자와 수정자를 처리해주는 AuditorAware
		return new AuditorAwareImpl();
	}
	
	public static void main(String[] args) {
		SpringApplication.run(ShopApplication.class, args);
		
		
	}

}
