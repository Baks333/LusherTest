package lushertest.sec;

import org.springframework.security.core.GrantedAuthority;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;

/**
 * Информация о праве пользователя для авторизации к ресурсам.

 */
@Getter
@AllArgsConstructor
@EqualsAndHashCode(of = "authority")
public class Authority implements GrantedAuthority {

    public static final String ROLE_ANON = "ROLE_ANON"; // неавторизованный пользователь (не проходивший аутентификацию - anonymous)
    public static final String ROLE_USER = "ROLE_USER"; // авторизованный пользователь с доступом только к своей информации
    public static final String ROLE_ADMIN = "ROLE_ADMIN"; // авторизованный пользователь с доступом к информации обо всех пользователях и связанной с ними информации

    private final String authority;

    @Override
    public String toString() {
        return authority;
    }
}
