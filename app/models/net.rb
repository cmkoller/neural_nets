class Net < ActiveRecord::Base
  has_many :nodes

  # ====================
  # HELPER FUNCTIONS
  # ====================

  # LAYER_N_NODES
  # --------------------
  # Input: L, representing the layer number (0th layer is top layer)
  # Output: Array of nodes from that layer
  def layer_n_nodes(l)
    nodes.where(net_id: id, layer: l).sort_by &:id
  end

  # NUM_LAYERS
  # --------------------
  # Output: Number of layers in NN
  def num_layers
    num_layers = 0
    # binding.pry
    while !nodes.where(net_id: id, layer: num_layers).empty?
      num_layers += 1
    end
    num_layers
  end

  # LOOP_OVER_NODES
  # --------------------
  # Input: L, representing layer number
  # => Additionally, takes in block representing what to do to each node
  def loop_over_nodes(l)
    layer_n_nodes(l).length.times do |i|
      yield i
    end
  end

  # GET_OUTPUTS
  # --------------------
  # Returns an array of outputs from output layer of net
  def get_outputs
    outputs = []
    last_layer_nodes = layer_n_nodes(num_layers - 1)
    loop_over_nodes(num_layers - 1) do |i|
      outputs << last_layer_nodes[i].output
    end
    outputs
  end

  # RESET_ALL_NODES
  # --------------------
  # Resets all OUTPUT and TOTAL_INPUT fields to 0
  def reset_all_nodes
    nodes.where(net_id: id).each do |node|
      node.output = 0
      node.total_input = 0
      node.save
    end
  end

  # ====================
  # CREATION/DELETION METHODS
  # ====================

  # CREATE_NODE
  # --------------------
  # Input: L, representing the layer number (0th layer is top layer)
  # Generates a new node on layer L with randomly weighted connections
  # to all nodes on layer above (if applicable) and below (if applicable)
  def create_node(l)
    node = Node.create(net_id: id, layer: l)
    # Unless L is first layer, generate upward connections
    unless l <= 0
      # For each parent node...
      loop_over_nodes(l - 1) do |i|
        parent = layer_n_nodes(l - 1)[i]
        # Generate a random connection weight between -1 and 1
        weight = rand * 2 - 1
        Connection.create(parent_id: parent.id,
          child_id: node.id,
          weight: weight.round(3))
      end
    end
    # Unless L is last layer, generate downward connections
    unless l >= num_layers - 1
      # For each child node...
      loop_over_nodes(l + 1) do |i|
        child = layer_n_nodes(l + 1)[i]
        # Generate a random connection weight between -1 and 1
        weight = rand * 2 - 1
        Connection.create(parent_id: node.id,
        child_id: child.id,
        weight: weight.round(3))
      end
    end
  end

  # DELETE_NODE
  # --------------------
  # Input: L, representing the layer number (0th layer is top layer)
  # Deletes a node from Layer L, and all connections associated with that node
  def delete_node(l)
    node = Node.find_by(layer: l).destroy
    Connection.destroy_all(parent_id: node.id)
    Connection.destroy_all(child_id: node.id)
  end


  # ====================
  # FEED FORWARD
  # ====================

  # FEED_FORWARD
  # --------------------
  # Input: Array of values between 0 and 1 (inclusive).
  # => Array must be same length as first layer of nodes

  def feed_forward(input)
    reset_all_nodes

    layer_0 = layer_n_nodes(0)
    # Check for wrong number of inputs
    unless input.length == layer_0.length
      return "ERROR - wrong number of inputs."
    end

    puts "LAYER 1 INPUTS"
    # Pass input values to first layer of nodes
    loop_over_nodes(0) do |i|
      node = layer_0[i]
      node.total_input = input[i]
      node.save
    end

    # For each layer but the last, pass activation down
    (num_layers - 1).times do |layer_num|
      cur_layer_nodes = layer_n_nodes(layer_num)
      # For each node in this layer, use the total input to calculate the output
      loop_over_nodes(layer_num) do |i|
        node = cur_layer_nodes[i]
        node.update_output
        #For each child of this node, add to that node's total input
        node.send_output_to_children
      end
    end

    # Once we've fed forward to the last layer, calculate last layer's output
    last_layer_nodes = layer_n_nodes(num_layers - 1)
    loop_over_nodes(num_layers - 1) do |i|
      node = last_layer_nodes[i]
      node.update_output
    end
  end

end
