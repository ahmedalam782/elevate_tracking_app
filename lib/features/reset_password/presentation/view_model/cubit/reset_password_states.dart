import 'package:equatable/equatable.dart';
import '../../../../../core/config/base_state/base_state.dart';
import '../../../domain/entities/change_password_entity.dart';

class ResetPasswordStates extends Equatable {
  final BaseState<ChangePasswordEntity> changePasswordState;

  const ResetPasswordStates({
    this.changePasswordState = const BaseState.initial(),
  });

  ResetPasswordStates copyWith({
    BaseState<ChangePasswordEntity>? changePasswordState,
  }) {
    return ResetPasswordStates(
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object?> get props => [changePasswordState];
}
