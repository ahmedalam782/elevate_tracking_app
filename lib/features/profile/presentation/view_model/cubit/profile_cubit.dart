import 'package:elevate_tracking_app/features/profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:elevate_tracking_app/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileDataUseCase _getProfileDataUseCase;

  ProfileCubit(this._getProfileDataUseCase) : super(const ProfileInitial());

  Future<void> getProfileData() async {
    emit(const ProfileLoading());

    final result = await _getProfileDataUseCase();

    result.when(
      success: (driver) => emit(ProfileLoaded(driver!)),
      error: (exception) => emit(ProfileError(exception?.toString() ?? 'Unknown error')),
    );
  }
}

