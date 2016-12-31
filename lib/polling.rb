class Tisket::Task::Polling < Tisket::Task

  def self.attr_names
    super + %i[ max_retries poll_interval ]
  end

  def self.defaults
    super.merge(
      max_retries: 10,
      poll_interval: 30 ) # seconds
  end

  def done?
    raise 'Abstract method'
  end

  def poll
    @max_retries.times do
      done? ? break : sleep(@poll_interval)
    end
  end

  def run
    super do
      start
      poll
    end
  end

  def start
    raise 'Abstract method'
  end
end
