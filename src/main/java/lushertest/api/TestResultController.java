package lushertest.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lushertest.dto.Statistics;
import lushertest.dto.TestResult;
import lushertest.service.TestResultService;
import lushertest.service.UserService;

import static lushertest.sec.Authority.ROLE_ADMIN;
import static lushertest.sec.Authority.ROLE_ANON;
import static lushertest.sec.Authority.ROLE_USER;


@RestController
@RequestMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
public class TestResultController {


    public static final String TEST_ENDPOINT = "/test";


    private static final String TEST_RESULTS_ENDPOINT = "/tests";


    private static final String STATISTICS_ENDPOINT = "/statistics";



    private final TestResultService service;

    public TestResultController(final TestResultService service) {
        this.service = service;
    }


    @PostMapping(TEST_ENDPOINT)
    @Secured({ ROLE_ANON, ROLE_ADMIN, ROLE_USER })

    public ResponseEntity<Iterable<String>> postTestResult(@RequestParam final String result) {

        Iterable<String> resultDescription = service.getResultDescriptionAndSave(result);


        if (resultDescription == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);


        if (!resultDescription.iterator().hasNext())
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);


        return new ResponseEntity<>(resultDescription,
                UserService.getAuthorized().isPresent() ?
                        HttpStatus.CREATED : HttpStatus.OK);
    }



    @GetMapping(TEST_RESULTS_ENDPOINT)
    @Secured({ ROLE_ADMIN, ROLE_USER })

    public ResponseEntity<Iterable<TestResult>> getTestResults(
            @RequestParam(required = false) final String email
    ) {
        Iterable<TestResult> results = service.getResults(email);


        if (results == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);


        if (!results.iterator().hasNext())
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);

        return new ResponseEntity<>(results, HttpStatus.OK);
    }



    @GetMapping(STATISTICS_ENDPOINT)
    @Secured({ ROLE_ADMIN })

    public ResponseEntity<Iterable<Statistics>> getStatistics()
    {
        Iterable<Statistics> results = service.getStatistics();

        if (results == null || !results.iterator().hasNext())
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);

        return new ResponseEntity<>(results, HttpStatus.OK);
    }
}
