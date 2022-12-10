
class Tree
  include Comparable

  attr_accessor :root
  attr_reader :array

  def initialize(array)
    @root = built_tree(array.sort)
    @array = array
  end

  def built_tree(arr = self.array)
    a = 0
    b = arr.size-1
    mid = (a+b)/2

    temp = Node.new(arr[mid])

    return nil if arr.empty?

    temp.left_child = self.built_tree(arr[0...mid])

    temp.right_child = self.built_tree(arr[mid+1..-1])
    
    temp
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' 
      : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' 
      : '│   '}", true) if node.left_child
  end

  def insert(value, node = @root)
    
    return @root = Node.new(value) if @root.nil?
    return Node.new(value) if node.nil?
    self.array << value unless self.array.include?(value)
    value < node.data ? node.left_child = insert(value, node.left_child)
    : node.right_child = insert(value, node.right_child)
    node
  end

  def insert_dfs_balanced(value)
    stack = [self.root]
    until stack.empty?  
      current = stack.shift
     
      if current.right_child
        stack.unshift(current.right_child)
      else 
        current.right_child = Node.new(value)
        self.array.push(value)
        break
      end

      if current.left_child
        stack.unshift(current.left_child)
      else 
        current.left_child = Node.new(value)
        self.array.push(value)
        break
      end
    end
  end

  def insert_bfs_balanced(value)
    queue  = [self.root]
    until queue.empty? 
      current = queue.shift

      if current.left_child
        queue.push(current.left_child)
      else
        current.left_child = Node.new(value)
        self.array.push(value)
        break
      end

      if current.right_child
        queue.push(current.right_child)
      else
        current.right_child = Node.new(value)
        self.array.push(value)
        break
      end
    end
  end

  def del_rebalance(value)
    #deletes a value and rebalances the tree
    raise StandardError, "Nonexisting value in Tree" unless self.includes?(value)
    self.array.delete(value)
    self.root = built_tree(array.sort)
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      node.right_child = delete(value, node.right_child)
    else
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      node.data = minimum(node.right_child)
      node.right_child = delete(node.data, node.right_child)
    end
    node
  end

  def minimum(node = @root)
    min = node.data
    until node.left_child.nil?
      min = node.left_child.data
      node = node.left_child
    end
    min
  end


  def find_it_dfs(target)
    stack = [self.root]
    until stack.empty?
      current = stack.shift
      
      if current.data == target
        return current
        break
      else
        stack.unshift(current.left_child) if current.left_child
        stack.unshift(current.right_child) if current.right_child
      end
    end
    raise StandardError, "Node not found"
  end

  def find_it_bfs(target)
    queue=[self.root]
    until queue.empty?
      current = queue.pop
      return current if current.data == target
    
      queue.unshift(current.left_child) if current.left_child
      queue.unshift(current.right_child) if current.right_child 
    end

    raise StandardError, "Node not found"
  end

  def find_rec_dfs(target, start = self.root)
    raise StandardError, "Node not found" if start.nil?
    return start if start.data == target
    return find_rec_dfs(target, start.left_child) || find_rec_dfs(target, start.right_child)
  end

  def includes? (target, start = self.root)
    return false if start.nil?
    return true if start.data == target
    return includes?(target, start.left_child) || includes?(target, start.right_child)
  end

  def level_order(output = [])
    queue = [self.root]
    until queue.empty?
      current = queue.shift
      output.push(current.data)
      
      yield current if block_given?
      
      queue.push(current.left_child) if current.left_child
      queue.push(current.right_child) if current.right_child
    end
    output
  end

  def level_order_rec

    puts "working on this method..."
    
  end

  def preorder
    stack = [self.root]
    no_block_arr = []
    until stack.empty?
      current = stack.pop
      no_block_arr.push(current.data)
      
      yield current if block_given?
      
      stack.push(current.right_child) if current.right_child
      stack.push(current.left_child) if current.left_child
      
    end
    no_block_arr
  end

  # root, l, r
  def preorder_rec(node = root, output = [], &block)

    return if node.nil?

    yield(node) if block_given?
    output << node.data
    
    preorder_rec(node.left_child, output, &block)
    preorder_rec(node.right_child, output, &block)
    output
  end

  # l root r
  def inorder_rec(node = self.root, output = [], &block)
    return if node.nil?

    inorder_rec(node.left_child, output, &block)
    yield(node) if block_given?
    output << node.data
    inorder_rec(node.right_child, output, &block)
    output
      
  end

  # l,r, root
  def postorder_rec(node = self.root, output = [], &block)
    return if node.nil?

    postorder_rec(node.left_child, output, &block)
    postorder_rec(node.right_child, output, &block)
    yield (node) if block_given?
    output << node.data
    output
  end

  def height(node = root)
    return -1 if node.nil?
    
    node = find(node) if node.is_a?(Integer)
    left = height(node.left_child)
    right = height(node.right_child)
    left > right ? 1 + left : 1 + right
  end

  def depth(x, node = root, edges = 0)
    if node.nil?
      nil
    elsif node.data == x
      edges
    elsif node.data > x
      edges += 1
      depth(x, node.left_child, edges)
    elsif node.data < x
      edges += 1
      depth(x, node.right_child, edges)
    end
  end

  def balanced?
    hl = self.height(self.root.left_child)
    hr = self.height(self.root.right_child)
    !(hl-hr > 1 || hr-hl > 1)
  end

  def rebalance
    self.root = built_tree((array.sort))
  end
end


class Node
  include Comparable

  attr_accessor :data, :left_child, :right_child
  
  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end

end
