require 'study/text_highlight'
require 'study/tree_node'
require 'study/version'

module Study
  module Methods
    def study(target, max_depth: 10, plain: false)
      TreeNode.convert(target).draw(max_depth: max_depth, plain: plain)
    end
  end
end

extend Study::Methods
include Study::Methods