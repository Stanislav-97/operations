class BaseModel
  class << self
    def find(id)
      model_attributes = Database.db[@table_name][id: id]
      if model_attributes.nil?
        raise StandardError, "Not found"
      else
        new(model_attributes)
      end
    end

    def create(attrs)
      id = Database.db[@table_name].insert(attrs)
      attrs[:id] = id
      new(attrs)
    end

    def table_name(name)
      @table_name ||= name
    end

    def attribute(name)
      attributes << name
    end

    def attributes
      @attributes ||= [:id]
    end
  end

  def initialize(kwargs= {})
    self.class.attributes.each do |attribute|
      instance_variable_set("@#{attribute}", kwargs[attribute])

      define_singleton_method(attribute) do
        instance_variable_get(:"@#{attribute}")
      end
    end
  end

  def to_h
    self.class.attributes.to_h do |attribute|
      [attribute, send(attribute)]
    end
  end
end