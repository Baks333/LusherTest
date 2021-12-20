package lushertest.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lushertest.dao.UserEntity;
import lushertest.dto.UserBriefInfo;
import lushertest.dto.UserDetailedInfo;
import lushertest.service.UserService;

import static lushertest.sec.Authority.*;


@RestController
@RequestMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
public class UserController {


    public static final String USER_REGISTER_ENDPOINT = "/user/register";

    private static final String ONE_USER_ENDPOINT = "/user";
    private static final String ALL_USERS_ENDPOINT = "/users";


    private final UserService service;

    public UserController(final UserService service) {
        this.service = service;
    }


    @PostMapping(USER_REGISTER_ENDPOINT)
    @Secured({ ROLE_ANON })
    public ResponseEntity<UserEntity> register(@RequestBody final UserEntity user)
    {

        if (service.exists(user.getEmail()))
            return new ResponseEntity<>(HttpStatus.CONFLICT);

        return service.registerNew(user)
                .map(userValidated ->
                        new ResponseEntity<>(user, HttpStatus.BAD_REQUEST))
                .orElseGet(() ->
                        new ResponseEntity<>(HttpStatus.CREATED));
    }


    @GetMapping(ALL_USERS_ENDPOINT)
    @Secured({ ROLE_ADMIN })
    public ResponseEntity<Iterable<UserBriefInfo>> getAll()
    {
        Iterable<UserBriefInfo> users = service.getAll();


        if (!users.iterator().hasNext())
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);

        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    @GetMapping(ONE_USER_ENDPOINT)
    @Secured({ ROLE_ADMIN, ROLE_USER })
    public ResponseEntity<UserDetailedInfo> getDetails(
            @RequestParam(required = false) final String email
    ) {
        return service.getDetailedInfo(email)
                .map(user ->
                        new ResponseEntity<>(user, HttpStatus.OK))
                .orElseGet(() ->
                        new ResponseEntity<>(HttpStatus.FORBIDDEN));
    }

    @PutMapping(ONE_USER_ENDPOINT)
    @Secured({ ROLE_ADMIN, ROLE_USER })
    public ResponseEntity<UserDetailedInfo> update(
            @RequestParam(required = false) final String email,
            @RequestBody final UserEntity user
    ) {
        return service.update(email, user)
                .map(userDetailedInfo ->
                        new ResponseEntity<>(userDetailedInfo, HttpStatus.OK))
                .orElseGet(() ->
                        new ResponseEntity<>(HttpStatus.FORBIDDEN));
    }

    @DeleteMapping(ONE_USER_ENDPOINT)
    @Secured({ ROLE_ADMIN })
    public ResponseEntity<?> delete(@RequestParam final String email)
    {
        return new ResponseEntity<>(service.delete(email) ?
                HttpStatus.NO_CONTENT : HttpStatus.FORBIDDEN);
    }
}
