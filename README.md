Pipeline for building/testing release
=====================================

Setup pipeline in Concourse
---------------------------

```
fly -t lite set-pipeline -p rsyslog-modules -c pipeline.yml --load-vars-from credentials.yml
```
