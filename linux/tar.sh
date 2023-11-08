#!/bin/bash

# Create tar file
# -c create archive
# -f file
# -v verbose
tar -cf tar-file-to-create.tar file01.txt file02.txt dir01 dir02

# Unpack tar file
# -x extract
# -v verbose
# -f file
tar -xvf tar-file-to-extract.tar

