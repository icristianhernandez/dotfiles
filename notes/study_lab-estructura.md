bool createTriad(unique_ptr<TreeNode> &parent, int leftVal, int centerVal,
int rightVal) {
if (parent == nullptr)
return false;

    try {
        parent->leftChild = make_unique<TreeNode>(leftVal);
        parent->centerChild = make_unique<TreeNode>(centerVal);
        parent->rightChild = make_unique<TreeNode>(rightVal);
        return true;
    } catch (const exception &e) {
        cerr << "Error creating triad: " << e.what() << endl;
        return false;
    }

}

int createLevel(unique_ptr<TreeNode> &node, int startValue) {
if (node == nullptr)
return startValue;

    if (!createTriad(node, startValue, startValue + 1, startValue + 2))
        return startValue;

    return startValue + 3; // Return next available value

}

unique_ptr<TreeNode> buildTree() {
auto root = make_unique<TreeNode>(1);
if (root == nullptr)
return nullptr;

    // Create first level (2, 3, 4)
    int nextValue = createLevel(root, 2);
    if (nextValue == 2)
        return nullptr;

    // Create second level for each first-level node
    createLevel(root->leftChild, 5);
    createLevel(root->centerChild, 8);
    createLevel(root->rightChild, 11);

    // Create third level for each second-level node
    createLevel(root->leftChild->leftChild, 14);
    createLevel(root->leftChild->centerChild, 17);
    createLevel(root->leftChild->rightChild, 20);
    createLevel(root->centerChild->leftChild, 23);
    createLevel(root->centerChild->centerChild, 26);
    createLevel(root->centerChild->rightChild, 29);
    createLevel(root->rightChild->leftChild, 32);
    createLevel(root->rightChild->centerChild, 35);
    createLevel(root->rightChild->rightChild, 38);

    // Create some nodes in fifth level (example: under first two nodes of
    // fourth level)
    createLevel(root->leftChild->leftChild->leftChild, 41);
    createLevel(root->leftChild->leftChild->centerChild, 44);
    createLevel(root->leftChild->leftChild->rightChild, 47);
    createLevel(root->leftChild->centerChild->leftChild, 50);

    return root;

}

Left for complete:

nodesWithoutChildren
insertNode
