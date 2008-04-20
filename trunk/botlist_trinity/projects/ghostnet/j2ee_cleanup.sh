#!/bin/sh

# Convert the JSP/J2EE source to django source.
# NOTE!! volatile operations, may completely remove HTML elements.

# for file in *.jsp ; do mv $file `echo $file | sed 's/\(.*\.\)jsp/\1html/'` ; done

find . -name '*.html' -exec sed -i 's/<c:url value=\"//g' {} \;
find . -name '*.html' -exec sed -i "s/<c:out value='//g" {} \;

# Convert JSP Comments
find . -name '*.html' -exec sed -i "s/<%--/{#/g" {} \;
find . -name '*.html' -exec sed -i "s/--%>/#}/g" {} \;

# End of Script

