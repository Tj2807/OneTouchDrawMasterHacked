%Written by Tejas S. Niphadkar.
%The Code is opensource and can be modified,distributed or may directly be
%used in any project.
%API Instructions:
%Create an object to the class by giving the Graph Matrix as an Argument.
%Call startEuler function without any argument.

%To do: A diagraph with no. of edges more than 1 between two vertices.
classdef eulerGraph < handle
    properties
        graphInp, nVertices, oddVertex , eulerIncludedEdges, eulerAnsArray , visited ;
    end
    methods
        function obj = eulerGraph(edges)
            obj.graphInp=edges;
            obj.nVertices = size(obj.graphInp,1);
        end
        function isIt = isEuler(obj)
            oddVertexCount=0;
            %returns 1 if Euler's Path , 2 if Euler's Circuit , 0 if NONE.
            %Function Assumes that graph is connected.If not, a simple dfs will do.
            for i=1:1:obj.nVertices
                sumRow = sum(obj.graphInp(i,:));
                if mod(sumRow,2)~=0
                    oddVertexCount = oddVertexCount+ 1;
                    obj.oddVertex = i ;
                end 
            end 
            if oddVertexCount==0
                obj.oddVertex = 1;
            end
            if oddVertexCount==0 || oddVertexCount == 2
                isIt=1;
            else
                isIt=0;
            end
        end
        function ansArray = startEuler(obj)
            if ~obj.isEuler()
                fprintf('The Graph Matrix Input Does not have a valid Euler Path/Circuit');
            end
            obj.eulerIncludedEdges = 0;
            obj.eulerAnsArray= {};
            u=obj.oddVertex;
            obj.storeEuler(u);
            ansArray = obj.eulerAnsArray;
        end
        function storeEuler(obj,vertex)
            %fprintf('here at %d\n',vertex);
            for i=1:1:obj.nVertices
                adj = obj.graphInp(vertex,i);
                %fprintf('at edge %d-%d\n',vertex,i);
                if adj~=0 && obj.isValidNextEdge(vertex,i)
                    obj.eulerIncludedEdges = obj.eulerIncludedEdges +1;
                    obj.eulerAnsArray{obj.eulerIncludedEdges,1} = vertex;
                    obj.eulerAnsArray{obj.eulerIncludedEdges,2} = i;
                    obj.rmvNormalEdge(vertex,i);
                    obj.storeEuler(i);
                end
            end
        end
        function rmvNormalEdge(obj,u,v)
            obj.graphInp(v,u) = obj.graphInp(v,u) -1;
            obj.graphInp(u,v) = obj.graphInp(u,v) -1; 
        end
        function addNormalEdge(obj,u,v)
            obj.graphInp(u,v) = obj.graphInp(u,v)+ 1;
            obj.graphInp(v,u) = obj.graphInp(v,u)+ 1;
        end
        function isValid= isValidNextEdge(obj,u,v)
            %fprintf('at edge checking if valid %d-%d\n',u,v);
            remVertices=0;
            for i= 1:1:obj.nVertices
                if obj.graphInp(u,i)~=0
                    remVertices = remVertices+ 1;
                end
            end
            obj.visited = zeros(1,obj.nVertices);
            countWithEdge = obj.dfsCount(u);
            obj.rmvNormalEdge(u,v);
            obj.visited = zeros(1,obj.nVertices);
            countWithoutEdge = obj.dfsCount(u);
            obj.addNormalEdge(u,v);
            isValid = (remVertices==1 || countWithEdge==countWithoutEdge);
        end
        function countVisited = dfsCount(obj,u)
            obj.visited(u)=1;
            countVisited=1;
            %fprintf('Visited %d\n',u);
            for i= 1:1:obj.nVertices
                if obj.graphInp(u,i)~=0 && ~obj.visited(i)
                    countVisited = countVisited + obj.dfsCount(i);
                    %fprintf('Increased count for %d->%d',u,i);
                end
            end
        end
    end
end
    