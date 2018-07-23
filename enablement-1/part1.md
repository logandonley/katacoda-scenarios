### Part 1 - Create OpenShift Projects
> _Using the OpenShift Applier, we will add new project namespaces to the cluster which will be used throughout the exercise._

3. In this course three different git projects will be created. To setup your local machine for each of these, create a new folder on the terminal in the root of your HOME directory for convenience. To do this, open a new Terminal session and create the new folder using the following command (new terminal sessions will start in your HOME dir).
```bash
mkdir -p ~/innovation-labs && cd ~/innovation-labs
```
<p class="tip">
NOTE - If you do not want to have this folder at the root of your home dir that's fine, just ensure any parent directories of this `innovation-labs` folder do NOT have any spaces in them as it breaks Ansible in later labs...
</p>

3. Clone the scaffold project to your local machine's `innovation-labs` folder and pull all remote branches for use in later exercises. Note - this may error saying `fatal: A branch named 'develop' already exists.` but it can be ignored
```bash
git clone https://github.com/rht-labs/enablement-ci-cd && cd enablement-ci-cd
```
```bash
./git-pull-all.sh
```

3. Open the `innovation-labs` folder in VSCode (or your favourite editor). The project is laid out as follows
```
.
├── README.md
├── apply.yml
├── docker
├── inventory
│   ├── host_vars
│   │   ├── ci-cd-tooling.yml
│   │   └── projects-and-policies.yml
│   └── hosts
├── jenkins-s2i
├── params
│   └── project-requests-ci-cd
├── requirements.yml
└── templates
    └── project-requests.yml
```
 * `docker` folder contains our jenkins-slave images that will be used by the builds.
 * `jenkins-s2i` contains the configuration and plugins we want to bring jenkins to life with
 * `params` houses the variables we will load the templates with
 * `templates` is a collection of OpenShift templates
 * `inventory/host_vars/*.yml` is the collection of objects we want to insert into the cluster.
 * `requirements.yml` is a manifest which contains the ansible modules needed to run the playbook
 * `apply.yml` is a playbook that sets up some variables and runs the OpenShift Applier role.

3. Open the `apply.yml` file in the root of the project. Update the namespace variables by replacing the `<YOUR_NAME>` with your name or initials. Don't use uppercase or special characters. For example; my name is Dónal so I've created:
```yaml
  hosts: "{{ target }}"
  vars:
    ci_cd_namespace: donal-ci-cd
    dev_namespace: donal-dev
    test_namespace: donal-test
  tasks:
```
<p class="tip">
NOTE - yaml is indentation sensitive so keep things lined up properly!
</p>

3. Open the `inventory/host_vars/projects-and-policies.yml` file; you should see some variables setup already to create the `<YOUR_NAME>-ci-cd` namespace. This object is passed to the OpenShift Applier to call the `templates/project-requests.yml` template with the `params/project-requests-ci-cd` parameters. We will add some additional content here but first let's explore the parameters and the template

3. Open the `params/project-requests-ci-cd` and replace the `<YOUR_NAME>` with your name to create the corresponding projects in the cluster.
![new-item](../images/exercise1/ci-cd-project-namespace.png)

3. Let's add two more params files to pass to our template to be able to create a `dev` and `test` project.
  * Create another two params files `params/project-requests-dev` & `params/project-requests-test`. On the terminal run
```bash
touch params/project-requests-dev params/project-requests-test
```
  * In your editor; Open `params/project-requests-dev` and add the following by substituting `<YOUR_NAME>` accordingly
```
NAMESPACE=<YOUR_NAME>-dev
NAMESPACE_DISPLAY_NAME=<YOUR-NAME> Dev
```
  * In your editor; Open `params/project-requests-test` and add the following by substituting `<YOUR_NAME>` accordingly
```
NAMESPACE=<YOUR_NAME>-test
NAMESPACE_DISPLAY_NAME=<YOUR-NAME> Test
```

3. In the `inventory/host_vars/projects-and-policies.yml` file; add the new objects for the projects you want to create (dev & test) by adding another object to the content array for each. You can copy and paste them from the `ci-cd` example and update them accordingly. If you do this; remember to change the params file! e.g.
```yaml
    - name: "{{ dev_namespace }}"
      template: "{{ playbook_dir }}/templates/project-requests.yml"
      template_action: create
      params: "{{ playbook_dir }}/params/project-requests-dev"
      tags:
      - projects
    - name: "{{ test_namespace }}"
      template: "{{ playbook_dir }}/templates/project-requests.yml"
      template_action: create
      params: "{{ playbook_dir }}/params/project-requests-test"
      tags:
      - projects
```
![project-request-yaml](../images/exercise1/project-request-yml.png)

3. With the configuration in place; install the OpenShift Applier dependency
```bash
ansible-galaxy install -r requirements.yml --roles-path=roles
```

3. Apply the inventory by logging into OpenShift on the terminal and running the playbook as follows (<CLUSTER_URL> should be replaced with the one you've been sent as shown below). Accept any insecure connection warning 👍:
```bash
oc login https://console.lader.rht-labs.com
```
```bash
ansible-playbook apply.yml -i inventory/ -e target=bootstrap
```
where the `-e target=bootstrap` is passing an additional variable specifying that we run the `bootstrap` inventory

3. Once successful you should see an output similar to this (Cows not included): ![playbook-success](../images/exercise1/play-book-success.png)

3. You can check to see the projects have been created successfully by running
```bash
oc projects
```
![project-success](../images/exercise1/project-success.png)