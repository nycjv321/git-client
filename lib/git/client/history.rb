class History
  attr_writer :entries

  def initialize
    @entries = []
  end

  def << (entry)
    @entries << entry
  end

  def each
    @entries.each do |entry|
      yield entry
    end
  end

  def entries
    @entries
  end

end