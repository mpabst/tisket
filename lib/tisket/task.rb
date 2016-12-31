class Tisket::Task

  def self.attr_names
    %i[ id manager ]
  end

  def self.defaults
    { }
  end

  def initialize(manager = nil, **kwargs)
    self.class.attr_names.each do |a|
      instance_variable_set("@#{a}", kwargs[a] || self.class.defaults[a])
    end
    @manager = manager
  end

  def run
    yield
    @manager.complete(@id) if @manager
  end
end
