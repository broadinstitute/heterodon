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

### Bumping Versions

Be sure to update the version both in `setup.py` and `pom.xml`.

### Publishing Versions

Navigate to the JFrog Artifact Repository Browser:
- Login to [jfrog](https://broadinstitute.jfrog.io/).
- In the left nav select `Artifacts`.

For both the jar file and the pom.xml:
- Find the "Deploy" button on the top right.
- Set "Target Repository" to "libs-release-local".
- Under "Single" upload or drop the file to deploy.
- Set the appropriate versioned "Target Path" for the file, for example:
  - `org/broadinstitute/heterodon/1.0.0-beta0/heterodon-1.0.0-beta0.pom`, or
  - `org/broadinstitute/heterodon/1.0.0-beta0/heterodon-1.0.0-beta0-single.jar`
- Leave any other boxes unchecked.
- Click the "Deploy" button.
