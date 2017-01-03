require 'set'

class Tisket::Manager

  attr_accessor *%i[ backward_deps forward_deps initial_set specs threads ]

  def initialize(specs)
    specs = YAML.load(specs) if specs.is_a?(String)
    specs = convert_specs(specs)

    self.backward_deps = {}
    self.forward_deps = Hash.new{|h,k| h[k] = Set.new }
    self.initial_set = Set.new

    specs.each do |id,spec|
      if (deps = spec.delete(:_requires)) && !deps.empty?
        deps.each{|d| forward_deps[d] << id }
        backward_deps[id] = deps
      else
        initial_set << id
      end
    end

    self.specs = specs
  end

  def complete(id)
    puts "completing #{id}"
    next_tasks = Set.new
    forward_deps[id].each do |dep|
      bw = backward_deps[dep]
      bw.delete(id)
      next_tasks << dep if bw.empty?
    end
    enqueue(next_tasks)
  end

  def enqueue(ids)
    ids.map{|id| run_one(id) }.map(&:join)
  end

  def run_one(id)
    puts "running #{id}"
    spec = specs[id].dup
    task = Object.const_get(
      spec.delete(:_class) || camelize(id)
    ).new(self, id: id, **spec)
    th = Thread.new{ task.run }
    th.run
    th
  end

  def run
    enqueue(initial_set)
  end

protected

  def convert_specs(node)
    case node
    when Hash
      # Some YAML parsers - including Psych 2 - don't have builtin support for
      # sets :(
      if !node.empty? && node.values.all?(&:nil?)
        Set.new(node.keys.map(&:to_sym))
      else
        node.inject({}){|h,(k,v)| h.update(k.to_sym => convert_specs(v)) }
      end
    when Array
      node.map{|a| convert_specs(a) }
    else
      node
    end
  end

  def camelize(snake_case)
    snake_case.scan(/[^_]+_?/).map{|s| s.chomp('_') }.map(&:capitalize).join
  end
end
