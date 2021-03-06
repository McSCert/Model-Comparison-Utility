# Model Comparison Utility
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4321649.svg)](https://doi.org/10.5281/zenodo.4321649)
[![View Model Comparison Utility on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/71834-model-comparison-utility)
#### The Model Comparison Utility provides command line functions for supporting Simulink model comparison.

<img src="imgs/Cover.png" width="750">

Differencing between two models is natively supported in Simulink via the [Simulink Comparison Tool](https://www.mathworks.com/help/simulink/model-comparison.html). This tool can generate a Word or HTML report displaying the changes that occur between models. Unfortunately, for large industrial models, these generated reports are not readable. As an alternative, the tool can output the comparison results to the Matlab base workspace as an `EditsObj` object that is structured as a tree.

Unfortunately, MathWorks provides no built-in commands to be able to easily and programmatically query or parse this tree from the command line or a script. Manually doing so for industrial models is simply not possible. Moreover, extracting information from the tree requires thorough knowledge of the tree structure and the object parameters, and thus is not trivial without much effort. The Model Comparison Utility was created to facilitate such operations via a collection of commands. Some useful commands provided by this tool are:

* `find_node` - Search the comparison tree for nodes with specific block types, changes, names, etc.
* `getHandle` - Get the handle of the model element associated with the node from the comparison tree.
* `getPath` - Get the pathname of the model element associated with the node from the comparison tree.
* `getNodeType` - Determine whether the node presents a block, line, annotation, mask, etc.
* `plotTree` - Plot the digraph of the comparison tree.
* `treeToTable` - Convert the comparison tree to a table.
* `summaryOfChanges` - Print a summary report of the changes in the comparison tree to the Command Window or a .txt file.

Many other commands are included and are free to be used, but are not listed here. Please explore the source files for this utility to see all the of the various functions.

## User Guide
For installation and other information, please see the [User Guide](doc/ModelComparisonUtility_UserGuide.pdf).
