#!/bin/sh

domains="$DOMAINS"
email="$EMAIL" # Adding a valid address is strongly recommended
staging=$STAGING # Set to 1 if you're testing your setup to avoid hitting request limits

domain=$(echo $domains | cut -d " " -f 1)

rsa_key_size=4096
conf_path="/etc/letsencrypt"
data_path="/usr/share/nginx/certbot"
domain_path="$conf_path/live/$domain"

function main () {
    if [ -d "$domain_path" ]; then
        start_nginx_and_auto_renew
    else
        first_run
    fi
}

function first_run () {
    import_recommended_tls_params
    create_dummy_certificates
    start_nginx_and_init_certbot
}

function start_nginx_and_init_certbot () {
    echo "### Starting nginx ..."
    start_nginx & init_certbot
}

function init_certbot () {
    sleep 5s & wait ${!}
    delete_dummy_certificates
    request_letsencryt_certificate
    reload_nginx
    auto_renew
}

function start_nginx_and_auto_renew () {
    echo "### Starting nginx ..."
    start_nginx & auto_renew
}

function start_nginx () {
    nginx -g "daemon off;"
    exit 1
}

function reload_nginx () {
    echo "### Reloading nginx ..."
    nginx -s reload
    echo
}

function import_recommended_tls_params () {
    echo "### Downloading recommended TLS parameters ..."
    mkdir -p "$conf_path"
    wget -P "$conf_path" https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
    wget -P "$conf_path" https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem
    echo
}

function create_dummy_certificates () {
    echo "### Creating dummy certificate for $domains ..."
    mkdir -p "$domain_path"
    openssl req -x509 -nodes -newkey rsa:1024 -days 1 -keyout "$domain_path/privkey.pem" -out "$domain_path/fullchain.pem" -subj "/CN=localhost"
    echo
}

function delete_dummy_certificates () {
    echo "### Deleting dummy certificate for $domains ..."
    rm -Rf $conf_path/live/$domain
    rm -Rf $conf_path/archive/$domain
    rm -Rf $conf_path/renewal/$domain.conf
    echo
}

function request_letsencryt_certificate () {
    echo "### Requesting Let's Encrypt certificate for $domains ..."

    mkdir -p "$data_path"

    #Join $domains to -d args
    domain_args=""
    for domain in $domains; do
        domain_args="$domain_args -d $domain"
        if [ $staging != "0" ]; then domain_args="$domain_args -d local.$domain"; fi
    done

    # Select appropriate email arg
    case "$email" in
        "") email_arg="--register-unsafely-without-email" ;;
        *) email_arg="--email $email" ;;
    esac

    # Enable staging mode if needed
    if [ $staging != "0" ]; then staging_arg="--staging"; fi

    certbot certonly --webroot -w $data_path \
        $staging_arg \
        $email_arg \
        $domain_args \
        --rsa-key-size $rsa_key_size \
        --non-interactive \
        --agree-tos \
        --force-renewal
    echo
}

function auto_renew () {
    trap exit TERM

    while :; do
        sleep 12h & wait ${!}
        certbot renew
        nginx -s reload
    done
}

main