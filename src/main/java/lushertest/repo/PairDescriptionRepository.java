package lushertest.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.Optional;

import lushertest.dao.PairDescriptionEntity;

/**
 * Репозиторий (интерфейс к БД) для получения из справочника в БД подробных текстовых описаний результатов тестов.

 */
@RepositoryRestResource(exported = false)
public interface PairDescriptionRepository extends JpaRepository<PairDescriptionEntity, Long> {

    Optional<PairDescriptionEntity> findByPair(String pair);
}