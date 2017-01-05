class Tisket::Task

  def self.defaults
    { }
  end

  attr_accessor :_spec

  def initialize(_spec = {})
    self._spec = _spec
  end

  def method_missing(name, *args, &block)
    if _spec.has_key?(name) && args.empty?
      _spec[name] || self.class.defaults[name]
    else
      super
    end
  end

  def run
    yield
    _manager.complete(id) if _manager
  end
end
