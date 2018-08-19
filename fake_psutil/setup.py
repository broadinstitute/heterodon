# A stub psutil for cwltool

# Couldn't find a psutil for jython...
# https://groups.google.com/forum/#!topic/psutil/HDGRRFZiOQU

# And couldn't figure out how to exclude dependencies
# https://github.com/pypa/pip/issues/3090

# see also the heterodon root ./setup.py
from setuptools import setup

setup(
    name="psutil",
    version="0.0.1-fake"
)
