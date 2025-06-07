// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return _QuestionModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get headline => throw _privateConstructorUsedError;
  String get paragraph => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'main_idea_question')
  MainIdeaQuestionModel? get mainIdeaQuestion =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'fill_in_the_blank_question')
  FillInTheBlankQuestionModel? get fillInTheBlankQuestion =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get userResponse => throw _privateConstructorUsedError;
  bool? get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionModelCopyWith<QuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelCopyWith<$Res> {
  factory $QuestionModelCopyWith(
          QuestionModel value, $Res Function(QuestionModel) then) =
      _$QuestionModelCopyWithImpl<$Res, QuestionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String headline,
      String paragraph,
      String? source,
      @JsonKey(name: 'main_idea_question')
      MainIdeaQuestionModel? mainIdeaQuestion,
      @JsonKey(name: 'fill_in_the_blank_question')
      FillInTheBlankQuestionModel? fillInTheBlankQuestion,
      DateTime createdAt,
      String? userResponse,
      bool? isCorrect});

  $MainIdeaQuestionModelCopyWith<$Res>? get mainIdeaQuestion;
  $FillInTheBlankQuestionModelCopyWith<$Res>? get fillInTheBlankQuestion;
}

/// @nodoc
class _$QuestionModelCopyWithImpl<$Res, $Val extends QuestionModel>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? headline = null,
    Object? paragraph = null,
    Object? source = freezed,
    Object? mainIdeaQuestion = freezed,
    Object? fillInTheBlankQuestion = freezed,
    Object? createdAt = null,
    Object? userResponse = freezed,
    Object? isCorrect = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      headline: null == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      paragraph: null == paragraph
          ? _value.paragraph
          : paragraph // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      mainIdeaQuestion: freezed == mainIdeaQuestion
          ? _value.mainIdeaQuestion
          : mainIdeaQuestion // ignore: cast_nullable_to_non_nullable
              as MainIdeaQuestionModel?,
      fillInTheBlankQuestion: freezed == fillInTheBlankQuestion
          ? _value.fillInTheBlankQuestion
          : fillInTheBlankQuestion // ignore: cast_nullable_to_non_nullable
              as FillInTheBlankQuestionModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userResponse: freezed == userResponse
          ? _value.userResponse
          : userResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      isCorrect: freezed == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MainIdeaQuestionModelCopyWith<$Res>? get mainIdeaQuestion {
    if (_value.mainIdeaQuestion == null) {
      return null;
    }

    return $MainIdeaQuestionModelCopyWith<$Res>(_value.mainIdeaQuestion!,
        (value) {
      return _then(_value.copyWith(mainIdeaQuestion: value) as $Val);
    });
  }

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FillInTheBlankQuestionModelCopyWith<$Res>? get fillInTheBlankQuestion {
    if (_value.fillInTheBlankQuestion == null) {
      return null;
    }

    return $FillInTheBlankQuestionModelCopyWith<$Res>(
        _value.fillInTheBlankQuestion!, (value) {
      return _then(_value.copyWith(fillInTheBlankQuestion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionModelImplCopyWith<$Res>
    implements $QuestionModelCopyWith<$Res> {
  factory _$$QuestionModelImplCopyWith(
          _$QuestionModelImpl value, $Res Function(_$QuestionModelImpl) then) =
      __$$QuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String headline,
      String paragraph,
      String? source,
      @JsonKey(name: 'main_idea_question')
      MainIdeaQuestionModel? mainIdeaQuestion,
      @JsonKey(name: 'fill_in_the_blank_question')
      FillInTheBlankQuestionModel? fillInTheBlankQuestion,
      DateTime createdAt,
      String? userResponse,
      bool? isCorrect});

  @override
  $MainIdeaQuestionModelCopyWith<$Res>? get mainIdeaQuestion;
  @override
  $FillInTheBlankQuestionModelCopyWith<$Res>? get fillInTheBlankQuestion;
}

/// @nodoc
class __$$QuestionModelImplCopyWithImpl<$Res>
    extends _$QuestionModelCopyWithImpl<$Res, _$QuestionModelImpl>
    implements _$$QuestionModelImplCopyWith<$Res> {
  __$$QuestionModelImplCopyWithImpl(
      _$QuestionModelImpl _value, $Res Function(_$QuestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? headline = null,
    Object? paragraph = null,
    Object? source = freezed,
    Object? mainIdeaQuestion = freezed,
    Object? fillInTheBlankQuestion = freezed,
    Object? createdAt = null,
    Object? userResponse = freezed,
    Object? isCorrect = freezed,
  }) {
    return _then(_$QuestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      headline: null == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      paragraph: null == paragraph
          ? _value.paragraph
          : paragraph // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      mainIdeaQuestion: freezed == mainIdeaQuestion
          ? _value.mainIdeaQuestion
          : mainIdeaQuestion // ignore: cast_nullable_to_non_nullable
              as MainIdeaQuestionModel?,
      fillInTheBlankQuestion: freezed == fillInTheBlankQuestion
          ? _value.fillInTheBlankQuestion
          : fillInTheBlankQuestion // ignore: cast_nullable_to_non_nullable
              as FillInTheBlankQuestionModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userResponse: freezed == userResponse
          ? _value.userResponse
          : userResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      isCorrect: freezed == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionModelImpl implements _QuestionModel {
  const _$QuestionModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.headline,
      required this.paragraph,
      this.source,
      @JsonKey(name: 'main_idea_question') this.mainIdeaQuestion,
      @JsonKey(name: 'fill_in_the_blank_question') this.fillInTheBlankQuestion,
      required this.createdAt,
      this.userResponse,
      this.isCorrect});

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String headline;
  @override
  final String paragraph;
  @override
  final String? source;
  @override
  @JsonKey(name: 'main_idea_question')
  final MainIdeaQuestionModel? mainIdeaQuestion;
  @override
  @JsonKey(name: 'fill_in_the_blank_question')
  final FillInTheBlankQuestionModel? fillInTheBlankQuestion;
  @override
  final DateTime createdAt;
  @override
  final String? userResponse;
  @override
  final bool? isCorrect;

  @override
  String toString() {
    return 'QuestionModel(id: $id, headline: $headline, paragraph: $paragraph, source: $source, mainIdeaQuestion: $mainIdeaQuestion, fillInTheBlankQuestion: $fillInTheBlankQuestion, createdAt: $createdAt, userResponse: $userResponse, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.paragraph, paragraph) ||
                other.paragraph == paragraph) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.mainIdeaQuestion, mainIdeaQuestion) ||
                other.mainIdeaQuestion == mainIdeaQuestion) &&
            (identical(other.fillInTheBlankQuestion, fillInTheBlankQuestion) ||
                other.fillInTheBlankQuestion == fillInTheBlankQuestion) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userResponse, userResponse) ||
                other.userResponse == userResponse) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      headline,
      paragraph,
      source,
      mainIdeaQuestion,
      fillInTheBlankQuestion,
      createdAt,
      userResponse,
      isCorrect);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      __$$QuestionModelImplCopyWithImpl<_$QuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionModel implements QuestionModel {
  const factory _QuestionModel(
      {@JsonKey(name: '_id') required final String id,
      required final String headline,
      required final String paragraph,
      final String? source,
      @JsonKey(name: 'main_idea_question')
      final MainIdeaQuestionModel? mainIdeaQuestion,
      @JsonKey(name: 'fill_in_the_blank_question')
      final FillInTheBlankQuestionModel? fillInTheBlankQuestion,
      required final DateTime createdAt,
      final String? userResponse,
      final bool? isCorrect}) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get headline;
  @override
  String get paragraph;
  @override
  String? get source;
  @override
  @JsonKey(name: 'main_idea_question')
  MainIdeaQuestionModel? get mainIdeaQuestion;
  @override
  @JsonKey(name: 'fill_in_the_blank_question')
  FillInTheBlankQuestionModel? get fillInTheBlankQuestion;
  @override
  DateTime get createdAt;
  @override
  String? get userResponse;
  @override
  bool? get isCorrect;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MainIdeaQuestionModel _$MainIdeaQuestionModelFromJson(
    Map<String, dynamic> json) {
  return _MainIdeaQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$MainIdeaQuestionModel {
  String get question => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String? get difficulty => throw _privateConstructorUsedError;

  /// Serializes this MainIdeaQuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MainIdeaQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MainIdeaQuestionModelCopyWith<MainIdeaQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainIdeaQuestionModelCopyWith<$Res> {
  factory $MainIdeaQuestionModelCopyWith(MainIdeaQuestionModel value,
          $Res Function(MainIdeaQuestionModel) then) =
      _$MainIdeaQuestionModelCopyWithImpl<$Res, MainIdeaQuestionModel>;
  @useResult
  $Res call(
      {String question,
      List<String> choices,
      String answer,
      String? difficulty});
}

/// @nodoc
class _$MainIdeaQuestionModelCopyWithImpl<$Res,
        $Val extends MainIdeaQuestionModel>
    implements $MainIdeaQuestionModelCopyWith<$Res> {
  _$MainIdeaQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainIdeaQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? choices = null,
    Object? answer = null,
    Object? difficulty = freezed,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainIdeaQuestionModelImplCopyWith<$Res>
    implements $MainIdeaQuestionModelCopyWith<$Res> {
  factory _$$MainIdeaQuestionModelImplCopyWith(
          _$MainIdeaQuestionModelImpl value,
          $Res Function(_$MainIdeaQuestionModelImpl) then) =
      __$$MainIdeaQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String question,
      List<String> choices,
      String answer,
      String? difficulty});
}

/// @nodoc
class __$$MainIdeaQuestionModelImplCopyWithImpl<$Res>
    extends _$MainIdeaQuestionModelCopyWithImpl<$Res,
        _$MainIdeaQuestionModelImpl>
    implements _$$MainIdeaQuestionModelImplCopyWith<$Res> {
  __$$MainIdeaQuestionModelImplCopyWithImpl(_$MainIdeaQuestionModelImpl _value,
      $Res Function(_$MainIdeaQuestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainIdeaQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? choices = null,
    Object? answer = null,
    Object? difficulty = freezed,
  }) {
    return _then(_$MainIdeaQuestionModelImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MainIdeaQuestionModelImpl implements _MainIdeaQuestionModel {
  const _$MainIdeaQuestionModelImpl(
      {required this.question,
      required final List<String> choices,
      required this.answer,
      this.difficulty})
      : _choices = choices;

  factory _$MainIdeaQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MainIdeaQuestionModelImplFromJson(json);

  @override
  final String question;
  final List<String> _choices;
  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  final String answer;
  @override
  final String? difficulty;

  @override
  String toString() {
    return 'MainIdeaQuestionModel(question: $question, choices: $choices, answer: $answer, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainIdeaQuestionModelImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question,
      const DeepCollectionEquality().hash(_choices), answer, difficulty);

  /// Create a copy of MainIdeaQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MainIdeaQuestionModelImplCopyWith<_$MainIdeaQuestionModelImpl>
      get copyWith => __$$MainIdeaQuestionModelImplCopyWithImpl<
          _$MainIdeaQuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MainIdeaQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _MainIdeaQuestionModel implements MainIdeaQuestionModel {
  const factory _MainIdeaQuestionModel(
      {required final String question,
      required final List<String> choices,
      required final String answer,
      final String? difficulty}) = _$MainIdeaQuestionModelImpl;

  factory _MainIdeaQuestionModel.fromJson(Map<String, dynamic> json) =
      _$MainIdeaQuestionModelImpl.fromJson;

  @override
  String get question;
  @override
  List<String> get choices;
  @override
  String get answer;
  @override
  String? get difficulty;

  /// Create a copy of MainIdeaQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainIdeaQuestionModelImplCopyWith<_$MainIdeaQuestionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FillInTheBlankQuestionModel _$FillInTheBlankQuestionModelFromJson(
    Map<String, dynamic> json) {
  return _FillInTheBlankQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$FillInTheBlankQuestionModel {
  @JsonKey(name: 'question_text_with_blank')
  String get questionTextWithBlank => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_prompt')
  String get questionPrompt => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String? get difficulty => throw _privateConstructorUsedError;

  /// Serializes this FillInTheBlankQuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FillInTheBlankQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FillInTheBlankQuestionModelCopyWith<FillInTheBlankQuestionModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FillInTheBlankQuestionModelCopyWith<$Res> {
  factory $FillInTheBlankQuestionModelCopyWith(
          FillInTheBlankQuestionModel value,
          $Res Function(FillInTheBlankQuestionModel) then) =
      _$FillInTheBlankQuestionModelCopyWithImpl<$Res,
          FillInTheBlankQuestionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'question_text_with_blank') String questionTextWithBlank,
      @JsonKey(name: 'question_prompt') String questionPrompt,
      List<String> choices,
      String answer,
      String? difficulty});
}

/// @nodoc
class _$FillInTheBlankQuestionModelCopyWithImpl<$Res,
        $Val extends FillInTheBlankQuestionModel>
    implements $FillInTheBlankQuestionModelCopyWith<$Res> {
  _$FillInTheBlankQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FillInTheBlankQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionTextWithBlank = null,
    Object? questionPrompt = null,
    Object? choices = null,
    Object? answer = null,
    Object? difficulty = freezed,
  }) {
    return _then(_value.copyWith(
      questionTextWithBlank: null == questionTextWithBlank
          ? _value.questionTextWithBlank
          : questionTextWithBlank // ignore: cast_nullable_to_non_nullable
              as String,
      questionPrompt: null == questionPrompt
          ? _value.questionPrompt
          : questionPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FillInTheBlankQuestionModelImplCopyWith<$Res>
    implements $FillInTheBlankQuestionModelCopyWith<$Res> {
  factory _$$FillInTheBlankQuestionModelImplCopyWith(
          _$FillInTheBlankQuestionModelImpl value,
          $Res Function(_$FillInTheBlankQuestionModelImpl) then) =
      __$$FillInTheBlankQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'question_text_with_blank') String questionTextWithBlank,
      @JsonKey(name: 'question_prompt') String questionPrompt,
      List<String> choices,
      String answer,
      String? difficulty});
}

/// @nodoc
class __$$FillInTheBlankQuestionModelImplCopyWithImpl<$Res>
    extends _$FillInTheBlankQuestionModelCopyWithImpl<$Res,
        _$FillInTheBlankQuestionModelImpl>
    implements _$$FillInTheBlankQuestionModelImplCopyWith<$Res> {
  __$$FillInTheBlankQuestionModelImplCopyWithImpl(
      _$FillInTheBlankQuestionModelImpl _value,
      $Res Function(_$FillInTheBlankQuestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FillInTheBlankQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionTextWithBlank = null,
    Object? questionPrompt = null,
    Object? choices = null,
    Object? answer = null,
    Object? difficulty = freezed,
  }) {
    return _then(_$FillInTheBlankQuestionModelImpl(
      questionTextWithBlank: null == questionTextWithBlank
          ? _value.questionTextWithBlank
          : questionTextWithBlank // ignore: cast_nullable_to_non_nullable
              as String,
      questionPrompt: null == questionPrompt
          ? _value.questionPrompt
          : questionPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FillInTheBlankQuestionModelImpl
    implements _FillInTheBlankQuestionModel {
  const _$FillInTheBlankQuestionModelImpl(
      {@JsonKey(name: 'question_text_with_blank')
      required this.questionTextWithBlank,
      @JsonKey(name: 'question_prompt') required this.questionPrompt,
      required final List<String> choices,
      required this.answer,
      this.difficulty})
      : _choices = choices;

  factory _$FillInTheBlankQuestionModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$FillInTheBlankQuestionModelImplFromJson(json);

  @override
  @JsonKey(name: 'question_text_with_blank')
  final String questionTextWithBlank;
  @override
  @JsonKey(name: 'question_prompt')
  final String questionPrompt;
  final List<String> _choices;
  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  final String answer;
  @override
  final String? difficulty;

  @override
  String toString() {
    return 'FillInTheBlankQuestionModel(questionTextWithBlank: $questionTextWithBlank, questionPrompt: $questionPrompt, choices: $choices, answer: $answer, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FillInTheBlankQuestionModelImpl &&
            (identical(other.questionTextWithBlank, questionTextWithBlank) ||
                other.questionTextWithBlank == questionTextWithBlank) &&
            (identical(other.questionPrompt, questionPrompt) ||
                other.questionPrompt == questionPrompt) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionTextWithBlank,
      questionPrompt,
      const DeepCollectionEquality().hash(_choices),
      answer,
      difficulty);

  /// Create a copy of FillInTheBlankQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FillInTheBlankQuestionModelImplCopyWith<_$FillInTheBlankQuestionModelImpl>
      get copyWith => __$$FillInTheBlankQuestionModelImplCopyWithImpl<
          _$FillInTheBlankQuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FillInTheBlankQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _FillInTheBlankQuestionModel
    implements FillInTheBlankQuestionModel {
  const factory _FillInTheBlankQuestionModel(
      {@JsonKey(name: 'question_text_with_blank')
      required final String questionTextWithBlank,
      @JsonKey(name: 'question_prompt') required final String questionPrompt,
      required final List<String> choices,
      required final String answer,
      final String? difficulty}) = _$FillInTheBlankQuestionModelImpl;

  factory _FillInTheBlankQuestionModel.fromJson(Map<String, dynamic> json) =
      _$FillInTheBlankQuestionModelImpl.fromJson;

  @override
  @JsonKey(name: 'question_text_with_blank')
  String get questionTextWithBlank;
  @override
  @JsonKey(name: 'question_prompt')
  String get questionPrompt;
  @override
  List<String> get choices;
  @override
  String get answer;
  @override
  String? get difficulty;

  /// Create a copy of FillInTheBlankQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FillInTheBlankQuestionModelImplCopyWith<_$FillInTheBlankQuestionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
