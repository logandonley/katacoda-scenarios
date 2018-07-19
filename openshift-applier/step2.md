For this tutorial, we are going to use an existing Ruby template. In many cases you may want your own custom template, but the process is the same.

First you'll need to find the name of the template you want to pull in:

``oc get templates -n openshift``{{execute}}

You should see the following output:
```
NAME                    DESCRIPTION   PARAMETERS    OBJECTS
ruby-example-template                 1 (1 blank)   6
```

`ruby-example-template` is the name of the template we're going to pull down as a template file into the `templates` directory.

``oc get template ruby-example-template -n openshift -o yaml > templates/ruby.yml``{{execute}}

To checkout what the template looks like, run the following:

``cat templates/ruby.yml``{{execute}}

You'll notice at the end of the template, there is a parameters section with only parameter: `BUILD_NAMESPACE`. We'll want to create a parameter file to set this value.

```
mkdir params/ruby
echo 'BUILD_NAMESPACE={{ dev.namespace }}' > params/ruby/build
```{{execute}}

In this BUILD_NAMESPACE we call on an Ansible variable called `dev.namespace`. Now we need to define this.

```
cat <<EOM >inventory/group_vars/all.yml
---
- dev:
    namespace: ruby-dev
    display_name: Ruby Dev
EOM
```{{execute}}

Next we need to create the `openshift_cluster_content` to tell it to create OpenShift objects from the template and parameters.

You can learn more details about this [here](https://github.com/redhat-cop/openshift-applier/blob/master/roles/openshift-applier/README.md).

```
cat <<EOM >inventory/host_vars/application.yml
---
ansible_connection: local
openshift_cluster_content:
- object: ruby-components
  content:
  - name: ruby-ex
    template: "{{ playbook_dir }}/templates/app/ruby.yml"
    params: "{{ playbook_dir }}/params/app/ruby"
    namespace: "{{ dev.namespace }}"
    tags:
    - app
EOM
```{{execute}}