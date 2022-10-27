# rctl command cheatsheet

Initialize the RCTL tool and import rafay config:

```bash
rctl config init your-config-file.json
```

Get your projects list:

```bash
rctl get projects
```

Set default project:

```bash
rctl config set project your-project-name
```

Download Kubeconfig to be used by Kubectl:

```bash
rctl download kubeconfig -f you-name-it
```
