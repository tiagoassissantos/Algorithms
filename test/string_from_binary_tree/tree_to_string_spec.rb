RSpec.describe TreeToString do
  it "return string with 1 node" do
    root = TreeNode.new(1)
    expect(TreeToString.new.tree2str(root)).to eq("(1)")
  end
end