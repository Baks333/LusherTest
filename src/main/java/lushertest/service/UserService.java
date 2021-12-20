package lushertest.service;

import org.springframework.lang.Nullable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Collections;
import java.util.Optional;

import lushertest.dao.Gender;
import lushertest.dao.UserEntity;
import lushertest.dto.UserBriefInfo;
import lushertest.dto.UserDetailedInfo;
import lushertest.repo.UserRepository;
import lushertest.sec.UserSecurityInfo;

/**
 * Сервис для сохранения, обработки и получения информации о пользователях.
 */

@Service
public class UserService implements UserDetailsService {


    private final UserRepository repository;


    private final DataValidatorService validatorService;


    private final PasswordEncoder encoder;

    public UserService(final UserRepository repository,
                       final DataValidatorService validatorService,
                       final PasswordEncoder encoder
    ) {
        this.repository = repository;
        this.validatorService = validatorService;
        this.encoder = encoder;
    }


    private static Optional<Authentication> getAuthentication()
    {
        return Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
                .filter(Authentication::isAuthenticated);
    }


    public static Optional<UserSecurityInfo> getAuthorized()
    {
        return getAuthentication()
                .flatMap(authentication -> {
                    Object principal = authentication.getPrincipal();

                    if (principal instanceof UserSecurityInfo)
                        return Optional.of((UserSecurityInfo) principal);

                    return Optional.empty();
                });
    }


    public static Optional<UserEntity> getUserEntity()
    {
        return getAuthorized().map(UserSecurityInfo::getUserEntity);
    }


    @Override
    public UserDetails loadUserByUsername(final String email)
            throws UsernameNotFoundException
    {
        return repository.findByEmail(email)
                .map(UserSecurityInfo::new)
                .orElseThrow(() -> new UsernameNotFoundException(""));
    }


    public boolean exists(final String email) {
        return validatorService.validateEmail(email)
                .map(repository::existsByEmail)
                .orElse(false);
    }


    private boolean validateNewEntity(final UserEntity user)
    {
        boolean result = true;

        Optional<String> optionalFullName = validatorService.validateStringValue(user.getFullName());
        if (optionalFullName.isPresent())
            user.setFullName(optionalFullName.get());
        else {
            user.setFullName(null);
            result = false;
        }
        
        Optional<Gender> optionalGender = validatorService.validateGender(user.getGender());
        if (optionalGender.isPresent())
            user.setGender(optionalGender.get());
        else {
            user.setGender(null);
            result = false;
        }

        Optional<LocalDate> optionalBirthday = validatorService.validateBirthday(user.getBirthday());
        if (optionalBirthday.isPresent())
            user.setBirthday(optionalBirthday.get());
        else {
            user.setBirthday(null);
            result = false;
        }

        Optional<String> optionalEmail = validatorService.validateEmail(user.getEmail());
        if (optionalEmail.isPresent())
            user.setEmail(optionalEmail.get());
        else {
            user.setEmail(null);
            result = false;
        }

        String password = user.getPassword();
        if (validatorService.passwordValid(password))
            user.setPassword(encoder.encode(password));

        user.setAdmin(repository.count() == 0);

        return result;
    }


    public Optional<UserEntity> registerNew(final UserEntity user)
    {
        if (validateNewEntity(user)) {

            if (repository.existsByEmail(user.getEmail()))
                return Optional.empty();

            repository.save(user);
            return Optional.empty();
        } else
            return Optional.of(user);
    }


    public Iterable<UserBriefInfo> getAll() {

        return getUserEntity()
                .filter(UserEntity::isAdmin)
                .map(ignore ->

                        repository.findBriefInfoListByAdminFalse()
                )
                .orElseGet(
                        Collections::emptyList);
    }


    private UserDetailedInfo fromEntity(UserEntity userEntity) {
        return new UserDetailedInfo(
                userEntity.getCreated(),
                userEntity.getFullName(),
                userEntity.getGender(),
                userEntity.getBirthday(),
                userEntity.getEmail());
    }


    public Optional<UserDetailedInfo> getDetailedInfo(@Nullable final String email)
    {
         return getUserEntity()
                .flatMap(userEntity -> {
                    if (email == null || email.equals(userEntity.getEmail()))
                        return Optional.of(fromEntity(userEntity));

                    if (userEntity.isAdmin())
                        return repository.findDetailedInfoByEmail(email);

                    return Optional.empty();
                });
    }


    private UserEntity validateAndUpdateEntity(final UserEntity target,
                                               final UserEntity source
    ) {
        validatorService.validateStringValue(source.getFullName())
                .ifPresent(target::setFullName);
        
        validatorService.validateGender(source.getGender())
                .ifPresent(target::setGender);

        validatorService.validateBirthday(source.getBirthday())
                .ifPresent(target::setBirthday);

        validatorService.validateEmail(source.getEmail())
                .ifPresent(target::setEmail);

        String password = source.getPassword();
        if (validatorService.passwordValid(password))
            target.setPassword(encoder.encode(password));

        return target;
    }


    public Optional<UserDetailedInfo> update(
            @Nullable final String email,
            final UserEntity user
    ) {
        return getUserEntity()
                .filter(userEntity ->
                        // пользователь может обновить информацию только о себе самом
                        email == null || email.equals(userEntity.getEmail()))
                .map(userEntity ->
                        fromEntity(repository.save(validateAndUpdateEntity(userEntity, user))));
    }


    public boolean delete(final String email)
    {
        return getUserEntity()
                .filter(UserEntity::isAdmin)
                .map(ignore ->
                    repository.findByEmail(email)
                            .map(user -> {
                                repository.delete(user);
                                return true;
                            })
                            .orElse(false)
                )
                .orElse(false);
    }
}
