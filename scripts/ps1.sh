#!/bin/bash
if [ $1 = "root" ]; then
  export PS1="🥔 root: \n\$"
elif [ $1 = "bob" ]; then
  export PS1="🧛‍♂️ bob: \n\$"
elif [ $1 = "suzy" ]; then
  export PS1="🧟‍♀️ suzy: \n\$"
fi
