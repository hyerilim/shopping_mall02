package com.shop.mall.entity;

import org.springframework.security.crypto.password.PasswordEncoder;

import com.shop.mall.constant.Role;
import com.shop.mall.dto.MemberFormDto;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
public class Member extends BaseEntity {
	
	@Id
    @Column(name="member_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

	private String loginId;
    
	private String name;

    // 회원은 이메일을 통해 유일하게 구분, unique = true
    @Column(unique = true)
    private String email;

    private String password;

    private String addressNo;
    
    private String address;
    
    private String addressDetail;
    
    // 자바 enum 타입을 엔티티의 속성으로 지정가능
    // Enum을 사용할 때 기본적으로 순서가 저장되는데, enum의 순서가 바뀔 경우 문제가 발생할 수 있으므로 EnumType.STRING 옵션을 사용해서 String으로 저장하기를 권장합니다.
    @Enumerated(EnumType.STRING)
    private Role role;

    // Member 엔티티를 생성하는 메소드입니다.
    // Member 엔티티에 회원을 생성하는 메소드를 만들어서 관리를 한다면 코드가 변경되더라도 한 군데만 수정하면 되는 이점이 있습니다.
    public static Member createMember(MemberFormDto memberFormDto, PasswordEncoder passwordEncoder) {
    	Member member = new Member();
    	member.setLoginId(memberFormDto.getLoginId());
    	member.setName(memberFormDto.getName());
    	member.setEmail(memberFormDto.getEmail());
    	member.setAddressNo(memberFormDto.getAddressNo());
    	member.setAddress(memberFormDto.getAddress());
    	member.setAddressDetail(memberFormDto.getAddressDetail());
    	
    	// 스프링 시큐리티 설정 클래스에 등록한 BCryptPasswordEncoder Bean을 파라미터로 넘겨서 비밀번호를 암호화합니다.
    	String password = passwordEncoder.encode(memberFormDto.getPassword());
    	member.setPassword(password);
    	member.setRole(Role.USER);
    	return member;
    }

}
