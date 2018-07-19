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
cat 'BUILD_NAMESPACE={{ dev.namespace }}' > params/ruby/build
```{{execute}}