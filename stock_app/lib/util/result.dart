// abstract class Result<T> {
//   factory Result.success(T data) = Success<T>;
//   factory Result.error(Exception exception) = Error<T>;
// }

// class Success<T> implements Result<T> {
//   final T data;

//   Success(this.data);
// }

// class Error<T> implements Result<T> {
//   final Exception exception;

//   Error(this.exception);
// }

import 'package:freezed_annotation/freezed_annotation.dart';
part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.error(Exception exception) = Error<T>;
}
