package lushertest.service;

import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import lushertest.dao.TestResultEntity;
import lushertest.dao.UserEntity;
import lushertest.dto.Statistics;
import lushertest.dto.TestResult;
import lushertest.repo.PairDescriptionRepository;
import lushertest.repo.TestResultRepository;
import lushertest.repo.UserRepository;

/**
 * Сервис для сохранения, обработки и получения результатов тестов.
 */

@Service
public class TestResultService {


    public static final int PAIR_COUNT = 4;


    public static final int COLORS_COUNT = PAIR_COUNT * 2;


    public static final char MIN_CHAR = '1';


    public static final char[] PAIR_CHAR = { '+', 'x', '=', '-' };


    private final UserRepository userRepository;
    private final PairDescriptionRepository pairDescriptionRepository;
    private final TestResultRepository testResultRepository;


    private final DataValidatorService validatorService;

    public TestResultService(final UserRepository userRepository,
                             final PairDescriptionRepository pairDescriptionRepository,
                             final TestResultRepository testResultRepository,
                             final DataValidatorService validatorService
    ) {
        this.userRepository = userRepository;
        this.pairDescriptionRepository = pairDescriptionRepository;
        this.testResultRepository = testResultRepository;
        this.validatorService = validatorService;
    }


    public static String getPair(final int pair, char first, char second) {
        return "" +
                PAIR_CHAR[pair] + first + PAIR_CHAR[pair] + second;
    }


    @Nullable
    public Iterable<String> getResultDescriptionAndSave(final String testResult)
    {
        if (!validatorService.testResultValid(testResult))
            return null;

        final Set<String> resultDescriptions = new HashSet<>();


        Instant created = Instant.now();
        for (int pair = 0; pair < PAIR_COUNT; pair++) {

            pairDescriptionRepository
                    .findByPair(getPair(pair,
                            testResult.charAt(pair * 2),
                            testResult.charAt(pair * 2 + 1))
                    )
                    .ifPresent(pairDescriptionEntity -> {
                        // добавляем описания результата согласно найденной в справочнике паре
                        resultDescriptions.add(
                                pairDescriptionEntity.getDescription());


                        UserService.getUserEntity()
                                .ifPresent(userEntity ->
                                        testResultRepository.save(new TestResultEntity(
                                                created, userEntity, pairDescriptionEntity)));
                    });
        }

        return resultDescriptions;
    }


    @Nullable
    public Iterable<TestResult> getResults(@Nullable final String email)
    {

        return UserService.getUserEntity()
                .map(userAuthorized -> {

                    UserEntity userEntity = userAuthorized;
                    if (email != null && !email.equals(userAuthorized.getEmail()))

                        if (userAuthorized.isAdmin())
                            userEntity = userRepository.findByEmail(email)
                                    .orElse(null);
                        else
                            return null;

                    if (userEntity == null)
                        return null;


                    final Set<TestResult> results = new HashSet<>();


                    final Map<Instant, TestResult> resultMap = new HashMap<>();


                    testResultRepository.findByUser(userEntity)
                            .forEach(testResultEntity -> {

                                final Instant created = testResultEntity
                                        .getCreated();

                                final String description = testResultEntity
                                        .getPairDescription().getDescription();

                                TestResult result = resultMap.get(created);

                                if (result == null) {
                                    result = new TestResult(created);
                                    resultMap.put(created, result);
                                    results.add(result);
                                }

                                result.getDescriptions().add(description);
                            });

                    return results;
                })

                .orElse(null);
    }


    @Nullable
    public Iterable<Statistics> getStatistics()
    {

        return UserService.getUserEntity()
                .filter(UserEntity::isAdmin)
                .map(ignore -> testResultRepository.getStatistics())
                .orElse(null);
    }
}
