# Heterodon

### Description

🐖🐍

Heterodon is a single jar containing a Jython distribution plus the Python dependencies required for 
[Cromwell](https://github.com/broadinstitute/cromwell).

Heterodon is built with [Clamp](https://github.com/jythontools/clamp). The resulting jar runs on the JVM and does not
require CPython to be installed.

### Build the Heterodon single jar packaged inside a Docker container

```bash
docker build . -t broadinstitute/heterodon
```

### Copy the jar file from inside the Docker image out to the host's current directory

```bash
docker run --rm -v $PWD:$PWD broadinstitute/heterodon sh -c "cp -v /heterodon/heterodon-*-single.jar $PWD"
```

### Example

See `SaladFileTest.java` for an example.
