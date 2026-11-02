# Phase 6 – Ansible Configuration Management

## Objective
Automate Linux server configuration using Ansible as part of the DevOps Capstone project.

## Environment
- OS: Ubuntu 26.04.1 LTS
- Ansible Core: 2.20.1
- Python: 3.14.4
- Ansible Controller: AWS EC2
- Managed Host: localhost (local connection)

## Project Structure
```text
ansible/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
└── playbooks/
    └── server_setup.yml
```

## Implementation
1. Installed Ansible Core.
2. Configured Ansible inventory.
3. Tested connectivity using Ansible ping module.
4. Created server configuration playbook.
5. Ensured curl package was installed.
6. Created `/opt/devops-capstone` directory.
7. Created Ansible-managed configuration file.
8. Validated playbook syntax.
9. Executed dry run using check mode and diff.
10. Executed playbook successfully.
11. Verified generated configuration file.
12. Tested idempotency by executing the playbook again.
13. Configured ansible.cfg for default inventory and settings.

## Ansible Concepts Demonstrated
- Inventory management
- Playbooks and tasks
- Facts gathering
- Privilege escalation using become
- Package management using apt
- File and directory management
- YAML syntax validation
- Check mode and diff
- Idempotency

## Validation Results

| Validation | Result |
|---|---|
| Ansible installation | Passed |
| Inventory validation | Passed |
| Ansible ping | Successful (pong) |
| Playbook syntax check | Passed |
| Dry run | Passed |
| Playbook execution | Passed |
| Configuration file verification | Passed |
| Idempotency test | Passed (changed=0) |
| Failed tasks | 0 |

## Execution Evidence
- `ansible-execution.txt` – Successful playbook execution output.

## Scope and Limitations
This phase demonstrates Ansible automation using a local connection on the EC2 controller instance. Remote SSH-based management of separate EC2 instances has not been implemented.

## Outcome
Successfully implemented and validated basic Linux configuration management using Ansible.
