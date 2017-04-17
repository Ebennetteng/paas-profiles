require 'mongoid'

module Profiles
  class Pricing
    include Mongoid::Document

    embedded_in :vendor

    field :model, type: String
    field :period, type: String
    # validations
    validates :model, inclusion: { in: %w[fixed metered hybrid free] }
    validates :period, inclusion: { in: %w[daily monthly annually] }, if: proc { !model.eql?('free') }
  end
end
