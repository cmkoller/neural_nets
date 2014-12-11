class Node < ActiveRecord::Base
  belongs_to :net
  has_many :child_connections, class_name: "Connection", foreign_key: "parent_id"
  has_many :parent_connections, class_name: "Connection", foreign_key: "child_id"
  has_many :parents, through: :parent_connections

  # ====================
  # METHODS
  # ====================

  # SIGMOID
  def sigmoid(x)
    1 / (1 + (Math::E ** (-x)))
  end

  # UPDATE_OUTPUT
  # -------------------
  # Uses total input, threshold, and sigmoid function to update output value
  # MIGHT take in NN's "sigmoidA" value as an input, whatever that is (it's 1 in Py implementation)
  def update_output
    write_attribute(:output, sigmoid(total_input))
    save
  end

  # SEND_OUTPUT_TO_CHILDREN
  # -------------------
  def send_output_to_children
      child_connections.each do |conn|
        child = Node.find(conn.child_id)
        child.total_input += output * conn.weight
        child.save
      end
  end

end


#D3.js -- look it up
