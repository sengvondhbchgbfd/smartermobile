import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_entity.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/attendance_record_tile.dart';

class RecordsList extends StatelessWidget {
  const RecordsList({
    super.key,
    required this.isLoading,
    required this.records,
    required this.selectedId,
    required this.onTap,
    required this.onLongPress,
    required this.onRefresh,
  });

  final bool                        isLoading;
  final List<AttendanceEntity>      records;
  final int?                        selectedId;
  final ValueChanged<AttendanceEntity> onTap;
  final ValueChanged<AttendanceEntity> onLongPress;
  final Future<void> Function()     onRefresh;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (records.isEmpty) {
      return const Center(child: Text('No attendance records found.'));
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding:     const EdgeInsets.symmetric(vertical: 4),
        itemCount:   records.length,
        itemBuilder: (_, i) {
          final r = records[i];
          return AttendanceRecordTile(
            record:    r,
            selected:  selectedId == r.attendanceId,
            onTap:     () => onTap(r),
            onLongPress: () => onLongPress(r),
          );
        },
      ),
    );
  }
}