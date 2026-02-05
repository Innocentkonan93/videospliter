import 'package:flutter_test/flutter_test.dart';
import 'package:video_spliter/app/utils/app_logic.dart';

void main() {
  group('Selection Logic Tests', () {
    test('toggleSelection adds item if not present', () {
      final selection = <String>[];
      final newSelection = SelectionLogic.toggleSelection(selection, 'item1');
      expect(newSelection, contains('item1'));
      expect(newSelection.length, 1);
    });

    test('toggleSelection removes item if present', () {
      final selection = ['item1', 'item2'];
      final newSelection = SelectionLogic.toggleSelection(selection, 'item1');
      expect(newSelection, isNot(contains('item1')));
      expect(newSelection, contains('item2'));
      expect(newSelection.length, 1);
    });

    test('toggleSelectAll selects all when selection is empty', () {
      final current = <String>[];
      final all = ['item1', 'item2', 'item3'];
      final result = SelectionLogic.toggleSelectAll(current, all);
      expect(result.length, 3);
      expect(result, containsAll(all));
    });

    test('toggleSelectAll clears selection when not empty', () {
      final current = ['item1'];
      final all = ['item1', 'item2', 'item3'];
      final result = SelectionLogic.toggleSelectAll(current, all);
      expect(result.isEmpty, true);
    });
  });

  group('Ad Logic Tests', () {
    test('shouldShowRewardedAd returns true every N counts', () {
      // Frequency 5
      expect(AdLogic.shouldShowRewardedAd(4, 5), false);
      expect(AdLogic.shouldShowRewardedAd(5, 5), true);
      expect(AdLogic.shouldShowRewardedAd(10, 5), true);
      expect(AdLogic.shouldShowRewardedAd(6, 5), false);
    });

    test('shouldShowRewardedAd returns false for 0', () {
      expect(AdLogic.shouldShowRewardedAd(0, 5), false);
    });

    test('shouldAskForRating returns true every N counts', () {
      // Frequency 2
      expect(AdLogic.shouldAskForRating(1, 2), false);
      expect(AdLogic.shouldAskForRating(2, 2), true);
      expect(AdLogic.shouldAskForRating(4, 2), true);
    });
  });
}
