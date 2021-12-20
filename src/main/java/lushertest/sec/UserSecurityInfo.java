package lushertest.sec;

import java.util.Collections;

import lombok.Getter;
import lushertest.dao.UserEntity;

/**
 * Объект для хранения информации об авторизованном пользователе.

 */
@Getter
public class UserSecurityInfo extends org.springframework.security.core.userdetails.User {

    private final UserEntity userEntity;

    public UserSecurityInfo(final UserEntity userEntity) {

        super(
                userEntity.getEmail(),
                userEntity.getPassword(),
                Collections.singleton(
                        new Authority(userEntity.isAdmin() ?
                                Authority.ROLE_ADMIN : Authority.ROLE_USER)
                )
        );

        this.userEntity = userEntity;
    }
}
