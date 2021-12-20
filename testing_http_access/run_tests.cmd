@echo off

rem тест конечной точки /user/register методом POST - доступно только анонимным клиентам (без данных авторизации в заголовке)

rem вызов без данных авторизации в заголовке
rem   можно вызвать для одних и тех же регистрационных данных 2 раза:
rem     первый раз (если пользователь м таким email ещё не был зарегистрирован) должен возвращать код 201 CREATED без тела
rem       если в таблице пользователей не было ни одной записи, то первому зарегистрировавшемуся проставляется признак admin = true (1), последующим - false (0)
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_ADMIN_anonymous.out" "--output-document=user_register_ADMIN_anonymous.json" "http://localhost:8080/user/register"
wget.exe "--post-file=POST_user_register_KOLYA.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_KOLYA_anonymous.out" "--output-document=user_register_KOLYA_anonymous.json" "http://localhost:8080/user/register"
wget.exe "--post-file=POST_user_register_DASHA.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_DASHA_anonymous.out" "--output-document=user_register_DASHA_anonymous.json" "http://localhost:8080/user/register"
rem     второй раз должен выдать ошибку 409 CONFLICT без тела, т.к. пользователь с таким email уже зарегистрирован
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_ADMIN_dupl_anonymous.out" "--output-document=user_register_ADMIN_dupl_anonymous.json" "http://localhost:8080/user/register"

rem вызов с данными авторизации в заголовке
rem   если пользователь ещё не создан, или существует, но пароль неверный, должен возвращать 401 UNAUTHORIZED без тела
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_auth_unknown.out" "--output-document=user_register_auth_unknown.json" "http://localhost:8080/user/register"
rem   если пользователь существует и пароль верный, то должен возвращать 403 FORBIDDEN без тела, т.к. эта конечная точка только для анонимных пользователей (без заголовка авторизации)
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_auth_ADMIN.out" "--output-document=user_register_auth_ADMIN.json" "http://localhost:8080/user/register"


rem тест конечной точки /users методом GET

rem если запрос без авторизации, должен возвращать 401 UNAUTHORIZED без тела
wget.exe "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=users.out" "--output-document=users.json" "http://localhost:8080/users"
rem если запрос с правами админа, но кроме админов нет зарегистрированных пользователей, должен возвращать код 204 NO CONTENT без тела

rem если запрос с правами админа, должен возвращать код 200 OK с JSON-ответом в виде списка пользователей (только полное имя и email)
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=users_ADMIN.out" "--output-document=users_ADMIN.json" "http://localhost:8080/users"
rem если запрос с правами пользователя, должен возвращать код 403 FORBIDDEN без тела
wget.exe "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=users_KOLYA.out" "--output-document=users_KOLYA.json" "http://localhost:8080/users"


rem тест конечной точки /user?<email> методом GET (получение детальных данных пользователя)

rem если не задать параметр, указать просто /user, должен возвращать код 200 OK, в теле ответа - полная информация о пользователе, который авторизовался
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_DASHA.out" "--output-document=user_DASHA.json" "http://localhost:8080/user"
rem если параметр - email НЕсуществующего юзера, должен возвращать код 403 FORBIDDEN без тела
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_unknown_ADMIN.out" "--output-document=user_unknown_ADMIN.json" "http://localhost:8080/user?email=aaa@test"
rem если параметр - email существующего юзера и запрос с правами админа, должен возвращать код 200 OK, в теле ответа - полная информация о пользователе
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_KOLYA_ADMIN.out" "--output-document=user_KOLYA_ADMIN.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem если параметр - email того же юзера, который авторизован, должен возвращать код 200 OK, в теле ответа - полная информация о самом пользователе
wget.exe "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_KOLYA_KOLYA.out" "--output-document=user_KOLYA_KOLYA.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem если параметр - email НЕ того юзера, который авторизован, должен возвращать код 403 FORBIDDEN без тела
wget.exe "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_DASHA_KOLYA.out" "--output-document=user_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem тест конечной точки /user?<email> методом POST (попытка обновление данных пользователя неправильным методом)

