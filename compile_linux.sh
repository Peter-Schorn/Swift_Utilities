docker run --rm \
    --volume "$(pwd):/src" \
    --workdir "/src" \
    swift:latest \
    /bin/bash -c \
    "swift package clean && swift build --build-path ./.build/linux"
    
# "swift package clean && swift build --build-path ./.build/linux && echo finished"
