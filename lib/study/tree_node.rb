module Study
  class TreeNode
    attr_accessor :type, :value

    def initialize(type:, value:)
      @type = type
      @value = value
    end

    def ==(other)
      @type == other.type && @value == other.value
    end

    def highlight(left: nil, right: nil, nested: false, plain: false)
      colored_left = left.is_a?(Integer) ? TextHighlight.violet(left, plain: plain) : TextHighlight.cyan(left, plain: plain)

      if nested
        [
          colored_left,
          TextHighlight.green(":", plain: plain),
          " ",
          TextHighlight.yellow(right, plain: plain)
        ].join("")
      else
        [
          colored_left,
          TextHighlight.green(":", plain: plain),
          " ",
          TextHighlight.white(right, plain: plain)
        ].join("")
      end     
    end

    def draw(indent: 0, tree_key: nil, branch_toggle: [], max_depth: 10, plain: false)
      return if indent > max_depth

      if indent == 0
        if has_children?
          draw_line(indent: 0, 
                    text: TextHighlight.yellow(@type, plain: plain), 
                    branch_toggle: branch_toggle, 
                    root: true,
                    max_depth: max_depth,)

        else
          draw_line(indent: 0, 
                    text: [TextHighlight.yellow(@type, plain: plain), TextHighlight.white(@value, plain: plain)].join(" "), 
                    branch_toggle: branch_toggle, 
                    root: true,
                    max_depth: max_depth)

          return
        end
      end

      if has_children?
        if tree_key
          draw_line(indent: indent, 
                    text: highlight(left: tree_key, right: @type, nested: true, plain: plain), 
                    branch_toggle: branch_toggle,
                    no_children: false,
                    max_depth: max_depth,
                    plain: plain)
        end

        each_child_with_last do |key, value, last|
          if value.is_a?(TreeNode)
            value.draw(indent: indent + 1, 
                       tree_key: key, 
                       branch_toggle: branch_toggle + [last], 
                       max_depth: max_depth,
                       plain: plain)
          else
            draw_line(indent: indent + 1,
                      text: highlight(left: key, right: value, plain: plain), 
                      branch_toggle: branch_toggle + [last], 
                      max_depth: max_depth,
                      plain: plain)
          end
        end
      else
        draw_line(indent: indent, 
                  text: highlight(left: tree_key, right: @value, plain: plain), 
                  branch_toggle: branch_toggle, 
                  max_depth: max_depth,
                  plain: plain)
      end

      nil
    end

    def each_child_with_last(&block)
      total_size = @value.size
      sorted_keys = @value.keys.sort

      sorted_number_keys = sorted_keys.select { |key| key.is_a?(Numeric) }.sort
      sorted_symbol_keys = sorted_keys.select { |key| key.is_a?(Symbol) }.sort
      sorted_string_keys = sorted_keys.select { |key| key.is_a?(String) }.sort
      remaining_keys = sorted_keys - sorted_number_keys - sorted_symbol_keys - sorted_string_keys
      remaining_keys = remaining_keys.sort rescue remaining_keys

      sorted_keys = sorted_number_keys + sorted_symbol_keys + sorted_string_keys + remaining_keys

      sorted_keys.each_with_index do |key, index|
        value = @value[key]

        block.call(key, value, total_size - 1 == index)
      end
    end

    def draw_line(indent: 0, text:, branch_toggle:, root: false, no_children: true, max_depth: 10, plain: false)
      if root
        puts text
      else
        previous, current = branch_toggle[0..-2], branch_toggle[-1]

        indent_lines = previous.map { |item| item ? "    " : "   │" }.join("")

        current_branch_line = current ? "   └── " : "   ├── "

        branch_lines = TextHighlight.green([indent_lines, current_branch_line].join(""), plain: plain)

        puts [branch_lines, text.force_encoding('UTF-8')].join("")

        if current && (no_children || (indent >= max_depth))
          puts TextHighlight.green([indent_lines].join(""), plain: plain)
        end
      end
    end

    def has_children?
      ["Hash", "Array"].include?(@value.class.name) && @value.size > 0
    end

    def self.convert(target, registered_objects: [])
      if registered_objects.include?(target.object_id)
        return TreeNode.new(type: target.class.name, value: "DUPLICATE #{ target.class.name }")
      else
        if target.is_a?(Array) || target.is_a?(Hash) || target.instance_variables.size > 0
          registered_objects << target.object_id
        end
      end

      output = {
        type: nil,
        value: nil
      }

      target_class_name = target.class.name

      if target.is_a?(Hash)
        output_container = {}

        target.each do |hash_key, hash_value|
          output_container[hash_key] = convert(hash_value, registered_objects: registered_objects)
        end

        output[:value] = output_container

      elsif target.is_a?(Array)
        output_container = {}

        target.each_with_index do |array_value, index|
          output_container[index] = convert(array_value, registered_objects: registered_objects)
        end

        output[:value] = output_container

      elsif target.instance_variables.size > 0
        output_container = {}

        target.instance_variables.each do |name|
          value = target.instance_variable_get(name)
          key = name.to_s.gsub('@', '').to_sym

          # use getter method instead
          if target.public_methods(false).include?(key.to_sym)
            begin
              output_container[key] = convert(target.send(key.to_sym), registered_objects: registered_objects)
            rescue
              output_container[key] = convert(value, registered_objects: registered_objects)
            end  
          else
            output_container[key] = convert(value, registered_objects: registered_objects)
          end
        end

        output[:value] = output_container

      elsif target_class_name == "NilClass"
        output[:value] = "nil"

      elsif target_class_name == "IO"
        output[:value] = "<IO>"

      elsif target_class_name == "Thread::Mutex"
        output[:value] = "<Thread::Mutex>"

      elsif target_class_name == "Proc"
        output[:value] = "<Proc>"

      else
        output[:value] = target
        
      end

      output[:type] = target_class_name

      TreeNode.new(type: output[:type], value: output[:value])
    end
  end
end