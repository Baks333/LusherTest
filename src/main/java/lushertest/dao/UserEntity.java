package lushertest.dao;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lushertest.dao.base.BaseEntity;

/**
 * Сущность, для хранения всех данных о пользователе, включая данные для авторизации.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
// функции equals и hashCode автоматически создаются библиотекой lombok
// по уникальному идентификатору пользователя
@EqualsAndHashCode(of = "email", callSuper = false)
@Entity(name = "user")
public class UserEntity extends BaseEntity {


    @Column(nullable = false)
    private String fullName;


    @Column(nullable = false)
    private Gender gender;


    @Column(nullable = false)
    private LocalDate birthday;

    /**
     * почтовый адрес, уникально идентифицирующий пользователя в БД,
     * по нему выполняются все запросы клиентского API, касающиеся конкретного пользователя
     */
    @Column(nullable = false, unique = true)
    private String email;


    @Column(nullable = false)
    private String password;


    @Column(nullable = false)
    private boolean admin;


    @Override
    public String toString() {
        return "{" +
                "'" + fullName + '\'' +
                ", '" + email + '\'' +
                '}';
    }
}
