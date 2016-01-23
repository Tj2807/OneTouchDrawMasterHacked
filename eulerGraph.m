%Written by Tejas S. Niphadkar.
%The Code is opensource and can be modified,distributed or may directly be
%used in any project.
%API Instructions:
%Create an object to the class by giving the Graph Matrix as an Argument.
%Call startEuler function without any argument.

classdef eulerGraph
    properties
        graphInp, nVertices, oddVertex , nTotalEdgesTwice , eulerIncludedEdges, eulerAnsArray ;
    end
    methods
        function obj = eulerGraph(edges)
            obj.graphInp=edges;
            obj.nVertices = size(obj.graphInp,1);
        end
        function isIt = isEuler(obj)
            obj.nTotalEdgesTwice = 0;
            oddVertexCount=0;
            %returns 1 if Euler's Path , 2 if Euler's Circuit , 0 if NONE.
            %Function Assumes that graph is connected.If not, a simple dfs will do.
            for i=1:1:obj.nVertices
                sumRow = sum(obj.graphInp(i,:));
                obj.nTotalEdgesTwice= obj.nTotalEdgesTwice +sumRow; 
                if mod(sumRow,2)~=0
                    oddVertexCount = oddVertexCount+ 1;
                    obj.oddVertex = i ;
                end
            end 
            if oddVertexCount==0 || oddVertexCount == 2
                isIt=1;
            else
                isIt=0;
            end
        end
        function ansArray = startEuler(obj)
            if ~isEuler()
                fprintf('The Graph Matrix Input Does not have a valid Euler Path/Circuit');
            end
            obj.eulerIncludedEdges = 0;
            nTotalEdges = obj.nTotalEdgesTwice/2;
            obj.eulerAnsArray= zeros(nTotalEdges,2);
            u=obj.oddVertex;
            obj.storeEuler(u);
            ansArray = obj.eulerAnsArray;
        end
        function storeEuler(obj,vertex) 
            for i=1:1:obj.nVertices
                adj = obj.graphInp(vertex,i);
                if adj~=-1 && isValidNextEdge(vertex,i)
                    obj.eulerIncludedEdges = obj.eulerIncludedEdges +1;
                    obj.eulerAnsArray(obj.eulerIncludedEdges,1) = vertex;
                    obj.eulerAnsArray(obj.eulerIncludedEdges,2) = i;
                    obj.rmvEdge(u,i);
                    obj.storeEuler(i);
                    break;
                end
            end
        end
        function rmvEdge(obj,u,v)
            obj.graphInp(v,u) = -1;
            obj.graphInp(u,v) = -1; %#ok<MCHV2>
        end
        function addEdge(obj,u,v)
            obj.graphInp(u,v) = 1;
            obj.graphInp(v,u) = 1;
        end
    end
end
    