/// Extension to format [Duration] for display (e.g. HH:MM:SS).
library;

extension DurationExtension on Duration {
  /// Formats as HH:MM:SS (e.g. "02:17:00" for 2h 17m).
  /// Hours can exceed 24.
  String get formattedHHMMSS {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  /// Formats as HH:MM (e.g. "02:17" for 2h 17m).
  String get formattedHHMM {
    final h = inHours;
    final m = inMinutes.remainder(60);
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
