import 'package:workmanager/workmanager.dart';

/// A reusable helper class that wraps [Workmanager] for scheduling and
/// cancelling background tasks.
///
/// Usage:
/// 1. Call [BackgroundTaskHelper.initialize] once in `main()`.
/// 2. Instantiate and call [registerPeriodicTask] to schedule a repeating task.
/// 3. Call [cancelTask] or [cancelAllTasks] to stop tasks when no longer needed.
class BackgroundTaskHelper {
  /// Initializes WorkManager with the provided callback dispatcher.
  /// Must be called once at app startup (in main).
  static Future<void> initialize(void Function() callbackDispatcher) async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  /// Registers a periodic background task.
  ///
  /// [uniqueName] is a unique identifier so the task can be cancelled later.
  /// [taskName] is the task name that will be matched in the callbackDispatcher.
  /// [inputData] is optional key-value data passed to the task.
  /// [frequency] defaults to the WorkManager minimum of 15 minutes.
  Future<void> registerPeriodicTask({
    required String uniqueName,
    required String taskName,
    Map<String, dynamic>? inputData,
    Duration frequency = const Duration(minutes: 15),
  }) async {
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: frequency,
      inputData: inputData,
      // existingWorkPolicy: ExistingWorkPolicy.replace,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Registers a one-shot (non-repeating) background task.
  ///
  /// [uniqueName] is a unique identifier so it can be cancelled later.
  /// [taskName] is matched in the callbackDispatcher.
  /// [inputData] is optional key-value data passed to the task.
  Future<void> registerOneOffTask({
    required String uniqueName,
    required String taskName,
    Map<String, dynamic>? inputData,
  }) async {
    await Workmanager().registerOneOffTask(
      uniqueName,
      taskName,
      inputData: inputData,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  /// Cancels a task by its [uniqueName].
  Future<void> cancelTask(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
  }

  /// Cancels all registered WorkManager tasks.
  Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }
}
