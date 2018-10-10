# VVV site template
Copied from https://github.com/Varying-Vagrant-Vagrants/custom-site-template, optimized for Level Level created themes (or in general themes using Clarkson Core / Clarkson Theme).

## Overview
This template will allow you to create a WordPress dev environment using only `vvv-custom.yml`.

## Configuration

Copy vvv-config.yml to vvv-custom.yml, and remove the sites that are already there.

### The minimum required configuration:
This is the minimum required config for a site, all other config keys are optional. Keep in mind that
the value for 'repo' should not be changed.
```
my-site:
  repo: https://github.com/mike-hermans/vvv-template
  hosts:
    - my-site.test
```
This will produce a website with the following settings:
| Setting    | Value       |
|------------|-------------|
| Domain     | my-site.dev |
| Site Title | my-site.dev |
| DB Name    | my-site     |
| Site Type  | Single      |
| WP Version | Latest      |

## Configuration Options
Adding a 'custom' group will allow for much more configuration. All keys are listed below:
```
my-site:
  repo: https://github.com/mike-hermans/vvv-template
  wp_type: single
  wp_version: latest
  hosts:
    - my-site.test
  custom:
    site_title: My Site
    project_repo: git@github.com/project/theme.git
    production: https://my-site.com
    db_name: custom_db_name
    db_prefix: lvl28_
```

## Default configuration variables
#### WP Type
Choose between single or multisite setup

Usage:
````
# Single site:
wp_type: single

# Multisite using subdirectories
wp_type: subdirectory

# Multisite using subdomains
wp_type: subdomain
````

#### WP Version
Specific WordPress version, defaults to 'latest'

Usage:
````
wp_version: 4.9.5
````

#### Hosts
Defines the domains and hosts for VVV to listen on.
The first domain in this list is your sites primary domain.

Usage
```
hosts:
    - foo.dev
    - bar.dev
    - baz.dev
```

## Custom variables
These are defined under the 'custom:' variable.

#### Site Title
Defines the site title to be set upon installing WordPress.

Usage:
```
site_title: My Awesome Dev Site
```

#### Project repository
Defines a theme that needs to be pulled. Also tries to do a Composer and NPM install.
Keep in mind that on protected repositories, your ssh key must be added to the SSH agent. On MacOS, use the `ssh-agent -K` command to accomplish this. Also make sure that if this is the case, do not use the http url to clone the project, but the ssh url.

Usage:
```
project_repo: git@github.com/level-level/Clarkson-Theme.git
```

#### Production
Defines the production website for the project. When this is set, any images that are not found locally will be pulled from the production environment.

Usage:
```
production: https://cool-website.com
```

#### Database name
Defines a custom DB name for the installation.

Usage:
```
db_name: super_secret_db_name
```

#### Database prefix
Defines a custom DB prefix for the installation.

Usage:
```
db_prefix: lvl28_
```
