To get started, let us login to the OpenShift cluster by running the following:

``oc login -u developer -p developer``{{execute}}

For this tutorial we are going to create everything from scratch. In the future, in the future you can use some of the following resources as starting points:

* https://github.com/rht-labs/labs-ci-cd
* https://github.com/redhat-cop/containers-quickstarts

To begin, let's create a new directory and go into it.

``mkdir sample-applier; cd sample-applier``{{execute}}

```
cat <<EOM >requirements.yml
- name: openshift-applier
  scm: git
  src: https://github.com/redhat-cop/openshift-applier
  version: v3.7.2
EOM
```{{execute}}
