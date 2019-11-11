function [n, e, nodes, elems] = import_hex_mesh(path)   

    fin = fopen(path,'r'); 
    while ~feof(fin) %Do it until the end of the file
        
        temp=fgetl(fin);
        
        if length(temp)>2
            if strcmp(temp(1:5),'*NODE') == 1
                nodes = textscan(fin, '%f %f %f %f','Delimiter', ',');
            elseif strcmp(temp(1:2),'*E') == 1
                elems= textscan(fin, '%f %f %f %f %f %f %f %f %f','Delimiter', ',');
            end
        end
        
    end
    n = [nodes{1,2} nodes{1,3} nodes{1,4}];
    e = [elems{1,2} elems{1,3} elems{1,4} elems{1,5} elems{1,6} elems{1,7} elems{1,8} elems{1,9} ];

end
              
    
    
    