import 'package:flutter_test/flutter_test.dart';
import 'package:signal_noise/services/notification_service.dart';

void main() {
  group('NotificationService notification ID ranges', () {
    test('assigns a unique ID per notification type for the same slot', () {
      const slotId = 'slot-alpha';
      final ids = NotificationService.slotScopedNotificationIdsForTesting(
        slotId,
      );

      expect(
        ids.length,
        NotificationService.slotScopedNotificationBaseIdsForTesting().length,
      );
      expect(ids.toSet().length, ids.length);
    });

    test('uses non-overlapping ranges for all notification type base IDs', () {
      final baseIds = List<int>.of(
        NotificationService.notificationBaseIdsForTesting(),
      )..sort();
      final rangeSize =
          NotificationService.notificationTypeRangeSizeForTesting();

      for (var i = 0; i < baseIds.length - 1; i++) {
        final currentRangeEnd = baseIds[i] + rangeSize - 1;
        final nextRangeStart = baseIds[i + 1];

        expect(nextRangeStart, greaterThan(currentRangeEnd));
      }
    });

    test('cancellation IDs match computed slot-scoped IDs', () {
      const slotId = 'slot-bravo';
      final baseIds =
          NotificationService.slotScopedNotificationBaseIdsForTesting();
      final ids = NotificationService.slotScopedNotificationIdsForTesting(
        slotId,
      );

      for (var i = 0; i < baseIds.length; i++) {
        expect(
          ids[i],
          NotificationService.computeSlotScopedNotificationIdForTesting(
            baseId: baseIds[i],
            slotId: slotId,
          ),
        );
      }
    });
  });
}
