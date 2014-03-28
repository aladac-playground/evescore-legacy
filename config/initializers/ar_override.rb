module ActiveRecord
  class Base
    def save(*args)
      super
    rescue ActiveRecord::RecordNotUnique
      false
    rescue ActiveRecord::RecordNotFound
      false
    end
  end
end