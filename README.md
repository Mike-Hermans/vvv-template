# VVV personal site template
Copied from https://github.com/Varying-Vagrant-Vagrants/custom-site-template

## Overview
This template will allow you to create a WordPress dev environment using only `vvv-custom.yml`.

## Configuration

Copy vvv-config.yml to vvv-custom.yml, and remove the sites that are already there.

### The minimum required configuration:

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
  hosts:
    - my-site.test
  custom:
    site_title: My Site
    project_repo: git@github.com/project/theme.git
    production: https://my-site.com
    db_name: custom_db_name
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

#### Project Repo
Defines a theme that needs to be pulled. Also tries to do a Composer and NPM install.

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

#### DB Name
Defines a custom DB name for the installation.

Usage:
```
db_name: super_secret_db_name
```
