package lushertest.dao;

import javax.persistence.Column;
import javax.persistence.Entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lushertest.dao.base.BaseEntity;

/**
 * Сущность для справочника результатов тестов:
 * пара цветов и её текстовая интерпретация по Люшеру.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "pair", callSuper = false)
@Entity(name = "pair_description")
public class PairDescriptionEntity extends BaseEntity {

    @Column(nullable = false, length = 4, unique = true)
    private String pair;

    @Column(nullable = false, length = 1500)
    private String description;
}
