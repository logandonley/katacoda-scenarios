ssh root@host01 "yum install epel-release -y"
ssh root@host01 "yum install ansible -y"
ssh root@host01 "oc create -f https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v3.10/quickstart-templates/rails-postgresql.json -n openshift"