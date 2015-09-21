module BankTrain
  module ApplicationHelper

    def controller?(*controller)
      controller.include?(params[:controller])
    end

    def action?(*action)
      action.include?(params[:action])
    end

    def nav_link(path, str)
      klass = current_page?(path) ? 'active' : ''

      capture_haml {
        haml_tag :li, class: klass do
          haml_tag :a, str, href: path
        end
      }
    end

    def operation_tree_node(operation)
        haml_tag :li, class: :operation do
          haml_tag :div, operation.name, class: :name
          haml_tag :ul, class: :operations do
            operation.children_operations.each do |child|
              operation_tree_node child
            end
          end
        end
    end

    def operation_tree_node_json
      operations = BankTrain::BusinessOperation.all.map {|x| {name: x.name, parent: x.parent_operation_id, id: x.id}}

      operations.select {|x| 
        x[:parent].blank?
      }.each {|o| 
        _r(o, operations)
      }
    end

    def _r(operation, operations)
      haml_tag :li, class: :operation do
        haml_tag :div, operation[:name], class: :name
        haml_tag :ul, class: :operations do
          children_operations = operations.select {|x|
            x[:parent] == operation[:id]
          }
          children_operations.each do |child|
            _r child, operations
          end
        end
      end
    end

  end
end