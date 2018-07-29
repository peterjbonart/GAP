

#This function returns a list of pairs of groups of a specified order
#whose tables of marks might be isomorphic.
#If for two groups G, H of the specified order the pairs [G,H] and
#[H,G] are not in the returned list, then
#G and H do not have equivalent tables of marks.
findEqualToms := function(order)
local groupList, tomList, tomList2, t1, t2, res;
    res := [];
    tomList := getAllTableOfMarks(order);
    tomList2 := ShallowCopy(tomList);
    for t1 in tomList do
        Remove(tomList2,1);
        for t2 in tomList2 do
            if matrixEntryTest(t1[1],t2[1]) then
                if rowAndColumnTest(t1[1],t2[1]) then
                    Add(res,[t1[2],t2[2]]);
                fi;
            fi;
        od;
    od;
    return res;
end;

#Tests whether the entries of tom1 and tom2 form the same multisets.
#If this function returns false, then tom1 and tom2 are not isomorphic
matrixEntryTest := function(tom1, tom2)
local multiset1, multiset2;
    multiset1 := listToMultiset(union(MarksTom(tom1)));
    multiset2 := listToMultiset(union(MarksTom(tom2)));
    return multisetEquality(multiset1, multiset2);
end;

#Tests whether tom1, tom2 have the same multiset of rows and columns
#where the rows and columns are themselves regarded as multisets.
rowAndColumnTest := function(tom1, tom2)
    return columnTest(tom1, tom2,true) and columnTest(tom1,tom2,false);
end;

#Tests whether tom1, tom2 have the same multiset of columns,
#where the columns are themselves regarded as multisets.
#If checkColumnsNotRows is false, it will check rows instead of columns.
columnTest := function(tom1, tom2, checkColumnsNotRows)
    return multisetEquality(multisetOfAllColumns(tom1,checkColumnsNotRows),
    multisetOfAllColumns(tom2,checkColumnsNotRows));
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

#Takes two multisets and returns true if and only if they are equal as multisets
multisetEquality := function(multiset1, multiset2)
local i , index;
    for i in [1..Length(multiset1[1])] do 
        index := Position(multiset2[1],multiset1[1][i]);
        if index = fail then
            return false;
        else
            if not (multiset1[2][i] = multiset2[2][index]) then
                return false;
            fi;
        fi;
    od;
    return Length(multiset1[1]) = Length(multiset2[1]);
end;

#If transpose is true, then this function returns
#the multiset of all columns of tom
#where the columns are themselves regarded as multisets.
#If transpose is false then this function does the same thing with
#rows instead of columns
multisetOfAllColumns := function(tom,transpose)
local elementList,element,i;
    elementList := [];
    for i in [1..Length(SubsTom(tom))] do
        element := columnMultiset(tom,i,transpose);
        Add(elementList,element);
    od;
    return listToMultiset(elementList);
end;

#If transpose is true then the function does the following:
#It takes a table of marks tom, and an integer columnIndex
#It returns the columnIndex-th column regarded as a multiset.
#If transpose is false then this function does the same thing with
#rows instead of columns
columnMultiset := function(tom, columnIndex,transpose)
local mat, column, multiset, sortedElements, sortedMultiplicities, x;
    mat := tomToMatrix(tom);
    if transpose then 
        mat := TransposedMat(mat);
    fi;
    column := mat[columnIndex];
    multiset := listToMultiset(column);
    #We sort the intelements so that we can later compare these multisets
    #directly using GAP's = equality instead of multisetEquality
    sortedElements := ShallowCopy(multiset[1]);
    Sort(sortedElements);
    sortedMultiplicities := [];
    for x in sortedElements do
        Add(sortedMultiplicities,multiset[2][Position(multiset[1],x)]);
    od;
    return [sortedElements,sortedMultiplicities];
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