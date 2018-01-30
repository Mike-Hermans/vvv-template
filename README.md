# VVV personal site template
Copied from https://github.com/Varying-Vagrant-Vagrants/custom-site-template

## Overview
This template will allow you to create a WordPress dev environment using only `vvv-custom.yml`.

# Configuration

### The minimum required configuration:

```
my-site:
  repo: https://github.com/mike-hermans/vvv-template
  hosts:
    - my-site.test
  custom:
    production: https://my-site.com
    site_title: My Site
```
| Setting    | Value       |
|------------|-------------|
| Domain     | my-site.dev |
| Site Title | my-site.dev |
| DB Name    | my-site     |
| Site Type  | Single      |
| WP Version | Latest      |

## Configuration Options

```
hosts:
    - foo.dev
    - bar.dev
    - baz.dev
```
Defines the domains and hosts for VVV to listen on.
The first domain in this list is your sites primary domain.

```
custom:
    site_title: My Awesome Dev Site
```
Defines the site title to be set upon installing WordPress.


```
custom:
    db_name: super_secret_db_name
```
Defines the DB name for the installation.

```
custom:
    production: https://cool-website.com
```
Defines the production website from where not-found images will be pulled.
