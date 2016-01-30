function inputGraph(node,edge)
circleCoors = node.centroid+1;
a = eulerGraph(edge);
a.startEuler(circleCoors)
end