rem если параметр - email НЕсуществующего юзера, должен возвращать код 405 METHOD NOT ALLOWED без тела
wget.exe "--post-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_POSTupdate_unknown_KOLYA.out" "--output-document=user_POSTupdate_unknown_KOLYA.json" "http://localhost:8080/user?email=aaa@test"
rem если параметр - email существующего юзера, который авторизован, должен возвращать код 405 METHOD NOT ALLOWED без тела
wget.exe "--post-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_POSTupdate_KOLYA_KOLYA.out" "--output-document=user_POSTupdate_KOLYA_KOLYA.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem если параметр - email НЕ того юзера, который авторизован, должен возвращать код 405 METHOD NOT ALLOWED без тела
wget.exe "--post-file=PUT_user_update_DASHA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_POSTupdate_DASHA_KOLYA.out" "--output-document=user_POSTupdate_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem тест конечной точки /user?<email> методом PUT (обновление всех данных пользователя правильным методом)

rem если параметр - email НЕсуществующего юзера, должен возвращать код 403 FORBIDDEN без тела, с БД ничего не происходит
wget.exe --method=PUT "--body-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_update_unknown_KOLYA.out" "--output-document=user_update_unknown_KOLYA.json" "http://localhost:8080/user?email=aaa@test"
rem если параметр - email существующего юзера, который авторизован, должен возвращать код 200 OK, в теле ответа - обновленные данные о пользователе (кроме пароля)
wget.exe --method=PUT "--body-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_update_KOLYA_KOLYA.out" "--output-document=user_update_KOLYA_KOLYA.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem если параметр - email НЕ того юзера, который авторизован, должен возвращать код 403 FORBIDDEN без тела, с БД ничего не происходит
wget.exe --method=PUT "--body-file=PUT_user_update_DASHA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_update_DASHA_KOLYA.out" "--output-document=user_update_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem тест конечной точки /user?<email> методом DELETE (удаление пользователя)

rem юзер с правами админа, если параметр - email НЕсуществующего юзера, должен возвращать код 403 FORBIDDEN без тела, с БД ничего не происходит
wget.exe --method=DELETE "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_delete_unknown_ADMIN.out" "--output-document=user_delete_unknown_ADMIN.json" "http://localhost:8080/user?email=aaa@test"
rem если юзер с правами админа, и пользователь с параметром email существует, должен возвращать код 204 NO CONTENT без тела и удалить пользователя
wget.exe --method=DELETE "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_delete_KOLYA_ADMIN.out" "--output-document=user_delete_KOLYA_ADMIN.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem если юзер НЕ админ, должен возвращать код 401 UNAUTHORIZED без тела
wget.exe --method=DELETE "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_delete_DASHA_KOLYA.out" "--output-document=user_delete_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem тест конечной точки /test методом POST без тела - доступно как авторизованным (возможно сохранение результата), так и анонимным клиентам (только получение описания результатов)

rem если не задать параметр, указать просто /test, должен возвращать код 400 BAD REQUEST без тела
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_DASHA.out" "--output-document=test_DASHA.json" "http://localhost:8080/test"
rem параметр некорректен - мало цифр, должен возвращать код 400 BAD REQUEST без тела
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_12345_DASHA.out" "--output-document=test_12345_DASHA.json" "http://localhost:8080/test?result=12345"
rem параметр некорректен - много цифр, должен возвращать код 400 BAD REQUEST без тела
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_1234567888_DASHA.out" "--output-document=test_1234567888_DASHA.json" "http://localhost:8080/test?result=1234567888"
rem параметр некорректен - есть цифры вне корректного диапазона, должен возвращать код 400 BAD REQUEST без тела
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_12349876_DASHA.out" "--output-document=test_12349876_DASHA.json" "http://localhost:8080/test?result=12349876"
rem параметр некорректен - есть повторяющиеся цифры, такие пары не могут существовать, должен возвращать код 400 BAD REQUEST без тела
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_11223344_DASHA.out" "--output-document=test_11223344_DASHA.json" "http://localhost:8080/test?result=11223344"
rem параметр корректен, пользователь авторизован, должен возвращать код 201 CREATED, в теле ответа - список описаний результатов теста (текстовые рашифровки пар), результат должен сохраниться в БД
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_12345678_DASHA.out" "--output-document=test_12345678_DASHA.json" "http://localhost:8080/test?result=12345678"
rem параметр корректен, пользователь НЕ авторизован, должен возвращать код 200 OK, в теле ответа - список описаний результатов теста (текстовые рашифровки пар), результат НЕ должен сохраниться в БД
wget.exe --method=POST "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_87654321_anonymous.out" "--output-document=test_87654321_anonymous.json" "http://localhost:8080/test?result=87654321"


