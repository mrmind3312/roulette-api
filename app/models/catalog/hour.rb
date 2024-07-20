class Catalog::Hour < ApplicationRecord
  has_many :services_hours, class_name: 'Services::Hour', foreign_key: 'catalog_hours_id', dependent: :destroy
  has_many :services, through: :services_hours

  DAYS = %w[Lunes Martes Miercoles Jueves Viernes Sábado Domingo]

  def start_at_time
    start_at.strftime('%H:%M')
  end

  def end_at_time
    end_at.strftime('%H:%M')
  end

  def show
    self_attributes = attributes

    self_attributes[:start_at] = start_at_time
    self_attributes[:end_at] = end_at_time

    self_attributes
  end
end
