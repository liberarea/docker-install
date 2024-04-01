#!/bin/bash
#!/bin/sh
#
FILE_NAME="$1"
echo $FILE_NAME
if [ -n "$FILE_NAME" ]; then
    sed -i -e 's/\r$//' "${FILE_NAME}"
    exit 1
fi
echo $"Usage: $0 [target-file]"
exit 0