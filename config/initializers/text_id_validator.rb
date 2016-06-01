class TextIdValidator < ActiveModel::Validations::FormatValidator
  def initialize(options)
    options[:with] = /\A[a-z0-9_]+\z/
    super(options)
  end
end