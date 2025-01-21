#!/bin/zsh

str="Dir/subdir/subsubdir/File Name.extension"
echo $str "\n\n"

## PATH MANIPULATIONS

# turn a file name into an absolute path
echo ${str:a}
# -> $(pwd)/Dir/File Name.extension

# leave only the head (remove all trailing pathname components)
echo ${str:h}
# -> Dir/subdir

# remove all but 2 leading path components 
echo ${str:h2}
# -> Dir/subdir

# leave only the tail (remove all leading pathname components)
echo ${str:t}
# -> File Name.extension

# Remove all but 2 trailing components
echo ${str:t2}
# -> File Name.extension

# remove all but the extension
echo ${str:e}
# -> extension

# remove extension
echo ${str:r}
# -> File Name

# remove all but filename (without extension)
echo ${str:t:r}
# -> extension

## CASE MANIPULATION

# Convert string to all uppercase
echo ${str:u}
# -> DIR/FILE NAME.EXTENSION

# convert string to all lowercase
echo ${str:l}
# -> dir/file name.extension

## REMOVE / REPLACE

# remove first occurence of "ir"
echo ${str/ir/}
echo ${str:s/ir/}
# -> D/subdir/File Name.extension

# remove all occurence of "ir"
echo ${str:gs/ir/}
# -> Dir/File .extension

# replace first occurence of "ir" with "on"
echo ${str/ir/on}
echo ${str:s/ir/on}
# -> Don/subdir/File Name.extension

# replace all occurences of "ir" with "on"
echo ${str:gs/ir/on}
# -> Don/subdon/File Name.extension

# quote the substituted words, escaping further substitutions
echo ${str:q}
# -> Dir/subdir/File\ Name.extension

# remove a filename extension leaving the root name. ‘.’
echo ${str:r}
# -> Dir/subdir/subsubdir/File Name
