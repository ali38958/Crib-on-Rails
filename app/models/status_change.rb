class StatusChange < ApplicationRecord
  belongs_to :order
  belongs_to :changed_by, class_name: 'OrderReceiver', foreign_key: 'changed_by_id', optional: true
end
