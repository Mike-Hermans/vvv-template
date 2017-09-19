#!/usr/bin/env bash
# Provision WordPress Stable

DOMAIN=`get_primary_host "${VVV_SITE_NAME}".dev`
DOMAINS=`get_hosts "${DOMAIN}"`
SITE_TITLE=`get_config_value 'site_title' "${DOMAIN}"`
WP_VERSION=`get_config_value 'wp_version' 'latest'`
WP_TYPE=`get_config_value 'wp_type' "single"`
DB_NAME=`get_config_value 'db_name' "${VVV_SITE_NAME}"`
DB_NAME=${DB_NAME//[\\\/\.\<\>\:\"\'\|\?\!\*-]/}

PROJECT_REPO=`get_config_value 'project_repo'`

# Make a database, if we don't already have one
echo -e "\nCreating database '${DB_NAME}' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Remove default git repo
rm -rf .git

# Install and configure the latest stable version of WordPress
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then
    mkdir ${VVV_PATH_TO_SITE}/public_html
    cd ${VVV_PATH_TO_SITE}/public_html

    echo "Downloading WordPress..."
    noroot wp core download --version="${WP_VERSION}"

    echo "Configuring Database and DEBUG mode"
    noroot wp core config --dbname="${DB_NAME}" --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP

    echo "Installing WordPress"
    noroot wp core install --url="${DOMAIN}" --quiet --title="${SITE_TITLE}" --admin_name=admin --admin_email="admin@local.dev" --admin_password="admin"

    # Remove unneeded plugins and themes
    cd wp-content/plugins
    rm -rf akismet hello.php

    # If project_repo is set, download the project and remove all other themes.
    if [ -n "${PROJECT_REPO}" ]; then
        cd ../themes
        rm -rf twenty*

        noroot git clone ${PROJECT_REPO} ${VVV_SITE_NAME}
        noroot wp theme activate ${VVV_SITE_NAME}

        cd ${VVV_SITE_NAME}
        noroot composer install
        cd development
        noroot npm install
        noroot npm run dev
    fi

else
    echo "Updating WordPress"
    cd ${VVV_PATH_TO_SITE}/public_html
    noroot wp core update --version="${WP_VERSION}"
fi

cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{DOMAINS_HERE}}#${DOMAINS}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
