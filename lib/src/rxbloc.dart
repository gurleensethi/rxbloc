import 'dart:async';

import 'package:rxdart/rxdart.dart';

mixin RxBloc {
  final List<Subject> _subjects = [];

  _addSubject(Subject subject) {
    this._subjects.add(subject);
  }

  Future<void> close() async {
    return Future.wait(_subjects
        .where((subject) => subject != null && !subject.isClosed)
        .map((subject) => subject.close()));
  }
}

class BlocStream<T> extends Stream {
  final Subject<T> _subject;
  final RxBloc rxBloc;
  final Type streamType;

  BlocStream(this.rxBloc) {


    rxBloc._addSubject(_subject);
  }

  @override
  StreamSubscription listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return _subject.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class RxUpdater {
  final RxBloc rxBloc;

  RxUpdater(this.rxBloc) : assert(rxBloc != null);

  Subject<T> update<T>(BlocStream<T> blocStream) {
    return blocStream._subject;
  }

  Subject<T> call<T>(BlocStream<T> blocStream) {
    print(identical(this.rxBloc, blocStream.rxBloc));
    return update<T>(blocStream);
  }
}
