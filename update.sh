#!/usr/bin/env bash

aws help | sed -ne '/acm/,$ p' | grep 'o ' | grep -v topics | awk '{ print $2 }' > ./services.txt

# cat services.txt | while read s; do echo $s; mkdir -p ./services/$s; for m in get describe list; do echo "- $m"; aws $s help | grep "o $m-" | awk '{ print $2 }' > ./services/$s/$m.txt; done; cat ./services/$s/{get,list,describe}.txt | sed -e 's/^[a-z]*-//' | sort -u > ./services/$s/entities.txt; done

while read s; do
	echo $s
	mkdir -p ./services/$s
	
	for m in get describe list; do
		echo "- $m"
		aws $s help | grep "o $m-" | awk '{ print $2 }' > "./services/$s/$m.txt"
	done

	cat ./services/$s/{get,list,describe}.txt | sed -e 's/^[a-z]*-//' | sort -u > ./services/$s/entities.txt
done < ./services.txt

# services=$(<./services.txt)

