require_relative "bst.rb"



my_tree = Tree.new(15.times.map{rand(100)+1})
my_tree.pretty_print
puts "it's my_tree balanced? #{my_tree.balanced?}"
puts "Level order"
puts my_tree.level_order
puts "preorder"
puts my_tree.preorder
puts "Inorder"
puts my_tree.inorder_rec
puts "Postoerder"
puts my_tree.postorder_rec
my_tree.insert(110)
my_tree.insert(150)
my_tree.insert(170)
my_tree.insert(190)
my_tree.insert(200)
my_tree.pretty_print
puts "it's my_tree balanced? #{my_tree.balanced?}"
my_tree.rebalance
my_tree.pretty_print
puts "it's my_tree balanced?#{my_tree.balanced?}"
puts "Level order"
puts my_tree.level_order
puts "preorder"
puts my_tree.preorder
puts "Inorder"
puts my_tree.inorder_rec
puts "Postoerder"
puts my_tree.postorder_rec