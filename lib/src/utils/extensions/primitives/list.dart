
extension SidBaseList<T> on List<T> {

  List<T> separateWith(T splitter, {
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) => <T>[
    if(alsoFirst || alsoFirstAndLast)
      splitter,
    if(isNotEmpty) 
      first,
    for(int i = 1; i < length; ++i)
      ...<T>[
        splitter, 
        this[i]
      ],
    if(alsoLast || alsoFirstAndLast)
      splitter,
  ];

  List<T> separateWithMultiple(Iterable<T> splitters, {
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) => <T>[
    if(alsoFirst || alsoFirstAndLast)
      ...splitters,
    if(isNotEmpty) 
      first,
    for(int i = 1; i < length; ++i)
      ...<T>[
        ...splitters, 
        this[i]
      ],
    if(alsoLast || alsoFirstAndLast)
      ...splitters,
  ];

  bool checkIndex(int index) {
    if(index < 0) return false;
    if(index >= length) return false;
    return true;
  }

  bool move(int from, int to){
    if(!this.checkIndex(from)) return false;
    if(!this.checkIndex(to)) return false;
    insert(to, removeAt(from));
    return true;
  }

  T? nullableAt(int index){
    if(isEmpty) return null;
    if(index < 0) return null;
    if(index >= length) return null;
    return elementAt(index);
  }

}

extension IterablePartition<T> on Iterable<T> {
  Iterable<List<T>> part(int size) => isEmpty 
    ? <List<T>>[] 
    : _Partition<T>(this, size);
}

class _Partition<T> extends Iterable<List<T>> {
  final Iterable<T> _iterable;
  final int _size;

  _Partition(this._iterable, this._size) {
    if (_size <= 0) throw ArgumentError(_size);
  }

  @override
  Iterator<List<T>> get iterator => _PartitionIterator<T>(
    _iterable.iterator, 
    _size,
  );
}

class _PartitionIterator<T> implements Iterator<List<T>> {
  final Iterator<T> _iterator;
  final int _size;
  List<T>? _current;

  _PartitionIterator(this._iterator, this._size);

  @override
  List<T> get current => _current ?? [];

  @override
  bool moveNext() {
    var newValue = <T>[];
    var count = 0;
    while (count < _size && _iterator.moveNext()) {
      newValue.add(_iterator.current);
      count++;
    }
    _current = (count > 0) ? newValue : null;
    return _current != null;
  }
}

