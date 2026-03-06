import 'package:workmanager/workmanager.dart';

/// Top-level callback dispatcher required by WorkManager.
/// Must be a top-level (not a class method) Dart function.
/// WorkManager calls this in an isolated Dart context when a task fires.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Add specific task handling here if needed in the future.
    // For now this is a placeholder re-start hook.
    return Future.value(true);
  });
}
