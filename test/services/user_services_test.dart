
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/firebase_service.dart';
import 'package:jericho/services/key_generator.dart';
import 'package:jericho/services/mock_firebase_service.dart';
import 'package:jericho/services/mock_authentication_service.dart';
import 'package:jericho/services/user_services.dart';

void main() {

  FirebaseService fb = MockFirebaseService();
  DataService data = DataService(fb, KeyGenerator());
  UserServices services = UserServices(data, MockAuthenticationService());

  group('Validate User', ()
  {
    testWidgets(
        'When the validate user service is called with an empty email then the system returns an exception',
            (WidgetTester tester) async {

          try {
           await services.validateUser(MockValidateUserRequest('', 'Bill'));
            expect(true, false);
          } catch (ex) {
            expect(ex is UserServicesException, true);
          }
          
        });

    testWidgets(
        'When the validate user service is called with an invalid email then the system returns an exception',
            (WidgetTester tester) async {

          try {
            await services.validateUser(MockValidateUserRequest('zzz', 'Bill'));
            expect(true, false);
          } catch (ex) {
            expect(ex is UserServicesException, true);
          }

        });

    testWidgets(
        'When the validate user service is called with valid data then the system returns a valid response',
            (WidgetTester tester) async {

          try {
            var response = await services.validateUser(MockValidateUserRequest('a@bc.com', 'Bill'));
            expect(response.valid, true);
          } catch (ex) {
            expect(true, false);
          }

        });

    testWidgets(
        'When the validate user service is called with a duplicate email then the system returns an invalid response',
            (WidgetTester tester) async {

          try {
            await services.createUser(MockCreateUserRequest('a@bc.com', 'Bill', 'hello123'));
            var response = await services.validateUser(MockValidateUserRequest('a@bc.com', 'Bill'));
            expect(response.valid, false);
            expect(response.reference, 'duplicateUser');

          } catch (ex) {
            expect(true, false);
          }

        });
  });

  group('Create User', ()
  {
    testWidgets(
        'When the create user service is called with invalid data the system throws an exception',
            (WidgetTester tester) async {
          try {
            await services.createUser(MockCreateUserRequest('', 'Bill', 'hello123'));
            expect(true, false);
          } catch (ex) {
            expect(ex is UserServicesException, true);
          }
        });

    testWidgets(
        'When the create user service is called with valid data the system creates a new user',
            (WidgetTester tester) async {
          try {
            var response = await services.createUser(MockCreateUserRequest('a@b.com', 'Bill', 'hello123'));
            expect(response.valid, true);
            expect(response.userId.length, 15);
            var map = await fb.get('User/${response.userId}');
            expect(map['email'], 'a@b.com');
          } catch (ex) {
            expect(true, false);
          }
        });
  });
  
}

class MockValidateUserRequest implements ValidateUserRequest {
  @override
  final String email;

  @override
  final String name;

  MockValidateUserRequest(this.email, this.name);
}

class MockCreateUserRequest extends MockValidateUserRequest implements CreateUserRequest {

  @override
  final String password;

  MockCreateUserRequest(String email, String name, this.password) : super(email, name);

}