import 'package:sid_base/sid_base.dart';

extension ReactiveRelated9<A, B, C, D, E, F, G, H, I>
    on
        (
          Reactive<A>,
          Reactive<B>,
          Reactive<C>,
          Reactive<D>,
          Reactive<E>,
          Reactive<F>,
          Reactive<G>,
          Reactive<H>,
          Reactive<I>,
        ) {
  Reactive<T> related<T>(
    T Function(A, B, C, D, E, F, G, H, I) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(
      this.$1.value,
      this.$2.value,
      this.$3.value,
      this.$4.value,
      this.$5.value,
      this.$6.value,
      this.$7.value,
      this.$8.value,
      this.$9.value,
    );
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
      this.$9,
    ]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated8<A, B, C, D, E, F, G, H>
    on
        (
          Reactive<A>,
          Reactive<B>,
          Reactive<C>,
          Reactive<D>,
          Reactive<E>,
          Reactive<F>,
          Reactive<G>,
          Reactive<H>,
        ) {
  Reactive<T> related<T>(
    T Function(A, B, C, D, E, F, G, H) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(
      this.$1.value,
      this.$2.value,
      this.$3.value,
      this.$4.value,
      this.$5.value,
      this.$6.value,
      this.$7.value,
      this.$8.value,
    );
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
      this.$8,
    ]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated7<A, B, C, D, E, F, G>
    on
        (
          Reactive<A>,
          Reactive<B>,
          Reactive<C>,
          Reactive<D>,
          Reactive<E>,
          Reactive<F>,
          Reactive<G>,
        ) {
  Reactive<T> related<T>(
    T Function(A, B, C, D, E, F, G) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(
      this.$1.value,
      this.$2.value,
      this.$3.value,
      this.$4.value,
      this.$5.value,
      this.$6.value,
      this.$7.value,
    );
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
      this.$7,
    ]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated6<A, B, C, D, E, F>
    on
        (
          Reactive<A>,
          Reactive<B>,
          Reactive<C>,
          Reactive<D>,
          Reactive<E>,
          Reactive<F>,
        ) {
  Reactive<T> related<T>(
    T Function(A, B, C, D, E, F) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(
      this.$1.value,
      this.$2.value,
      this.$3.value,
      this.$4.value,
      this.$5.value,
      this.$6.value,
    );
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
      this.$6,
    ]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated5<A, B, C, D, E>
    on (Reactive<A>, Reactive<B>, Reactive<C>, Reactive<D>, Reactive<E>) {
  Reactive<T> related<T>(
    T Function(A, B, C, D, E) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(
      this.$1.value,
      this.$2.value,
      this.$3.value,
      this.$4.value,
      this.$5.value,
    );
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [
      this.$1,
      this.$2,
      this.$3,
      this.$4,
      this.$5,
    ]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated4<A, B, C, D>
    on (Reactive<A>, Reactive<B>, Reactive<C>, Reactive<D>) {
  Reactive<T> related<T>(
    T Function(A, B, C, D) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() =>
        map(this.$1.value, this.$2.value, this.$3.value, this.$4.value);
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [this.$1, this.$2, this.$3, this.$4]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated3<A, B, C> on (Reactive<A>, Reactive<B>, Reactive<C>) {
  Reactive<T> related<T>(
    T Function(A, B, C) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(this.$1.value, this.$2.value, this.$3.value);
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [this.$1, this.$2, this.$3]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated2<A, B> on (Reactive<A>, Reactive<B>) {
  Reactive<T> related<T>(
    T Function(A, B) map, {
    bool Function(T, T)? equality,
  }) {
    T getValue() => map(this.$1.value, this.$2.value);
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() {
      if (!result.isDisposed) result.update(getValue());
    }

    for (final Reactive reactive in [this.$1, this.$2]) {
      reactive.addListener(listener);
      result.beforeDisposing(() => reactive.removeListener(listener));
    }
    return result;
  }
}

extension ReactiveRelated<A> on Reactive<A> {
  Reactive<T> related<T>(T Function(A) map, {bool Function(T, T)? equality}) {
    T getValue() => map(value);
    final Reactive<T> result = Reactive(getValue(), equality: equality);
    void listener() => result.update(getValue());
    addListener(listener);
    result.beforeDisposing(() => removeListener(listener));
    return result;
  }
}