rem тест конечной точки /tests методом GET без тела - доступно только авторизованным пользователям

rem пользователь НЕ авторизован, должен возвращать код 401 UNAUTHORIZED без тела
wget.exe "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_anonymous.out" "--output-document=tests_anonymous.json" "http://localhost:8080/tests"
rem если не задать параметр, указать просто /tests, пользователь авторизован, должен возвращать код 200 OK, в теле ответа - список описаний результатов всех тестов пользователя (текстовые рашифровки пар с метками времени прохождения теста)
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_DASHA.out" "--output-document=tests_DASHA.json" "http://localhost:8080/tests"
rem если не задать параметр, указать просто /tests, авторизация с правами админа, если сам админ не проходил тесты и не сохранял их результаты, должен возвращать код 204 NO CONTENT без тела, если было что-то сохранено, должен возвращать код 200 OK, в теле ответа - список описаний результатов всех тестов только его самого (текстовые рашифровки пар с метками времени прохождения теста), сам админ теретически тоже мог проходить тесты
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_ADMIN.out" "--output-document=tests_ADMIN.json" "http://localhost:8080/tests"
rem параметр - НЕсуществующий пользователь, авторизация с правами админа, должен возвращать код 404 NOT FOUND без тела
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_unknown_ADMIN.out" "--output-document=tests_unknown_ADMIN.json" "http://localhost:8080/tests?email=aaa@test"
rem параметр - существующий пользователь, авторизация с правами админа, должен возвращать код 200 OK, в теле ответа - список описаний результатов всех тестов пользователя, указанного в параметре (текстовые рашифровки пар с метками времени прохождения теста)
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_DASHA_ADMIN.out" "--output-document=tests_DASHA_ADMIN.json" "http://localhost:8080/tests?email=darya@gmail.com"
rem параметр - существующий пользователь, авторизован этот же пользователь, должен возвращать код 200 OK, в теле ответа - список описаний результатов всех тестов этого пользователя (текстовые рашифровки пар с метками времени прохождения теста)
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_DASHA_DASHA.out" "--output-document=tests_DASHA_DASHA.json" "http://localhost:8080/tests?email=darya@gmail.com"
rem параметр - существующий пользователь, авторизован ДРУГОЙ пользователь - НЕ админ, должен возвращать код 404 NOT FOUND без тела
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_ADMIN_DASHA.out" "--output-document=tests_ADMIN_DASHA.json" "http://localhost:8080/tests?email=admin@gmail.com"


rem тест конечной точки /statistics методом GET без тела - доступно только админу

rem пользователь НЕ авторизован, должен возвращать код 401 UNAUTHORIZED без тела
wget.exe "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=statistics_anonymous.out" "--output-document=statistics_anonymous.json" "http://localhost:8080/statistics"
rem пользователь НЕ админ, должен возвращать код 403 FORBIDDEN без тела
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=statistics_DASHA.out" "--output-document=statistics_DASHA.json" "http://localhost:8080/statistics"
rem пользователь - админ, должен возвращать код 200 OK, в теле ответа - список: <пара>, <кол-во результатов с такой парой>
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=statistics_ADMIN.out" "--output-document=statistics_ADMIN.json" "http://localhost:8080/statistics"
