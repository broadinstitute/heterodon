#!/usr/bin/env bash

set -e

JYTHON_VERSION="2.7.1"

# Download jython
curl -sSO http://search.maven.org/remotecontent?filepath=org/python/jython-installer/${JYTHON_VERSION}/jython-installer-${JYTHON_VERSION}.jar > /dev/null

# Install jython
java -jar jython-installer-${JYTHON_VERSION}.jar -s -d /jython

# Upgrade pip
pip install --upgrade pip setuptools wheel

# Install clamp that's only available in github
pip install git+https://github.com/jythontools/clamp.git

# Install a fake psutil as it's not available for jython
# see also fake_util/setup.py
pip install -e fake_psutil

# Install dependencies
jython setup.py develop

# Clamp, building java classes from python
jython setup.py clamp

# Package the single jar
jython setup.py singlejar

heterodon_jar=$(ls $PWD/heterodon-*-single.jar)

# Install zip to thin down the jar
apt-get update
apt-get install -y zip

# Manually curated. Could be further slimmed with information from something like:
# https://github.com/Deconimus/JarShrink (aka `jdep`)
# https://github.com/zenglian/minimize-jar (aka `java -verbose:class`)
# Note ICU is huge, but (parts are) required: http://bugs.jython.org/issue2175
# Note BouncyCastle bindings and jni ffi are required for HTTPS/SSL/TLS.
# However, only the Darwin and Linux ffi libs are not removed.
# Remove windows executables
# Remove '*.class' files. May slow down jython on its first run. But we don't want to copy around the cache.

extraneous_file_patterns=( \
    "*.exe" \
    "Lib/*.class" \
    "Lib/distutils/tests/*" \
    "Lib/email/test/*" \
    "Lib/ensurepip/*" \
    "Lib/isodate/tests/*" \
    "Lib/jars/*" \
    "Lib/json/tests/*" \
    "Lib/lib2to3/tests/*" \
    "Lib/pip/*" \
    "Lib/prov/tests/*" \
    "Lib/schema_salad/tests/*" \
    "Lib/share/doc/*" \
    "Lib/setuptools-*-info/*" \
    "Lib/test/*" \
    "Lib/unittest/*" \
    "javatests/*" \
    "jni/aarch64-Linux/*" \
    "jni/arm-Linux/*" \
    "jni/i386-SunOS/*" \
    "jni/i386-Windows/*" \
    "jni/ppc-AIX/*" \
    "jni/ppc64-Linux/*" \
    "jni/ppc64le-Linux/*" \
    "jni/sparcv9-SunOS/*" \
    "jni/x86_64-FreeBSD/*" \
    "jni/x86_64-OpenBSD/*" \
    "jni/x86_64-SunOS/*" \
    "jni/x86_64-Windows/*" \
    "org/bouncycastle/util/test/*" \
    "org/python/tests/*" \
)

for extraneous_file_pattern in "${extraneous_file_patterns[@]}"; do
    zip -q -d "${heterodon_jar}" "${extraneous_file_pattern}"
done

# Test that the jar works at compilation and runtime
heterodon_classpath=.:${heterodon_jar}
javac -cp ${heterodon_classpath} SaladFileTest.java
diff -w test.salad <(java -cp ${heterodon_classpath} SaladFileTest test.cwl)
diff -w https.salad <(java -cp ${heterodon_classpath} SaladFileTest 'https://raw.githubusercontent.com/broadinstitute/cromwell/3262e87/centaur/src/main/resources/standardTestCases/cwl_relative_imports/workflow.cwl')
