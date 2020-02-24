class Authorize
  class << self
    def type(current_user, class_name)
      current_user[:type] == class_name.name.upcase
    end
  end
end