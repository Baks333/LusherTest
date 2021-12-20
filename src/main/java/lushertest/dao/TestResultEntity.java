package lushertest.dao;

import java.time.Instant;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lushertest.dao.base.BaseEntity;

/**
 * Сущность для привязки результатов тестов (в виде пар цветов с описанием по Люшеру)
 * к зарегистрированному пользователю.
 */
@Getter
@NoArgsConstructor
@Entity(name = "test_result")
public class TestResultEntity extends BaseEntity {

//    @Column(nullable = false)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user", nullable = false)
    private UserEntity user;

//    @Column(nullable = false)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pair", nullable = false)
    private PairDescriptionEntity pairDescription;

    public TestResultEntity(final Instant created,
                            final UserEntity user,
                            final PairDescriptionEntity pairDescription
    ) {
        this.created = created;
        this.user = user;
        this.pairDescription = pairDescription;
    }
}
