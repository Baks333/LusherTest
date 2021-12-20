@echo off

rem ���� �������� ����� /user/register ������� POST - �������� ������ ��������� �������� (��� ������ ����������� � ���������)

rem ����� ��� ������ ����������� � ���������
rem   ����� ������� ��� ����� � ��� �� ��������������� ������ 2 ����:
rem     ������ ��� (���� ������������ � ����� email ��� �� ��� ���������������) ������ ���������� ��� 201 CREATED ��� ����
rem       ���� � ������� ������������� �� ���� �� ����� ������, �� ������� ��������������������� ������������� ������� admin = true (1), ����������� - false (0)
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_ADMIN_anonymous.out" "--output-document=user_register_ADMIN_anonymous.json" "http://localhost:8080/user/register"
wget.exe "--post-file=POST_user_register_KOLYA.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_KOLYA_anonymous.out" "--output-document=user_register_KOLYA_anonymous.json" "http://localhost:8080/user/register"
wget.exe "--post-file=POST_user_register_DASHA.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_DASHA_anonymous.out" "--output-document=user_register_DASHA_anonymous.json" "http://localhost:8080/user/register"
rem     ������ ��� ������ ������ ������ 409 CONFLICT ��� ����, �.�. ������������ � ����� email ��� ���������������
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_ADMIN_dupl_anonymous.out" "--output-document=user_register_ADMIN_dupl_anonymous.json" "http://localhost:8080/user/register"

rem ����� � ������� ����������� � ���������
rem   ���� ������������ ��� �� ������, ��� ����������, �� ������ ��������, ������ ���������� 401 UNAUTHORIZED ��� ����
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_auth_unknown.out" "--output-document=user_register_auth_unknown.json" "http://localhost:8080/user/register"
rem   ���� ������������ ���������� � ������ ������, �� ������ ���������� 403 FORBIDDEN ��� ����, �.�. ��� �������� ����� ������ ��� ��������� ������������� (��� ��������� �����������)
wget.exe "--post-file=POST_user_register_ADMIN.json" "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_register_auth_ADMIN.out" "--output-document=user_register_auth_ADMIN.json" "http://localhost:8080/user/register"


rem ���� �������� ����� /users ������� GET

rem ���� ������ ��� �����������, ������ ���������� 401 UNAUTHORIZED ��� ����
wget.exe "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=users.out" "--output-document=users.json" "http://localhost:8080/users"
rem ���� ������ � ������� ������, �� ����� ������� ��� ������������������ �������������, ������ ���������� ��� 204 NO CONTENT ��� ����

rem ���� ������ � ������� ������, ������ ���������� ��� 200 OK � JSON-������� � ���� ������ ������������� (������ ������ ��� � email)
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=users_ADMIN.out" "--output-document=users_ADMIN.json" "http://localhost:8080/users"
rem ���� ������ � ������� ������������, ������ ���������� ��� 403 FORBIDDEN ��� ����
wget.exe "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=users_KOLYA.out" "--output-document=users_KOLYA.json" "http://localhost:8080/users"


rem ���� �������� ����� /user?<email> ������� GET (��������� ��������� ������ ������������)

rem ���� �� ������ ��������, ������� ������ /user, ������ ���������� ��� 200 OK, � ���� ������ - ������ ���������� � ������������, ������� �������������
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_DASHA.out" "--output-document=user_DASHA.json" "http://localhost:8080/user"
rem ���� �������� - email ��������������� �����, ������ ���������� ��� 403 FORBIDDEN ��� ����
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_unknown_ADMIN.out" "--output-document=user_unknown_ADMIN.json" "http://localhost:8080/user?email=aaa@test"
rem ���� �������� - email ������������� ����� � ������ � ������� ������, ������ ���������� ��� 200 OK, � ���� ������ - ������ ���������� � ������������
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_KOLYA_ADMIN.out" "--output-document=user_KOLYA_ADMIN.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem ���� �������� - email ���� �� �����, ������� �����������, ������ ���������� ��� 200 OK, � ���� ������ - ������ ���������� � ����� ������������
wget.exe "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_KOLYA_KOLYA.out" "--output-document=user_KOLYA_KOLYA.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem ���� �������� - email �� ���� �����, ������� �����������, ������ ���������� ��� 403 FORBIDDEN ��� ����
wget.exe "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_DASHA_KOLYA.out" "--output-document=user_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem ���� �������� ����� /user?<email> ������� POST (������� ���������� ������ ������������ ������������ �������)

