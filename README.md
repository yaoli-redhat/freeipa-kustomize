# freeipa-kustomize

This is an experimental repository that store different investigations
carry out for getting a better understanding of the different scenarios
that we wish to address into freeipa-operator.

The repository is divided into two big blocks:

- config: This directory store static configurations under the shape of
  Kustomize projects, which represent different static scenarios that
  we want to plan with freeipa-operator.
- incubator: This directory store many different proof of concepts developed
  for getting a better understanding of the scenarios to be handled before
  creating the static version into the above directory.

Once said the above, we will start creating any proof of concept by creating
a directory into `incubator` directory. This MUST be easy to execute to see
the resulting states into the cluster; the way followed has been by creating
the following layout:

```raw
+- 999-proof-of-concept
   +- Makefile    Entry point for running the proof of concept.
   +- README.md   Markdown documentation for the proof of concept.
   +- HELP.txt    Contain the content printed out by `make help`.
   ...            Free form of 
   +- config      [optional] If the proof of concept is including
                  infrastructure configuration, this directory will
                  contain it in the form of Kustomize projects.
      +- poc-a
         +- kustomization.yaml
         +- ... *.yaml   Infrastructure as a Code files.
      ...
      +- poc-z
         +- kustomization.yaml
         +- ... *.yaml   Infrastructure as a Code files.
```
