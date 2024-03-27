

# CondorJobs
**Original code by K. Paraschou, https://github.com/ecloud-cern/ecloud-scrubbing-containers**

## Quick Links

- [**HTCondor documentation**](https://batchdocs.web.cern.ch/)
- [**Registry documentation**](https://kubernetes.docs.cern.ch/docs/registry/quickstart)
- [**Available image**](https://registry.cern.ch/harbor/projects/3663/repositories )


## HTCondor

A list of useful commands:
```bash
condor_q
```



## Docker

**To build an image:**

```bash
# Create the image
sudo docker build -f build.pybb.2024.0 -t registry.cern.ch/bbstudies/pybb:2024.0 .

# Push to the registry
sudo docker login registry.cern.ch
sudo docker push registry.cern.ch/bbstudies/pybb:2024.0
```

- **Your password to login in registry.cern.ch is found in the user profile in registry.cern.ch (called "CLI secret").**
- **As a final step, need to add the registry address in the [cvmfs sourcing yaml](https://gitlab.cern.ch/unpacked/sync/-/blob/master/recipe.yaml)**



**To use the image in interactive mode:**
```bash
# (sourcing from registry directly)
sudo docker run -it -v /absolute/path/to/mount/:/usr/local/pybb/OUT registry.cern.ch/bbstudies/pybb:2024.0

# (sourcing from cvmfs)
singularity exec /cvmfs/unpacked.cern.ch/registry.cern.ch/bbstudies/pybb:2024.0 /bin/bash
```

**To list images pulled on local machine:**
```bash
# List images
sudo docker images
```




