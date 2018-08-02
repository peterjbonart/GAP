
Find5Pairs := function() 
	return findEqualToms(64,[2,4]);
end;


#This function returns a list of pairs of groups of a specified order
#whose tables of marks have the same number of x's in them
#for every x in the list restriction.
findEqualToms := function(order, restriction)
local tomList, tomList2, t1, t2, res;
    res := [];
    tomList := getAllTableOfMarks(order);
    tomList2 := ShallowCopy(tomList);
    for t1 in tomList do
        Remove(tomList2,1);
        for t2 in tomList2 do
            if matrixEntryTest(t1[1],t2[1],restriction) then
                Add(res,[t1[2],t2[2]]);
            fi;
        od;
    od;
    return res;
end;

#Tests whether the entries of tom1 and tom2 have the same number of x's
#in them for every x in the list restriction.
matrixEntryTest := function(tom1, tom2, restriction)
local multiset1, multiset2;
    multiset1 := listToMultiset(union(MarksTom(tom1)));
    multiset2 := listToMultiset(union(MarksTom(tom2)));
    return multisetEquality(multiset1, multiset2, restriction);
end;


#Converts a list into a multiset
#Multisets are implemented as pairs [elements,multiplicity].
#elements is a list of objects
#multiplicity is a list of integers
#such that for all i, multiplicity[i] is the number of times
#elements[i] is in the multiset.
listToMultiset := function(list)
local elements, multiplicity, x, index;
    elements := [];
    multiplicity := [];
    for x in list do
        index := Position(elements,x);
        if index = fail then
            Add(elements,x);
            Add(multiplicity,1);
        else
            multiplicity[index] := multiplicity[index] + 1;
        fi;
    od;
    return [elements,multiplicity];
end;

#Takes two multisets and returns true if and only if for each x in restriction
#the multiset contain the same amounts of x's.
multisetEquality := function(multiset1, multiset2,restriction)
local x, index1, index2;
    for x in restriction do
		index1 := Position(multiset1[1],x);
		index2 := Position(multiset2[1],x);
		if (index1 = fail) or (index2 = fail) then
			if not ((index1 = fail) and (index2 = fail)) then
				return false;
			fi;
		else
			if not (multiset1[2][index1] = multiset2[2][index2]) then
				return false;
			fi;
		fi;
	od;
    return true;
end;

#This function creates a list of the table of marks of all groups
#of a specified order
getAllTableOfMarks := function(order)
local list, G;
    list := [];
    for G in AllSmallGroups(order) do
        Add(list,[TableOfMarks(G),G]);
    od;
    return list;
end;

#Takes a list L of lists and returns the union of all the entries of L
union := function(list)
local res, x;
    res := [];
    for x in list do 
        Append(res,x);
    od;
    return res;
end;