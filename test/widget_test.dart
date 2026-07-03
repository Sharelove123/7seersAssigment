import 'package:flutter_test/flutter_test.dart';
import 'package:dall_app/features/home/controller/home_controller.dart';
import 'package:dall_app/models/user_model.dart';

void main() {
  group('HomeState Greeting Tests', () {
    test('Should return welcome message for first-time user', () {
      final state = HomeState(
        userProfile: UserModel(
          id: 'test',
          name: 'Harsh',
          isFirstTime: true,
          completedCheckIn: false,
        ),
      );

      expect(state.isFirstTime, true);
      expect(state.greetingText, 'Welcome,\nHarsh.');
      expect(state.accentText, 'glad you came.');
    });

    test('Should calculate morning greeting for regular user in morning', () {
      final state = HomeState(
        userProfile: UserModel(
          id: 'test',
          name: 'Harsh',
          isFirstTime: false,
          completedCheckIn: false,
        ),
        simulatedTimeOfDay: 'Morning',
      );

      expect(state.isFirstTime, false);
      expect(state.greetingText, 'Morning, Harsh.');
      expect(state.accentText, "it's a quiet one.");
    });

    test('Should calculate evening greeting for regular user in evening', () {
      final state = HomeState(
        userProfile: UserModel(
          id: 'test',
          name: 'Harsh',
          isFirstTime: false,
          completedCheckIn: false,
        ),
        simulatedTimeOfDay: 'Evening',
      );

      expect(state.isFirstTime, false);
      expect(state.greetingText, 'Evening, Harsh.');
      expect(state.accentText, 'good work today.');
    });
  });
}
