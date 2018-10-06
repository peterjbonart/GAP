
#Takes a pair of group.
#Creates a table representing the multiset of columns of the two groups.
PrintMultisetOfColumnsTable := function(groupPair, printColumnsNotRows)
local multiset1, multiset2;
	multiset1 := multisetOfAllColumns(TableOfMarks(groupPair[1]),printColumnsNotRows);
	multiset2 := multisetOfAllColumns(TableOfMarks(groupPair[2]),printColumnsNotRows);
	printPairAsLatex(multiset1,multiset2);
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
local mat, column, multiset, sortedElements, sortedMultiplicities, x, requiredEntries, rEntry, zeroIndex;
    mat := tomToMatrix(tom);
    if transpose then 
        mat := TransposedMat(mat);
    fi;
    column := mat[columnIndex];
    multiset := listToMultiset(column);
	#We add some zero entries because then the output is easier to convert into a Latex tabular
	requiredEntries := [1,2,4,8,16,32,64];
	for rEntry in requiredEntries do 
		if not (rEntry in multiset[1]) then
			Add(multiset[1],rEntry);
			Add(multiset[2],0);
		fi;
	od;
	#And zeros are very uninteresting
	zeroIndex := Position(multiset[1],0);
	if not zeroIndex = fail then
		Remove(multiset[1],zeroIndex);
		Remove(multiset[2],zeroIndex);
	fi;
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

#Takes two multisets and prints out the entries of a table
#Each line of the table first specifies a row/column type
#and then specifies how many times that type of row appears in the multisets. 
printPairAsLatex := function(multiset1, multiset2)
local combinedElements, x, otherElement, element, pair;
	combinedElements := ShallowCopy(multiset1[1]);
	for otherElement in multiset2[1] do 
		if not (otherElement in combinedElements) then
			Add(combinedElements,otherElement);
		fi;
	od;
	#TODO: for each line print the element, then multiset1[2][i], then multiset2[2][i]
	for pair in combinedElements do 
		element := pair[2];
		Print("\n");
		for x in element do
			Print(x);
			Print(" &");
		od;
		if getMultiplicity(multiset1,pair) = getMultiplicity(multiset2,pair) then 
			Print(getMultiplicity(multiset1,pair));
			Print(" &");
			Print(getMultiplicity(multiset2,pair));
			Print("\\\\");
		else
			Print("\\underline\{");
			Print(getMultiplicity(multiset1,pair));
			Print("\} & \\underline\{");
			Print(getMultiplicity(multiset2,pair));
			Print("\}\\\\");
		fi;
	od;
end;
getMultiplicity := function(multiset, element)
local index;
	index := Position(multiset[1],element);
	if not (index = fail) then 
		return multiset[2][index];
	else 
		return 0;
	fi;
end;