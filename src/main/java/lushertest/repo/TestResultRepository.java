package lushertest.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.Collection;

import lushertest.dao.TestResultEntity;
import lushertest.dao.UserEntity;
import lushertest.dto.Statistics;


@RepositoryRestResource(exported = false)
public interface TestResultRepository extends JpaRepository<TestResultEntity, Long> {


    Iterable<TestResultEntity> findByUser(UserEntity user);

    @Query("select new lushertest.dto.Statistics(e.pairDescription.pair, count(e)) " +
            "from #{#entityName} e " +
            "group by e.pairDescription.pair " +
            "order by e.pairDescription.id")
    Iterable<Statistics> getStatistics();


}