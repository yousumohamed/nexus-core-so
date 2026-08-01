class NexusState<T> {
  T _value;
  NexusState(this._value);
  T get value => _value;
  void update(T val) { _value = val; }
}
