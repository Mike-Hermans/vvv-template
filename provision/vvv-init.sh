#!/usr/bin/env bash
# Provision WordPress Stable

#
#   SETUP
#

DOMAIN=`get_primary_host "${VVV_SITE_NAME}".dev`
DOMAINS=`get_hosts "${DOMAIN}"`
PROD_DOMAIN=`get_config_value 'production'`
SITE_TITLE=`get_config_value 'site_title' "${DOMAIN}"`
WP_VERSION=`get_config_value 'wp_version' 'latest'`
WP_TYPE=`get_config_value 'wp_type' "single"`
DB_NAME=`get_config_value 'db_name' "${VVV_SITE_NAME}"`
DB_NAME=${DB_NAME//[\\\/\.\<\>\:\"\'\|\?\!\*-]/}
USE_BOWER=`get_config_value 'use_bower'`

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

#
#   WORDPRESS
#
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then
    mkdir ${VVV_PATH_TO_SITE}/public_html
    cd ${VVV_PATH_TO_SITE}/public_html

    echo "Downloading WordPress..."
    noroot wp core download --version="${WP_VERSION}"

    echo "Configuring Database and DEBUG mode"
    noroot wp core config --dbname="${DB_NAME}" --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP

    # Check if we need multisite or not
    echo "Installing WordPress"
    if [ "${WP_TYPE}" = "subdomain" ]; then
        INSTALL_COMMAND="multisite-install --subdomains"
    elif [ "${WP_TYPE}" = "subdirectory" ]; then
        INSTALL_COMMAND="multisite-install"
    else
        INSTALL_COMMAND="install"
    fi
    noroot wp core ${INSTALL_COMMAND} --url="${DOMAIN}" --quiet --title="${SITE_TITLE}" --admin_name=admin --admin_email="admin@local.dev" --admin_password="admin"

    # Remove unneeded plugins and themes
    cd wp-content/plugins
    rm -rf akismet hello.php

    # If project_repo is set, download the project and remove all other themes.
    if [ -n "${PROJECT_REPO}" ]; then
        cd ../themes
        rm -rf twenty*

        echo "cloning ${PROJECT_REPO} into ${VVV_SITE_NAME}"

        noroot git clone ${PROJECT_REPO} ${VVV_SITE_NAME}
        noroot wp theme activate ${VVV_SITE_NAME}

        cd ${VVV_SITE_NAME}
        noroot composer install
        cd development
        noroot npm install
        if [ -n "${USE_BOWER}" ]; then
            noroot ./node_modules/.bin/bower install
        fi
        noroot ./node_modules/.bin/gulp
    fi

else
    echo "Updating WordPress"
    cd ${VVV_PATH_TO_SITE}/public_html
    noroot wp core update --version="${WP_VERSION}"
fi

#
#   NGINX RULES
#
if [ -n "${PROD_DOMAIN}" ]; then
    cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.media.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
    sed -i "s#{{PROD_DOMAIN}}#${PROD_DOMAIN}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
else
    cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
fi
sed -i "s#{{DOMAINS_HERE}}#${DOMAINS}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"