#Calculates all multisets of entries of groups of the specified order
#and simply outputs them into the GAP console
printEntriesRaw := function(order)
local groupList, i;
	groupList := AllSmallGroups(order);
	for i in [1..Length(groupList)] do 
		Print(i);
		Print("  : ");
		Print(multisetOfEntries(groupList[i]));
		Print("\n");
	od;
end;

#Returns a list containing all the multisets of entries of the tables of marks of the groups of the specified order
getAllEntryMultisets := function(order)
local result, group;
	result := [];
	for group in AllSmallGroups(order) do
		Add(result,multisetOfEntries(group));
	od;
	return result;
end;

#Calculates multisets of entries of groups of the specified order
#But this function prints the output in a way
#that it can easily be included in a latex document
#The latex document needs to use "\usepackage{longtable}"
#This function requires a list "relevantValues" to tell
#how the columns of the table should be labelled and in which order
printEntriesLatex := function(order)
local i, j, entries, entryList, index, relevantValues, multiset, value;
	entryList := getAllEntryMultisets(order);
	
	#Find out which values appear in Tables of Marks at all
	relevantValues := [];
	for multiset in entryList do 
		for value in multiset[1] do 
			if not value in relevantValues then
				Add(relevantValues,value);
			fi;
		od;
	od;
	Sort(relevantValues);
	
	#Print first two latex lines
	Print("\\begin\{longtable\}\{c");
	for i in relevantValues do 
		Print("\|c");
	od;
	Print("\}\n");
	Print("Group");
	for i in relevantValues do 
		Print(" \& \\\#");
		Print(i);
	od;
	Print("\\\\\n");
	
	#Print actual table data
	for j in [1..Length(entryList)] do 
		Print(j);
		entries := entryList[j];
		for i in relevantValues do
			Print(" \& ");
			index := Position(entries[1],i);
			if index = fail then 
				Print(0);
			else
				Print(entries[2][index]);
			fi;
		od;
		Print("\\\\\n");
	od;
	
	#Print last latex line
	Print("\\end\{longtable\}");
end;

#Takes in a group and returns the multiset of entries of its table of marks
multisetOfEntries := function(group)
	return listToMultiset(union(MarksTom(TableOfMarks(group))));
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

#Takes a list L of lists and returns the union of all the entries of L
union := function(list)
local res, x;
    res := [];
    for x in list do 
        Append(res,x);
    od;
    return res;
end;