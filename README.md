# cavallo

GCP infrastructure for a self-hosted LLM inference node, managed with [OpenTofu](https://opentofu.org/).

## What it creates

- A VPC network with an SSH firewall rule
- A single Compute Engine VM (Ubuntu 22.04, SSD boot disk)
- Outputs: external IP + ready-to-use SSH command

## Prerequisites

### 1. GCP project with billing enabled

Find your project ID (not the display name — the lowercase slug):

```sh
gcloud projects list
```

The value in the `PROJECT_ID` column is what you need.

### 2. Enable the Compute API

```sh
gcloud services enable compute.googleapis.com --project=YOUR_PROJECT_ID
```

### 3. Authenticate

```sh
gcloud auth application-default login
```

This opens a browser and stores credentials that OpenTofu will pick up automatically.

### 4. OpenTofu ≥ 1.6

```sh
tofu version   # check if already installed
```

> Using Nix + direnv? Run `direnv allow` once in the repo root — the shell loads automatically from then on. To enter manually: `nix develop`.

### 5. SSH key pair

If you don't have one yet:

```sh
ssh-keygen -t ed25519 -C "cavallo"
```

Your public key is at `~/.ssh/id_ed25519.pub`. Print it with:

```sh
cat ~/.ssh/id_ed25519.pub
```

You'll paste this value into `terraform.tfvars` as `ssh_public_key`.

## Quick start

```sh
# 1. Enter the infra directory
cd infra

# 2. Create your variable file
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
```

Set at minimum:

```hcl
project_id     = "your-project-id"          # from: gcloud projects list
ssh_public_key = "ssh-ed25519 AAAA..."      # from: cat ~/.ssh/id_ed25519.pub
```

```sh
# 3. Initialise providers
tofu init

# 4. Preview changes
tofu plan

# 5. Apply
tofu apply
```

After `apply` completes, Tofu prints the VM's external IP and a ready-to-use SSH command:

```
ssh_command = "ssh root@<external-ip>"
```

## Variables

| Name | Required | Default | Description |
|---|---|---|---|
| `project_id` | yes | — | GCP project ID (`gcloud projects list`) |
| `ssh_public_key` | yes | — | Public key written to `root`'s `authorized_keys` |
| `machine_type` | no | `n1-standard-8` | Compute Engine machine type |
| `disk_size_gb` | no | `100` | Boot disk size (GB) |
| `allowed_ssh_cidr` | no | `0.0.0.0/0` | Restrict SSH to your IP, e.g. `203.0.113.1/32` |

## Tear down

```sh
tofu destroy
```

## State

State is stored locally in `infra/terraform.tfstate` and is excluded from git via `.gitignore`.
