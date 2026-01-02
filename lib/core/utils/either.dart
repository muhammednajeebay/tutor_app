abstract class Either<L, R> {
  const Either();

  bool get isRight => this is Right<L, R>;

  bool get isLeft => this is Left<L, R>;

  Either<L, T> map<T>(T Function(R) fn) {
    if (this is Right<L, R>) {
      return Right(fn((this as Right<L, R>).value));
    }
    return Left((this as Left<L, R>).value);
  }

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    if (this is Right<L, R>) {
      return rightFn((this as Right<L, R>).value);
    }
    return leftFn((this as Left<L, R>).value);
  }

  R getOrElse(R Function() defaultValue) {
    if (this is Right<L, R>) {
      return (this as Right<L, R>).value;
    }
    return defaultValue();
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Left && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Right &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}