#This function takes a group called "G", the table of marks of G called "tom" and a list of subgroups of G called "subGroupList"
#It returns a vector whose i-th entry is 1 if and only if the subgroup representing the
#i-th column of the table of marks is contained in the smallest family of subgroups of G
#that contains all subgroups of subGroupList.
groupListToFamily := function(G, tom, subGroupList)
    local oneSpots, i, subGroup;
    #oneSpots is a list containing all the positions at which the result vector should be 1.
    oneSpots := [];
    
    for subGroup in subGroupList do 
        Add(oneSpots,getTomColumnOfSubgroup(G,tom, subGroup));
    od;
    
    oneSpots := closeUnderSubgroups(oneSpots,SubsTom(tom));
    
    return oneSpotsToVector(oneSpots,Length(SubsTom(tom)));
end;

#This function returns a vector of length "length" whose i-th entry it 1 if i is in "oneSpots" and 0 otherwise
oneSpotsToVector := function(oneSpots, length)
    local vector,i;
    vector := [];
    for i in [1..length] do
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





powerset := function(list) 
    local res, subList, x;
    res := [];
    if (Length(list) = 0) then
        return [[]];
    fi;
    subList := list{ [2..Length(list)]};
    for x in powerset(subList) do 
        Add(res,x);
        Add(res,Concatenation([list[1]],x));
    od;
    return res;
end;


getAllFamilies := function(G,tom)
    local res, subGroupList, i, oneSpots,x,actualRes;
    subGroupList := [1..Length(SubsTom(tom))];
    res := [];
    for oneSpots in powerset(subGroupList) do 
        Add(res,oneSpotsToVector(closeUnderSubgroups(oneSpots,SubsTom(tom)),Length(SubsTom(tom))));
    od;
    res := DuplicateFreeList(res);
    return res;
end;




