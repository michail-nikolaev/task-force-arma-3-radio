#From https://github.com/Brig13Team/Operation_Kerberos
# author: iJesuz, extended by Dorbedo
#
# description:
#   This is a simple xml validator for TravisCI.
#   It's not guaranteed to find all errors!
#
#!/usr/bin/python3

import os
import sys

FILES_TO_IGNORE = ["ftlib.prj.xml"]

# description:
#   returns index before pattern
#   if pattern isn't found a ValueError is thrown
#
# parameter:
#   content : str - string
#   index   : int - start index
#   pattern : str - pattern to search
#   error   : str - to created ValueError(error)
#
# return:
#   int
def skipUntil(content : str, index : int, pattern : str, error : str) -> int:
    skip = content.find(pattern,index)
    if (skip < 0):
        print(index)
        raise ValueError(error)
    return skip + len(pattern) - 1

# description:
#   check if xml-tag is correct
#   if tag is not correct a ValueError is thrown
#
# parameter:
#   string  : str - XML-Tag without '<' and '>'
#
# return:
#   str - tag name
def checkHeader(string : str) -> str:

    # description:
    #   check if attribute assignment(s) are correct
    #   or throw ValueError
    #
    # parameter:
    #   string  : str  - string to check
    #   __name  : str  - (internal) attribute which is currently parsed
    #   __equal : bool - (internal) already encountered '=' (__name is now final)
    #   __names : []   - (internal) already found attributes
    #
    # return:
    #   bool
    def checkAttributes(string : str, __name = "", __equal = False, __names = [], __isKey = False) -> bool:
        if (len(string) == 0):
            if (len(__name) > 0):
                raise ValueError("Non finished assignment for attribute '" + __name + "'!")
            else:
                return True
        else:
            if (string[0] == "="):
                if (len(__name) > 0):
                    if (__equal):
                        raise ValueError("Expected '\"' but encountered '='!")
                    else:
                        if (__name in __names):
                            raise ValueError("Attribute '" + __name + "' is assigned more then once!")
                        else:
                            return checkAttributes(string[1:],__name,True,__names)
                else:
                    raise ValueError("Tag-Name can't start width '='!")

            elif (string[0] == "\""):
                if (len(__name) > 0):
                    if (__equal):
                        skip = skipUntil(string,1,"\"","Missing closing '\"'!")
                        if (skip+1 < len(string)):
                            if (not string[skip+1] == " "):
                                raise ValueError("Missing ' ' after attribute assignment!")
                        __names.append(__name)
                        if (__name.lower() == "id"):
                            if (string in allKeys):
                                raise ValueError("Doubled String detected:" + string)
                            else:
                                allKeys.append(string)
                        return checkAttributes(string[skip+1:],"",False,__names)
                    else:
                        raise ValueError("Encountered '\"' before '='!")
                else:
                    raise ValueError("Tag-Name can't start with '\"'!")

            elif (string[0] == " "):
                return checkAttributes(string[1:],__name,__equal,__names)
            else:
                if (len(__name) > 0):
                    if (__equal):
                        raise ValueError("Expected '\"' after '='!")
                return checkAttributes(string[1:],__name + string[0],__equal,__names)

    if ('<' in string):
        raise ValueError("Encountered illegal character inside a tag header: '<'")
    # shouldn't be inside (see calling function)
    # if ('>' in string):
    #     raise ValueError("Encountered illegal character inside a tag header: '>'")

    space = string.find(" ")
    if (space < 0):
        # tag as no attributes
        return string
    else:
        if checkAttributes(string[space+1:]):
            return string[0:space]

# description:
#   check if given xml-file is correct
#
# parameter:
#   filepath : str - path to xml
#
# return:
#    bool
def validate_xml(filepath : str) -> bool:
    file = open(filepath, 'r', encoding="utf8")
    content = file.read()

    try:
        stack = []
        index = 0

        while index < len(content):
            if (content[index] == '<'):
                # a comment
                if (content[index:index+4] == "<!--"):
                    index = skipUntil(content, index, "-->", "Comment never closed!")

                # processing instruction
                elif (content[index:index+2] == "<?"):
                    index = skipUntil(content, index, "?>", "Missing '?>' in processing instruction!")


                # end tag
                elif (content[index:index+2] == "</"):
                    first = index + 2
                    last = skipUntil(content, first, ">", "End Tag never closed!")
                    closedName = content[first:last]

                    if (len(stack) == 0):
                        raise ValueError("Element '" + closedName + "' closed but not opened before!")

                    openedName = stack.pop()
                    if (openedName != closedName):
                        raise ValueError ("Element '" + closedName + "' closed but '" + openedName + "' expected to be closed!")

                    index = last

                # start tag
                else:
                    first = index + 1
                    last = skipUntil(content, first, ">", "Start Tag never closed!")

                    # not an empty-element tag
                    if (content[last-1] == '/'):
                        tag = checkHeader(content[first:last-1])
                    else:
                        tag = checkHeader(content[first:last])
                        stack.append(tag)
                    index = last

            index += 1

    except ValueError as error:
        print(error)

        last = ""
        count = 0
        countLines = 0

        file.seek(0)
        for line in file:
            if (count <= index):
                count += len(str(line))
                countLines += 1
                last = line
            else:
                break

        file.close()
        print("at line " + str(countLines) + ": '" + last[0:-1] + "'")
        print("in file '" + filepath + "'")
        return False

    file.close()
    return True

# description:
#   check xml-files inside dirToCheck recursivly
#
# return
#   int - 0 (on success) or 1 (if errors are found)
def main():
    dirToCheck = "../"
    global allKeys
    allKeys = []
    errors = 0;
    for root, subdirs, files in os.walk(dirToCheck):
        #for name in list(filter(lambda x: x.endswith(".xml"),files)):
        for name in list(filter(lambda x: x.endswith(".xml"),files)):
            if not name in FILES_TO_IGNORE:
                if (not validate_xml(os.path.join(root,name))):
                    errors = errors + 1

    if (errors > 0):
        print('')
        print(str(errors) + " error found!")
        return 1
    else:
        print("No errors found.")
        return 0

if __name__ == '__main__':
    sys.exit(main())
