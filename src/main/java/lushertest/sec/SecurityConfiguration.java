package lushertest.sec;

import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.servlet.http.HttpServletResponse;

import static lushertest.api.TestResultController.TEST_ENDPOINT;
import static lushertest.api.UserController.USER_REGISTER_ENDPOINT;
import static lushertest.sec.Authority.ROLE_ANON;

/**
 * Основная конфигурация безопасности,
 * в соответствие с которой сервер реализует идентификацию, аутентификацию и авторизацию пользователей RESTful API
 */
@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {


    private static final String[] ANONYMOUS_ENDPOINTS = new String[] {
            USER_REGISTER_ENDPOINT,
            TEST_ENDPOINT
    };

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .cors().disable()

            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()

            .formLogin().disable()
            .logout().disable()
            .anonymous().authorities(ROLE_ANON)
                .and()
            .httpBasic()
                .and()

            .authorizeRequests()
                .antMatchers(ANONYMOUS_ENDPOINTS).permitAll()
                .anyRequest().authenticated()
                .and()

            .exceptionHandling()
                .accessDeniedHandler(((request, response, accessDeniedException) ->
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN)))
                .authenticationEntryPoint(((request, response, accessDeniedException) ->
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED)));
    }


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
