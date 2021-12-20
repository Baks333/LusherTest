package lushertest.dao.base;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.time.Instant;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

import lombok.Getter;

/**
 * Базовая сущность, от которой наследуются все остальные, имеет общие для всех сущностей поля.
 */
@Getter

@MappedSuperclass
public class BaseEntity {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    protected Long id;


    @Column(name = "created", nullable = false)
    protected Instant created = Instant.now();


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BaseEntity that = (BaseEntity) o;
        return Objects.equals(getId(), that.getId());
    }


    @Override
    public int hashCode() {
        if (getId() == null)
            return super.hashCode();

        return Objects.hash(getId());
    }


    @Override
    public String toString() {
        return "OBJ(" + id + ")";
    }
}
