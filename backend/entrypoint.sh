#!/bin/bash

set -e

JAVA_OPTS="-XX:+UseG1GC -XX:+UseStringDeduplication -Duser.Timezone=America/Sao_Paulo -Dfile.encoding=UTF-8"
ACTIVE_PROFILE="-Dspring.profiles.active=prod"

exec java -Xmx$MAX_MEM_ALLOC -Xms$INITIAL_MEM_ALLOC $JAVA_OPTS $ACTIVE_PROFILE -jar back-end.jar