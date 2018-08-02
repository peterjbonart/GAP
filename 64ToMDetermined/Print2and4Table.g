
print2and4s := function()
	printEntriesTable(64,[2,4]);
end;


printEntriesTable := function(order,restriction)
local groupList, list1, list2, list3, subSize;
	groupList := AllSmallGroups(order);
	subSize := Length(groupList) / 3;
	list1 := [];
	list2 := [];
	list3 := [];
	CopyListEntries(groupList,1,1,list1,1,1,subSize);
	CopyListEntries(groupList,subSize+1,1,list2,1,1,subSize);
	CopyListEntries(groupList,(2*subSize)+1,1,list3,1,1,subSize);
	printInThreeColumns(list1,list2,list3,[groupList,restriction]);
end;

#Takes in a group, and a pair consisting of a list of all groups
#and a list restriction.
#Prints out first the id of the group.
#Then prints out for every x in restriction the number of times 
#x appears in the Table of Marks of the group.
#And the whole thing is printed in a latex friendly format.
printAsLatex := function(group, groupListAndRestriction)
local tom, entries, groupList, restriction, x;
	groupList := groupListAndRestriction[1];
	restriction := groupListAndRestriction[2];
	Print(Position(groupList,group));
	tom := TableOfMarks(group);
	entries := union(MarksTom(tom));
	for x in restriction do 
		Print(" & ");
		Print(count(entries,x));
	od;
end;

#Counts the number of x in list with x = element.
count := function(list, element)
local res, x;
	res := 0;
	for x in list do
		if x = element then
			res := res + 1;
		fi;
	od;
	return res;
end;

printInThreeColumns := function(list1, list2, list3, extraData)
local i;
	for i in [1..Length(list1)] do 
		printAsLatex(list1[i], extraData);
		Print(" & & ");
		printAsLatex(list2[i], extraData);
		Print(" & & ");
		printAsLatex(list3[i], extraData);
		Print("\\\\\n");
	od;
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