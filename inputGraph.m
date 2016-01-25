function inputGraph(inpArray,Ccentroid)
circleCoors = Ccentroid+1;
a = eulerGraph(inpArray);
a.startEuler(circleCoors)
end