rem ���� �������� - email ��������������� �����, ������ ���������� ��� 405 METHOD NOT ALLOWED ��� ����
wget.exe "--post-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_POSTupdate_unknown_KOLYA.out" "--output-document=user_POSTupdate_unknown_KOLYA.json" "http://localhost:8080/user?email=aaa@test"
rem ���� �������� - email ������������� �����, ������� �����������, ������ ���������� ��� 405 METHOD NOT ALLOWED ��� ����
wget.exe "--post-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_POSTupdate_KOLYA_KOLYA.out" "--output-document=user_POSTupdate_KOLYA_KOLYA.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem ���� �������� - email �� ���� �����, ������� �����������, ������ ���������� ��� 405 METHOD NOT ALLOWED ��� ����
wget.exe "--post-file=PUT_user_update_DASHA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_POSTupdate_DASHA_KOLYA.out" "--output-document=user_POSTupdate_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem ���� �������� ����� /user?<email> ������� PUT (���������� ���� ������ ������������ ���������� �������)

rem ���� �������� - email ��������������� �����, ������ ���������� ��� 403 FORBIDDEN ��� ����, � �� ������ �� ����������
wget.exe --method=PUT "--body-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_update_unknown_KOLYA.out" "--output-document=user_update_unknown_KOLYA.json" "http://localhost:8080/user?email=aaa@test"
rem ���� �������� - email ������������� �����, ������� �����������, ������ ���������� ��� 200 OK, � ���� ������ - ����������� ������ � ������������ (����� ������)
wget.exe --method=PUT "--body-file=PUT_user_update_KOLYA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_update_KOLYA_KOLYA.out" "--output-document=user_update_KOLYA_KOLYA.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem ���� �������� - email �� ���� �����, ������� �����������, ������ ���������� ��� 403 FORBIDDEN ��� ����, � �� ������ �� ����������
wget.exe --method=PUT "--body-file=PUT_user_update_DASHA_KOLYA.json" "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_update_DASHA_KOLYA.out" "--output-document=user_update_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem ���� �������� ����� /user?<email> ������� DELETE (�������� ������������)

rem ���� � ������� ������, ���� �������� - email ��������������� �����, ������ ���������� ��� 403 FORBIDDEN ��� ����, � �� ������ �� ����������
wget.exe --method=DELETE "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_delete_unknown_ADMIN.out" "--output-document=user_delete_unknown_ADMIN.json" "http://localhost:8080/user?email=aaa@test"
rem ���� ���� � ������� ������, � ������������ � ���������� email ����������, ������ ���������� ��� 204 NO CONTENT ��� ���� � ������� ������������
wget.exe --method=DELETE "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_delete_KOLYA_ADMIN.out" "--output-document=user_delete_KOLYA_ADMIN.json" "http://localhost:8080/user?email=kolya@gmail.com"
rem ���� ���� �� �����, ������ ���������� ��� 401 UNAUTHORIZED ��� ����
wget.exe --method=DELETE "--header=Authorization: Basic a29seWFAZ21haWwuY29tOjIzNA==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=user_delete_DASHA_KOLYA.out" "--output-document=user_delete_DASHA_KOLYA.json" "http://localhost:8080/user?email=darya@gmail.com"


rem ���� �������� ����� /test ������� POST ��� ���� - �������� ��� �������������� (�������� ���������� ����������), ��� � ��������� �������� (������ ��������� �������� �����������)

rem ���� �� ������ ��������, ������� ������ /test, ������ ���������� ��� 400 BAD REQUEST ��� ����
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_DASHA.out" "--output-document=test_DASHA.json" "http://localhost:8080/test"
rem �������� ����������� - ���� ����, ������ ���������� ��� 400 BAD REQUEST ��� ����
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_12345_DASHA.out" "--output-document=test_12345_DASHA.json" "http://localhost:8080/test?result=12345"
rem �������� ����������� - ����� ����, ������ ���������� ��� 400 BAD REQUEST ��� ����
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_1234567888_DASHA.out" "--output-document=test_1234567888_DASHA.json" "http://localhost:8080/test?result=1234567888"
rem �������� ����������� - ���� ����� ��� ����������� ���������, ������ ���������� ��� 400 BAD REQUEST ��� ����
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_12349876_DASHA.out" "--output-document=test_12349876_DASHA.json" "http://localhost:8080/test?result=12349876"
rem �������� ����������� - ���� ������������� �����, ����� ���� �� ����� ������������, ������ ���������� ��� 400 BAD REQUEST ��� ����
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_11223344_DASHA.out" "--output-document=test_11223344_DASHA.json" "http://localhost:8080/test?result=11223344"
rem �������� ���������, ������������ �����������, ������ ���������� ��� 201 CREATED, � ���� ������ - ������ �������� ����������� ����� (��������� ���������� ���), ��������� ������ ����������� � ��
wget.exe --method=POST "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_12345678_DASHA.out" "--output-document=test_12345678_DASHA.json" "http://localhost:8080/test?result=12345678"
rem �������� ���������, ������������ �� �����������, ������ ���������� ��� 200 OK, � ���� ������ - ������ �������� ����������� ����� (��������� ���������� ���), ��������� �� ������ ����������� � ��
wget.exe --method=POST "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=test_87654321_anonymous.out" "--output-document=test_87654321_anonymous.json" "http://localhost:8080/test?result=87654321"


