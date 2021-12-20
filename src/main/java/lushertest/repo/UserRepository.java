package lushertest.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.Collection;
import java.util.Optional;

import lushertest.dao.UserEntity;
import lushertest.dto.UserBriefInfo;
import lushertest.dto.UserDetailedInfo;


@RepositoryRestResource(exported = false)
public interface UserRepository extends JpaRepository<UserEntity, Long> {


    boolean existsByEmail(String email);


    Optional<UserEntity> findByEmail(String email);


    Optional<UserDetailedInfo> findDetailedInfoByEmail(String email);


    Collection<UserBriefInfo> findBriefInfoListByAdminFalse();


}