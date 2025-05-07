// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaking_practice_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpeakingPracticeState {
  bool get isRecording => throw _privateConstructorUsedError;
  bool get isProcessing => throw _privateConstructorUsedError;
  String? get userSpeech => throw _privateConstructorUsedError;
  String? get aiResponse => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SpeakingPracticeStateCopyWith<SpeakingPracticeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeakingPracticeStateCopyWith<$Res> {
  factory $SpeakingPracticeStateCopyWith(SpeakingPracticeState value,
          $Res Function(SpeakingPracticeState) then) =
      _$SpeakingPracticeStateCopyWithImpl<$Res, SpeakingPracticeState>;
  @useResult
  $Res call(
      {bool isRecording,
      bool isProcessing,
      String? userSpeech,
      String? aiResponse,
      String? error});
}

/// @nodoc
class _$SpeakingPracticeStateCopyWithImpl<$Res,
        $Val extends SpeakingPracticeState>
    implements $SpeakingPracticeStateCopyWith<$Res> {
  _$SpeakingPracticeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecording = null,
    Object? isProcessing = null,
    Object? userSpeech = freezed,
    Object? aiResponse = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      userSpeech: freezed == userSpeech
          ? _value.userSpeech
          : userSpeech // ignore: cast_nullable_to_non_nullable
              as String?,
      aiResponse: freezed == aiResponse
          ? _value.aiResponse
          : aiResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeakingPracticeStateImplCopyWith<$Res>
    implements $SpeakingPracticeStateCopyWith<$Res> {
  factory _$$SpeakingPracticeStateImplCopyWith(
          _$SpeakingPracticeStateImpl value,
          $Res Function(_$SpeakingPracticeStateImpl) then) =
      __$$SpeakingPracticeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isRecording,
      bool isProcessing,
      String? userSpeech,
      String? aiResponse,
      String? error});
}

/// @nodoc
class __$$SpeakingPracticeStateImplCopyWithImpl<$Res>
    extends _$SpeakingPracticeStateCopyWithImpl<$Res,
        _$SpeakingPracticeStateImpl>
    implements _$$SpeakingPracticeStateImplCopyWith<$Res> {
  __$$SpeakingPracticeStateImplCopyWithImpl(_$SpeakingPracticeStateImpl _value,
      $Res Function(_$SpeakingPracticeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecording = null,
    Object? isProcessing = null,
    Object? userSpeech = freezed,
    Object? aiResponse = freezed,
    Object? error = freezed,
  }) {
    return _then(_$SpeakingPracticeStateImpl(
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      userSpeech: freezed == userSpeech
          ? _value.userSpeech
          : userSpeech // ignore: cast_nullable_to_non_nullable
              as String?,
      aiResponse: freezed == aiResponse
          ? _value.aiResponse
          : aiResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SpeakingPracticeStateImpl implements _SpeakingPracticeState {
  const _$SpeakingPracticeStateImpl(
      {this.isRecording = false,
      this.isProcessing = false,
      this.userSpeech,
      this.aiResponse,
      this.error});

  @override
  @JsonKey()
  final bool isRecording;
  @override
  @JsonKey()
  final bool isProcessing;
  @override
  final String? userSpeech;
  @override
  final String? aiResponse;
  @override
  final String? error;

  @override
  String toString() {
    return 'SpeakingPracticeState(isRecording: $isRecording, isProcessing: $isProcessing, userSpeech: $userSpeech, aiResponse: $aiResponse, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeakingPracticeStateImpl &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.userSpeech, userSpeech) ||
                other.userSpeech == userSpeech) &&
            (identical(other.aiResponse, aiResponse) ||
                other.aiResponse == aiResponse) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isRecording, isProcessing, userSpeech, aiResponse, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeakingPracticeStateImplCopyWith<_$SpeakingPracticeStateImpl>
      get copyWith => __$$SpeakingPracticeStateImplCopyWithImpl<
          _$SpeakingPracticeStateImpl>(this, _$identity);
}

abstract class _SpeakingPracticeState implements SpeakingPracticeState {
  const factory _SpeakingPracticeState(
      {final bool isRecording,
      final bool isProcessing,
      final String? userSpeech,
      final String? aiResponse,
      final String? error}) = _$SpeakingPracticeStateImpl;

  @override
  bool get isRecording;
  @override
  bool get isProcessing;
  @override
  String? get userSpeech;
  @override
  String? get aiResponse;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$SpeakingPracticeStateImplCopyWith<_$SpeakingPracticeStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
