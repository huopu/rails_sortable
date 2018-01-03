class SortableController < ApplicationController
  #
  # post /sortable/reorder, :klass => ["1", "3", "2"], :sort_attribute => "position_by_widget"
  #
  def reorder
    klass, ids, sort_attribute = parse_params
    klass.set_sortable sort_attribute, klass.sortable_options
    attr = klass.sort_attribute
    models = klass.where(id: ids).order(attr).to_a
    ids.each_with_index do |id, new_sort|
      model = models.find {|m| m.id == id }
      model.update_sort!(new_sort) if model.read_attribute(attr) != new_sort
    end
    head :ok
  end

private

  def parse_params
    klass_name = params.keys.first
    ids = params[klass_name].map {|id| id.to_i }
    sort_attribute = params[:sort_attribute].presence || klass_name.constantize.sort_attribute
    [ klass_name.constantize, ids, sort_attribute ]
  end
end
