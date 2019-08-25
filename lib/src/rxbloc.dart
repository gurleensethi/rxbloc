import 'dart:async';

import 'package:rxdart/rxdart.dart';

class BlocStream<T> extends Stream {
  Subject<T> _subject;
  final RxBloc _altRxBloc;

  BlocStream(this._altRxBloc, this._subject);

  @override
  StreamSubscription listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return _subject.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class RxBloc {
  final List<Subject> _subjects = [];

  _addSubject(Subject subject) {
    this._subjects.add(subject);
  }

  Future<void> close() async {
    return Future.wait(_subjects
        .where((subject) => subject != null && !subject.isClosed)
        .map((subject) => subject.close()));
  }

  BlocStream<T> behaviour<T>() {
    final BehaviorSubject<T> behaviorSubject = BehaviorSubject<T>();
    this._addSubject(behaviorSubject);
    return BlocStream<T>(this, behaviorSubject);
  }

  Subject<T> update<T>(BlocStream<T> blocStream) {
    if (this != blocStream._altRxBloc) {
      throw Exception("Trying to access stream from a different RxBloc!");
    }
    return blocStream._subject;
  }

  Subject<T> call<T>(BlocStream<T> blocStream) {
    return update<T>(blocStream);
  }
}
