inp = [
    0 1 0 2 0 1;
    1 0 2 0 1 0;
    0 2 0 2 0 2;
    2 0 2 0 2 0;
    0 1 0 2 0 1;
    1 0 2 0 1 0
    ];

a = eulerGraph(inp);
a.startEuler()