rem ���� �������� ����� /tests ������� GET ��� ���� - �������� ������ �������������� �������������

rem ������������ �� �����������, ������ ���������� ��� 401 UNAUTHORIZED ��� ����
wget.exe "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_anonymous.out" "--output-document=tests_anonymous.json" "http://localhost:8080/tests"
rem ���� �� ������ ��������, ������� ������ /tests, ������������ �����������, ������ ���������� ��� 200 OK, � ���� ������ - ������ �������� ����������� ���� ������ ������������ (��������� ���������� ��� � ������� ������� ����������� �����)
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_DASHA.out" "--output-document=tests_DASHA.json" "http://localhost:8080/tests"
rem ���� �� ������ ��������, ������� ������ /tests, ����������� � ������� ������, ���� ��� ����� �� �������� ����� � �� �������� �� ����������, ������ ���������� ��� 204 NO CONTENT ��� ����, ���� ���� ���-�� ���������, ������ ���������� ��� 200 OK, � ���� ������ - ������ �������� ����������� ���� ������ ������ ��� ������ (��������� ���������� ��� � ������� ������� ����������� �����), ��� ����� ����������� ���� ��� ��������� �����
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_ADMIN.out" "--output-document=tests_ADMIN.json" "http://localhost:8080/tests"
rem �������� - �������������� ������������, ����������� � ������� ������, ������ ���������� ��� 404 NOT FOUND ��� ����
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_unknown_ADMIN.out" "--output-document=tests_unknown_ADMIN.json" "http://localhost:8080/tests?email=aaa@test"
rem �������� - ������������ ������������, ����������� � ������� ������, ������ ���������� ��� 200 OK, � ���� ������ - ������ �������� ����������� ���� ������ ������������, ���������� � ��������� (��������� ���������� ��� � ������� ������� ����������� �����)
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_DASHA_ADMIN.out" "--output-document=tests_DASHA_ADMIN.json" "http://localhost:8080/tests?email=darya@gmail.com"
rem �������� - ������������ ������������, ����������� ���� �� ������������, ������ ���������� ��� 200 OK, � ���� ������ - ������ �������� ����������� ���� ������ ����� ������������ (��������� ���������� ��� � ������� ������� ����������� �����)
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_DASHA_DASHA.out" "--output-document=tests_DASHA_DASHA.json" "http://localhost:8080/tests?email=darya@gmail.com"
rem �������� - ������������ ������������, ����������� ������ ������������ - �� �����, ������ ���������� ��� 404 NOT FOUND ��� ����
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=tests_ADMIN_DASHA.out" "--output-document=tests_ADMIN_DASHA.json" "http://localhost:8080/tests?email=admin@gmail.com"


rem ���� �������� ����� /statistics ������� GET ��� ���� - �������� ������ ������

rem ������������ �� �����������, ������ ���������� ��� 401 UNAUTHORIZED ��� ����
wget.exe "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=statistics_anonymous.out" "--output-document=statistics_anonymous.json" "http://localhost:8080/statistics"
rem ������������ �� �����, ������ ���������� ��� 403 FORBIDDEN ��� ����
wget.exe "--header=Authorization: Basic ZGFyeWFAZ21haWwuY29tOjEyMw==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=statistics_DASHA.out" "--output-document=statistics_DASHA.json" "http://localhost:8080/statistics"
rem ������������ - �����, ������ ���������� ��� 200 OK, � ���� ������ - ������: <����>, <���-�� ����������� � ����� �����>
wget.exe "--header=Authorization: Basic YWRtaW5AZ21haWwuY29tOjQ1Ng==" "--header=Content-Type: application/json" "--header=Accept: application/json; charset=utf-8" "--output-file=statistics_ADMIN.out" "--output-document=statistics_ADMIN.json" "http://localhost:8080/statistics"