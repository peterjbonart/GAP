
#This function takes as input a group G and a list L of subgroups of G
#and returns the index of the smallest family of subgroups containing all elements of L
calculateIndex := function(G,subGroupList)
    local tom,vec,mat;
    tom := TableOfMarks(G);
    mat := tomToMatrix(tom);
    vec := groupListToFamily(G,tom,subGroupList);
    return calculateIndexForVectorAndMatrix(vec, mat);
end;


calculateIndexForVectorAndMatrix := function(vec, mat)
	local rationalSolution, i, res;
	rationalSolution := SolutionMat(mat,vec);
    res := DenominatorRat(rationalSolution[1]);
    for i in [2..Length(rationalSolution)] do
        res := LcmInt(res, DenominatorRat(rationalSolution[i]));
    od;
    return res;
end;


#Converts a Table-Of-Marks object to a matrix object
tomToMatrix := function(tom)
    local mat, length, currentRow, nonZeroRowEntries,i,j;
    mat := [];
    length := Length(SubsTom(tom));
    for i in [1..length] do
        currentRow := [];
        nonZeroRowEntries := ShallowCopy(MarksTom(tom)[i]);
        for j in [1..length] do 
            if (j in SubsTom(tom)[i]) then
                Add(currentRow,nonZeroRowEntries[1]);
                Remove(nonZeroRowEntries,1);
            else
                Add(currentRow,0);
            fi;
        od;
        Add(mat,currentRow);
    od;
    return mat;
end;

#This function takes a group called "G", the table of marks of G called "tom" and a list of subgroups of G called "subGroupList"
#It returns a vector whose i-th entry is 1 if and only if the subgroup representing the
#i-th column of the table of marks is contained in the smallest family of subgroups of G
#that contains all subgroups of subGroupList.
groupListToFamily := function(G, tom, subGroupList)
    local oneSpots, i, subGroup, vector;
    #oneSpots is a list containing all the positions at which the result vector should be 1.
    oneSpots := [];
    
    for subGroup in subGroupList do 
        Add(oneSpots,getTomColumnOfSubgroup(G,tom, subGroup));
    od;
    
    oneSpots := closeUnderSubgroups(oneSpots,SubsTom(tom));
    
    vector := [];
    
    for i in [1..Length(SubsTom(tom))] do
        if (i in oneSpots) then 
            Add(vector,1);
        else
            Add(vector,0);
        fi;
    od;
    return vector;
end;

closeUnderSubgroups := function(oneSpots,subsTom)
    local res, i, j;
    res := [];
    for j in oneSpots do;
        for i in subsTom[j] do
            Add(res,i);
        od;
    od;
    return res;
end;

#This function takes a group called "G", the table of marks of G called "tom", and a subgroup of G called "subGroup"
#it returns an integer i such that subGroup corresponds to the i-th column of tom.
getTomColumnOfSubgroup := function(G, tom, subGroup)
    local conjugates , i;
    conjugates := ConjugateSubgroups(G,subGroup);
    for i in [1..Length(SubsTom(tom))] do 
        if (RepresentativeTom(tom,i) in conjugates) then
            return i;
        fi;
    od;
    Print("Error: One of the subgroups specified wasn´t conjugate to anything in the table of marks.");
end;
