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
extraneous_dirs=( \
    "Lib/distutils/tests" \
    "Lib/email/test" \
    "Lib/ensurepip" \
    "Lib/isodate/tests" \
    "Lib/jars" \
    "Lib/json/tests" \
    "Lib/lib2to3/tests" \
    "Lib/pip" \
    "Lib/prov/tests" \
    "Lib/schema_salad/tests" \
    "Lib/share/doc" \
    "Lib/setuptools-*-info" \
    "Lib/test" \
    "Lib/unittest" \
    "javatests" \
    "jni" \
    "org/bouncycastle/util/test" \
    "org/python/bouncycastle" \
    "org/python/tests" \
)

for extraneous_dir in "${extraneous_dirs[@]}"; do zip -q -d ${heterodon_jar} "$(printf "%s/*" ${extraneous_dir})"; done

# Remove windows executables
zip -q -d ${heterodon_jar} '*.exe'

# Remove '*.class' files. May slow down jython on its first run. But we don't want to copy around the cache.
zip -q -d ${heterodon_jar} 'Lib/*.class'

# Test that the jar works at compilation and runtime
heterodon_classpath=.:${heterodon_jar}
javac -cp ${heterodon_classpath} SaladFileTest.java
diff -w test.salad <(java -cp ${heterodon_classpath} SaladFileTest test.cwl)
