from clamp.commands import clamp_command
from setuptools import setup, find_packages

# Tired of trying to get SemVer working with setuptools. Ignoring the warning for now, but it means the pre-release
# versions are getting mangled. Comments didn't seem to help from https://github.com/pypa/setuptools/issues/308
heterodon_version = "1.0.0-beta2"
cwltool_version = "1.0.20180809224403"

setup(
    name="heterodon",
    version=heterodon_version,
    packages=find_packages(),
    install_requires=[
        "clamp>=0.4",
        "cwltool==" + cwltool_version
    ],
    clamp={
        "modules": ["heterodon"]
    },
    cmdclass={"install": clamp_command}
)
